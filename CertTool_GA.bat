@echo off
mode con cols=80 lines=36
cd /d %~dp0
chcp 65001 >nul 2>nul
title David Miller Certificate Tool ^(GA Release^)
setlocal EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "color=%%a"
)
setlocal DisableDelayedExpansion
md temp >nul 2>nul
set lineShort=__________________________________________________
set lineLong=____________________________________________________________
set echoName=true
goto choice

:choice
set installationMode=
set uninstallationMode=
if %echoName%==true (
	echo.
	echo.
	echo.
	echo                          David Miller Certificate Tool
	set echoName=false
)
echo           %lineLong%
echo.
call :color 0C "               Please disable antivirus program before starting!"
echo.
echo                %lineShort%
echo.
echo                [1] Install root CA certificates ^(Recommended^)
echo.
echo                [2] Uninstall all CA certificates
echo.
echo                [3] Switch to LTS release
echo.
echo                [4] Visit our website
echo.
echo                [5] Show more options
echo.
echo                [6] Exit
echo           %lineLong%
echo.
set /p mainOption=^>           Please enter your choice ^(1-6^):
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
	set uninstallationMode=all
	goto uninstallation
)
if %mainOption%==3 (
	if exist CertTool_LTS.exe (
		set mainOption=
		start CertTool_LTS.exe
		exit
	)
	set mainOption=
	set choice=main
	goto openLTSeXeFailed
)
if %mainOption%==4 (
	set mainOption=
	set url=pki
	goto openURL
)
if %mainOption%==5 (
	set mainOption=
	set echoName=true
	cls
	goto moreChoice
)

if %mainOption%==6 (
	exit
)
set choice=main
set mainOption=
goto invalidOption

:moreChoice
if %echoName%==true (
	echo.
	echo.
	echo.
	echo                          David Miller Certificate Tool
	set echoName=false
)
echo           %lineLong%
echo.
call :color 0C "               Please disable antivirus program before starting!"
echo.
echo                %lineShort%
echo.
echo                [1] Install root and intermediate CA certificates
echo.
echo                [2] Install TEST CA certificates
echo.
echo                [3] Uninstall TEST CA certificates
echo.
echo                [4] Re-download CertTool
echo.
echo                [5] Return to main menu
echo.
echo                [6] Exit
echo           %lineLong%
echo.
set /p moreOption=^>           Please enter your choice ^(1-6^):
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
	set uninstallationMode=test
	goto testUninstallation
)
if %moreOption%==4 (
	set url=dl
	goto openURL
)
if %moreOption%==5 (
	set moreOption=
	set echoName=true
	cls
	goto choice
)
if %moreOption%==6 (
	exit
)
set choice=more
set moreOption=
goto invalidOption

:installationPrecheck
cls
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
if %installIntermediateCA%==true (
	echo                Validating integrity of 17 files...
) else (
	echo                Validating integrity of 5 files...
)
echo.
if not exist "%~dp0\cross-sign\R4_R1RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0\cross-sign\R4_R2RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0\cross-sign\R4_R3RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0\root\R4RootCA.reg" (
	goto installationCheckFailed
)
if not exist "%~dp0\cross-sign\R4_RootCertificateAuthority.reg" (
	goto installationCheckFailed
)
if %installIntermediateCA%==true (
	if not exist "%~dp0\intermediate\ClientAuthCAG3SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\CodeSigningCAG3SHA384.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\DocumentSigningCAG2SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\DVServerCAG4SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\ECCDVServerCAG5SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\ECCEVServerCAG4SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\ECCOVServerCAG6SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\EVServerCAG4SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\ExternalCAG4SHA384.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\OVServerCAG6SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\SecureEmailCAG5SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0\intermediate\TimestampingCAG8SHA256.crt" (
		goto installationCheckFailed
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
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\OVServerCAG6SHA256.crt" SHA256 > "%~dp0\temp\OVServerCAG6SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\SecureEmailCAG5SHA256.crt" SHA256 > "%~dp0\temp\SecureEmailCAG5SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\TimestampingCAG8SHA256.crt" SHA256 > "%~dp0\temp\TimestampingCAG8SHA256.crt.sha256"
)
findstr f56e728f435af6322561fa9a62c366a6032de8c371155572004f7fe4a48c0371 "%~dp0\temp\R4_R1RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr a33f7f708fbb18326315bf469e8a77feb234478683b249ad5ad3a13f4f631742 "%~dp0\temp\R4_R2RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr cfe2a8c5ec0d2828e06b2a6306c5fb6722581dc10864059463356904915750a4 "%~dp0\temp\R4_R3RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr 51aa09a59873c7afd4c7a18443a79d16ba832ae2e37bb3513328f9c958c23407 "%~dp0\temp\R4RootCA.reg.sha256" >nul 2>nul || goto installationCheckFailed
findstr 674095a879128f7e13d8336051cf1a622eda5a29e93faca302fbf7b59e90031b "%~dp0\temp\R4_RootCertificateAuthority.reg.sha256" >nul 2>nul || goto installationCheckFailed
if %installIntermediateCA%==true (
	findstr 0c27b946daeb726ac8d84bcbe2c7cc6355262a68989532e94050db10c8aa71f4 "%~dp0\temp\ClientAuthCAG3SHA256.crt.sha256"  >nul 2>nul || goto installationCheckFailed
	findstr 53999bfc6b657f8975f131a30c1f4c8b2b4600854570e99d97ce6ff08ab8596d "%~dp0\temp\CodeSigningCAG3SHA384.crt.sha256"  >nul 2>nul || goto installationCheckFailed
	findstr 564eb266594a6a48b57c3139dcd679b7b358e6ee277001643f007af460532663 "%~dp0\temp\DVServerCAG4SHA256.crt.sha256"  >nul 2>nul || goto installationCheckFailed
	findstr 24e33eeb2553d919c68c912da4c8b37b99228567d209f867f9fcd6930c2d7fb8 "%~dp0\temp\DocumentSigningCAG2SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 6977c709a643b4c8afe0756c9337dfce6bbe871891c6f6f501714e08e187f1ec "%~dp0\temp\ECCDVServerCAG5SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr c28eec34793954c458e281b47a8ae4d47c80f067041b2c4ba11ec98d578b907b "%~dp0\temp\ECCEVServerCAG4SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 34d98e0e1e60f7121f22e68d75e397bd0eea8970dc8710afc00122a5b55f05dc "%~dp0\temp\ECCOVServerCAG6SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 3e191ad3d0bee6333b34b6e5bab844ca0b32c88d240f8e0469d71f35d5e6801a "%~dp0\temp\EVServerCAG4SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 49827bf2365f057bda6ce55a0e6f7758f30280a13835fc79326ca48f1c95e467 "%~dp0\temp\ExternalCAG4SHA384.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 2d80d1d7e9d8d7ae71602842a7a350ed3f9fd84f1b60acaaf6333f604777b268 "%~dp0\temp\OVServerCAG6SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 412556f536caf1295eeaacc093f6dee5d10b08796110a4667e908b2b1fa99d4c "%~dp0\temp\SecureEmailCAG5SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 487fcfb818b20c395e03baf22fc470df5845b2785c372505b48f6ba257938935 "%~dp0\temp\TimestampingCAG8SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
)
if %installIntermediateCA%==true (
	echo                All 17 files successfully validated!
) else (
	echo                All 5 files successfully validated!
)
echo                %lineShort%
echo.
goto installation

:installation
echo                Installing Root CA - R1 ^(R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\cross-sign\R4_R1RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root CA - R2 ^(R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\cross-sign\R4_R2RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root CA - R3 ^(R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\cross-sign\R4_R3RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root CA - R4...
regedit.exe /s "%~dp0\root\R4RootCA.reg" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root Certificate Authority ^(R4^)...
regedit.exe /s "%~dp0\cross-sign\R4_RootCertificateAuthority.reg" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" >nul 2>nul || set installationFailed=true
if %installIntermediateCA%==true (
	echo           %lineShort%
	echo.
	echo                Installing Client Authentication CA - G3 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ClientAuthCAG3SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Code Signing CA - G3 - SHA384...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\CodeSigningCAG3SHA384.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Document Signing CA - G2 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\DocumentSigningCAG2SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing DV Server CA - G4 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\DVServerCAG4SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing ECC DV Server CA - G5 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ECCDVServerCAG5SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing ECC EV Server CA - G4 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ECCEVServerCAG4SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing ECC OV Server CA - G6 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ECCOVServerCAG6SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing EV Server CA - G4 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\EVServerCAG4SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing External CA - G4 - SHA384...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\ExternalCAG4SHA384.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing OV Server CA - G6 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\OVServerCAG6SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Secure Email CA - G5 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\SecureEmailCAG5SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Timestamping CA - G8 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\TimestampingCAG8SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" >nul 2>nul || set installationFailed=true
)
if defined installationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:uninstallation
cls
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
echo                Removing Root CA - R1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R1 ^(R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R1 ^(Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R2 ^(R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R2 ^(Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3 ^(R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3 ^(R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3 ^(Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R3^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(TrusAuth^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(Raytonne^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root Certificate Authority...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root Certificate Authority ^(R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root Certificate Authority ^(R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing External RSA CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EFS CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EFS CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Public RSA CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Public SHA2 Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Public SHA2 Timestamping CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Open RSA CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing RSA4096 SHA256 Timestamping CA - G6...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing RSA4096 SHA384 Code Signing CA1 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Client Authentication CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Client Authentication CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 DV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 DV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 DV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Document Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Mail CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Email Protection CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Email CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Timestamping CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Timestamping CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing External ECC CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G5...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC Secure Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC Secure Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA2 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC High Assurance Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC High Assurance Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing High Assurance Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing High Assurance Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2425C624410303E3D305CEB27D7970D04AB5D78F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2425C624410303E3D305CEB27D7970D04AB5D78F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA2 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 High Assurance Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 High Assurance Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Client Authentication CA - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G2 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G3 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing DV Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Document Signing CA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G6 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing External CA - G4 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal PCA - G5 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal Server PCA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing OV Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing OV Server CA - G6 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Secure Email CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test DV Server CA - G1 - SHA1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Timestamping CA - G7 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Timestamping CA - G8 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA1 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA1 - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA2 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA2 - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA2 - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA3 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA4 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing MitM CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing MitM CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G1 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing other certificates...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" >nul 2>nul && set uninstallationFailed=true
if defined uninstallationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:openURL

cls
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
echo                Starting your default browser...
if %url%==pki (
	start https://pki.davidmiller.top
	cls
	set echoName=true
	goto choice
)
if %url%==dl (
	reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Nls\Language" /v InstallLanguage | find "0804" >nul 2>nul && start https://go.davidmiller.top/ct || start https://go.davidmiller.top/ct2
	exit
)

:testInstallationPrecheck
cls
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
echo                Validating integrity of 2 files...
echo.
if not exist "%~dp0\root\T4RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0\intermediate\TestTimestampingCASHA256.crt" (
	goto installationCheckFailed
)
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\root\T4RootCA.crt" SHA256 > "%~dp0\temp\T4RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0\intermediate\TestTimestampingCASHA256.crt" SHA256 > "%~dp0\temp\TestTimestampingCASHA256.crt.sha256"
findstr 7c842e48c25ce222b3b7d003c76bd433c2c18a8a34cf73013d67a7298ab4d0f6 "%~dp0\temp\T4RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr 9fba19871469a9aebf2f15cef7ed5fb4101608c587b4057118d92f14572da544 "%~dp0\temp\TestTimestampingCASHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
echo                All 2 files successfully validated!
echo           %lineLong%
echo.
goto testInstallation

:testInstallation
echo                Installing Test Root CA - T4...
"%Windir%\System32\certutil.exe" -addstore ROOT "%~dp0\root\T4RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Test Timestamping CA - G1 - SHA256...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0\intermediate\TestTimestampingCASHA256.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul || set installationFailed=true
if defined installationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:testUninstallation
cls
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
echo                Removing Test Root CA - T1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G1 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
if defined uninstallationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:invalidOption
cls
echo.
echo.
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
call :color 0C "                    Your choice is invalid. Please try again"
echo.
if %choice%==main (
	goto choice
)
if %choice%==more (
	goto moreChoice
)
if %choice%==loop (
	exit
)
if %choice%==installationCheckFailed (
	echo Some files are missing or corrupted!
	goto installationCheckFailedChoice
)

:openLTSeXeFailed
cls
set echoName=false
echo.
echo.
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
call :color 0C "                        The executable file is missing!"
echo.
goto choice

:installationCheckFailed
cls
echo.
echo.
echo.
echo                          David Miller Certificate Tool
echo           %lineLong%
echo.
call :color 0C "                      Some files are missing or corrupted!"
echo.
goto installationCheckFailedChoice

:installationCheckFailedChoice
echo                %lineShort%
echo.
echo                [1] Re-download CertTool ^(Recommended^)
echo.
echo                [2] Continue installing
echo.
echo                [3] Return to main menu
echo.
echo                [4] Exit
echo           %lineLong%
echo.
set /p installationCheckFailedOption=^>           Please enter your choice ^(1-4^):
if not defined installationCheckFailedOption (
	set choice=installationCheckFailed
	goto invalidOption
)
if %installationCheckFailedOption%==1 (
	set url=dl
	goto openURL
)
if %installationCheckFailedOption%==2 (
	set installationCheckFailedOption=
	cls
	echo.
	echo                          David Miller Certificate Tool
	echo           %lineLong%
	echo.
	if %installationMode%==production (
		goto installation
	) else (
		goto testInstallation
	)
)
if %installationCheckFailedOption%==3 (
	set installationCheckFailedOption=
	cls
	set echoName=true
	goto choice
)
if %installationCheckFailedOption%==4 (
	exit
)
set choice=installationCheckFailed
set installationCheckFailedOption=
goto invalidOption

:credits
echo           %lineLong%
echo.
if %result%==fail (
	call :color 0C "               Failed!"
	echo.
)
if %result%==success (
	call :color 0C "               Finished!"
	echo.
)
echo.
if defined uninstallationFailed (
	call :color 0C "               Some CA certificates are not removed from your system!"
	echo.
	echo.
)
if defined installationFailed (
	call :color 0C "               Some CA certificates are not installed to your system!"
	echo.
	echo.
)
set uninstallationFailed=
set installationFailed=
echo                Author: David Miller Trust Services Team
echo.
echo                Website: https://pki.davidmiller.top
echo.
echo                Version 2.7.1 ^(GA Release Build 2^)
goto loopChoice

:loopChoice
echo                %lineShort%
echo.
echo                [1] Return to main menu
echo.
setlocal EnableDelayedExpansion
if !result!==success (
	echo                [2] Visit our website
	echo.
	echo                [3] Exit
	echo           !lineLong!
	echo.
	set /p loopOption=^>           Please enter your choice ^(1-3^):
	if not defined loopOption (
		set choice=loop
		goto invalidOption
	)
	if !loopOption!==1 (
		cls
		set result=
		set echoName=true
		set loopOption=
		setlocal DisableDelayedExpansion
		goto choice
	)
	if !loopOption!==2 (
		cls
		set result=
		set echoName=true
		set loopOption=
		set url=pki
		setlocal DisableDelayedExpansion
		goto openURL
	)
	if !loopOption!==3 (
		setlocal DisableDelayedExpansion
		exit
	)
)
if !result!==fail (
	if defined installationMode (
		echo                [2] Retry installation
	) else (
		echo                [2] Retry uninstallation
	)
	echo.
	echo                [3] Visit our website
	echo.
	echo                [4] Exit
	echo           !lineLong!
	echo.
	set /p loopOption=^>           Please enter your choice ^(1-4^):
	if not defined loopOption (
		set choice=loop
		goto invalidOption
	)
	if !loopOption!==1 (
		cls
		set result=
		set echoName=true
		set loopOption=
		setlocal DisableDelayedExpansion
		goto choice
	)
	if !loopOption!==2 (
		cls
		set result=
		set echoName=true
		set loopOption=
		if !installationMode!==production (
			setlocal DisableDelayedExpansion
			goto installationPrecheck
		)
		if !installationMode!==test (
			setlocal DisableDelayedExpansion
			goto testInstallationPrecheck
		)
		if !uninstallationMode!==all (
			setlocal DisableDelayedExpansion
			goto uninstallation
		)
		if !uninstallationMode!==test (
			setlocal DisableDelayedExpansion
			goto testUninstallation
		)
	)
	if !loopOption!==3 (
		cls
		set result=
		set echoName=true
		set loopOption=
		set url=pki
		setlocal DisableDelayedExpansion
		goto openURL
	)
	if !loopOption!==4 (
		setlocal DisableDelayedExpansion
		exit
	)
)
set choice=loop
set loopOption=
goto invalidOption

:color
<nul set /p ".=%color%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof