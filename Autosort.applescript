try
	set clipboardData to (the clipboard as text)
end try
set thisFolder to POSIX path of ((path to me as text) & "::")
set configFile to ((path to me as text) & "::") & "config.txt"
set lns to paragraphs of (read file configFile as Çclass utf8È)
set apiUser to first item of lns
set apiKey to second item of lns

tell application "OmniFocus"
	synchronize
	compact front document
	delay 1
end tell

on find_replace(theContent, stringToFind, stringToReplace)
	set {oldTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, stringToFind}
	set ti to every text item of theContent
	set AppleScript's text item delimiters to stringToReplace
	set newContent to ti as string
	set AppleScript's text item delimiters to oldTID
	return newContent
end find_replace


tell application "OmniFocus"
	tell default document
		set theInbox to every inbox task
		if theInbox is not equal to {} then
			repeat with n from 1 to length of theInbox
				set currentTask to item n of theInbox
				set taskName to name of currentTask
				
				
				-- Remove leading and trailing whitespace from task name
				if taskName starts with " " then
					set shorterName to do shell script "echo '" & taskName & "' | awk '{$1=$1};1'"
					set name of currentTask to shorterName
					
					
					
					
					-- Insert your own custom rules here: 
					-- for example I have ones for automatically populating my shopping list
					-- my example requires GNU sed to be installed : brew install sed	
					(*
				else if taskName starts with "Buy more" then
					set shorterName to do shell script "echo '" & taskName & "' | gsed 's/buy\\s*more\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					
				else if taskName starts with "Buy a" then
					set shorterName to do shell script "echo '" & taskName & "' | gsed 's/buy\\s*a\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					
				else if taskName starts with "Buy an" then
					set shorterName to do shell script "echo '" & taskName & "' | gsed 's/buy\\s*an\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					
				else if taskName starts with "Buy" then
					set shorterName to do shell script "echo '" & taskName & "' | gsed 's/buy\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					*)
					
					
				end if
				
			end repeat
			
		end if
	end tell
end tell


try
	set the clipboard to clipboardData
end try




-- Cross off the tasks that are marked as completed on Habitica
run script ((do shell script "dirname " & (quoted form of POSIX path of (path to me)) as string) & "/Omnifocus-CrossOff.applescript")



-- Remove flag from completed tasks
tell application "OmniFocus"
	tell default document
		set flaggedTasks to every flattened task whose flagged is true and completed is true
		repeat with a from 1 to length of flaggedTasks
			
			set currentTask to item a of flaggedTasks
			set flagged of currentTask to false
		end repeat
	end tell
end tell


-- Compact and Syncronize OmniFocus
try
	tell application "OmniFocus"
		compact front document
	end tell
	tell application "OmniFocus"
		synchronize document 1
	end tell
end try