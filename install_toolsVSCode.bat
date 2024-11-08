@echo off
REM Install Chocolatey
@powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

REM Ensure Chocolatey is available in the PATH
set PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM Install the tools using Chocolatey
choco install make --yes
choco install gcc-arm-embedded --yes
choco install git --yes
choco install 7zip --yes

REM Copy arm-none-eabi compiler files to accessible folder
echo Copying compiler to an accessible folder...
mkdir "C:\Program Files (x86)\GNU Arm Embedded Toolchain"
xcopy "C:\ProgramData\chocolatey\lib\gcc-arm-embedded" "C:\Program Files (x86)\GNU Arm Embedded Toolchain" /E /I /Y /Q
echo Compiler directory copied to "C:\Program Files (x86)\GNU Arm Embedded Toolchain"

REM Remove the existing stutil.zip if it exists
if exist stutil.zip (
    echo Removing existing stutil.zip...
    del /Q stutil.zip
    rmdir /S /Q stlink-1.8.0-win32
)

REM Download the latest release ZIP file
echo Downloading stutil binaries...
curl -L -o stutil.zip "https://github.com/stlink-org/stlink/releases/download/v1.8.0/stlink-1.8.0-win32.zip"

REM Extract the ZIP file
echo Extracting stutil binaries...
powershell -command "Expand-Archive -Path 'stutil.zip' -DestinationPath '.'"

REM Create the directory for stutil binaries
set "STUTIL_DIR=C:\Program Files\stutil"
if not exist "%STUTIL_DIR%" (
    echo Creating directory %STUTIL_DIR%...
    mkdir "%STUTIL_DIR%\"
)

REM Move binaries to the directory
echo Moving binaries to PATH directory...
move /Y C:\Windows\System32\stlink-1.8.0-win32\bin\* "%STUTIL_DIR%\"

REM Remove the existing Program Files (x86) stlink directory if it exists
if exist "C:\Program Files (x86)\stlink" (
    echo Removing existing "C:\Program Files (x86)\stlink"...
    rmdir /Q /S "C:\Program Files (x86)\stlink"
)

mkdir "C:\Program Files (x86)\stlink"

REM Move chip config to Program Files (x86) directory
echo Moving chip config folder to Program Files (x86) directory
move /Y "C:\Windows\System32\stlink-1.8.0-win32\Program Files (x86)\stlink\config" "C:\Program Files (x86)\stlink"

REM Remove the existing libusb.zip if it exists
if exist libusb.7z (
    echo Removing existing libusb.zip...
    del /Q libusb.7z
    rmdir /S /Q libusb
)

REM Download the libusb-1.0 ZIP file
echo Downloading libusb-1.0.dll from libusb-1.0.23
curl -L -o libusb.7z "https://github.com/libusb/libusb/releases/download/v1.0.23/libusb-1.0.23.7z"

REM Create the directory for libusb dll
set "LIBUSB_DIR=C:\Program Files\libusb"
if not exist "%LIBUSB_DIR%" (
    echo Creating directory %LIBUSB_DIR%
    mkdir "%LIBUSB_DIR%\"
)

REM Extract the ZIP file
echo Extracting libusb dll...
7z x "C:\Windows\System32\libusb.7z" -o"C:\Windows\System32\libusb"

REM Move dll to the the directory
echo Moving dll to PATH directory
move /Y C:\Windows\System32\libusb\MinGW64\dll\* "%LIBUSB_DIR%\"

REM Directories to check
set "DIR1=%STUTIL_DIR%"
set "DIR2=%LIBUSB_DIR%"

REM Initialize flags
set "DIR1_EXISTS=0"
set "DIR2_EXISTS=0"

REM Check if DIR1 is in the PATH
echo %PATH% | findstr /i /c:"%DIR1%" >nul 2>&1
if %ERRORLEVEL%==0 (
    set "DIR1_EXISTS=1"
)

REM Check if DIR2 is in the PATH
echo %PATH% | findstr /i /c:"%DIR2%" >nul 2>&1
if %ERRORLEVEL%==0 (
    set "DIR2_EXISTS=1"
)

REM Check the flags and echo the results using nested if statements
if %DIR1_EXISTS%==1 (
    if %DIR2_EXISTS%==1 (
        echo Both %DIR1% and %DIR2% exist in PATH
        echo Continuing...
    ) else (
        echo %DIR1% exists in PATH, but %DIR2% does not
        echo Adding %DIR2% to PATH...
        setx PATH "%PATH%;%LIBUSB_DIR%" /M
    )
) else (
    if %DIR2_EXISTS%==1 (
        echo %DIR2% exists in PATH, but %DIR1% does not
        echo Adding %DIR1% to PATH...
        setx PATH "%PATH%;%STUTIL_DIR%" /M
    ) else (
        echo Neither %DIR1% nor %DIR2% exist in PATH
        echo Adding %DIR1% and %DIR2% to PATH...
        setx PATH "%PATH%;%LIBUSB_DIR%;%STUTIL_DIR%" /M
    )
)

echo All tools installed!

echo Now installing Visual Studio Code
curl -L -o "C:\Program Files\VSCodeUserSetup.exe" "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
"C:\Program Files\VSCodeUserSetup.exe"
echo Visual Studio Code installed!
echo Batchfile run completed!
pause