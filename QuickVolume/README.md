# QuickVolume

<p align="center">
  <img src="https://github.com/cyanz/WOW-ADDONS/blob/main/QuickVolume/preview.png" >
</p>

A lightweight World of Warcraft addon for fast volume control.

QuickVolume adds a small draggable speaker button to your UI, letting you adjust game audio without opening the full Sound settings menu.

## Version
12.12

## Features

- Hover the speaker icon for quick Master Volume control
- Left-click to open the full volume panel
- Middle-click to mute / restore Master Volume
- Mouse wheel adjusts Master Volume by 5%
- `+ / -` buttons adjust volume by 1%
- Separate controls for:
  - Master
  - Music
  - SFX
  - Dialog
- Audio output device selector
- Draggable speaker button
- Smart hover panel positioning
- Multi-language support
- Optional NDui-style integration
- Works normally without NDui

## NDui Support

If NDui is installed, QuickVolume automatically uses an NDui-style interface.

NDui is an optional dependency and is not required for QuickVolume to work.

## Installation

Copy the `QuickVolume` folder to:

```text
World of Warcraft/_retail_/Interface/AddOns/
```

## 📖 插件介绍

**QuickVolume** 在游戏界面中添加一个可自由拖动的扬声器按钮，让你无需打开系统声音设置，就可以快速调整游戏音量。

鼠标悬停即可调节主音量，也可以打开完整控制面板分别调整音乐、音效和对话音量。

---

## ✨ 功能

* 🔊 鼠标悬停快速调整 **主音量**
* 🖱️ 左键点击打开完整音量控制面板
* 🔇 鼠标中键快速 **静音 / 恢复音量**
* 🖱️ 鼠标滚轮每次调整主音量 **±5%**
* ➕ / ➖ 按钮精确调整音量 **±1%**
* 🎚️ 独立控制：

  * 主音量 Master
  * 音乐 Music
  * 音效 SFX
  * 对话 Dialog
* 🎧 可直接切换 **音频输出设备**
* 📌 扬声器按钮可自由拖动
* ↕️ 根据屏幕位置自动调整悬浮面板弹出方向
* 🌎 支持多国语言
* 🎨 支持 **NDui 风格界面**
* ✅ 不安装 NDui 也可以独立正常使用

---

## 🎨 NDui 支持

如果检测到 **NDui**，QuickVolume 会自动启用 NDui 风格界面。

包括：

* NDui 风格面板
* NDui 风格 Slider
* NDui 风格按钮
* NDui 风格输出设备选择框
* Hover 高亮效果

> **NDui 只是可选依赖，并不是运行 QuickVolume 的必要条件。**

没有安装 NDui 时，QuickVolume 会自动使用 Blizzard 默认界面风格。

---

## 🕹️ 操作方式

| 操作       | 功能             |
| :------- | :------------- |
| 🖱️ 鼠标悬停 | 快速调整主音量        |
| 👆 左键点击  | 打开完整控制面板       |
| 🖱️ 中键点击 | 静音 / 恢复        |
| 🛞 鼠标滚轮  | 主音量 ±5%        |
| ➕ / ➖    | 音量 ±1%         |
| ✋ 拖动图标   | 移动 QuickVolume |

---

## 🎧 音量控制

QuickVolume 可以分别控制：

`Master`　主音量
`Music`　音乐
`SFX`　音效
`Dialog`　对话

同时可以直接从插件面板切换当前的 **Audio Output Device（音频输出设备）**。

---

## 🌎 支持语言

目前支持：

🇺🇸 English
🇨🇳 简体中文
🇹🇼 繁體中文
🇩🇪 Deutsch
🇫🇷 Français
🇰🇷 한국어
🇪🇸 Español
🇷🇺 Русский
🇧🇷 Português
🇮🇹 Italiano

---

## 📦 安装

下载 QuickVolume 后，将整个 `QuickVolume` 文件夹复制到：

```text
World of Warcraft/_retail_/Interface/AddOns/
```

目录结构：

```text
QuickVolume/
├── QuickVolume.toc
├── QuickVolume.lua
├── lang.lua
└── NDui.lua
```

然后重新启动游戏，或者在游戏中输入：

```text
/reload
```

---

## 🔖 Version

**12.12**

---

<p align="center">
  Made with ❤️ for World of Warcraft
</p>

<p align="center">
  <b>QuickVolume by Cyan</b>
</p>



