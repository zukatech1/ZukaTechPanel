// anti_themida.js
// A Frida script designed to neutralize common Themida anti-debugging checks.

// Send a message to our Python GUI to confirm injection.
send({ "status": "script_injected", "message": "Anti-Themida script is now active." });

// --- Hook 1: IsDebuggerPresent ---
// This is the most common and basic check.
const isDebuggerPresent = Module.getExportByName('kernel32.dll', 'IsDebuggerPresent');
Interceptor.replace(isDebuggerPresent, new NativeCallback(() => {
    send({ "log": "Blocked call to IsDebuggerPresent. Returning FALSE." });
    return 0; // Return FALSE (0)
}, 'int', []));

// --- Hook 2: NtQueryInformationProcess ---
// This is a more advanced check. The application can ask the kernel directly
// if a debugger is attached to its process.
const ntQueryInfoProcess = Module.getExportByName('ntdll.dll', 'NtQueryInformationProcess');
Interceptor.attach(ntQueryInfoProcess, {
    onEnter: function(args) {
        // The second argument (ProcessInformationClass) tells us what info is being requested.
        // A value of 7 (ProcessDebugPort) is a request to check for a debugger.
        const processInfoClass = args[1].toInt32();
        if (processInfoClass === 7) {
            // We store the pointer to the output buffer. We will modify it on leave.
            this.isDebugPortQuery = true;
            this.outputBuffer = args[2];
            send({ "log": "Detected NtQueryInformationProcess call for ProcessDebugPort." });
        } else {
            this.isDebugPortQuery = false;
        }
    },
    onLeave: function(retval) {
        // If this was a debugger check, we overwrite the result.
        if (this.isDebugPortQuery) {
            // The kernel would normally write a non-zero value here if a debugger
            // is present. We write 0 to indicate no debugger.
            this.outputBuffer.writePointer(ptr(0));
            send({ "log": "Patched ProcessDebugPort result to 0 (no debugger)." });
        }
    }
});

// --- Hook 3: OutputDebugStringA ---
// Sometimes used to detect debuggers by timing how long the call takes.
// We will simply neutralize it.
const outputDebugString = Module.getExportByName('kernel32.dll', 'OutputDebugStringA');
Interceptor.replace(outputDebugString, new NativeCallback((message) => {
    // Do nothing. The original function is never called.
    // We can optionally log the message if we want.
    // send({ "log": `Blocked OutputDebugStringA: ${message.readCString()}` });
}, 'void', ['pointer']));

send({ "status": "hooks_applied", "message": "All Anti-Themida hooks are in place." });