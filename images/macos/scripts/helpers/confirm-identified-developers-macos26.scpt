on run argv
    set userpassword to item 1 of argv
    set developerName to "Parallels International GmbH"
    set allowTitle to "Allow"

    -- Open System Settings -> Privacy & Security
    do shell script "open 'x-apple.systempreferences:com.apple.preference.security'"
    delay 2

    tell application "System Settings"
        reopen
        activate
    end tell
    delay 2

    tell application "System Events"
        tell process "System Settings"
            repeat until exists window 1
                delay 0.2
            end repeat

            set frontmost to true
            try
                perform action "AXRaise" of window 1
            end try
            delay 1

            -- Debug: Log all buttons in the window
            log "=== DEBUG: Searching for Allow button ==="
            try
                set allButtons to every button of window 1
                log "Found " & (count of allButtons) & " buttons in window"
                repeat with b in allButtons
                    try
                        log "Button: " & (name of b as text)
                    end try
                end repeat
            end try

            -- Debug: Log all static text in the window
            log "=== DEBUG: Static texts in window ==="
            try
                set allTexts to every static text of window 1
                repeat with t in allTexts
                    try
                        set tVal to value of t
                        if tVal is not missing value then
                            log "Text: " & (tVal as text)
                        end if
                    end try
                end repeat
            end try

            -- Scroll until we find the correct Allow button near the Parallels text
            set foundButton to missing value
            repeat with i from 1 to 30
                log "=== Scroll iteration " & i & " ==="
                set foundButton to my findAllowButtonForDeveloper(window 1, allowTitle, developerName)
                if foundButton is not missing value then
                    log "Found Allow button!"
                    exit repeat
                end if

                -- Page down to reveal lower part of Privacy & Security
                try
                    click window 1
                end try
                key code 121 -- Page Down
                delay 0.5
            end repeat

            if foundButton is missing value then
                -- Additional debug: dump the entire UI hierarchy
                log "=== DEBUG: Full UI hierarchy ==="
                try
                    set entireUI to entire contents of window 1
                    repeat with el in entireUI
                        try
                            set elClass to class of el as text
                            set elName to ""
                            try
                                set elName to name of el as text
                            end try
                            if elName is not "" then
                                log elClass & ": " & elName
                            end if
                        end try
                    end repeat
                end try
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
            log "findAllowButtonForDeveloper: Found " & (count of btns) & " buttons named '" & allowTitle & "'"
        end try

        if (count of btns) is 0 then
            -- Try to find buttons with different names that might be Allow-related
            log "No buttons named 'Allow', searching for all buttons..."
            try
                set allBtns to every button of rootWin
                repeat with ab in allBtns
                    try
                        log "Available button: " & (name of ab as text)
                    end try
                end repeat
            end try
            return missing value
        end if

        repeat with b in btns
            try
                set p to parent of b
                log "Checking button parent for developer name..."
                if my containerHasText(p, developerName) then
                    log "Found in parent!"
                    return b
                end if

                -- sometimes button is nested; check one more level up
                set pp to parent of p
                log "Checking button grandparent for developer name..."
                if my containerHasText(pp, developerName) then
                    log "Found in grandparent!"
                    return b
                end if

                -- Check three levels up
                set ppp to parent of pp
                log "Checking button great-grandparent for developer name..."
                if my containerHasText(ppp, developerName) then
                    log "Found in great-grandparent!"
                    return b
                end if
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
                        set vText to (v as text)
                        log "containerHasText checking: " & vText
                        if vText contains needle then
                            log "MATCH FOUND: " & vText
                            return true
                        end if
                    end if
                end try
            end repeat
        end try

        -- Also check nested groups for static text
        try
            set nestedGroups to every group of containerRef
            repeat with g in nestedGroups
                try
                    set nestedTexts to every static text of g
                    repeat with nt in nestedTexts
                        try
                            set nv to value of nt
                            if nv is not missing value then
                                set nvText to (nv as text)
                                log "containerHasText (nested) checking: " & nvText
                                if nvText contains needle then
                                    log "MATCH FOUND (nested): " & nvText
                                    return true
                                end if
                            end if
                        end try
                    end repeat
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
