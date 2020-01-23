set divider======================================
title %appname% %appvers% - %appstat%

@echo off
color b
echo Administrative permissions required. Detecting permissions.
ping localhost -n 2 >NUL
cls
echo Administrative permissions required. Detecting permissions..
ping localhost -n 2 >NUL
cls
echo Administrative permissions required. Detecting permissions...
ping localhost -n 2 >NUL
net session >nul 2>&1
if %errorLevel% == 0 (
echo Administrator privileges found!
echo Starting the program...
ping localhost -n 2 >NUL
goto mainMenu
) else (
cls
color c
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo #
echo # ERROR * ERROR * ERROR * ERROR * ERROR * ERROR
echo #
echo # Current user permissions to execute this .bat file are inadequate.
echo # This .bat file must be run with administrative privileges.
echo # Close this program and run it as administrator.
echo # Contact the developer to assist you...
echo #
echo # ERROR * ERROR * ERROR * ERROR * ERROR * ERROR
echo #
pause
exit
)

REM =============================
REM Main Menu
REM =============================
:mainMenu
cls
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo # %desc%
echo # %divider%
echo Please press any key to continue!
pause>null

REM =============================
REM Getting WiFi Credentials
REM =============================
:scan
cls
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # THE FOLLOWING WIFI PROFILES BELOW ARE HACKABLE!
netsh wlan show profiles
set /p ssidname= Please enter the SSID of target WiFi: 
netsh wlan show profiles %ssidname% key=clear
if %errorlevel% neq 0 goto fail
goto success

pause>null

REM =============================
REM Success Message
REM =============================
:success
cls
color %infouicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # Congrats! You've successfully unlock the password!
echo # Look for "SECURITY SETTINGS > KEY CONTENT"
echo # The value of KEY CONTENT is the password of the Target WiFi
echo # %divider%
pause>null
exit

REM =============================
REM Fail Message
REM =============================
:fail
cls
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # ERROR ERROR ERROR (FAIL)
echo # The WiFi profile name doesn't exist
echo # Make sure you enter the correct one!
echo # Please try again or contact the developer for support...
echo # %divider%
pause>null
exit