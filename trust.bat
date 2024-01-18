@echo off
cd /d %~dp0
chcp 65001 > nul
set testMode=off
::set testMode=on

::Set current version
set currMajorVer=2
set currMinorVer=0
set currPatchVer=1
set currBuild=2
if %currPatchVer%==0 (
	set currVer=%currMajorVer%.%currMinorVer%
) else ( 
	set currVer=%currMajorVer%.%currMinorVer%.%currPatchVer%
)

::Set environment variables (for offline)
set name=David Miller Trust Root CA Tool
set author=David Miller Trust Services Team
set websiteURL=https://go.davidmiller.top/pki
set systemStatusURL=https://go.davidmiller.top/status
set updateURL1=https://go.davidmiller.top/trust
set updateURL2=https://go.davidmiller.top/trust2

set updateWgetFail=false
set testInstallFailure=false

title %name%
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Nls\Language" /v InstallLanguage | find "0804" > nul && set country=CN || set country=RoW
if not defined country (
	set country=RoW
)
goto precheck

:precheck
::Check if certutil and wget exists
if not exist "%Windir%\System32\certutil.exe" (
	goto certutilFailure
)
if not exist "wget.exe" (
	goto wgetFailure
)
"%Windir%\System32\certutil.exe" -hashfile "wget.exe" SHA256 > "wget.exe.sha256"
findstr /i D68286C89F448F67749370FC349AE8F3F11EBAF49330A60470168959BC92047F "wget.exe.sha256" > nul || goto wgetFailure
goto dlConfig

:dlConfig
::Check for updates through TrustRootCATool API
echo %name%
echo Checking for updates...
if %testMode%==on (
	"%~dp0\wget.exe" https://api.davidmiller.top/trust/config_test.ini -q -T 5 -t 2 -O "config.ini"
) else (
	if %country%==CN (
		"%~dp0\wget.exe" https://api.davidmiller.top/trust/config.ini -q -T 5 -t 2 -O "config.ini"
	) else (
		"%~dp0\wget.exe" https://api2.davidmiller.top/trust/config.ini -q -T 5 -t 2 -O "config.ini"
	)
)
::Check if the file is empty
findstr /i . "config.ini" > nul && goto importConfig || goto re-dlConfig

:re-dlConfig
::Check for updates through TrustRootCATool API
if %country%==CN (
	"%~dp0\wget.exe" https://api2.davidmiller.top/trust/config.ini -q -T 5 -t 2 -O "config.ini"
) else (
	"%~dp0\wget.exe" https://api.davidmiller.top/trust/config.ini -q -T 5 -t 2 -O "config.ini"
)
::Check if the file is empty
findstr /i . "config.ini" > nul && goto importConfig || goto updateCheckUnknown

:importConfig
setlocal EnableDelayedExpansion
for /f "tokens=1,2 delims==" %%i in (
	config.ini
) do (
	if "%%i"=="name" set name=%%j
	if "%%i"=="author" set author=%%j
	if "%%i"=="website_url" set websiteURL=%%j
	if "%%i"=="system_status_url" set systemStatusURL=%%j
	if "%%i"=="update_url1" set updateURL1=%%j
	if "%%i"=="update_url2" set updateURL2=%%j
	if "%%i"=="status" set status=%%j
	if "%%i"=="status_notice" set statusNotice=%%j
	if "%%i"=="notice" set notice=%%j
	if "%%i"=="major_version" set latestMajorVer=%%j
	if "%%i"=="minor_version" set latestMinorVer=%%j
	if "%%i"=="patch_version" set latestPatchVer=%%j
	if "%%i"=="build" set latestBuild=%%j
)
setlocal DisableDelayedExpansion
title %name%

::Check if all required variables are imported
if not defined status (
	goto updateCheckFailure
)
if not defined latestMajorVer (
	goto updateCheckFailure
)
if not defined latestMinorVer (
	goto updateCheckFailure
)
if not defined latestPatchVer (
	goto updateCheckFailure
)
if not defined latestBuild (
	goto updateCheckFailure
)
goto statusCheck

:statusCheck
::Check system status
if %status%==available (
	goto updateCheck
) else (
	goto statusFailure
)

:updateCheck
::Compare current version number with the latest version number
if %currMajorVer% lss %latestMajorVer% (
	goto updateCheckFailure
)
if %currMajorVer% gtr %latestMajorVer% (
	goto updateCheckSuccess
)
if %currMinorVer% lss %latestMinorVer% (
	goto updateCheckFailure
)
if %currMinorVer% gtr %latestMinorVer% (
	goto updateCheckSuccess
)
if %currPatchVer% lss %latestPatchVer% (
	goto updateCheckFailure
)
if %currPatchVer% gtr %latestPatchVer% (
	goto updateCheckSuccess
)
if %currBuild% lss %latestBuild% (
	goto updateCheckFailure
)
goto updateCheckSuccess

:choice
::Avoid to show the name again when returning to main menu
if %echoName%==true (
	echo %name%
	set echoName=false
)
if %updateWgetFail%==true (
	echo %name%
	set updateWgetFail=false
	echo Failed to download the latest version!
)
::Display the notice
if defined statusNotice (
	echo NOTE: %statusNotice%
)
if defined notice (
	echo NOTE: %notice%
)
echo Please disable antivirus program before starting!
echo [1] Install root certificates ^(Recommended^)
echo [2] Uninstall root certifcates
echo [3] Install TEST root certificate
echo [4] Uninstall TEST root certificate
echo [5] Visit our website
echo [6] Exit
set /p usersChoiceMain=Please enter your choice ^(1-6^):
if %usersChoiceMain%==1 (
	goto installCheck
)
if %usersChoiceMain%==2 (
	goto uninstallCheck
)
if %usersChoiceMain%==3 (
	goto testInstallCheck
)
if %usersChoiceMain%==4 (
	goto testUninstall
)
if %usersChoiceMain%==5 (
	goto openWebsite
)
if %usersChoiceMain%==6 (
	goto exit
)
::Avoid the user choose an invalid option
set choice=main
goto usersChoiceFail

:installCheck
::Check if all files exist
echo Validating integrity 5 files...
if not exist "R4_R1RootCA.crt" (
	goto installFailure
)
if not exist "R4_R2RootCA.crt" (
	goto installFailure
)
if not exist "R4_R3RootCA.crt" (
	goto installFailure
)
if not exist "R4RootCA.reg" (
	goto installFailure
)
if not exist "R4_RootCertificateAuthority.reg" (
	goto installFailure
)

::Compute file's SHA256 checksum
"%Windir%\System32\certutil.exe" -hashfile "R4_R1RootCA.crt" SHA256 > "R4_R1RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "R4_R2RootCA.crt" SHA256 > "R4_R2RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "R4_R3RootCA.crt" SHA256 > "R4_R3RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "R4RootCA.reg" SHA256 > "R4RootCA.reg.sha256"
"%Windir%\System32\certutil.exe" -hashfile "R4_RootCertificateAuthority.reg" SHA256 > "R4_RootCertificateAuthority.reg.sha256"

::Compare file hash
findstr /i F56E728F435AF6322561FA9A62C366A6032DE8C371155572004F7FE4A48C0371 "R4_R1RootCA.crt.sha256" > nul
if errorlevel 1 (
	goto installFailure
)
findstr /i A33F7F708FBB18326315BF469E8A77FEB234478683B249AD5AD3A13F4F631742 "R4_R2RootCA.crt.sha256" > nul
if errorlevel 1 (
	goto installFailure
)
findstr /i CFE2A8C5EC0D2828E06B2A6306C5FB6722581DC10864059463356904915750A4 "R4_R3RootCA.crt.sha256" > nul
if errorlevel 1 (
	goto installFailure
)
findstr /i 00714CECB03A5EEC64570E5B0CCF90A9A1BB429825C2A83A9E719558C7738248 "R4RootCA.reg.sha256" > nul
if errorlevel 1 (
	goto installFailure
)
findstr /i 674095A879128F7E13D8336051CF1A622EDA5A29E93FACA302FBF7B59E90031B "R4_RootCertificateAuthority.reg.sha256" > nul
if errorlevel 1 (
	goto installFailure
)
cls
echo %name%
echo All 5 files successfully validated!
goto install

:install
::Install root certificates
echo Installing David Miller Root CA - R1 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "R4_R1RootCA.crt" > nul
echo Installing David Miller Root CA - R2 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "R4_R2RootCA.crt" > nul
echo Installing David Miller Root CA - R3 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -addstore CA "R4_R3RootCA.crt" > nul
echo Installing David Miller Root CA - R4...
regedit.exe /s "R4RootCA.reg" > nul
echo Installing David Miller Root Certificate Authority ^(cross-signed by R4^)...
regedit.exe /s "R4_RootCertificateAuthority.reg" > nul
set end=success
goto credits

:uninstallCheck
::Check if all files exist
echo Validating integrity of 5 files...
if not exist R4_R1RootCA.crt (
	goto uninstallFailure
)
if not exist R4_R2RootCA.crt (
	goto uninstallFailure
)
if not exist R4_R3RootCA.crt (
	goto uninstallFailure
)
if not exist R4RootCA.reg (
	goto uninstallFailure
)
if not exist R4_RootCertificateAuthority.reg (
	goto uninstallFailure
)

::Compute file's SHA256 checksum
"%Windir%\System32\certutil.exe" -hashfile "R4_R1RootCA.crt" SHA256 > "R4_R1RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "R4_R2RootCA.crt" SHA256 > "R4_R2RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "R4_R3RootCA.crt" SHA256 > "R4_R3RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "R4_RootCertificateAuthority.reg" SHA256 > "R4_RootCertificateAuthority.reg.sha256"

::Compare file hash
findstr /i F56E728F435AF6322561FA9A62C366A6032DE8C371155572004F7FE4A48C0371 "R4_R1RootCA.crt.sha256" > nul
if errorlevel 1 (
	goto uninstallFailure
)
findstr /i A33F7F708FBB18326315BF469E8A77FEB234478683B249AD5AD3A13F4F631742 "R4_R2RootCA.crt.sha256" > nul
if errorlevel 1 (
	goto uninstallFailure
)
findstr /i CFE2A8C5EC0D2828E06B2A6306C5FB6722581DC10864059463356904915750A4 "R4_R3RootCA.crt.sha256" > nul
if errorlevel 1 (
	goto uninstallFailure
)
findstr /i 674095A879128F7E13D8336051CF1A622EDA5A29E93FACA302FBF7B59E90031B "R4_RootCertificateAuthority.reg.sha256" > nul
if errorlevel 1 (
	goto uninstallFailure
)
cls
echo %name%
echo All 5 files successfully validated!
goto uninstall

:uninstall
::Uninstall root certificates
echo Removing David Miller Root CA - R1 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -delstore CA "R4_R1RootCA.crt" > nul
echo Removing David Miller Root CA - R2 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -delstore CA "R4_R2RootCA.crt" > nul
echo Removing David Miller Root CA - R3 ^(cross-signed by R4^)...
"%Windir%\System32\certutil.exe" -delstore CA "R4_R3RootCA.crt" > nul
echo Removing David Miller Root CA - R4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" /f > nul
echo Removing David Miller Root Certificate Authority ^(cross-signed by R4^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" /f > nul
::Uninstall EOL root certificates
echo Removing David Miller Root CA - R1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" /f > nul
echo Removing David Miller Root CA - R2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" /f > nul
echo Removing David Miller Root CA - R3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" /f > nul
echo Removing David Miller Root Certificate Authority ^(cross-signed by R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f > nul
echo Removing David Miller Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f > nul
set end=success
goto credits

:testInstallCheck
::Check if all file exists
echo Validating integrity of 1 file...
if not exist "T4RootCA.crt" (
	::Save disk space
	set testInstallFailure=true
	goto installFailure
)
::Compute file's SHA256 checksum
"%Windir%\System32\certutil.exe" -hashfile "T4RootCA.crt" SHA256 > "T4RootCA.crt.sha256"
::Compare file hash
findstr /i 7C842E48C25CE222B3B7D003C76BD433C2C18A8A34CF73013D67A7298AB4D0F6 "T4RootCA.crt.sha256" > nul
if errorlevel 1 (
	::Save disk space
	set testInstallFailure=true
	goto installFailure
)
cls
echo %name%
echo All 1 file successfully validated!
goto testInstall

:testInstall
::Install test root certificate
echo Installing David Miller Test Root CA - T4...
"%Windir%\System32\certutil.exe" -addstore ROOT "T4RootCA.crt" > nul
set end=success
goto credits

:testUninstall
cls
echo %name%
::Uninstall test root certificate
echo Removing David Miller Test Root CA - T4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f > nul
set end=success
goto credits

:openWebsite
cls
echo %name%
::Open website
echo Starting your default browser...
start %websiteURL%
cls
set echoName=true
goto choice

:certutilFailure
cls
echo %name%
::Unable to find cerutil
echo "certutil.exe" is missing!
echo You may need to reinstall Windows.
set end=criticalFailure
goto credits

:wgetFailure
cls
echo %name%
::Unable to find wget
echo "wget.exe" is missing or corrupted!
set end=criticalFailure
goto credits

:statusFailure
cls
echo %name%
::System outstage or critical security issues
if defined statusNotice (
	echo NOTE: %statusNotice%
) else (
	echo Something went wrong. Please try again later.
)
echo Check system status: %systemStatusURL%
set end=criticalFailure
goto credits

:updateCheckSuccess
cls
echo %name%
::All brand new
set echoName=false
echo Your software is up to date.
goto choice

:updateCheckFailure
cls
echo %name%
::Version alert. Can be skipped by user
if defined notice (
	echo %notice%
)
echo Due to security concerns, updating to the latest version is recommended.
goto updateChoice

:updateCheckUnknown
cls
echo %name%
::Offline alert. Back to Main menu
echo An error occurred while checking for updates!
echo Checking for updates requires an Internet connection.
goto choice

:updateChoice
::Download the latest version or continue
echo [1] Download the latest version through your default browser ^(Recommended^)
echo [2] Download the latest version through the built-in downloader
echo [3] Continue using current version
echo [4] Exit
set /p usersChoiceDl=Please enter your choice ^(1-4^):
if %usersChoiceDl%==1 (
	goto updateBrowser
)
if %usersChoiceDl%==2 (
	goto updateWget
)
if %usersChoiceDl%==3 (
	cls
	set echoName=true
	goto choice
)
if %usersChoiceDl%==4 (
	goto exit
)
set choice=dl
goto usersChoiceFail

:updateBrowser
cls
echo %name%
::Download the latest version through browser
echo Starting your default browser...
if %country%==CN (
	start %updateURL1%
) else (
	start %updateURL2%
)
set end=dlSuccess
goto credits

:updateWget
cls
echo %name%
if not defined updateURL1 (
	goto updateWgetFail
)
if not defined updateURL2 (
	goto updateWgetFail
)
::Download the latest version through wget
echo Downloading the latest version...
if %country%==CN (
	"%~dp0\wget.exe" %updateURL1% -q -T 5 -t 2 -O "%TEMP%\TrustRootCATool.exe"
) else (
	"%~dp0\wget.exe" %updateURL2% -q -T 5 -t 2 -O "%TEMP%\TrustRootCATool.exe"
)
::Check if the file is empty
findstr /i . "%TEMP%\TrustRootCATool.exe" > nul && goto updateWgetSuccess || goto re-updateWget

:re-updateWget
if %country%==CN (
	"%~dp0\wget.exe" %updateURL2% -q -T 5 -t 2 -O "%TEMP%\TrustRootCATool.exe"
) else (
	"%~dp0\wget.exe" %updateURL1% -q -T 5 -t 2 -O "%TEMP%\TrustRootCATool.exe"
)
::Check if the file is empty
findstr /i . "%TEMP%\TrustRootCATool.exe" > nul && goto updateWgetSuccess || goto updateWgetFail

:updateWgetSuccess
echo Download completed. Starting the latest version...
start %TEMP%\TrustRootCATool.exe
exit

:updateWgetFail
set updateWgetFail=true
goto choice

:usersChoiceFail
cls
echo %name%
::Avoid the user choose an invalid option
echo Your choice is invalid. Please try again.
if %choice%==main (
	goto choice
)
if %choice%==dl (
	goto updateChoice
)
if %choice%==installFailure (
	goto installFailureChoice
)
if %choice%==uninstallFailure (
	goto uninstallFailureChoice
)

:installFailure
cls
echo %name%
::Cannot find certain files or fail to match checksum
echo Some files are missing or corrupted!
goto installFailureChoice

:installFailureChoice
::Choose to download the latest version or continue
echo [1] Re-download the software through your default browser ^(Recommended^)
echo [2] Re-download the software through the built-in downloader
echo [3] Continue installing ^(may damage your system^)
echo [4] Return to main menu
echo [5] Exit
set /p usersChoiceInstallFailure=Please enter your choice ^(1-5^):
if %usersChoiceInstallFailure%==1 (
	goto updateBrowser
)
if %usersChoiceInstallFailure%==2 (
	goto updateWget
)
if %usersChoiceInstallFailure%==3 (
	cls
	echo %name%
	if %testInstallFailure%==false (
		goto install
	) else (
		goto testInstall
	)
)
if %usersChoiceInstallFailure%==4 (
	cls
	set echoName=true
	goto choice
)
if %usersChoiceInstallFailure%==5 (
	goto exit
)
set choice=installFailure
goto usersChoiceFail

:uninstallFailure
cls
echo %name%
echo Some files are missing or corrupted!
goto uninstallFailureChoice

:uninstallFailureChoice
::Choose to download the latest version or continue
echo [1] Re-download the software through your default browser ^(Recommended^)
echo [2] Re-download the software through the built-in downloader
echo [3] Continue uninstalling ^(may damage your system^)
echo [4] Return to main menu
echo [5] Exit
set /p usersChoiceUninstallFailure=Please enter your choice ^(1-5^):
if %usersChoiceUninstallFailure%==1 (
	goto updateBrowser
)
if %usersChoiceUninstallFailure%==2 (
	goto updateWget
)
if %usersChoiceUninstallFailure%==3 (
	cls
	echo %name%
	goto uninstall
)
if %usersChoiceUninstallFailure%==4 (
	set echoName=true
	goto choice
)
if %usersChoiceUninstallFailure%==5 (
	goto exit
)
set choice=uninstallFailure
goto usersChoiceFail

:credits
if %end%==dlSuccess (
	goto exit
)
if %end%==success (
	echo Finished!
) 
if %end%==failure (
	echo Failed!
)
if %end%==criticalFailure (
	echo Failed!
)
::Show the author, website and version number
echo Author: %author%
echo Website: %websiteURL%
echo Version %currVer%
if %end%==criticalFailure (
	goto pause
)
::A loop
echo [1] Return to main menu
echo [2] Exit
set /p usersChoiceCredits=Please enter your choice ^(1-2^):
if %usersChoiceCredits%==1 (
	cls
	set echoName=true
	goto choice
)
if %usersChoiceCredits%==2 (
	goto exit
)
:exit
del /Q "%TEMP%\TrustRootCATool.exe"
exit

:pause
echo This window can now be safely closed! & pause > nul