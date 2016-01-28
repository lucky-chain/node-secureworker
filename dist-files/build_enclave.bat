where cl || call "%VS110COMNTOOLS%VsDevCmd.bat"
where ld || set "PATH=%PATH%;C:\MinGW\bin"
cl /c /I"C:\Program Files (x86)\Intel\IntelSGXSDK\include\tlibc" /I"..\scripts" "scripts-table.c"
ld -r -b binary -o scripts-binary.lib %*
link "/OUT:duk_enclave.dll" "/LIBPATH:C:\Program Files (x86)\Intel\IntelSGXSDK\bin\Win32\Debug" "sgx_trts.lib" "sgx_tstdc.lib" "sgx_tservice.lib" "sgx_tcrypto_opt.lib" "sgx_tstdcxx.lib" /NODEFAULTLIB /MANIFEST:NO /NOENTRY /DYNAMICBASE /NXCOMPAT /MACHINE:X86 /DLL "..\duk_enclave\Debug\duk_enclave.obj" "..\duk_enclave\Debug\duk_enclave_t.obj" "..\Debug\duktape-dist.lib" "scripts-binary.lib" "scripts-table.obj"
if not exist duk_enclave_private.pem openssl.exe genrsa -out duk_enclave_private.pem -3 3072
sgx_sign sign -key "duk_enclave_private.pem" -enclave "duk_enclave.dll" -out "duk_enclave.signed.dll" -config "..\duk_enclave\duk_enclave.config.xml"