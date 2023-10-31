%Windir%\System32\certutil.exe -addstore CA R4_R1RootCA.crt
%Windir%\System32\certutil.exe -addstore CA R4_R2RootCA.crt
%Windir%\System32\certutil.exe -addstore CA R4_R3RootCA.crt
regedit.exe /s R4RootCA.reg
regedit.exe /s R4_RootCertificateAuthority.reg