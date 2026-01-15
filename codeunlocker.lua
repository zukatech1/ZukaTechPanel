--local code = workspace.Staff_Code.Code.SurfaceGui.Desc.Text
local code = workspace.CodeDoor.Code.Value
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Code",
    Text = code,
    Duration = 9
})
