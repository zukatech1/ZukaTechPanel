// This script hooks common anti-debugging functions to make the process
// unaware that it is being traced or debugged by Frida.

// 1. Hook Kernel32!IsDebuggerPresent
// This is the most common and basic check. We will force it to always return FALSE (0).
try {
    const isDebuggerPresentPtr = Module.getExportByName('kernel32.dll', 'IsDebuggerPresent');
    
    Interceptor.replace(isDebuggerPresentPtr, new NativeCallback(() => {
        // Log the attempt to the Frida console for our own debugging.
        console.log("[Anti-AD] IsDebuggerPresent called! Returning FALSE.");
        return 0; // Return FALSE
    }, 'int', []));
    
    console.log("[Anti-AD] Hook on IsDebuggerPresent installed successfully.");

} catch (err) {
    console.log("[Anti-AD] Could not find IsDebuggerPresent. The target may not use it.");
}

// 2. Hook Kernel32!CheckRemoteDebuggerPresent
// Another very common check.
try {
    const checkRemoteDebuggerPresentPtr = Module.getExportByName('kernel32.dll', 'CheckRemoteDebuggerPresent');

    Interceptor.attach(checkRemoteDebuggerPresentPtr, {
        onEnter: function(args) {
            // This function takes two arguments: hProcess and a pointer to a BOOL.
            // We store the pointer to the boolean result.
            this.pbIsPresent = args[1];
        },
        onLeave: function(retval) {
            // After the original function runs, we overwrite its result in memory.
            this.pbIsPresent.writeU8(0); // Write FALSE (0) to the pointer.
            console.log("[Anti-AD] CheckRemoteDebuggerPresent called! Falsified result to FALSE.");
        }
    });

    console.log("[Anti-AD] Hook on CheckRemoteDebuggerPresent installed successfully.");

} catch (err) {
    console.log("[Anti-AD] Could not find CheckRemoteDebuggerPresent.");
}