@echo off
cd /d %~dp0
chcp 65001 >nul 2>nul
title David Miller Certificate Tool ^(x64 Release^)
::title David Miller Certificate Tool ^(x86 Release^)
md temp >nul 2>nul

set echoName=true
goto choice

:choice
if %echoName%==true (
	echo David Miller Certificate Tool
	set echoName=false
)
echo Please disable antivirus program before starting!
echo [1] Install root CA certificates ^(Recommended^)
echo [2] Uninstall root and intermediate CA certificates
echo [3] Visit our website
echo [4] Show more options
echo [5] Exit
set /p mainOption=Please enter your choice ^(1-5^):
if not defined mainOption (
	set choice=main
	goto invalidOption
)
if %mainOption%==1 (
	set mainOption=
	set installationMode=production
	set installIntermediateCA=false
	goto installationPrecheck
)
if %mainOption%==2 (
	set mainOption=
	goto uninstallation
)
if %mainOption%==3 (
	set mainOption=
	set url=pki
	goto openURL
)
if %mainOption%==4 (
	set mainOption=
	set echoName=true
	cls
	goto moreChoice
)
if %mainOption%==5 (
	exit
)
set choice=main
set mainOption=
goto invalidOption

:moreChoice
if %echoName%==true (
	echo David Miller Certificate Tool
	set echoName=false
)
echo Please disable antivirus program before starting!
echo [1] Install production root and intermediate CA certificates
echo [2] Install TEST CA certificates
echo [3] Uninstall TEST CA certificates
echo [4] Return to main menu
echo [5] Exit
set /p moreOption=Please enter your choice ^(1-5^):
if not defined moreOption (
	set choice=more
	goto invalidOption
)
if %moreOption%==1 (
	set moreOption=
	set installationMode=production
	set installIntermediateCA=true
	goto installationPrecheck
)
if %moreOption%==2 (
	set moreOption=
	set installationMode=test
	goto testInstallationPrecheck
)
if %moreOption%==3 (
	set moreOption=
	goto testUninstallation
)
if %moreOption%==4 (
	set moreOption=
	set echoName=true
	cls
	goto choice
)
if %moreOption%==5 (
	exit
)
set choice=more
set moreOption=
goto invalidOption

:installationPrecheck
cls
echo David Miller Certificate Tool
if %installIntermediateCA%==true (
	echo Validating integrity of 18 files...
) else (
	echo Validating integrity of 5 files...
)
if not exist "%~dp0\cross-sign\R4_R1RootCA.crt" (
	goto installationFailed
)
if not exist "%~dp0\cross-sign\R4_R2RootCA.crt" (
	goto installationFailed
)
if not exist "%~dp0\cross-sign\R4_R3RootCA.crt" (
	goto installationFailed
)
if not exist "%~dp0\root\R4RootCA.reg" (
	goto installationFailed
)
if not exist "%~dp0\cross-sign\R4_RootCertificateAuthority.reg" (
	goto installationFailed
)
if %installIntermediateCA%==true (
	if not exist "%~dp0\intermediate\ClientAuthCAG3SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\CodeSigningCAG3SHA384.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\DocumentSigningCAG2SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\DVServerCAG4SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\ECCDVServerCAG5SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\ECCEVServerCAG4SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\ECCOVServerCAG6SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\EVServerCAG4SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\ExternalCAG4SHA384.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\OVServerCAG5SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\OVServerCAG6SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\SecureEmailCAG5SHA256.crt" (
		goto installationFailed
	)
	if not exist "%~dp0\intermediate\TimestampingCAG8SHA256.crt" (
		goto installationFailed
	)
)
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\cross-sign\R4_R1RootCA.crt" SHA256 > "%~dp0\temp\R4_R1RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\cross-sign\R4_R2RootCA.crt" SHA256 > "%~dp0\temp\R4_R2RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\cross-sign\R4_R3RootCA.crt" SHA256 > "%~dp0\temp\R4_R3RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\root\R4RootCA.reg" SHA256 > "%~dp0\temp\R4RootCA.reg.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\cross-sign\R4_RootCertificateAuthority.reg" SHA256 > "%~dp0\temp\R4_RootCertificateAuthority.reg.sha256"
if %installIntermediateCA%==true (
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\ClientAuthCAG3SHA256.crt" SHA256 > "%~dp0\temp\ClientAuthCAG3SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\CodeSigningCAG3SHA384.crt" SHA256 > "%~dp0\temp\CodeSigningCAG3SHA384.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\DocumentSigningCAG2SHA256.crt" SHA256 > "%~dp0\temp\DocumentSigningCAG2SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\DVServerCAG4SHA256.crt" SHA256 > "%~dp0\temp\DVServerCAG4SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\ECCDVServerCAG5SHA256.crt" SHA256 > "%~dp0\temp\ECCDVServerCAG5SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\ECCEVServerCAG4SHA256.crt" SHA256 > "%~dp0\temp\ECCEVServerCAG4SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\ECCOVServerCAG6SHA256.crt" SHA256 > "%~dp0\temp\ECCOVServerCAG6SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\EVServerCAG4SHA256.crt" SHA256 > "%~dp0\temp\EVServerCAG4SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\ExternalCAG4SHA384.crt" SHA256 > "%~dp0\temp\ExternalCAG4SHA384.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\OVServerCAG5SHA256.crt" SHA256 > "%~dp0\temp\OVServerCAG5SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\OVServerCAG6SHA256.crt" SHA256 > "%~dp0\temp\OVServerCAG6SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\SecureEmailCAG5SHA256.crt" SHA256 > "%~dp0\temp\SecureEmailCAG5SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\TimestampingCAG8SHA256.crt" SHA256 > "%~dp0\temp\TimestampingCAG8SHA256.crt.sha256"
)
findstr f56e728f435af6322561fa9a62c366a6032de8c371155572004f7fe4a48c0371 "%~dp0\temp\R4_R1RootCA.crt.sha256" >nul 2>nul || goto installationFailed
findstr a33f7f708fbb18326315bf469e8a77feb234478683b249ad5ad3a13f4f631742 "%~dp0\temp\R4_R2RootCA.crt.sha256" >nul 2>nul || goto installationFailed
findstr cfe2a8c5ec0d2828e06b2a6306c5fb6722581dc10864059463356904915750a4 "%~dp0\temp\R4_R3RootCA.crt.sha256" >nul 2>nul || goto installationFailed
findstr 00714cecb03a5eec64570e5b0ccf90a9a1bb429825c2a83a9e719558c7738248 "%~dp0\temp\R4RootCA.reg.sha256" >nul 2>nul || goto installationFailed
findstr 674095a879128f7e13d8336051cf1a622eda5a29e93faca302fbf7b59e90031b "%~dp0\temp\R4_RootCertificateAuthority.reg.sha256" >nul 2>nul || goto installationFailed
if %installIntermediateCA%==true (
	findstr 0c27b946daeb726ac8d84bcbe2c7cc6355262a68989532e94050db10c8aa71f4 "%~dp0\temp\ClientAuthCAG3SHA256.crt.sha256"  >nul 2>nul || goto installationFailed
	findstr 53999bfc6b657f8975f131a30c1f4c8b2b4600854570e99d97ce6ff08ab8596d "%~dp0\temp\CodeSigningCAG3SHA384.crt.sha256"  >nul 2>nul || goto installationFailed
	findstr 564eb266594a6a48b57c3139dcd679b7b358e6ee277001643f007af460532663 "%~dp0\temp\DVServerCAG4SHA256.crt.sha256"  >nul 2>nul || goto installationFailed
	findstr 24e33eeb2553d919c68c912da4c8b37b99228567d209f867f9fcd6930c2d7fb8 "%~dp0\temp\DocumentSigningCAG2SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 6977c709a643b4c8afe0756c9337dfce6bbe871891c6f6f501714e08e187f1ec "%~dp0\temp\ECCDVServerCAG5SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr c28eec34793954c458e281b47a8ae4d47c80f067041b2c4ba11ec98d578b907b "%~dp0\temp\ECCEVServerCAG4SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 34d98e0e1e60f7121f22e68d75e397bd0eea8970dc8710afc00122a5b55f05dc "%~dp0\temp\ECCOVServerCAG6SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 3e191ad3d0bee6333b34b6e5bab844ca0b32c88d240f8e0469d71f35d5e6801a "%~dp0\temp\EVServerCAG4SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 49827bf2365f057bda6ce55a0e6f7758f30280a13835fc79326ca48f1c95e467 "%~dp0\temp\ExternalCAG4SHA384.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 37155abeb071af179410c4368c6154c262efe0c362fc572d448c9303ba8edd8f "%~dp0\temp\OVServerCAG5SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 2d80d1d7e9d8d7ae71602842a7a350ed3f9fd84f1b60acaaf6333f604777b268 "%~dp0\temp\OVServerCAG6SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 412556f536caf1295eeaacc093f6dee5d10b08796110a4667e908b2b1fa99d4c "%~dp0\temp\SecureEmailCAG5SHA256.crt.sha256" >nul 2>nul || goto installationFailed
	findstr 487fcfb818b20c395e03baf22fc470df5845b2785c372505b48f6ba257938935 "%~dp0\temp\TimestampingCAG8SHA256.crt.sha256" >nul 2>nul || goto installationFailed
)
if %installIntermediateCA%==true (
	echo All 18 files successfully validated!
) else (
	echo All 5 files successfully validated!
)
goto installation

:installation
echo Installing David Miller Root CA - R1 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\cross-sign\R4_R1RootCA.crt" >nul 2>nul
echo Installing David Miller Root CA - R2 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\cross-sign\R4_R2RootCA.crt" >nul 2>nul
echo Installing David Miller Root CA - R3 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\cross-sign\R4_R3RootCA.crt" >nul 2>nul
echo Installing David Miller Root CA - R4...
regedit.exe /s "%~dp0\root\R4RootCA.reg" >nul 2>nul
echo Installing David Miller Root Certificate Authority ^(cross-signed by R4^)...
regedit.exe /s "%~dp0\cross-sign\R4_RootCertificateAuthority.reg" >nul 2>nul
if %installIntermediateCA%==true (
	echo Installing David Miller Client Authentication CA - G3 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ClientAuthCAG3SHA256.crt" >nul 2>nul
	echo Installing David Miller Code Signing CA - G3 - SHA384...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\CodeSigningCAG3SHA384.crt" >nul 2>nul
	echo Installing David Miller Document Signing CA - G2 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\DVServerCAG4SHA256.crt" >nul 2>nul
	echo Installing David Miller Domain Validation Server CA - G4 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\DocumentSigningCAG2SHA256.crt" >nul 2>nul
	echo Installing David Miller ECC Domain Validation Server CA - G5 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ECCDVServerCAG5SHA256.crt" >nul 2>nul
	echo Installing David Miller ECC Extended Validation Server CA - G4 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ECCEVServerCAG4SHA256.crt" >nul 2>nul
	echo Installing David Miller ECC Organization Validation Server CA - G6 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ECCOVServerCAG6SHA256.crt" >nul 2>nul
	echo Installing David Miller Extended Validation Server CA - G4 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\EVServerCAG4SHA256.crt" >nul 2>nul
	echo Installing David Miller External CA - G4 - SHA384...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ExternalCAG4SHA384.crt" >nul 2>nul
	echo Installing David Miller Organization Validation Server CA - G5 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\OVServerCAG5SHA256.crt" >nul 2>nul
	echo Installing David Miller Organization Validation Server CA - G6 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\OVServerCAG6SHA256.crt" >nul 2>nul
	echo Installing David Miller Secure Email CA - G5 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\SecureEmailCAG5SHA256.crt" >nul 2>nul
	echo Installing David Miller Timestamping CA - G8 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\TimestampingCAG8SHA256.crt" >nul 2>nul
)
goto credits

:uninstallation
cls
echo David Miller Certificate Tool
echo Removing David Miller Root CA - R1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" /f >nul 2>nul
echo Removing David Miller Root CA - R1 ^(cross-signed by R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" /f >nul 2>nul
echo Removing David Miller Root CA - R1 ^(cross-signed by Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" /f >nul 2>nul
echo Removing David Miller Root CA - R2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" /f >nul 2>nul
echo Removing David Miller Root CA - R2 ^(cross-signed by R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" /f >nul 2>nul
echo Removing David Miller Root CA - R2 ^(cross-signed by Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" /f >nul 2>nul
echo Removing David Miller Root CA - R3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" /f >nul 2>nul
echo Removing David Miller Root CA - R3 ^(cross-signed by R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" /f >nul 2>nul
echo Removing David Miller Root CA - R3 ^(cross-signed by R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" /f >nul 2>nul
echo Removing David Miller Root CA - R3 ^(cross-signed by Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" /f >nul 2>nul
echo Removing David Miller Root CA - R4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" /f >nul 2>nul
echo Removing David Miller Root CA - R4 ^(cross-signed by R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" /f >nul 2>nul
echo Removing David Miller Root CA - R4 ^(cross-signed by R2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" /f >nul 2>nul
echo Removing David Miller Root CA - R4 ^(cross-signed by R3^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" /f >nul 2>nul
echo Removing David Miller Root CA - R4 ^(cross-signed by TrusAuth^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" /f >nul 2>nul
echo Removing David Miller Root CA - R4 ^(cross-signed by Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" /f >nul 2>nul
echo Removing David Miller Root Certificate Authority...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" /f >nul 2>nul
echo Removing David Miller Root Certificate Authority ^(cross-signed by R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f >nul 2>nul
echo Removing David Miller Root Certificate Authority ^(cross-signed by R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" /f >nul 2>nul
echo Removing David Miller Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" /f >nul 2>nul
echo Removing David Miller Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" /f >nul 2>nul
echo Removing David Miller Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" /f >nul 2>nul
echo Removing David Miller Trust Services External RSA CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" /f >nul 2>nul
echo Removing David Miller SHA2 EFS CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" /f >nul 2>nul
echo Removing David Miller SHA2 EFS CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" /f >nul 2>nul
echo Removing David Miller EV Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" /f >nul 2>nul
echo Removing David Miller EV Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" /f >nul 2>nul
echo Removing David Miller EV Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" /f >nul 2>nul
echo Removing David Miller EV Code Signing CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" /f >nul 2>nul
echo Removing David Miller Public RSA CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" /f >nul 2>nul
echo Removing David Miller Public SHA2 Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" /f >nul 2>nul
echo Removing David Miller David Miller Public SHA2 Timestamping CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" /f >nul 2>nul
echo Removing David Miller Open RSA CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" /f >nul 2>nul
echo Removing David Miller RSA4096 SHA256 Timestamping CA - G6...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" /f >nul 2>nul
echo Removing David Miller RSA4096 SHA384 Code Signing CA1 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" /f >nul 2>nul
echo Removing David Miller SHA2 Client Authentication CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" /f >nul 2>nul
echo Removing David Miller SHA2 Client Authentication CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" /f >nul 2>nul
echo Removing David Miller SHA2 Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" /f >nul 2>nul
echo Removing David Miller SHA2 Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" /f >nul 2>nul
echo Removing David Miller SHA2 Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" /f >nul 2>nul
echo Removing David Miller SHA2 Domain Validation Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" /f >nul 2>nul
echo Removing David Miller SHA2 Domain Validation Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" /f >nul 2>nul
echo Removing David Miller SHA2 Domain Validation Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" /f >nul 2>nul
echo Removing David Miller SHA2 Document Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" /f >nul 2>nul
echo Removing David Miller SHA2 EV Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" /f >nul 2>nul
echo Removing David Miller SHA2 EV Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" /f >nul 2>nul
echo Removing David Miller SHA2 EV Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" /f >nul 2>nul
echo Removing David Miller SHA2 Extended Validation Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" /f >nul 2>nul
echo Removing David Miller SHA2 Extended Validation Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" /f >nul 2>nul
echo Removing David Miller SHA2 Extended Validation Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" /f >nul 2>nul
echo Removing David Miller SHA2 Organization Validation Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" /f >nul 2>nul
echo Removing David Miller SHA2 Organization Validation Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" /f >nul 2>nul
echo Removing David Miller SHA2 Organization Validation Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" /f >nul 2>nul
echo Removing David Miller SHA2 Organization Validation Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" /f >nul 2>nul
echo Removing David Miller SHA2 Secure Mail CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" /f >nul 2>nul
echo Removing David Miller SHA2 Email Protection CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" /f >nul 2>nul
echo Removing David Miller SHA2 Secure Email CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" /f >nul 2>nul
echo Removing David Miller SHA2 Secure Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" /f >nul 2>nul
echo Removing David Miller SHA2 Secure Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" /f >nul 2>nul
echo Removing David Miller SHA2 Timestamping CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" /f >nul 2>nul
echo Removing David Miller SHA2 Timestamping CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" /f >nul 2>nul
echo Removing David Miller Trust Services External ECC CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
echo Removing David Miller ECC Domain Validation Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
echo Removing David Miller ECC Domain Validation Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" /f >nul 2>nul
echo Removing David Miller ECC Domain Validation Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" /f >nul 2>nul
echo Removing David Miller ECC Extended Validation Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" /f >nul 2>nul
echo Removing David Miller ECC Extended Validation Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" /f >nul 2>nul
echo Removing David Miller ECC Extended Validation Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" /f >nul 2>nul
echo Removing David Miller ECC Organization Validation Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" /f >nul 2>nul
echo Removing David Miller ECC Organization Validation Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" /f >nul 2>nul
echo Removing David Miller ECC Organization Validation Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" /f >nul 2>nul
echo Removing David Miller ECC Organization Validation Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" /f >nul 2>nul
echo Removing David Miller ECC Organization Validation Server CA - G5...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" /f >nul 2>nul
echo Removing David Miller ECC Secure Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" /f >nul 2>nul
echo Removing David Miller ECC Secure Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" /f >nul 2>nul
echo Removing David Miller Code Signing CA2 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" /f >nul 2>nul
echo Removing David Miller ECC High Assurance Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" /f >nul 2>nul
echo Removing David Miller ECC High Assurance Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" /f >nul 2>nul
echo Removing David Miller High Assurance Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" /f >nul 2>nul
echo Removing David Miller High Assurance Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2425C624410303E3D305CEB27D7970D04AB5D78F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2425C624410303E3D305CEB27D7970D04AB5D78F" /f >nul 2>nul
echo Removing David Miller SHA2 EV Code Signing CA2 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
echo Removing David Miller SHA2 High Assurance Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
echo Removing David Miller SHA2 High Assurance Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
echo Removing David Miller Client Authentication CA - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" /f >nul 2>nul
echo Removing David Miller Code Signing CA - G2 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" /f >nul 2>nul
echo Removing David Miller Code Signing CA - G3 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" /f >nul 2>nul
echo Removing David Miller Domain Validation Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" /f >nul 2>nul
echo Removing David Miller Document Signing CA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" /f >nul 2>nul
echo Removing David Miller ECC Domain Validation Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" /f >nul 2>nul
echo Removing David Miller ECC Extended Validation Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" /f >nul 2>nul
echo Removing David Miller ECC Organization Validation Server CA - G6 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" /f >nul 2>nul
echo Removing David Miller Extended Validation Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" /f >nul 2>nul
echo Removing David Miller External CA - G4 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" /f >nul 2>nul
echo Removing David Miller Internal PCA - G5 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" /f >nul 2>nul
echo Removing David Miller Internal Server PCA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" /f >nul 2>nul
echo Removing David Miller Organization Validation Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" /f >nul 2>nul
echo Removing David Miller Organization Validation Server CA - G6 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" /f >nul 2>nul
echo Removing David Miller David Miller Secure Email CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" /f >nul 2>nul
echo Removing David Miller Test Domain Validation Server CA - G1 - SHA1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" /f >nul 2>nul
echo Removing David Miller Timestamping CA - G7 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" /f >nul 2>nul
echo Removing David Miller Timestamping CA - G8 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" /f >nul 2>nul
echo Removing David Miller Global Services CA1 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" /f >nul 2>nul
echo Removing David Miller Global Services CA1 - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" /f >nul 2>nul
echo Removing David Miller Global Services CA2 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" /f >nul 2>nul
echo Removing David Miller Global Services CA2 - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" /f >nul 2>nul
echo Removing David Miller Global Services CA2 - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" /f >nul 2>nul
echo Removing David Miller Global Services CA3 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" /f >nul 2>nul
echo Removing David Miller Global Services CA4 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" /f >nul 2>nul
echo Removing David Miller Test Root CA - T4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
echo Removing David Miller Test Timestamping CA - G1 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
echo You may still need to remove personal certificates manually.
goto credits

:openURL
cls
echo David Miller Certificate Tool
echo Starting your default browser...
if %url%==pki (
	start https://go.davidmiller.top/pki
	cls
	set echoName=true
	goto choice
)
if %url%==dl (
	reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Nls\Language" /v InstallLanguage | find "0804" >nul 2>nul && start https://go.davidmiller.top/ct || start https://go.davidmiller.top/ct2
	exit
)

:dl
cls
echo David Miller Certificate Tool
echo Starting your default browser...

:testInstallationPrecheck
cls
echo David Miller Certificate Tool
echo Validating integrity of 2 files...
if not exist "%~dp0\root\T4RootCA.crt" (
	goto installationFailed
)
if not exist "%~dp0\intermediate\TestTimestampingCASHA256.crt" (
	goto installationFailed
)
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\root\T4RootCA.crt" SHA256 > "%~dp0\temp\T4RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\TestTimestampingCASHA256.crt" SHA256 > "%~dp0\temp\TestTimestampingCASHA256.crt.sha256"

findstr 7c842e48c25ce222b3b7d003c76bd433c2c18a8a34cf73013d67a7298ab4d0f6 "%~dp0\temp\T4RootCA.crt.sha256" >nul 2>nul || goto installationFailed
findstr 9fba19871469a9aebf2f15cef7ed5fb4101608c587b4057118d92f14572da544 "%~dp0\temp\TestTimestampingCASHA256.crt.sha256" >nul 2>nul || goto installationFailed
echo All 2 files successfully validated!
goto testInstallation

:testInstallation
echo Installing David Miller Test Root CA - T4...
"%Windir%\System32\certutil.exe" -addstore ROOT "%~dp0\root\T4RootCA.crt" >nul 2>nul
echo Installing David Miller Test Timestamping CA - G1 - SHA256...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\TestTimestampingCASHA256.crt" >nul 2>nul
goto credits

:testUninstallation
cls
echo David Miller Certificate Tool
echo Removing David Miller Test Root CA - T4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
echo Removing David Miller Test Timestamping CA - G1 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
goto credits

:invalidOption
cls
echo David Miller Certificate Tool
echo Your choice is invalid. Please try again.
if %choice%==main (
	goto choice
)
if %choice%==more (
	goto moreChoice
)
if %choice%==loop (
	exit
)
if %choice%==installationFailed (
	echo Some files are missing or corrupted!
	goto installationFailedChoice
)

:installationFailed
cls
echo David Miller Certificate Tool
echo Some files are missing or corrupted!
goto installationFailedChoice

:installationFailedChoice
echo [1] Re-download the software through your default browser ^(Recommended^)
echo [2] Continue installing ^(may damage your system^)
echo [3] Return to main menu
echo [4] Exit
set /p installationFailedOption=Please enter your choice ^(1-4^):
if not defined installationFailedOption (
	set choice=installationFailed
	goto invalidOption
)
if %installationFailedOption%==1 (
	set installationFailedOption=
	set url=dl
	goto openURL
)
if %installationFailedOption%==2 (
	set installationFailedOption=
	cls
	echo David Miller Certificate Tool
	if %installationMode%==production (
		goto installation
	) else (
		goto testInstallation
	)
)
if %installationFailedOption%==3 (
	set installationFailedOption=
	cls
	set echoName=true
	goto choice
)
if %installationFailedOption%==4 (
	exit
)
set choice=installationFailed
set installationFailedOption=
goto invalidOption

:credits
echo Finished!
echo Author: David Miller Trust Services Team
echo Website: https://go.davidmiller.top/pki
echo Version 2.4 ^(Release Build 9^)
goto loopChoice

:loopChoice
echo [1] Return to main menu
echo [2] Exit
set /p loopOption=Please enter your choice ^(1-2^):
if not defined loopOption (
	set choice=loop
	goto invalidOption
)
if %loopOption%==1 (
	cls
	set echoName=true
	set loopOption=
	goto choice
)
if %loopOption%==2 (
	exit
)
set choice=loop
set loopOption=
goto invalidOption