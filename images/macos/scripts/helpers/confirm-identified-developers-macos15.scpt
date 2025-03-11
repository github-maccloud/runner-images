on run argv
    set userpassword to item 1 of argv

    tell application "System Settings"
        activate
        delay 5
    end tell

    tell application "System Events"
        tell process "System Settings"
            set frontmost to true
            repeat until exists window "System Settings"
                delay 2
            end repeat

            -- Select "Privacy & Security" from the sidebar
            tell splitter group 1 of group 1 of window "System Settings"
                tell outline 1 of scroll area 1 of group 1
                    set privacyRow to a reference to row 26
                    if exists privacyRow then
                        select privacyRow
                        delay 5
                    else
                        error "Could not find 'Privacy & Security' in System Settings."
                    end if
                end tell
            end tell

            -- Click the "Allow" button for Parallels
            tell scroll area 1 of group 1 of splitter group 1 of group 1 of window "System Settings"
                set allowButton to a reference to UI element 1 of group 2 -- Adjust group number if needed
                if exists allowButton then
                    click allowButton
                    delay 5
                else
                    error "Could not find the 'Allow' button."
                end if
            end tell

            -- Enter password for authentication
            delay 2
            keystroke userpassword
            delay 2
            keystroke return
            delay 2
        end tell
    end tell
end run
