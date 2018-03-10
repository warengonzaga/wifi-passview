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
) else (
cls
color c
echo Please run this script with administrator privileges.
pause
exit
)
cls
echo ============================================
echo ** WiFi Passview v 0.2 (zsecurity.org)
echo ** A batch program to show the saved WiFi Passwords!
echo ** Created by Waren Gonzaga
echo ** Facebook: @warengonzagaofficialpage
echo ** Twitter: @waren_gonzaga
echo ** Github: @warengonzaga
echo ** Email: warengonzaga.dev@gmail.com
echo ********************************************
echo ** Modified by keethesh
echo ** Email: keethesh15@gmail.com
echo ** Github: @keethesh
echo ============================================
echo ** Disclaimer: I am not liable for any
echo ** misuse of this tool. Use this tool on
echo ** your own risk!
echo ============================================
echo Please press any key to continue!
pause>Nul
cls
color a
echo ======================================================================
echo If you encounter "There is no wireless interface on the system" error
echo make sure that you have a wireless adapter connected 
echo and that you connected at least once to a password-protected hotspot
echo ======================================================================
pause
cls
echo THE FOLLOWING WIFI PROFILES ARE HACKABLE!
netsh wlan show profiles
set /p ssidname= Please enter the SSID of target WiFi: 
netsh wlan show profiles %ssidname% key=clear
if not %errorlevel%==0 goto :fail
goto :success

pause>Nul

:success
echo ============================================
echo Congrats! The password has been recovered successfully!
echo Look for "SECURITY SETTINGS > KEY CONTENT"
echo The value of KEY CONTENT is the password of the Target WiFi
echo ============================================
pause>Nul
exit

:fail
cls
echo ============================================
color c
echo An error has occured
echo Please try again later or post your issue on https://github.com/WarenGonzaga/WiFi-Passview/issues
echo Facebook: @warengonzagaofficialpage
echo Do you want me to open the issue page? [Y]/N
set /P openpage=
if %openpage%==y (
start https://github.com/WarenGonzaga/WiFi-Passview/issues
)
echo ============================================
pause>Nul
exit
