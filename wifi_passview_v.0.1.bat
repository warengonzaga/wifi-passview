@echo off
goto :intro

:intro
color b
echo ============================================
echo ** WiFi Passview v.0.1 (zsecurity.org)
echo ** A batch tool to show the saved WiFi Passwords!
echo ** Created by Waren Gonzaga
echo ** Facebook: @warengonzagaofficialpage
echo ** Twitter: @waren_gonzaga
echo ** Github: @warengonzaga
echo ** Email: warengonzaga.dev@gmail.com
echo ============================================
echo ** Disclaimer: I am not liable for any
echo ** misuse of this tool. Use this tool on
echo ** your own risk!
echo ============================================
echo Please press any key to continue!
pause>Nul

goto :start
:start
color a
echo ...
echo THE FOLLOWING WIFI PROFILES BELOW ARE HACKABLE!
netsh wlan show profiles
set /p ssidname= Please enter the SSID of target WiFi: 
netsh wlan show profiles %ssidname% key=clear
if %errorlevel% neq 0 goto :fail
goto :successsd

pause>Nul

:success
echo ============================================
echo Congrats! You've successfully unlock the password!
echo Look for "SECURITY SETTINGS > KEY CONTENT"
echo The value of KEY CONTENT is the password of the Target WiFi
echo ============================================
pause>Nul
exit

:fail
cls
echo ============================================
color c
echo ERROR!!! ERROR!!!
echo You enter wrong wifi profile name
echo Make sure you enter the right one!
echo Please try again or contact Waren Gonzaga for support!
echo Facebook: @warengonzagaofficialpage
echo ============================================
pause>Nul
exit