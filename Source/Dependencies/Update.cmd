@echo off
setlocal
echo Update Dependencies
echo ===================
echo.
echo Updates dependencies with the current checked-in build version.
echo.

echo.
echo Close Visual Studio now to avoid errors with locked files.
pause

echo.
echo Initializing Visual Studio environment...
call "%~dp0..\Visual Studio\Variables.cmd"
if %errorlevel% neq 0 goto Error

echo.
echo Updating build outputs from source control...
if exist "%~dp0Temp" (
    rmdir "%~dp0Temp" /s /q
    if %errorlevel% gtr 1 goto Error
)
git clone --branch=master git://github.com/WallLabs/CodeForPowerShell "%~dp0Temp\CodeForPowerShell"
if %errorlevel% neq 0 goto Error

echo.
echo Copying dependencies...
robocopy "%~dp0Temp\CodeForPowerShell\Build\Modules\CodeForPowerShell.VisualStudio" "%~dp0PowerShell\CodeForPowerShell.VisualStudio" /s /purge
if %errorlevel% gtr 7 goto Error
copy "%~dp0Temp\CodeForPowerShell\Build\Documentation\Release Notes.md" "%~dp0Documentation\Code for PowerShell Release Notes.md" /y
if %errorlevel% neq 0 goto Error
robocopy "%~dp0Temp\CodeForPowerShell\Build\Version" "%~dp0Version" *.Version.txt
if %errorlevel% gtr 7 goto Error
attrib "%~dp0*" -r /s
if %errorlevel% neq 0 goto Error

echo.
echo Calling version script to update references...
call "%~dp0..\Version.cmd"
if %errorlevel% neq 0 goto Error

echo.
echo Clean temporary files...
rmdir "%~dp0Temp" /s /q
if %errorlevel% gtr 1 goto Error

echo.
echo Update successful.
endlocal
exit /b 0

:Error
echo Error %errorlevel%!
endlocal
exit /b 1
