import subprocess, os, sys, webbrowser, ctypes, time, json, requests
from prettytable import PrettyTable
from colorama import Fore, init, Style

VERSION = "v4.1.0"
AUTHOR = "Waren Gonzaga"

init(convert=True)

# Get Path
system_path = os.getcwd()

# Serve Menu
def serve():
    clear()
    main_menu()

# Serve Donation
def serve_donation():
    clear()
    donate()

# Serve Options
def serve_options():
    clear()
    options()

def clear():
    os.system("cls")

# Serve Header
def header():
    header = "# =====================================\n"
    header += "# WiFi Passview {0} - Bella\n".format(VERSION)
    header += "# by {0}\n".format(AUTHOR)
    header += "# =====================================\n"

    return header


# Automated
def automated():
    clear()
    print(Fore.GREEN +"""
{0}
#
# Automated mode will extract all the available SSID in this machine.
# Press any key to continue... (except power button lol)
    """.format(header()))
    input()
    table = PrettyTable(['Wifi Name', 'Password'])
    profile = []
    data = subprocess.check_output(['netsh', 'wlan', 'show', 'profiles'])
    data = data.decode('utf-8', errors ="backslashreplace")
    data = data.split('\n')

    for wifi_name in data:
        if "All User Profile" in wifi_name:
            wifi_name = wifi_name.replace("All User Profile     :", '')
            wifi_name = wifi_name.replace("     ", '')
            wifi_name = wifi_name.replace('\r', '')

            profile.append(wifi_name)

    for password_key in profile:
        try:
            pass_result = subprocess.check_output(['netsh', 'wlan', 'show', 'profiles', password_key, 'key=clear'])
            pass_result = pass_result.decode('utf-8', errors ="backslashreplace")
            pass_result = pass_result.split('\n')
            pass_result = [key.split(":")[1][1:-1]
                for key in pass_result
                    if "Key Content" in key]
            try:
                table.add_row(['{0}'.format(password_key), '{0}'.format(pass_result[0])])
            except IndexError:
                table.add_row(['{0}'.format(password_key), 'No Password Found'])
        except subprocess.CalledProcessError:
            print("Error Occured")
    
    clear()
    print(Fore.GREEN + """
{0}
# Checking for wireless interface...
# Available SSID in this Machine
{1}
# =====================================
    """.format(header(), wifi_name))
    time.sleep(2)
    print(Fore.GREEN + """
# Done...
# Extracting passwords and saving it...
    """)
    clear()
    file_save_password = open('creds.txt', 'w+')
    file_save_password.write(str(table))
    file_save_password.close()
    time.sleep(2)
    print("""
{0}
#
# WiFi credentials has been saved to "creds.txt", Press any key to continue... (except power button lol)
    """.format(header()))
    input()
    clear()
    main_menu()

#Manual
def manual():
    print(Fore.GREEN + """
{0}
# Ready to scan available wifi profiles in this machine?
#
# Yes, continue ............. [1]
# Back to Main Menu ..........[2]
#
    """.format(header()))

    command = str(input(Fore.GREEN + "# $WiFiPassview > "))
    clear()
    if command == "1":
        show_profile = "cmd /c netsh wlan show profiles"
        data = subprocess.run([show_profile], shell=True, stdout=subprocess.PIPE, text=True)
        data = data.stdout
        print(Fore.GREEN + """
{0}
# THE FOLLOWING WIFI PROFILES BELOW ARE HACKABLE
# =====================================
{1}
# =====================================
# Please enter the SSID of target WiFi
# (e.g. WIFI-NAME or if contains spaces do "WIFI NAME")
# Type "cancel" or hit enter to go back (default)
""".format(header(), data))
        wifi_ = str(input(Fore.GREEN + "# $WiFiPassview > "))
        if wifi_ in ['cancel', 'Cancel']:
            serve()
        elif wifi_ == "":
            serve()
        else:
            pass_result = subprocess.check_output(['netsh', 'wlan', 'show', 'profiles', wifi_, 'key=clear'])
            pass_result = pass_result.decode('utf-8', errors ="backslashreplace")
            pass_result = pass_result.split('\n')
            pass_result = [key.split(":")[1][1:-1]
                            for key in pass_result
                                if "Key Content" in key]
            pass_result = ''.join(pass_result)
            password_text ="""
# SSID: {0}
# ================================================
#    Key Content            : {1}
# ================================================
# Key content is the password of your target SSID.
# ================================================
""".format(wifi_, pass_result)
            print(Fore.CYAN + """
{0}
# SSID: {1}
# ================================================
#    Key Content            : {2}
# ================================================
# Key content is the password of your target SSID.
# ================================================
#
# Save to creds.txt .................................. [1]
# Ignore and back to Main Menu (default) ............. [2]
#
# Note: If you hit enter or enter an invalid value the extracted password will not be saved.
#""".format(header(), wifi_, pass_result))
            option = str(input(Fore.GREEN + "# $WiFiPassview > "))
            if option == "1":
                file_pass = open('creds.txt', 'w+')
                pass_ = password_text.replace("FORE.CYAN", "")
                file_pass.write(str(pass_))
                file_pass.close()
                print(Fore.GREEN + """
{0}
# An open source batch script based program that can recover your WiFi Password easily in seconds.
# =====================================
#
# WiFi credentials has been saved to "creds.txt", Press any key to open it in the file explorer...
                    """.format(header()))
                input()
                os.system("start {0}".format(system_path))
                serve()
            elif option == "2":
                serve()
            elif option == "":
                serve()
            elif option:
                serve()
            else:
                serve()
    elif command == "2":
        serve()
    elif command == "":
        serve()
    elif command:
        serve()
    else:
        serve()


# Donate
def donate():
    print(Fore.GREEN + """
{0}
# Donate and Support
# =====================================
#
# Do you like this tool?
# Please consider to buy me a coffee or
# just donate to keep this project alive.
#
# Buy Me A Coffee ....... [1]
# PayPal ................ [2]
# Back to Main Menu ..... [3]
#
""".format(header()))
    command = str(input(Fore.GREEN + "# $WiFiPassview > "))
    if command == "1":
        webbrowser.open("https://wrngnz.ga/bmc")
        serve()
    elif command == "2":
        webbrowser.open("https://wrngnz.ga/paypal")
        serve()
    elif command == "3":
        serve()
    else:
        serve_donation()


# Credits
def credits():
    print(Fore.GREEN + """
{0}
#
# This project is originally developed by Waren Gonzaga
# Version name Bella is a real name from Bella of Elris
# Elris is a popular KPOP Girl Group... (my bias lol)
#
# =====================================
#
# Press any key to continue... (except power button lol)
# 
""".format(header()))
    input()
    serve()


# Options
def options():
    print(Fore.GREEN + """
{0}
#
# Delete "creds.txt" ......................... [1]
# Locate "creds.txt" ......................... [2]
# Open "creds.txt" in Notepad ................ [3]
# Upload "creds.txt" to Anonymous Cloud ...... [4]
# Generate WLAN Report ....................... [5]
# Premium Version ............................ [6]
# Elris? Here I Am ........................... [7]
# Back to Main Menu .......................... [8]
#
    """.format(header()))
    while True:
        command = str(input(Fore.GREEN + "# $WiFiPassview > "))
        if command == "1":
            command = "cmd /c del /q creds.txt"
            subprocess.run([command], stdout=subprocess.PIPE, shell=True, text=True)
            print("""
{0}
# An open source batch script based program that can recover your WiFi Password easily in seconds.
# =====================================
#
# The "creds.txt" has been deleted! Press any key to continue... (except power button lol)
""".format(header()))
            input()
            clear()
            options()
        elif command == "2":
            command = "cmd /c where /R {0} /F creds.txt".format(system_path)
            result = subprocess.run([command], stdout=subprocess.PIPE, shell=True, text=True)
            if "returncode=1" in str(result):
                print(Fore.RED + """
{0}
# ERROR ERROR ERROR (FAIL)
# The file "creds.txt" does not exist!
# Run automated mode or manual mode first and save extracted passwords in "creds.txt" file.
# Please try again or contact the developer for support...
# =====================================
#
# Press any key to continue... (except power button lol)
                """.format(header()))
                input()
                serve_options()
            else:
                open_folder = "cmd /c start {0}".format(system_path)
                os.system(open_folder)
                serve_options()
        elif command == "3":
            open_notepad = "cmd /c start notepad {0}\\creds.txt".format(system_path)
            os.system(open_notepad)
            serve_options()
        elif command == "4":
            print(Fore.GREEN + """
{0}
# [Upload Creds to Anonymous Cloud]
#
# This feature will upload "creds.txt" to Anonymous Cloud powered by file.io
# Your anonymous upload will be available for 14 days only.
#
# Continue Upload ....... [1]
# Back to Options ....... [2]
#
            """.format(header()))
            command = str(input(Fore.GREEN + "# $WiFiPassview > "))
            if command == "1":
                files_upload = {
                    'file' : '@creds.txt'
                }
                res = requests.post('https://file.io' ,files=files_upload).text
                data_link = json.loads(res)
                link = data_link['link']
                print(Fore.GREEN + """{0}""".format(header()))
                
                print(Fore.GREEN + """
{0}
# Uploaded!
""".format(header()))
                time.sleep(1)
                print(Fore.GREEN + """
# Generating link...
                """)
                time.sleep(1)
                print(Fore.GREEN + """
# Got it!
                """)
                time.sleep(1)
                print(Fore.GREEN  + """
# Here's your shortlink...
# =====================================
#
# Link: {0}
#
# =====================================
#
# Open it to browser?
# Yes ....... [1]
# No ........ [2]
# =====================================
                """.format(link))
                brow = str(input(Fore.GREEN + "# $WiFiPassview > "))
                if brow: 
                    serve_options()
                elif brow == "":
                    serve_options()
                elif brow == "1":
                    webbrowser.open(link)
                    serve_options()
                elif brow == "2":
                    serve_options()
                else:
                    serve()
            elif command == "2":
                serve_options()
            elif command == "":
                serve()
            elif command:
                serve()
            else:
                serve() 
        elif command == "5":
            print(Fore.GREEN + """
{0}
# [Generate WLAN Report]
#
# This feature will execute a command to generate WLAN Report for this machine.
#
# Note: This feature requires an administrative permissions to proceed.
# Close this program and run it as administrator to be able to work!
# =====================================
#
# Press any key to continue... (except power button lol)
            """.format(header()))
            input()
            print(Fore.GREEN + """
{0}
Administrative permissions required. Detecting permissions...
            """.format(header()))
            clear()
            if ctypes.windll.shell32.IsUserAnAdmin() == 0:
                print(Fore.RED + """
{0}
# ERROR ERROR ERROR [FAIL]
#
# WLAN reporting will not work!
# Close this program and run it as administrator and try again.
# =====================================
#
# Press any key to continue...

                """.format(header()))
                input()
                serve_options()
            else:
                clear()
                print(Fore.GREEN + """
{0}
Administrator privileges found!
Starting WLAN Reporting...
                """.format(header()))
                print(os.system("netsh wlan show wlanreport"))
                print(Fore.GREEN + """
# =====================================
#
# Press any key to continue... (except power button lol)
                """)
                input()
                clear()
                webbrowser.open("file:///C:/ProgramData/Microsoft/Windows/WlanReport/wlan-report-latest.html")
                serve_options()
        elif command == "6":
            clear()
            webbrowser.open("https://bmc.xyz/l/wifipassview")
            serve_options()
        elif command == "7":
            clear()
            webbrowser.open("https://www.youtube.com/watch?v=tpLro7n3PWo")
            serve_options()
        elif command == "8":
            serve()
        elif command:
            serve_options()
        elif command == "":
            serve()
        else:
            serve()


# Main Menu
# To Be Served at Main.py
def main_menu():
    while True:
        print(Fore.GREEN + """
{0}
# An open source batch script based program that can recover your WiFi Password easily in seconds.
# =====================================
#
# Automated (Default) ....... [1]
# Manual .................... [2]
# Donate .................... [3]
# Credits ................... [4]
# Options ................... [5]
# Exit ...................... [6]
#
        """.format(header()))
        command = str(input(Fore.GREEN + "# $WiFiPassview > "))
        if command == "1":
            clear()
            automated()
        elif command == "2":
            clear()
            manual()
        elif command == "3":
            clear()
            donate()
        elif command == "4":
            clear()
            credits()
        elif command == "5":
            clear()
            options()
        elif command == "6":
            clear()
            sys.exit(0)
        elif command == "":
            serve()
        elif command:
            serve()
        else:
            serve()
