@echo off
SET D="C:\HaxeToolkit"

:: Check if Haxe is installed
if not exist %D% (
    echo Haxe is note installed. Please install Haxe, then run this file again.
    GOTO mylabel
)

echo Haxe is installed, continuing...
echo Please wait while dependencies are installed.
echo This might take a while depending on your internet connection speed.

:: Install dependencies
haxelib install flixel
haxelib install away3d
haxelib install lunarps
haxelib install hlwnative
haxelib install flixel-ui
haxelib install flixel-addons
haxelib install hxdiscord

:: Test lime command
echo Running lime command as a test...
lime

echo if nothing showed, please check your internet connection or rerun this file.

echo Install complete.

setlocal

:PROMPT
SET /P AREYOUSURE=Would you lke to run lime setup (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

:END
echo Understood. Setup is complete.
endlocal
pause
exit /b

:mylabel
echo ERROR: HAXE_NOT_INSTALLED
pause
exit /b