set divider======================================
set tempdivider=================================================
title %appname% %appvers% - %appstat% [Loading...]

@echo off
color b
cls
echo Administrative permissions required. Detecting permissions.
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

rem =============================
rem Main Menu
rem =============================
:mainMenu
cls
title %appname% %appvers% - %appstat% [Main Menu]
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo # %desc%
echo # %divider%
echo #
echo # Automated ....... [1]
echo # Manual .......... [2]
echo # Donate .......... [3]
echo # Credits ......... [4]
echo # Options ......... [5]
echo # Exit ............ [6]
echo #
set /p "mainMenu=# $WiFiPassview> " || set mainMenu=1
if %mainMenu%==1 goto autoMode
if %mainMenu%==2 goto manualMode
if %mainMenu%==3 goto donate
if %mainMenu%==4 goto credits
if %mainMenu%==5 goto options
if %mainMenu%==6 goto exitProgram
pause>null

rem =============================
rem Automated Mode
rem =============================
:autoMode
cls
title %appname% %appvers% - %appstat% [Automated Mode]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo #
echo # Automated mode will extract all the available SSID in this machine.
echo # Press any key to continue... (except power button lol)
pause>null
cls
title %appname% %appvers% - %appstat% [Automated Mode]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
netsh wlan show profiles | findstr "All" > temp.txt
echo # Available SSID in this Machine
type temp.txt
echo # %divider%
echo # Creating helper file...
echo @echo off >> helper.bat
echo setlocal enabledelayedexpansion >> helper.bat
echo for /f "tokens=5*" %%%%i in (temp.txt) do ( set val=%%%%i %%%%j >> helper.bat
echo if "!val:~-1!" == " " set val=!val:~0,-1! >> helper.bat
echo echo !val! ^>^> final.txt) >> helper.bat
echo mkdir "%userprofile%"\Desktop\WiFi-Passview >> helper.bat
echo for /f "tokens=*" %%%%i in (final.txt) do @echo SSID: %%%%i ^>^> "%userprofile%"\Desktop\WiFi-Passview\creds.txt ^& echo # %tempdivider% ^>^> "%userprofile%"\Desktop\WiFi-Passview\creds.txt ^& netsh wlan show profiles name=%%%%i key=clear ^| findstr /c:"Key Content" ^>^> "%userprofile%"\Desktop\WiFi-Passview\creds.txt ^& echo # %tempdivider% ^>^> "%userprofile%"\Desktop\WiFi-Passview\creds.txt ^& echo # Key content is the password of your target SSID. ^>^> "%userprofile%"\Desktop\WiFi-Passview\creds.txt ^& echo # %tempdivider% ^>^> "%userprofile%"\Desktop\WiFi-Passview\creds.txt >> helper.bat
echo del /q temp.txt final.txt >> helper.bat
echo exit >> helper.bat
echo # Done...
echo # Extracting passwords and saving it...
ping localhost -n 3 >NUL
start helper.bat
echo # Done...
echo # Deleting temporary files...
ping localhost -n 3 >NUL
del /q helper.bat
echo # Done...
ping localhost -n 2 >NUL
cls
title %appname% %appvers% - %appstat% [Automated Mode]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo #
echo # WiFi credentials has been saved to "Desktop/WiFi-Passview/creds.txt", Press any key to open it in the file explorer...
pause>null
start explorer "%userprofile%"\Desktop\WiFi-Passview
pause>null
goto mainMenu

rem =============================
rem Manual Mode
rem =============================
:manualMode
cls
title %appname% %appvers% - %appstat% [Manual Mode]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # THE FOLLOWING WIFI PROFILES BELOW ARE HACKABLE!
netsh wlan show profiles
echo # Please enter the SSID of target WiFi
set /p "ssidname=# $WiFiPassview> "
cls
netsh wlan show profiles name=%ssidname%
if %errorlevel%==1 goto fail1
cls
color %infouicolor%
echo # %tempdivider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %tempdivider%
echo # SSID: %ssidname%
echo # %tempdivider%
netsh wlan show profiles name=%ssidname% key=clear | findstr /c:"Key Content" > temp.txt
type temp.txt
echo # %tempdivider%
echo # Key content is the password of your target SSID.
echo # %tempdivider%
echo # 
echo # Save to creds.txt ............. [1]
echo # Back to Main Menu ............. [2]
echo #
set /p "manualMode=# $WiFiPassview> " || set manualMode=2
if %manualMode%==1 goto manualSave
if %manualMode%==2 goto manualDel
pause>null

rem =============================
rem Manual: Save
rem =============================
:manualSave
cls
title %appname% %appvers% - %appstat%
mkdir "%userprofile%"/Desktop/WiFi-Passview
echo # SSID: %ssidname% >> "%userprofile%"/Desktop/WiFi-Passview/creds.txt
echo # %tempdivider% >> "%userprofile%"/Desktop/WiFi-Passview/creds.txt
netsh wlan show profiles name=%ssidname% key=clear | findstr /c:"Key Content" >> "%userprofile%"/Desktop/WiFi-Passview/creds.txt
echo # %tempdivider% >> "%userprofile%"/Desktop/WiFi-Passview/creds.txt
echo # Key content is the password of your target SSID. >> "%userprofile%"/Desktop/WiFi-Passview/creds.txt
echo # %tempdivider% >> "%userprofile%"/Desktop/WiFi-Passview/creds.txt
del temp.txt
cls
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo # %desc%
echo # %divider%
echo #
echo # WiFi credentials has been saved to "Desktop/WiFi-Passview/creds.txt", Press any key to open it in the file explorer...
pause>null
start explorer "%userprofile%"\Desktop\WiFi-Passview
goto mainMenu

rem =============================
rem Manual: Delete
rem =============================
:manualDel
cls
title %appname% %appvers% - %appstat%
del temp.txt
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo # %desc%
echo # %divider%
echo #
echo # Extracted password has been deleted! Press any key to continue... (except power button lol)
pause>null
goto mainMenu

rem =============================
rem Donate
rem =============================
:donate
cls
title %appname% %appvers% - %appstat% [Donate]
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo # Donate and Support
echo # %divider%
echo #
echo # Do you like this tool? 
echo # Please consider to buy me a coffee or
echo # just donate to keep this project alive.
echo #
echo # Buy Me A Coffee ....... [1]
echo # PayPal ................ [2]
echo # Back to Main Menu ..... [3]
echo #
set /p "donate=# $WiFiPassview> " || set donate=3
if %donate%==1 goto buymeacoffee
if %donate%==2 goto paypal
if %donate%==3 goto mainMenu
pause>null

rem =============================
rem Donate: BMC
rem =============================
:buymeacoffee
start https://buymeacoff.ee/warengonzaga
goto donate

rem =============================
rem Donate: PayPal
rem =============================
:paypal
start https://paypal.me/warengonzagaofficial
goto donate

rem =============================
rem Credits
rem =============================
:credits
cls
title %appname% %appvers% - %appstat% [Credits]
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo #
echo # This project is originally developed by Waren Gonzaga
echo # Version name Karin is a real name from Karin of Elris
echo # Elris is a popular KPOP Girl Group... (my bias lol)
echo # 
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto mainMenu

rem =============================
rem Options
rem =============================
:options
cls
title %appname% %appvers% - %appstat% [Options]
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo #
echo # Delete "creds.txt" ....... [1]
echo # Locate "creds.txt" ....... [2]
echo # Elris? Here I Am ......... [3]
echo # Back to Main Menu ........ [4]
echo #
set /p "options= # $WiFiPassview> " || set options=2
if %options%==1 goto deleteCreds
if %options%==2 goto locateCreds
if %options%==3 goto elris
if %options%==4 goto mainMenu
pause>null

rem =============================
rem Options: Delete Creds
rem =============================
:deleteCreds
cls
title %appname% %appvers% - %appstat%
del /q "%userprofile%"\Desktop\WiFi-Passview\creds.txt
rmdir "%userprofile%"\Desktop\WiFi-Passview
cls
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo # %desc%
echo # %divider%
echo #
echo # The "creds.txt" has been deleted! Press any key to continue... (except power button lol)
pause>null
goto options

rem =============================
rem Options: Locate Creds
rem =============================
:locateCreds
type "%userprofile%"\Desktop\WiFi-Passview\creds.txt
if %errorlevel%==1 goto fail2
start explorer "%userprofile%"\Desktop\WiFi-Passview
goto options

rem =============================
rem Options: Elris
rem =============================
:elris
start https://www.youtube.com/watch?v=iPAIlZM1VUU
goto options

rem =============================
rem Manual: Fail Message
rem =============================
:fail1
cls
title %appname% %appvers% - %appstat% [Error]
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # ERROR ERROR ERROR (FAIL)
echo # The WiFi profile name or the SSID doesn't exist!!!
echo # Make sure you enter the correct and exact one!
echo # Please try again or contact the developer for support...
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto mainMenu

rem =============================
rem Options: Fail Message
rem =============================
:fail2
cls
title %appname% %appvers% - %appstat% [Error]
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # ERROR ERROR ERROR (FAIL)
echo # The location of "creds.txt" does not exist!
echo # Please try again or contact the developer for support...
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto options

rem =============================
rem Exit Option Function
rem =============================
:exitProgram
exit