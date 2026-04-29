#Requires AutoHotkey v2.0

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
    MsgBox("Color mode enabled for " minutes " minutes.", "Focus Mode", "T3") ; Auto-closes after 3 seconds

    temporaryColorTimerActive := true

    ; Set a timer to re-enable grayscale
    SetTimer(ReEnableGrayscale, -minutes * 60000)
}

ReEnableGrayscale() {
    global temporaryColorTimerActive
    EnsureGrayscaleOn()
    MsgBox("Grayscale mode re-enabled.", "Focus Mode", "T3")
    temporaryColorTimerActive := false
}

; --- Automatic 2-hour Cycle ---
; This will toggle the state every 2 hours.
; If it was ON, it goes OFF. If it was OFF, it goes ON.
SetTimer(ToggleGrayscale, FOCUS_INTERVAL_MS)

