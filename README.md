# Windows Focus Mode: Automatic Grayscale

A lightweight Windows automation tool built with AutoHotkey (v2) to reduce digital distraction. This script enforces intermittent grayscale usage while providing controlled, timed access to full color.

## 🎯 Objective

Reduce "digital dopamine" by maintaining a grayscale display as the default state. The system allows for temporary color access when needed but automatically reverts to a focused, black-and-white environment.

## ✨ Features

- **Automatic Grayscale:** Enforces grayscale mode on system startup and script launch.
- **Smart Toggling:** Automatically toggles the grayscale state every 2 hours (configurable) to prevent eye fatigue while maintaining focus.
- **Timed Color Access:** Hotkey-triggered (`Ctrl + Alt + Shift + C`) temporary color mode. Just input how many minutes you need, and the script handles the rest.
- **State-Aware Logic:** Uses Windows registry checks to ensure it never gets "out of sync" with system settings.
- **Low Footprint:** Runs in the background with minimal system resources.

## 🚀 Getting Started

### Prerequisites

- **Windows 10/11**
- **[AutoHotkey v2+](https://www.autohotkey.com/v2/)**
- **Windows Color Filters Enabled:** 
  1. Go to `Settings > Accessibility > Color filters`.
  2. Toggle "Color filters" to **On**.
  3. Ensure "Grayscale" is selected.
  4. (Optional) Check "Keyboard shortcut for color filters" (`Win + Ctrl + C`).

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YOUR_USERNAME/focus-mode-windows.git
    cd focus-mode-windows
    ```
2.  **Run the script:**
    Double-click `focus_mode.ahk`.

### Set it to Run at Startup

To make this a permanent part of your workflow:

1. Press `Win + R`, type `shell:startup`, and press Enter.
2. Create a **shortcut** to `focus_mode.ahk` in that folder.

## ⌨️ Controls

| Action | Shortcut |
| :--- | :--- |
| **Request Color Mode** | `Ctrl + Alt + Shift + C` |
| **Manual Toggle** | `Win + Ctrl + C` (Native Windows) |

## ⚙️ Configuration

Open `focus_mode.ahk` in any text editor to modify the following:

- `FOCUS_INTERVAL_MS`: Change the 2-hour automatic cycle (set in milliseconds).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Made to help you reclaim your focus.*
