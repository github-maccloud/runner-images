# This AppleScript clicks "Allow" for "System Software from developer "Parallels International GmbH"
# Steps:
# - Open System Settings -> Privacy & Security
# - Click 'Allow' for 'System Software from developer "Parallels International GmbH'
# - Enter password for runner

on run argv
    set userpassword to item 1 of argv
    set developerName to "Parallels International GmbH"
    set allowButtonTitle to "Allow"

    -- Open System Settings -> Privacy & Security
    do shell script "open 'x-apple.systempreferences:com.apple.preference.security'"
    delay 1

    tell application "System Settings"
        reopen
        activate
    end tell

    tell application "System Events"
        tell process "System Settings"
            -- wait for main window
            repeat until exists window 1
                delay 0.2
            end repeat

            set frontmost to true
            try
                perform action "AXRaise" of window 1
            end try
            delay 0.5

            -- Try to find the Parallels block; if not visible, scroll down and retry.
            set allowButtonRef to missing value

            repeat with i from 1 to 25
                set allowButtonRef to my findAllowButtonNearDeveloperText(window 1, developerName, allowButtonTitle)
                if allowButtonRef is not missing value then exit repeat

                -- scroll down in the content area
                try
                    click (group 1 of window 1)
                end try
                key code 121 -- Page Down
                delay 0.4
            end repeat

            if allowButtonRef is missing value then
                error "Could not find '" & allowButtonTitle & "' near '" & developerName & "'."
            end if

            click allowButtonRef
            delay 0.5

            -- Handle auth prompt: can be a sheet in System Settings or a separate SecurityAgent window
            my enterPasswordIfPrompted(userpassword)
        end tell
    end tell
end run

-- Finds button "Allow" in the same (or parent) container where static text contains developerName
on findAllowButtonNearDeveloperText(rootContainer, developerName, allowButtonTitle)
    tell application "System Events"
        set targetText to missing value

        -- Search static texts in the current UI tree
        set uiList to entire contents of rootContainer
        repeat with e in uiList
            if class of e is static text then
                try
                    if (value of e as text) contains developerName then
                        set targetText to e
                        exit repeat
                    end if
                end try
            end if
        end repeat

        if targetText is missing value then return missing value

        -- Walk up a few levels and look for the Allow button nearby
        set p to targetText
        repeat with level from 1 to 6
            try
                set p to parent of p
                if exists (button allowButtonTitle of p) then
                    return (button allowButtonTitle of p)
                end if

                -- fallback: search any button with title "Allow" within this parent
                set nearList to entire contents of p
                repeat with b in nearList
                    if class of b is button then
                        try
                            if (name of b as text) is allowButtonTitle then return b
                        end try
                    end if
                end repeat
            end try
        end repeat
    end tell

    return missing value
end findAllowButtonNearDeveloperText

on enterPasswordIfPrompted(userpassword)
    tell application "System Events"
        -- wait a bit for either a sheet in System Settings or SecurityAgent dialog
        repeat with i from 1 to 60
            if exists process "SecurityAgent" then exit repeat
            tell process "System Settings"
                if exists sheet 1 of window 1 then exit repeat
            end tell
            delay 0.2
        end repeat

        if exists process "SecurityAgent" then
            tell process "SecurityAgent"
                repeat until exists window 1
                    delay 0.1
                end repeat
                my typePasswordInWindow(window 1, userpassword)
            end tell
            return
        end if

        tell process "System Settings"
            if exists sheet 1 of window 1 then
                my typePasswordInWindow(sheet 1 of window 1, userpassword)
            end if
        end tell
    end tell
end enterPasswordIfPrompted

on typePasswordInWindow(w, userpassword)
    tell application "System Events"
        -- try secure text field first, then regular text field
        try
            if exists secure text field 1 of w then
                click secure text field 1 of w
            else
                click text field 1 of w
            end if
        on error
            -- last resort: focus whatever is focused
        end try

        delay 0.1
        keystroke userpassword
        delay 0.1
        key code 36 -- Return
    end tell
end typePasswordInWindow
