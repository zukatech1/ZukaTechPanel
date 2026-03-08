-- Zukas Lifter Pro - Enhanced Mercury UI Version
-- Advanced multi-stage deobfuscation system

-- Load Mercury Library
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

-- ============================================================
-- GUI is created FIRST so stage functions can reference it
-- ============================================================
local GUI = Mercury:create{
	Name = "Zukas Lifter",
	Size = UDim2.fromOffset(680, 480),
	Theme = Mercury.Themes.Dark,
	Link = "https://github.com/zukatech1/Lifter"
}

local Lifter = {
	State = {
		IsLifting = false,
		VFS_Cache = {},    -- persists across lifts so we don't re-download
		VFS_Loading = {},
		VFS_Base = "https://raw.githubusercontent.com/zukatech1/Lifter/main/src/",
		CurrentCode = "",
		ProcessingStage = 1,
	},
	Config = {
		KEYWORDS = {
			"and","break","do","else","elseif","end","false","for",
			"function","goto","if","in","local","nil","not","or",
			"repeat","return","then","true","until","while"
		},
		GLOBALS = {
			"getrawmetatable","game","Workspace","script","math","string",
			"table","print","wait","Instance","Vector3","CFrame","Enum",
			"loadstring","getgenv","getrenv","getreg","getgc"
		},
	}
}

-- ============================================================
-- Virtual File System
-- ============================================================
function Lifter:_vRequire(modulePath)
	local state = self.State

	if state.VFS_Cache[modulePath] then
		return state.VFS_Cache[modulePath]
	end

	-- Cycle guard: return placeholder while loading
	if state.VFS_Loading[modulePath] then
		return state.VFS_Loading[modulePath]
	end

	local internalPath = modulePath:gsub("%.", "/") .. ".lua"
	local url = state.VFS_Base .. internalPath

	local success, content = pcall(game.HttpGet, game, url)
	if not success or content:find("404: Not Found") then
		local fallback = "https://raw.githubusercontent.com/zukatech1/Lifter/main/" .. internalPath
		success, content = pcall(game.HttpGet, game, fallback)
	end

	if not success or content:find("404: Not Found") then
		warn("[VFS] Resolution Failed: " .. modulePath)
		return nil
	end

	local func, err = loadstring(content, "@VFS/" .. modulePath)
	if not func then
		warn("[VFS] Syntax Error in " .. modulePath .. ": " .. tostring(err))
		return nil
	end

	local modulePlaceholder = {}
	state.VFS_Loading[modulePath] = modulePlaceholder

	local env = getfenv(func)
	env.require = function(path) return self:_vRequire(path) end
	env.arg = {}
	env.print = function(...) print("[LIFTER]:", ...) end
	setfenv(func, env)

	local result = func()
	local finalData = result or modulePlaceholder

	state.VFS_Cache[modulePath] = finalData
	state.VFS_Loading[modulePath] = nil

	return finalData
end

-- ============================================================
-- Initialize Prometheus components
-- VFS_Cache persists, so repeated calls don't re-download
-- ============================================================
function Lifter:_initializeLifter()
	-- Only clear VFS_Loading, never VFS_Cache
	self.State.VFS_Loading = {}

	local Parser   = self:_vRequire("prometheus.parser")
	local Ast      = self:_vRequire("prometheus.ast")
	local VisitAst = self:_vRequire("prometheus.visitast")
	local Unparser = self:_vRequire("prometheus.unparser")

	return {
		Parser   = Parser,
		Ast      = Ast,
		VisitAst = VisitAst,
		Unparser = Unparser,
	}
end

-- ============================================================
-- ============================================================
-- WRD: Detect if code is WeAreDevs-obfuscated
-- Signature: --[[ v1.0.0 https://wearedevs.net/obfuscator ]]
-- or the return(function(...) wrapper pattern
-- ============================================================
function Lifter:IsWRD(code)
	return code:find("wearedevs%.net/obfuscator", 1, true) ~= nil
		or code:find("^%s*%-%-%[%[.-wearedevs", 1) ~= nil
		or (code:find("^%s*return%(function%(%.%.%.)") ~= nil and code:find("table%.concat") ~= nil)
end

-- ============================================================
-- WRD Stage A: Strip header comment and unwrap outer closure
-- WRD wraps everything in: return(function(...)local ... end)(...)
-- We extract the inner body so Prometheus can parse it cleanly
-- ============================================================
function Lifter:WRD_StripWrapper(code)
	GUI:notification{ Title = "WRD Stage A", Text = "Stripping WRD wrapper...", Duration = 2 }

	-- Remove the header comment block
	local stripped = code:gsub("^%s*%-%-%[%[.-%]%]%s*", "")

	-- The outer pattern is: return(function(...)BODY end)(...)
	-- We want BODY. Prometheus handles this better without the wrapper.
	-- We do a best-effort extraction — if it fails we return as-is.
	local inner = stripped:match("^%s*return%s*%(function%s*%(%.%.%.%)(.+)end%)%s*%((.-)%)%s*$")
	if inner then
		-- Wrap in a do..end block so it's valid standalone Lua
		return "do\n" .. inner .. "\nend"
	end

	return stripped
end

-- ============================================================
-- WRD Stage B: Resolve string pool
-- WRD stores all strings in a shuffled table, then accesses
-- them via index: local _POOL = {"str1","str2",...}
-- followed by a shuffle loop, then _POOL[N] everywhere.
-- We resolve all _POOL[N] references to their literal values.
-- ============================================================
function Lifter:WRD_ResolveStringPool(code)
	GUI:notification{ Title = "WRD Stage B", Text = "Resolving string pool...", Duration = 2 }

	-- Step 1: find the pool table assignment
	-- Pattern: local <name> = { "...", "...", ... }  (large table of strings)
	local poolName, poolContent = code:match('local%s+([%w_]+)%s*=%s*{([\n\r%s"\'%d%a%p,]+)}')
	if not poolName or not poolContent then
		-- try without newlines
		poolName, poolContent = code:match('local%s+([%w_]+)%s*=%s*({[^}]+})')
		if poolName then
			poolContent = poolContent:sub(2, -2) -- strip braces
		end
	end

	if not poolName then
		print("[Lifter] WRD_ResolveStringPool: no string pool found")
		return code
	end

	-- Step 2: parse pool entries into an array
	-- Handles both "string" and 'string' entries, and \NNN escapes
	local pool = {}
	for entry in poolContent:gmatch('"(.-)"') do
		table.insert(pool, entry)
	end
	for entry in poolContent:gmatch("'(.-)'") do
		table.insert(pool, entry)
	end

	if #pool == 0 then
		print("[Lifter] WRD_ResolveStringPool: pool table found but no strings parsed")
		return code
	end

	print(string.format("[Lifter] WRD: Found pool '%s' with %d entries", poolName, #pool))

	-- Step 3: WRD shuffles the pool at runtime with a numeric key.
	-- Without running the code we can't know the final shuffle order,
	-- BUT we can still replace numeric literal accesses that appear
	-- BEFORE the shuffle loop runs (i.e. direct index constants).
	-- For indices that appear after shuffle, runtime capture handles them.
	-- Replace: poolName[N] or poolName[N+offset] literal patterns
	local resolved = code

	-- Direct numeric index: _POOL[5] -> "literal"
	resolved = resolved:gsub(poolName .. "%[(%d+)%]", function(idx)
		local i = tonumber(idx)
		if i and pool[i] then
			return string.format("%q", pool[i])
		end
		return poolName .. "[" .. idx .. "]"
	end)

	-- Arithmetic index: _POOL[5+1] or _POOL[5-1]
	resolved = resolved:gsub(poolName .. "%[(%d+)%s*([%+%-])%s*(%d+)%]", function(a, op, b)
		local idx = op == "+" and (tonumber(a) + tonumber(b)) or (tonumber(a) - tonumber(b))
		if idx and pool[idx] then
			return string.format("%q", pool[idx])
		end
		return poolName .. "[" .. a .. op .. b .. "]"
	end)

	return resolved
end

-- ============================================================
-- WRD Stage C: Inline proxy/alias tables
-- WRD creates alias tables: local _ENV = {_G.string, _G.table, ...}
-- then calls _ENV[1](args) instead of string.whatever(args).
-- We resolve single-level alias table accesses where the table
-- is defined with literal values we can trace.
-- ============================================================
function Lifter:WRD_InlineAliases(code)
	GUI:notification{ Title = "WRD Stage C", Text = "Inlining proxy aliases...", Duration = 2 }

	local result = code

	-- Pattern: local X = Y  (simple single-value alias)
	-- Collect all simple aliases: local varname = some.path
	local aliases = {}
	for varName, value in result:gmatch("local%s+([%w_]+)%s*=%s*([%w_%.]+)%s*\n") do
		-- Only track globals/paths, not function calls or complex exprs
		if not value:find("%(") and not value:find("{") then
			aliases[varName] = value
		end
	end

	-- Replace alias usages: if X is aliased to string.format,
	-- replace X( with string.format(
	for alias, original in pairs(aliases) do
		-- Only replace as function calls to avoid mangling variable reads
		result = result:gsub("([^%w_])" .. alias .. "%s*%(", function(pre)
			return pre .. original .. "("
		end)
	end

	-- Remove the now-redundant local alias declarations
	for alias, original in pairs(aliases) do
		result = result:gsub("local%s+" .. alias .. "%s*=%s*" .. original:gsub("%.", "%%.") .. "%s*\n", "")
	end

	return result
end

-- ============================================================
-- Stage 1: Decode escaped strings
-- Fixed: correct octal order + safe 1-2 digit fallback
-- ============================================================
function Lifter:DecodeStrings(code)
	GUI:notification{ Title = "Stage 1", Text = "Decoding escaped strings...", Duration = 2 }

	local decoded = code

	-- Hex escape sequences (\xXX) - do first, no ambiguity
	decoded = decoded:gsub("\\x(%x%x)", function(hex)
		local num = tonumber(hex, 16)
		return (num and num >= 0 and num <= 255) and string.char(num) or ("\\x" .. hex)
	end)

	-- 3-digit decimal escape sequences (\000 to \255)
	-- Lua escape sequences are decimal, NOT octal
	decoded = decoded:gsub("\\(%d%d%d)", function(dec)
		local num = tonumber(dec, 10)
		return (num and num >= 0 and num <= 255) and string.char(num) or ("\\" .. dec)
	end)

	-- 1-2 digit decimal escape sequences not followed by a digit
	decoded = decoded:gsub("\\(%d%d?)(%D)", function(dec, nextChar)
		local num = tonumber(dec, 10)
		return (num and num >= 0 and num <= 255) and (string.char(num) .. nextChar) or ("\\" .. dec .. nextChar)
	end)

	return decoded
end

-- ============================================================
-- Stage 2: Simplify concatenated string literals
-- Fixed: handles both single and double quoted strings
-- ============================================================
function Lifter:SimplifyStrings(code)
	GUI:notification{ Title = "Stage 2", Text = "Simplifying string concatenations...", Duration = 2 }

	local simplified = code
	local changed = true

	while changed do
		local prev = simplified
		-- double .. double
		simplified = simplified:gsub('"([^"]*)"%s*%.%.%s*"([^"]*)"', '"%1%2"')
		-- single .. single
		simplified = simplified:gsub("'([^']*)'%s*%.%.%s*'([^']*)'", "'%1%2'")
		-- double .. single  →  double
		simplified = simplified:gsub('"([^"]*)"%s*%.%.%s*\'([^\']*)\'"', '"%1%2"')
		-- single .. double  →  double
		simplified = simplified:gsub("'([^']*)'%s*%.%.%s*\"([^\"]*)\"", '"%1%2"')
		changed = (simplified ~= prev)
	end

	return simplified
end

-- ============================================================
-- Stage 3: Clean up formatting
-- Fixed: preserve newlines before collapsing spaces
-- ============================================================
function Lifter:CleanFormatting(code)
	GUI:notification{ Title = "Stage 3", Text = "Cleaning up formatting...", Duration = 2 }

	-- Normalize line endings
	local normalized = code:gsub("\r\n", "\n"):gsub("\r", "\n")

	-- Collapse runs of spaces/tabs (but NOT newlines) to a single space
	normalized = normalized:gsub("[ \t]+", " ")

	local lines = {}
	local indent = 0

	for line in (normalized .. "\n"):gmatch("([^\n]*)\n") do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed == "" then
			table.insert(lines, "")
		else
			-- Decrease indent before writing for closing keywords
			if trimmed:match("^end[^%w_]") or trimmed:match("^end$")
			or trimmed:match("^else[^%w_]") or trimmed:match("^else$")
			or trimmed:match("^elseif[^%w_]")
			or trimmed:match("^until[^%w_]") or trimmed:match("^until$") then
				indent = math.max(0, indent - 1)
			end

			table.insert(lines, string.rep("\t", indent) .. trimmed)

			-- Increase indent after opening keywords
			if trimmed:match("^function[%s%(]") or trimmed:match("^local%s+function[%s%(]")
			or trimmed:match("%s*function%s*%(")
			or trimmed:match("^if%s") or trimmed:match("^elseif%s")
			or trimmed:match("^else$")
			or trimmed:match("^for%s") or trimmed:match("^while%s")
			or trimmed:match("^repeat$") then
				indent = indent + 1
			end
		end
	end

	return table.concat(lines, "\n")
end

-- ============================================================
-- Stage 4: Runtime loadstring capture
-- Fixed: hook via getgenv so the executing function sees it;
--        safe nil check on captured; proper cleanup on error
-- ============================================================
function Lifter:TryExecuteCapture(code)
	GUI:notification{ Title = "Stage 4", Text = "Attempting runtime capture...", Duration = 2 }

	local capturedList = {}
	local largestCapture = nil
	local hookActive = true

	-- Hook via getgenv so inner calls inside the executed chunk see our hook
	local genv = getgenv and getgenv() or getfenv(0)
	local realLoadstring = genv.loadstring or loadstring

	local function hookedLoadstring(str, ...)
		if hookActive and type(str) == "string" and #str > 100 then
			table.insert(capturedList, str)
			if not largestCapture or #str > #largestCapture then
				largestCapture = str
			end
		end
		return realLoadstring(str, ...)
	end

	-- Install hook
	pcall(function() genv.loadstring = hookedLoadstring end)
	if genv.load then
		pcall(function() genv.load = hookedLoadstring end)
	end

	-- Execute in isolated env that blocks side-effects
	local blocked = function() return nil end
	local safeEnv = setmetatable({
		loadstring  = hookedLoadstring,
		load        = hookedLoadstring,
		require     = blocked,
		spawn       = blocked,
		delay       = blocked,
		wait        = function() return 0 end,
		task        = { spawn = blocked, defer = blocked, delay = blocked, wait = function() return 0 end },
		print       = function() end,
		warn        = function() end,
		type        = type,
		typeof      = typeof,
		tonumber    = tonumber,
		tostring    = tostring,
		string      = string,
		math        = math,
		table       = table,
		pairs       = pairs,
		ipairs      = ipairs,
		next        = next,
		select      = select,
		unpack      = unpack or table.unpack,
		getfenv     = getfenv,
		setfenv     = setfenv,
		pcall       = pcall,
		xpcall      = xpcall,
		newproxy    = newproxy,
		getmetatable= getmetatable,
		setmetatable= setmetatable,
	}, { __index = function() return nil end })

	pcall(function()
		local func, err = realLoadstring(code)
		if func then
			setfenv(func, safeEnv)
			pcall(func)
		end
	end)

	-- Restore hook
	hookActive = false
	pcall(function() genv.loadstring = realLoadstring end)
	if genv.load then
		pcall(function() genv.load = realLoadstring end)
	end

	if largestCapture and #largestCapture > 100 then
		GUI:notification{
			Title = "Captured!",
			Text = string.format("Got %d inner block(s)!", #capturedList),
			Duration = 3
		}
		return largestCapture
	end

	return code
end

-- ============================================================
-- Run Prometheus parse → unparse (used twice so factored out)
-- ============================================================
function Lifter:_prometheusPass(code, components)
	local p = components.Parser:new({ LuaVersion = "LuaU" })
	local ast = p:parse(code)
	local u = components.Unparser:new({
		LuaVersion   = "LuaU",
		PrettyPrint  = true,
		IndentSpaces = 4
	})
	return u:unparse(ast)
end

-- ============================================================
-- Execute arbitrary code
-- ============================================================
function Lifter:ExecuteCode(code)
	local f, e = loadstring(code)
	if f then
		task.spawn(f)
		GUI:notification{ Title = "Execution", Text = "Code executed successfully!", Duration = 2 }
	else
		warn(e)
		GUI:notification{ Title = "Error", Text = "Syntax error in code", Duration = 3 }
	end
end

-- ============================================================
-- Main multi-stage lift
-- Fixed: all wait() → task.wait(); timeout guard on IsLifting;
--        VFS cache preserved between runs
-- ============================================================
function Lifter:LiftCode(inputCode, callback)
	if self.State.IsLifting then
		GUI:notification{ Title = "Busy", Text = "Lifting already in progress...", Duration = 2 }
		return
	end

	if #inputCode == 0 then
		GUI:notification{ Title = "Empty", Text = "No code to lift!", Duration = 2 }
		return
	end

	self.State.IsLifting = true

	task.spawn(function()
		-- Safety: always release the lock even if something throws
		local ok, err = pcall(function()

			local function safeStage(name, fn)
				local s, r = pcall(fn)
				if s then return r end
				warn(string.format("[Lifter] %s failed: %s", name, tostring(r)))
				GUI:notification{ Title = name .. " Error", Text = "Stage failed, continuing...", Duration = 2 }
				return nil
			end

			-- Hide VFS traces from debug.getinfo
			local _oldInfo = debug.getinfo
			if getgenv then
				pcall(function()
					getgenv().debug.getinfo = function(f, ...)
						local res = _oldInfo(f, ...)
						if res and type(res.source) == "string" and res.source:find("VFS") then
							res.source = "=[C]"
						end
						return res
					end
				end)
			end

			local components = self:_initializeLifter()
			if not components.Parser then
				GUI:notification{ Title = "VFS Error", Text = "Failed to load Prometheus. Check console.", Duration = 4 }
				return
			end

			local currentCode = inputCode
			local isWRD = self:IsWRD(currentCode)

			if isWRD then
				GUI:notification{ Title = "WRD Detected", Text = "WeAreDevs obfuscation found, running targeted pipeline...", Duration = 3 }
			end

			-- WRD Stage A: strip wrapper (WRD only)
			if isWRD then
				local sA = safeStage("WRD Stage A: Strip Wrapper", function()
					return self:WRD_StripWrapper(currentCode)
				end)
				if sA then currentCode = sA end
				task.wait(0.2)
			end

			-- Stage 1: decode escape sequences
			local s1 = safeStage("Stage 1: String Decode", function()
				return self:DecodeStrings(currentCode)
			end)
			if s1 then currentCode = s1 end
			task.wait(0.3)

			-- WRD Stage B: resolve string pool (WRD only, before Prometheus)
			if isWRD then
				local sB = safeStage("WRD Stage B: String Pool", function()
					return self:WRD_ResolveStringPool(currentCode)
				end)
				if sB then currentCode = sB end
				task.wait(0.2)
			end

			-- Stage 2: Prometheus AST pass
			GUI:notification{ Title = "Prometheus", Text = "Analyzing AST structure...", Duration = 2 }
			local s2 = safeStage("Stage 2: Prometheus", function()
				return self:_prometheusPass(currentCode, components)
			end)
			if s2 then currentCode = s2 end
			task.wait(0.3)

			-- WRD Stage C: inline proxy aliases (WRD only, after Prometheus cleans up names)
			if isWRD then
				local sC = safeStage("WRD Stage C: Inline Aliases", function()
					return self:WRD_InlineAliases(currentCode)
				end)
				if sC then currentCode = sC end
				task.wait(0.2)
			end

			-- Stage 3: simplify string concatenations
			local s3 = safeStage("Stage 3: Simplify Strings", function()
				return self:SimplifyStrings(currentCode)
			end)
			if s3 then currentCode = s3 end
			task.wait(0.3)

			-- Stage 4: runtime loadstring capture
			local s4 = safeStage("Stage 4: Runtime Capture", function()
				return self:TryExecuteCapture(currentCode)
			end)

			if s4 and s4 ~= currentCode and #s4 > 100 then
				currentCode = s4
				-- Stage 4b: re-run Prometheus on the captured payload
				local s4b = safeStage("Stage 4b: Re-Prometheus", function()
					return self:_prometheusPass(currentCode, components)
				end)
				if s4b then currentCode = s4b end
				-- If it was WRD, try the pool resolver again on the inner payload
				if isWRD then
					local s4c = safeStage("Stage 4c: WRD Pool (inner payload)", function()
						return self:WRD_ResolveStringPool(currentCode)
					end)
					if s4c then currentCode = s4c end
				end
			end
			task.wait(0.3)

			-- Stage 5: format cleanup
			local s5 = safeStage("Stage 5: Format Cleanup", function()
				return self:CleanFormatting(currentCode)
			end)
			if s5 then currentCode = s5 end

			self.State.CurrentCode = currentCode
			GUI:notification{ Title = "Complete!", Text = "Multi-stage lifting finished!", Duration = 3 }

			if callback then callback(currentCode) end

			-- Restore debug.getinfo
			if getgenv then
				pcall(function() getgenv().debug.getinfo = _oldInfo end)
			end
		end)

		if not ok then
			warn("[Lifter] Unhandled error during lift: " .. tostring(err))
			GUI:notification{ Title = "Fatal Error", Text = "Lifter crashed. Check console.", Duration = 4 }
		end

		-- Always release the lock
		self.State.IsLifting = false
	end)
end

-- Convenience: decode octal only
function Lifter:DecodeOctalString(str)
	return str:gsub("\\(%d%d%d)", function(dec)
		local num = tonumber(dec, 10)
		return (num and num <= 255) and string.char(num) or ("\\" .. dec)
	end)
end

-- ============================================================
-- UI
-- ============================================================
local MainTab = GUI:tab{ Name = "Multi-Stage Lifter", Icon = "rbxassetid://8569322835" }
local codeInput  = ""
local codeOutput = ""

local EditorSection = MainTab:section{ Name = "Code Editor" }

EditorSection:button{
	Name = "Instructions",
	Description = "How to use this advanced lifter",
	Callback = function()
		GUI:notification{
			Title = "Multi-Stage Lifting",
			Text = "5 stages: 1) Escape decode  2) Prometheus AST  3) String simplify  4) Runtime capture  5) Format cleanup",
			Duration = 6
		}
	end
}

EditorSection:button{
	Name = "Paste Code",
	Description = "Enter your obfuscated code",
	Callback = function()
		local inputFrame = Instance.new("ScreenGui")
		inputFrame.Name = "LifterInput"
		inputFrame.Parent = game:GetService("CoreGui")
		inputFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local bg = Instance.new("Frame", inputFrame)
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bg.BackgroundTransparency = 0.5
		bg.BorderSizePixel = 0

		local container = Instance.new("Frame", bg)
		container.Size = UDim2.fromOffset(500, 350)
		container.Position = UDim2.fromScale(0.5, 0.5)
		container.AnchorPoint = Vector2.new(0.5, 0.5)
		container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		container.BorderSizePixel = 0
		Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

		local title = Instance.new("TextLabel", container)
		title.Size = UDim2.new(1, -20, 0, 30)
		title.Position = UDim2.fromOffset(10, 10)
		title.BackgroundTransparency = 1
		title.Text = "Paste Obfuscated Code"
		title.TextColor3 = Color3.fromRGB(70, 130, 180)
		title.Font = Enum.Font.SourceSansBold
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left

		local textBox = Instance.new("TextBox", container)
		textBox.Size = UDim2.new(1, -20, 1, -90)
		textBox.Position = UDim2.fromOffset(10, 45)
		textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
		textBox.BorderColor3 = Color3.fromRGB(70, 130, 180)
		textBox.BorderSizePixel = 1
		textBox.TextColor3 = Color3.fromRGB(220, 220, 220)
		textBox.Font = Enum.Font.Code
		textBox.TextSize = 14
		textBox.TextXAlignment = Enum.TextXAlignment.Left
		textBox.TextYAlignment = Enum.TextYAlignment.Top
		textBox.MultiLine = true
		textBox.ClearTextOnFocus = false
		textBox.PlaceholderText = "Paste your obfuscated Lua code here..."
		textBox.Text = codeInput
		Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 5)

		local function makeBtn(parent, text, color, xOffset)
			local btn = Instance.new("TextButton", parent)
			btn.Size = UDim2.fromOffset(100, 30)
			btn.Position = UDim2.new(1, xOffset, 1, -35)
			btn.BackgroundColor3 = color
			btn.BorderSizePixel = 0
			btn.Text = text
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 14
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
			return btn
		end

		local submitBtn = makeBtn(container, "Submit",  Color3.fromRGB(70, 130, 180), -110)
		local cancelBtn = makeBtn(container, "Cancel",  Color3.fromRGB(50, 50, 55),   -220)

		submitBtn.MouseButton1Click:Connect(function()
			codeInput = textBox.Text
			Lifter.State.CurrentCode = codeInput
			inputFrame:Destroy()
			GUI:notification{ Title = "Code Loaded", Text = "Ready for lifting!", Duration = 2 }
		end)
		cancelBtn.MouseButton1Click:Connect(function()
			inputFrame:Destroy()
		end)
	end
}

EditorSection:button{
	Name = "Multi-Stage Lift",
	Description = "Advanced 5-stage deobfuscation",
	Callback = function()
		if #Lifter.State.CurrentCode == 0 then
			GUI:notification{ Title = "No Code", Text = "Please paste code first!", Duration = 2 }
			return
		end
		Lifter:LiftCode(Lifter.State.CurrentCode, function(lifted)
			codeOutput = lifted
		end)
	end
}

EditorSection:button{
	Name = "View Output",
	Description = "View the lifted code",
	Callback = function()
		if #codeOutput == 0 then
			GUI:notification{ Title = "No Output", Text = "No lifted code yet!", Duration = 2 }
			return
		end

		local outputFrame = Instance.new("ScreenGui")
		outputFrame.Name = "LifterOutput"
		outputFrame.Parent = game:GetService("CoreGui")
		outputFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local bg = Instance.new("Frame", outputFrame)
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bg.BackgroundTransparency = 0.5
		bg.BorderSizePixel = 0

		local container = Instance.new("Frame", bg)
		container.Size = UDim2.fromOffset(650, 450)
		container.Position = UDim2.fromScale(0.5, 0.5)
		container.AnchorPoint = Vector2.new(0.5, 0.5)
		container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		container.BorderSizePixel = 0
		Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

		local title = Instance.new("TextLabel", container)
		title.Size = UDim2.new(1, -20, 0, 30)
		title.Position = UDim2.fromOffset(10, 10)
		title.BackgroundTransparency = 1
		title.Text = "Deobfuscated Output"
		title.TextColor3 = Color3.fromRGB(70, 130, 180)
		title.Font = Enum.Font.SourceSansBold
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left

		local scroll = Instance.new("ScrollingFrame", container)
		scroll.Size = UDim2.new(1, -20, 1, -90)
		scroll.Position = UDim2.fromOffset(10, 45)
		scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
		scroll.BorderColor3 = Color3.fromRGB(70, 130, 180)
		scroll.BorderSizePixel = 1
		scroll.ScrollBarThickness = 4
		Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 5)

		local textLabel = Instance.new("TextLabel", scroll)
		textLabel.Size = UDim2.new(1, -10, 1, 0)
		textLabel.Position = UDim2.fromOffset(5, 5)
		textLabel.BackgroundTransparency = 1
		textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		textLabel.Font = Enum.Font.Code
		textLabel.TextSize = 14
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.Text = codeOutput
		textLabel.TextWrapped = true
		-- Resize to fit content
		task.wait()
		textLabel.Size = UDim2.new(1, -10, 0, textLabel.TextBounds.Y + 10)
		scroll.CanvasSize = UDim2.new(0, 0, 0, textLabel.TextBounds.Y + 20)

		local function makeBtn(parent, text, color, xOffset)
			local btn = Instance.new("TextButton", parent)
			btn.Size = UDim2.fromOffset(100, 30)
			btn.Position = UDim2.new(1, xOffset, 1, -35)
			btn.BackgroundColor3 = color
			btn.BorderSizePixel = 0
			btn.Text = text
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 14
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
			return btn
		end

		local copyBtn  = makeBtn(container, "Copy",  Color3.fromRGB(70, 130, 180), -110)
		local closeBtn = makeBtn(container, "Close", Color3.fromRGB(50, 50, 55),   -220)

		copyBtn.MouseButton1Click:Connect(function()
			setclipboard(codeOutput)
			GUI:notification{ Title = "Copied", Text = "Code copied to clipboard!", Duration = 2 }
		end)
		closeBtn.MouseButton1Click:Connect(function()
			outputFrame:Destroy()
		end)
	end
}

EditorSection:button{
	Name = "Execute Output",
	Description = "Run the deobfuscated code",
	Callback = function()
		if #codeOutput == 0 then
			GUI:notification{ Title = "No Output", Text = "Nothing to execute!", Duration = 2 }
			return
		end
		Lifter:ExecuteCode(codeOutput)
	end
}

EditorSection:button{
	Name = "Clear All",
	Description = "Reset everything",
	Callback = function()
		codeInput  = ""
		codeOutput = ""
		Lifter.State.CurrentCode = ""
		GUI:notification{ Title = "Cleared", Text = "All cleared!", Duration = 2 }
	end
}

-- ============================================================
-- Utilities Tab
-- ============================================================
local UtilsTab = GUI:tab{ Name = "Utilities", Icon = "rbxassetid://8559790237" }
local WRDSection = UtilsTab:section{ Name = "WeAreDevs Targeted" }

WRDSection:button{
	Name = "Auto-Detect WRD",
	Description = "Check if pasted code is WRD-obfuscated",
	Callback = function()
		if #Lifter.State.CurrentCode == 0 then
			GUI:notification{ Title = "No Code", Text = "Paste code first!", Duration = 2 }
			return
		end
		if Lifter:IsWRD(Lifter.State.CurrentCode) then
			GUI:notification{ Title = "WRD Detected!", Text = "WeAreDevs obfuscation signature found. Use Multi-Stage Lift.", Duration = 4 }
		else
			GUI:notification{ Title = "Not WRD", Text = "No WRD signature detected. May still be Prometheus-based.", Duration = 3 }
		end
	end
}

WRDSection:button{
	Name = "WRD: Strip Wrapper Only",
	Description = "Remove the outer return(function(...) closure",
	Callback = function()
		if #Lifter.State.CurrentCode == 0 then
			GUI:notification{ Title = "No Code", Text = "Paste code first!", Duration = 2 }
			return
		end
		codeOutput = Lifter:WRD_StripWrapper(Lifter.State.CurrentCode)
		GUI:notification{ Title = "Done", Text = "WRD wrapper stripped!", Duration = 2 }
	end
}

WRDSection:button{
	Name = "WRD: Resolve String Pool",
	Description = "Resolve _POOL[N] references to string literals",
	Callback = function()
		if #Lifter.State.CurrentCode == 0 then
			GUI:notification{ Title = "No Code", Text = "Paste code first!", Duration = 2 }
			return
		end
		local decoded = Lifter:DecodeStrings(Lifter.State.CurrentCode)
		codeOutput = Lifter:WRD_ResolveStringPool(decoded)
		GUI:notification{ Title = "Done", Text = "String pool resolved!", Duration = 2 }
	end
}

WRDSection:button{
	Name = "WRD: Full Targeted Lift",
	Description = "Run the full pipeline with WRD stages forced on",
	Callback = function()
		if #Lifter.State.CurrentCode == 0 then
			GUI:notification{ Title = "No Code", Text = "Paste code first!", Duration = 2 }
			return
		end
		-- Force WRD mode by prepending the signature if not present
		local code = Lifter.State.CurrentCode
		if not Lifter:IsWRD(code) then
			code = "--[[ v1.0.0 https://wearedevs.net/obfuscator ]]\n" .. code
		end
		Lifter:LiftCode(code, function(lifted)
			codeOutput = lifted
		end)
	end
}

local QuickSection = UtilsTab:section{ Name = "Quick Tools" }

QuickSection:button{
	Name = "Decode Escape Sequences Only",
	Description = "Decode \\xxx / \\xXX without full lift",
	Callback = function()
		if #Lifter.State.CurrentCode > 0 then
			codeOutput = Lifter:DecodeStrings(Lifter.State.CurrentCode)
			GUI:notification{ Title = "Decoded", Text = "Escape sequences decoded!", Duration = 2 }
		else
			GUI:notification{ Title = "No Code", Text = "Paste code first!", Duration = 2 }
		end
	end
}

QuickSection:button{
	Name = "Extract String Pool",
	Description = "Extract and decode constant string arrays",
	Callback = function()
		if #Lifter.State.CurrentCode == 0 then
			GUI:notification{ Title = "No Code", Text = "Paste code first!", Duration = 2 }
			return
		end

		local code = Lifter:DecodeStrings(Lifter.State.CurrentCode)
		local strings = {}
		local count = 0

		for arrayContent in code:gmatch('=%s*{([^}]+)}') do
			for str in arrayContent:gmatch('"([^"]*)"') do
				if #str > 0 then
					count = count + 1
					table.insert(strings, string.format('[%d] = "%s"', count, str))
				end
			end
		end

		if count > 0 then
			codeOutput = "-- Extracted String Pool (" .. count .. " strings)\n\n" .. table.concat(strings, "\n")
			GUI:notification{ Title = "Extracted", Text = string.format("Found %d strings!", count), Duration = 3 }
		else
			GUI:notification{ Title = "None Found", Text = "No string pools detected", Duration = 2 }
		end
	end
}

QuickSection:button{
	Name = "Copy Output",
	Description = "Quick copy to clipboard",
	Callback = function()
		if #codeOutput > 0 then
			setclipboard(codeOutput)
			GUI:notification{ Title = "Copied", Text = "Copied!", Duration = 2 }
		else
			GUI:notification{ Title = "Empty", Text = "Nothing to copy!", Duration = 2 }
		end
	end
}

-- Welcome
GUI:notification{ Title = "Zukas Lifter", Text = "Multi-stage deobfuscator", Duration = 3 }
print("version loaded!")
