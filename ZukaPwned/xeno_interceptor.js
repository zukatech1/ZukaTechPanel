// xeno_interceptor.js

// Use 'use strict' for better error-checking and performance
'use strict';

// Send a message to the Python GUI to confirm the script has loaded.
send({ 'log': 'Xeno interceptor loaded and running.' });

// Find the memory address of the CreateFileW function, which is exported by kernel32.dll
const createFileWPtr = Module.getExportByName('kernel32.dll', 'CreateFileW');

// Attach a Frida Interceptor to the CreateFileW function.
Interceptor.attach(createFileWPtr, {
    /**
     * This function is executed every time CreateFileW is called in the target process.
     * @param {Array} args - An array of arguments passed to the function. For CreateFileW,
     *                       args[0] is the pointer to the filename (lpFileName).
     */
    onEnter: function (args) {
        // args[0] is a NativePointer. We need to read the UTF-16 string it points to.
        const filename = args[0].readUtf16String();

        // Check if the filename is valid and contains our target path components.
        // Using .toLowerCase() makes the check case-insensitive and more robust.
        if (filename && filename.toLowerCase().includes('xeno\\workspace\\script.txt')) {
            
            // Log to the Frida console (useful for debugging with frida-tools)
            console.log(`[+] Intercepted CreateFileW call for target file: ${filename}`);
            
            // The returnAddress property gives us the address of the instruction
            // that will be executed after CreateFileW returns. This is exactly what we need
            // to find the location in the Xeno DLL's code.
            const callerAddress = this.returnAddress;
            console.log(`[!] Call originated from: ${callerAddress}`);

            // Send a structured payload back to our Python application's
            // 'on_script_message' handler.
            send({
                'status': 'found_call',
                'address': callerAddress.toString()
            });
        }
    },

    /**
     * This function is executed when CreateFileW is about to return.
     * @param {*} retval - The return value of the function.
     */
    onLeave: function (retval) {
        // We don't need to do anything here for this operation, but it's
        // useful for monitoring if the function succeeded or failed.
    }
});