<div align="center">
  <img src="Assets/logo.png" alt="logo" width="160" height="160" />
  <h3><code>PaimonMenuBar</code></h3>
  <p><em>Track real-time Genshin Impact stats in your macOS menubar</em></p>

  <img src="https://img.shields.io/badge/uses-SwiftUI-f05138?labelColor=282c34&logo=swift" alt="Use Swift" />
  <img src="https://img.shields.io/badge/macOS-11.0+-f05138?labelColor=282c34&logo=apple" alt="macOS 11.0+" />
  <a href="https://github.com/spencerwooo/PaimonMenuBar/releases/latest"><img src="https://img.shields.io/github/v/release/spencerwooo/PaimonMenuBar?labelColor=282c34&logo=GitHub" alt="GitHub Release" /></a>
</div>

## What's this?

![screenshot](Assets/screenshot.jpg)

> Paimon helps you track your Genshin Impact daily resin, expeditions, and more — straight in your macOS menu bar.

Paimon can help you —

* 🌙 Keep track of your daily resin.
* 💰 Monitor your daily expeditions and real-time realm currency.
* 🏁 Remind you about your daily commissions and weekly boss fights.
* 🍯 And notify you when your parametric transformer is ready to use.

Basically, `PaimonMenuBar` lives in your macOS menu bar quietly, and offers you a nice way of monitoring your in-game real-time stats when you need to check them.

> **Note**
>
> `PaimonMenuBar` is made with SwiftUI, designed for and native to macOS.

## Download

[![GitHub Release](https://img.shields.io/github/v/release/spencerwooo/PaimonMenuBar?labelColor=282c34&logo=GitHub&style=for-the-badge)](https://github.com/spencerwooo/PaimonMenuBar/releases/latest)

## Things to know

1. Paimon uses the official Hoyoverse API found in either [米游社 (for CN players)](https://bbs.mihoyo.com/ys/) or [HoYoLAB (for Global players)](https://www.hoyolab.com/home).
2. Yes, Paimon needs your cookie. It is so that Paimon can request said API on your behalf, and fetch those in-game stats periodically. Rest assured that **the cookie is only stored locally.**
3. Check [FAQ](https://paimon.swo.moe/) if you have anymore questions.

## Credits

* Credits to [@Chawong](https://www.pixiv.net/en/artworks/92415888) for the logo. (Love from Hu Tao :heart:)
* iOS widget (Scriptable): [[闲聊杂谈][工具分享] iOS 快捷指令/小组件](https://bbs.nga.cn/read.php?tid=29801567)
* Friendly browser extension alternative: [daidr/paimon-webext](https://github.com/daidr/paimon-webext)
* Friendly Windows alternative: [ArvinZJC/PaimonTray](https://github.com/ArvinZJC/PaimonTray)

<details>
<summary>Development notes.</summary>

## TO-DO

* [x] Menu bar of varying height.
* [x] Configurable data refresh rate.
* [x] Start at login.
* [x] `i18n` support for at least Simplified Chinese and English.
* [x] Manual refresh button.
* [x] Code-sign and publish as `.dmg`.
* [x] Auto-updates and check for update.
* [x] Custom website and help for acquiring the cookie.
* [x] Help button beside the text field for entering the cookie.
* [x] Support for cn and global genshin accounts (米游社 and hoyolab).
* [x] Backward-compatibility for macOS 11.0.
* [x] Better first-time installation experience (guidance for initial setup).
* ~~[ ] Support for multiple accounts?~~

## Releasing a new version

* Create a build in Xcode, bump the build number, and notarize build.
* Create a new release on GitHub with a new version tag and increment the build number.
* Use `create-dmg` to create the `.dmg` file:

  ```bash
  create-dmg PaimonMenuBar.app
  ```

* Update appcast.xml with the new version tag and build number:

  ```bash
  cd <PATH_TO_SPARKLE>/artifacts/sparkle/bin
  ./generate_appcast <PATH_TO_PROJECT>/PaimonMenuBar/Build/
  ```

* Profit.

</details>

## License

[MIT](LICENSE)

<div align="center">
  <img src="Assets/footer.png" />
  <em>made with ❤️ by <a href="https://spencerwoo.com">spencer woo</a></em>
</div>
