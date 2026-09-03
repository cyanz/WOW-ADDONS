# QuickVolume

A lightweight and convenient World of Warcraft addon for quickly controlling game audio without opening the Sound settings menu.

QuickVolume adds a small draggable speaker icon to your UI. Hover over it for instant Master Volume control, or click it to access individual volume channels and audio output devices.

## Features

### Quick Master Volume Control

Hover your mouse over the speaker icon to display a compact vertical Master Volume slider.

* Vertical volume slider
* Current volume percentage
* `-` button decreases volume by 1%
* `+` button increases volume by 1%
* The popup automatically opens upward or downward depending on the icon's screen position
* Automatically stays within the visible screen area

### Full Volume Control

Left-click the speaker icon to open the full QuickVolume panel.

Individual controls are available for:

* Master Volume
* Music
* Sound Effects (SFX)
* Dialog

Each channel includes:

* Vertical volume slider
* Current volume percentage
* `-` button: decrease by 1%
* `+` button: increase by 1%

### Audio Output Device

QuickVolume can display the audio output devices detected by World of Warcraft.

Use the **Output Device** selector at the bottom of the main panel to quickly switch between available audio devices without opening the game's Sound settings.

For example:

* System Default
* Speakers
* Headphones
* USB Audio
* HDMI / DisplayPort Audio
* Other devices detected by World of Warcraft

The WoW sound system is restarted automatically when switching devices so the new output can take effect immediately.

### Quick Mute

Middle-click the speaker icon to instantly mute Master Volume.

Middle-click again to restore the previous Master Volume level.

When muted, the speaker icon remains visible and displays a red **X**, so the control never disappears when the volume reaches 0%.

### Mouse Wheel Control

Move the mouse over the speaker icon and use the mouse wheel to quickly adjust Master Volume.

Each mouse-wheel step changes Master Volume by 5%.

### Draggable

Drag the speaker icon with the left mouse button to place QuickVolume wherever you want on your UI.

The Master Volume popup automatically determines the best opening direction based on the speaker icon's current screen position.

## Controls

| Action       | Function                       |
| ------------ | ------------------------------ |
| Hover        | Show Master Volume control     |
| Left Click   | Open / close full volume panel |
| Middle Click | Mute / restore Master Volume   |
| Mouse Wheel  | Adjust Master Volume by 5%     |
| `-`          | Decrease selected volume by 1% |
| `+`          | Increase selected volume by 1% |
| Left Drag    | Move the speaker icon          |

## Localization

QuickVolume automatically detects your World of Warcraft client language using `GetLocale()`.

Currently included localization support:

* English (`enUS`)
* Simplified Chinese (`zhCN`)
* Traditional Chinese (`zhTW`)
* German (`deDE`)
* French (`frFR`)
* Korean (`koKR`)
* Spanish (`esES`, `esMX`)
* Russian (`ruRU`)
* Brazilian Portuguese (`ptBR`)
* Italian (`itIT`)

English is used automatically as the fallback language if a translation is unavailable.

Localization strings are stored separately in:

```text
lang.lua
```

This makes it easy to add or improve translations without modifying the main addon code.

## Installation

1. Download or clone QuickVolume.
2. Place the `QuickVolume` folder inside your World of Warcraft AddOns directory:

```text
World of Warcraft/
└── _retail_/
    └── Interface/
        └── AddOns/
            └── QuickVolume/
                ├── QuickVolume.toc
                ├── lang.lua
                └── QuickVolume.lua
```

3. Start or restart World of Warcraft.
4. Make sure **QuickVolume** is enabled in the AddOns menu.
5. Log into your character.

If World of Warcraft reports that the addon is out of date after a game update, enable **Load out of date AddOns** until the addon is updated for the new Interface version.

## Design Philosophy

QuickVolume is designed to do one thing well:

**Make audio controls immediately accessible without opening the full World of Warcraft settings interface.**

The addon intentionally keeps its UI small and uses World of Warcraft's existing sound CVars and audio system wherever possible.

No complicated configuration window is required.

## Project Structure

```text
QuickVolume/
│
├── QuickVolume.toc
│   Addon metadata and load order
│
├── lang.lua
│   Localization strings
│
└── QuickVolume.lua
    Main addon logic and UI
```

## Sound Controls

QuickVolume currently controls the following World of Warcraft sound channels:

```text
Sound_MasterVolume
Sound_MusicVolume
Sound_SFXVolume
Sound_DialogVolume
```

Audio output selection uses World of Warcraft's available sound output drivers.

## Planned Improvements

Possible future improvements include:

* Ambience volume control
* Save speaker icon position between sessions
* Additional appearance options
* Adjustable mouse-wheel step
* Optional tooltip
* Optional audio-device quick switch
* Voice Chat output device support
* More localization improvements

## Compatibility

Designed for modern World of Warcraft Retail.

Because Blizzard occasionally changes UI APIs, a new World of Warcraft patch may require an Interface version update or minor addon adjustments.

## Issues & Feedback

If you encounter a bug, please open a GitHub Issue and include:

* World of Warcraft version
* QuickVolume version
* Client language
* Other UI addons you are using
* Full Lua error message, if available
* Steps to reproduce the problem

For Lua errors, enabling script errors can help with debugging:

```text
/console scriptErrors 1
/reload
```

## License

QuickVolume is an open-source World of Warcraft addon.

A license file should be included with the repository to define redistribution and modification permissions.

## Credits

**QuickVolume**

Created by Cyan.

Built for players who want faster and simpler control over World of Warcraft audio.
