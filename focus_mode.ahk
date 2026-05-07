#Requires AutoHotkey v2.0
#SingleInstance Force ; Prevents multiple instances from running

; Configuration
; FOCUS_INTERVAL_MS: The interval in milliseconds for the automatic grayscale toggle. Default is 2 hours (7,200,000 ms).
FOCUS_INTERVAL_MS := 7200000

; Global variable to track if a temporary color mode timer is active
global temporaryColorTimerActive := false

; Function to get the current state of the color filter from the registry
; Returns 1 if enabled (grayscale), 0 if disabled (color)
GetGrayscaleState() {
    try {
        return RegRead("HKEY_CURRENT_USER\Software\Microsoft\ColorFiltering", "Active")
    } catch {
        return -1 ; Could not read registry
    }
}

; Function to ensure grayscale is ON
EnsureGrayscaleOn() {
    if (GetGrayscaleState() == 0) {
        Send "#^c"
    }
}

; Function to ensure grayscale is OFF (Color Mode)
EnsureGrayscaleOff() {
    if (GetGrayscaleState() == 1) {
        Send "#^c"
    }
}

; Function to toggle grayscale
ToggleGrayscale() {
    Send "#^c"
}

; --- Startup Behavior ---
; Wait a few seconds to ensure Windows Shell is ready
Sleep 3000
EnsureGrayscaleOn()
TrayTip "Focus Mode Started", "Grayscale is now active.", 1

; --- Hotkey: Temporary Color Mode (Ctrl + Alt + Shift + C) ---
^!+c::
{
    global temporaryColorTimerActive

    if (temporaryColorTimerActive) {
        MsgBox("A temporary color mode is already active.", "Focus Mode")
        return
    }

    input := InputBox("How many minutes of color mode? (Enter 0 to cancel)", "Focus Control")
    
    if (input.Result != "OK")
        return

    ; Validate integer
    if !IsNumber(input.Value) {
        MsgBox("Invalid input. Please enter a number.", "Focus Control")
        return
    }

    minutes := Integer(input.Value)

    if (minutes <= 0)
        return

    ; Disable grayscale (Switch to color)
    EnsureGrayscaleOff()
    TrayTip "Color Mode Active", "Reverting to grayscale in " minutes " minutes.", 1

    temporaryColorTimerActive := true

    ; Set a timer to re-enable grayscale
    SetTimer(ReEnableGrayscale, -minutes * 60000)
}

ReEnableGrayscale() {
    global temporaryColorTimerActive
    EnsureGrayscaleOn()
    TrayTip "Focus Mode", "Grayscale mode re-enabled.", 1
    temporaryColorTimerActive := false
}

; --- Automatic 2-hour Cycle ---
SetTimer(ToggleGrayscale, FOCUS_INTERVAL_MS)
