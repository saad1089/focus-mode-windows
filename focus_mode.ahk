#Requires AutoHotkey v2.0
#SingleInstance Force ; Prevents multiple instances from running

; Configuration
; FOCUS_INTERVAL_MS: The interval in milliseconds for the automatic grayscale toggle. Default is 2 hours (7,200,000 ms).
FOCUS_INTERVAL_MS := 7200000

; Global variables
global temporaryColorTimerActive := false
global autoCycleTimer := "" ; Will store the Timer object for the 2-hour cycle

; Function to get the current state of the color filter from the registry
; Returns 1 if enabled (grayscale), 0 if disabled (color)
GetGrayscaleState() {
    try {
        return RegRead("HKEY_CURRENT_USER\Software\Microsoft\ColorFiltering", "Active")
    } catch {
        return -1 ; Could not read registry or registry key not found
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

; Initialize and start the auto-cycle timer
; Use a persistent Timer object
autoCycleTimer := SetTimer(ToggleGrayscale, FOCUS_INTERVAL_MS)


; --- Hotkey: Temporary Color Mode (Ctrl + Alt + Shift + C) ---
^!+c::
{
    global temporaryColorTimerActive
    global autoCycleTimer

    ; Pause the auto-cycle timer
    if (IsObject(autoCycleTimer) && autoCycleTimer.IsEnabled) {
        autoCycleTimer.Stop()
    }

    if (temporaryColorTimerActive) {
        MsgBox("A temporary color mode is already active. Please wait for it to finish.", "Focus Mode")
        return
    }

    input := InputBox("How many minutes of color mode? (Enter 0 to cancel)", "Focus Control")
    
    if (input.Result != "OK") {
        ; If cancelled, restart auto-cycle timer if it was running
        if (IsObject(autoCycleTimer) && !autoCycleTimer.IsEnabled) {
            autoCycleTimer.Start()
        }
        return
    }

    ; Validate integer
    if (!IsNumber(input.Value) || Integer(input.Value) < 0) {
        MsgBox("Invalid input. Please enter a non-negative whole number for minutes.", "Focus Control")
        ; If invalid, restart auto-cycle timer if it was running
        if (IsObject(autoCycleTimer) && !autoCycleTimer.IsEnabled) {
            autoCycleTimer.Start()
        }
        return
    }

    minutes := Integer(input.Value)

    if (minutes = 0) { ; User chose to cancel or input 0
        ; If cancelled, restart auto-cycle timer if it was running
        if (IsObject(autoCycleTimer) && !autoCycleTimer.IsEnabled) {
            autoCycleTimer.Start()
        }
        return
    }

    ; Disable grayscale (Switch to color)
    EnsureGrayscaleOff()
    TrayTip "Color Mode Active", "Reverting to grayscale in " minutes " minutes.", 1

    temporaryColorTimerActive := true

    ; Set a timer to re-enable grayscale (runs once)
    SetTimer(ReEnableGrayscale, -minutes * 60000)
}

ReEnableGrayscale() {
    global temporaryColorTimerActive
    global autoCycleTimer
    EnsureGrayscaleOn()
    TrayTip "Focus Mode", "Grayscale mode re-enabled.", 1
    temporaryColorTimerActive := false

    ; Resume the auto-cycle timer if it was previously running
    if (IsObject(autoCycleTimer) && !autoCycleTimer.IsEnabled) {
        autoCycleTimer.Start()
    }
}
