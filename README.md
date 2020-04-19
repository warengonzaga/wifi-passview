# WiFi Passview [![Developed by Waren Gonzaga](https://img.shields.io/badge/Developed%20by-Waren%20Gonzaga-blue.svg?longCache=true&style=for-the-badge)](https://facebook.com/warengonzagaofficial)

[![OS](https://img.shields.io/badge/OS-Windows-blue.svg?style=for-the-badge)](https://github.com/warengonzaga/wifi-passview) [![Github Release](https://img.shields.io/github/release/warengonzaga/wifi-passview.svg?style=for-the-badge)](https://github.com/warengonzaga/wifi-passview/releases) [![Github Star](https://img.shields.io/github/stars/warengonzaga/wifi-passview.svg?style=for-the-badge)](https://github.com/warengonzaga/wifi-passview) [![Github Fork](https://img.shields.io/github/forks/warengonzaga/wifi-passview.svg?style=for-the-badge)](https://github.com/warengonzaga/wifi-passview) [![License](https://img.shields.io/github/license/warengonzaga/wifi-passview.svg?style=for-the-badge)](https://github.com/warengonzaga/wifi-passview) [![Powered By](https://img.shields.io/badge/Powered%20By-GulpJS-orange.svg?style=for-the-badge)](https://gulpjs.com)

![Official Icon](./src/img/official-icon.png)

**WiFi Passview** is an open-source batch script-based program that can recover your WiFi Password easily in seconds. This is for Windows OS only. Basically, this scripted program has the same function as other passview software such as webpassview and mailpassview. [Visit Wiki](https://github.com/warengonzaga/wifi-passview/wiki)

_**Disclaimer**: WiFi Passview is **NOT** designed for malicious use! Please use this program responsibly!_

## Featured By

The project has been featured in some popular cybersecurity websites such as **[KitPloit.com](https://www.kitploit.com/2020/03/wifi-passview-v20-open-source-batch.html)**, **[Hakin9.org](https://hakin9.org/wifi-passview-an-open-source-batch-script-based-wifi-passview-for-windows)**, **[Pentest Magazine](https://pentestmag.com/wifi-passview)**, and **[Hackers Guru](https://www.facebook.com/hackersguru.in/photos/rpp.102159241158334/220015989372658)**.

## How it Works

Basically, this is the shortcut and batch scripted file version of a popular WiFi password manager viewing method using the command prompt. This is how it works...

```bash
netsh wlan show profiles
```

When you use this tool, you are able to extract the WiFi passwords stored on the target machine in just seconds.

To learn more [visit Wiki](https://github.com/warengonzaga/wifi-passview/wiki) page...

## Features

This simple tool offers you the following features...

* Extract all available WiFi passwords stored in the target machine and can be done in just a seconds.
* Extract password from specific target SSID.
* Save extracted passwords.
* Additional options.
* No manual reading of **``Key Content``**, the tool will do that for you!
* No need admin rights to run the program.
* Standalone batch program.
* Customizable.

## Usage

Download the repository and look for **``"wifi-passview-vX.X.X.bat"``** file and run it as ordinary ``*.bat`` file (_no need to run it as administrator_). All you have to do is to follow the on-screen instructions.

Read the official blog on **[How to Use WiFi Passview](https://warengonzaga.com/wifi-passview-for-windows-os)**.

_Wanna use for WiFi Hacking? Visit this [exclusive post from the author](https://www.buymeacoffee.com/p/40225)._

## Screenshots

Here's the screeshot of the program...

![Screenshot](./src/img/screenshot.jpg)

## In Action

Here's how this tool works...

[![YouTube](https://img.shields.io/badge/YouTube-Watch%20Here-red.svg?style=for-the-badge)](https://www.youtube.com/watch?v=dYWuXBjMyVc)

Don't forget to like, share, and subscribe to my channel!

## White Label / Personalize / Custom / Development

* Download the repository
* Do **``"npm install"``** and **``"npm install gulp-cli -g && npm install gulp -D"``**
* After that, edit the **``"./src/config.json"``** file for your customization or personalization.
* When you think you are satisfy, just do **``"gulp build"``** or **``"gulp"``** to initiate the building process.
* If you want to reset the building process just do **``"gulp cleandev"``**.
* If you are editing the **``"./src/core.bat"``** you can use **``"gulp test"``**  it is a combination of **``"gulp build"``** and **``"gulp cleandev"``** so you can quickly quality check the production build.
* Do **``"gulp --tasks"``** to see all available **``"gulp"``** commands.

## Premium Version

Looking for the official **``"wifi-passview-vX.X.X.exe"``** version and wanna support the project?

![Premium](./src/img/premium.jpg)

[![Support](https://img.shields.io/badge/Download-Premium%20Version-green.svg?style=for-the-badge)](https://bmc.xyz/l/wifipassview)

## FAQs

**Q**: Why you don't use the built-in ``netsh wlan`` export command?

> _I'm aware of that command, the only reason why I use ``findstr`` instead of that command is that to make the tool more user-level that does not require any admin rights. For example, if you are about to use the tool in a machine that you don't own then you're not able to use the tool. Got the idea? If the tool does not require admin rights then we can avoid the UAC prompt and we can use the tool more efficiently, the command ``netsh wlan show profiles`` do not require admin rights that's why we can still use that and capture the data and save it to file using the ``findstr`` command. Brilliant?_

Visit [FAQ section](https://github.com/warengonzaga/wifi-passview/wiki/Frequently-Asked-Questions) for more information.

## Contributing

Contributions are welcome, create a pull request to this repo and I will review your code.

## Issues

If you're facing a problem in using WiFi Passview please let me know by creating an issue in this github repository. I'm happy to help you! Don't forget to provide some screenshot or error logs of it!

## To Do

* Gulp Options
* Email Options
* CI (Travis)
* Wireless Network Reporting
* Extract WiFi Password Across Network (experimental)
* More... (have suggestions? let me know!)

## Community

Wanna see other projects I made? Join today!

[![Community](https://discordapp.com/api/guilds/659684980137656340/widget.png?style=banner2)](https://bmc.xyz/l/wgofficialds)

## Donate or Support

If you love this project please consider to support the development by means of coffee. I spend and waste my time just to save your time! Be a sponsor or backer of this project. Just a cup of coffee!

[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg?style=for-the-badge)](https://paypal.me/warengonzagaofficial) [![Support](https://img.shields.io/badge/Support-Buy%20Me%20A%20Coffee-orange.svg?style=for-the-badge)](https://www.buymeacoffee.com/warengonzaga)

## Supporters and Backers

* ernest_bigelow, nanantakeshi, kerry_howell

Wanna see your name here? [Just buy me a coffee](https://www.buymeacoffee.com/warengonzaga)!

## License

WiFi Passview is licensed under GNU General Public License v3 - <https://opensource.org/licenses/GPL-3.0>

## Author

This project is created by **Waren Gonzaga** for educational purposes.

* **Facebook:** <https://facebook.com/warengonzagaofficial>
* **Twitter:** <https://twitter.com/warengonzaga>
* **Website:** <https://warengonzaga.com>
* **Email:** dev(at)warengonzaga[.]com

---

**</>** with **<3** by **Waren Gonzaga**
