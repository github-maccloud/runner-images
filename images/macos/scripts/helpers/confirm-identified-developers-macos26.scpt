on run argv
    set userpassword to item 1 of argv
    set developerName to "Parallels International GmbH"
    set allowTitle to "Allow"

    -- Open System Settings -> Privacy & Security
    do shell script "open 'x-apple.systempreferences:com.apple.preference.security'"
    delay 1

    tell application "System Settings"
        reopen
        activate
    end tell

    tell application "System Events"
        tell process "System Settings"
            repeat until exists window 1
                delay 0.2
            end repeat

            set frontmost to true
            try
                perform action "AXRaise" of window 1
            end try
            delay 0.5

            -- Scroll until we find the correct Allow button near the Parallels text
            set foundButton to missing value
            repeat with i from 1 to 30
                set foundButton to my findAllowButtonForDeveloper(window 1, allowTitle, developerName)
                if foundButton is not missing value then exit repeat

                -- Page down to reveal lower part of Privacy & Security
                try
                    click window 1
                end try
                key code 121 -- Page Down
                delay 0.4
            end repeat

            if foundButton is missing value then
                error "Could not find '" & allowTitle & "' for '" & developerName & "'."
            end if

            click foundButton
            delay 0.5

            my enterPasswordIfPrompted(userpassword)
        end tell
    end tell
end run

-- Find "Allow" button whose nearby container contains developerName
on findAllowButtonForDeveloper(rootWin, allowTitle, developerName)
    tell application "System Events"
        set btns to {}
        try
            set btns to (every button of rootWin whose name is allowTitle)
        end try

        if (count of btns) is 0 then return missing value

        repeat with b in btns
            try
                set p to parent of b
                if my containerHasText(p, developerName) then return b

                -- sometimes button is nested; check one more level up
                set pp to parent of p
                if my containerHasText(pp, developerName) then return b
            end try
        end repeat
    end tell

    return missing value
end findAllowButtonForDeveloper

on containerHasText(containerRef, needle)
    tell application "System Events"
        try
            set texts to every static text of containerRef
            repeat with t in texts
                try
                    set v to value of t
                    if v is not missing value then
                        if (v as text) contains needle then return true
                    end if
                end try
            end repeat
        end try
    end tell
    return false
end containerHasText

on enterPasswordIfPrompted(userpassword)
    tell application "System Events"
        -- wait for either SecurityAgent or a sheet in System Settings
        repeat with i from 1 to 80
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
                my typePasswordAndSubmit(window 1, userpassword)
            end tell
            return
        end if

        tell process "System Settings"
            if exists sheet 1 of window 1 then
                my typePasswordAndSubmit(sheet 1 of window 1, userpassword)
            end if
        end tell
    end tell
end enterPasswordIfPrompted

on typePasswordAndSubmit(wRef, userpassword)
    tell application "System Events"
        -- focus first available (secure) text field
        try
            if exists secure text field 1 of wRef then
                click secure text field 1 of wRef
            else if exists text field 1 of wRef then
                click text field 1 of wRef
            end if
        end try

        delay 0.1
        keystroke userpassword
        delay 0.1
        key code 36 -- Return
    end tell
end typePasswordAndSubmit
