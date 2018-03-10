try
	set clipboardData to (the clipboard as text)
end try
set thisFolder to POSIX path of ((path to me as text) & "::")
set configFile to ((path to me as text) & "::") & "config.txt"
set lns to paragraphs of (read file configFile)
log lns
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
					
				else if taskName starts with "Buy more" then
					set shorterName to do shell script "PATH='/usr/bin:/bin:/usr/sbin:/usr/local/bin:/usr/X11/bin:$PATH';echo '" & taskName & "' | gsed 's/buy\\s*more\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					
				else if taskName starts with "Buy a" then
					set shorterName to do shell script "PATH='/usr/bin:/bin:/usr/sbin:/usr/local/bin:/usr/X11/bin:$PATH';echo '" & taskName & "' | gsed 's/buy\\s*a\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					
				else if taskName starts with "Buy an" then
					set shorterName to do shell script "PATH='/usr/bin:/bin:/usr/sbin:/usr/local/bin:/usr/X11/bin:$PATH';echo '" & taskName & "' | gsed 's/buy\\s*an\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					
				else if taskName starts with "Buy" then
					set shorterName to do shell script "PATH='/usr/bin:/bin:/usr/sbin:/usr/local/bin:/usr/X11/bin:$PATH';echo '" & taskName & "' | gsed 's/buy\\s*//gI'"
					set MyProject to project "Shopping" of folder "Home"
					move currentTask to end of tasks of MyProject
					set name of currentTask to shorterName
					
					
					
					
					-- Look for tasks starting with "Waiting4" and set context to "#Waiting for..", while deleting "Waiting4" prefix	
				else if taskName starts with "Waiting4" then
					set shorterName to ((characters 9 thru -1 of taskName) as string)
					set theContext to (first flattened context where its name = "#Waiting for..")
					set context of currentTask to theContext
					set name of currentTask to shorterName
					
					
					--Contexts
					-- Look for tasks starting with "SmDyMyB" and set context to "Someday/Maybe", while deleting "SmDyMyB" prefix	
				else if taskName starts with "SmDyMyB" then
					set shorterName to ((characters 8 thru -1 of taskName) as string)
					set theContext to (first flattened context where its name = "Someday/Maybe")
					set context of currentTask to theContext
					
					
					-- Look for tasks starting with "3MarkPriority" and set context to "!!!", while deleting "3MarkPriority" prefix	
				else if taskName starts with "3MarkPriority" then
					set shorterName to ((characters 14 thru -1 of taskName) as string)
					set theContext to (first flattened context where its name = "!!!")
					set context of currentTask to theContext
					
					
					-- Look for tasks starting with "2MarkPriority" and set context to "!!", while deleting "2MarkPriority" prefix	
				else if taskName starts with "2MarkPriority" then
					set shorterName to ((characters 14 thru -1 of taskName) as string)
					set theContext to (first flattened context where its name = "!!")
					set context of currentTask to theContext
					
					
					-- Look for tasks starting with "1MarkPriority" and set context to "!", while deleting "1MarkPriority" prefix	
				else if taskName starts with "1MarkPriority" then
					set shorterName to ((characters 14 thru -1 of taskName) as string)
					set theContext to (first flattened context where its name = "!")
					set context of currentTask to theContext
					
					
				else if taskName starts with "Send2buddy" then
					set shorterName to ((characters 11 thru -1 of taskName) as string)
					set name of currentTask to shorterName
					set flagged of currentTask to true
					tell application "Finder"
						set current_path to (get (container of (container of (path to me))) as text) & "Share Omnifocus Tasks" & ":Share Omnifocus Task.applescript"
						set current_path to quoted form of POSIX path of current_path
					end tell
					--display dialog current_path
					run script "\"" & current_path & "\""
					
					
				else if taskName starts with "PUSH2HABITICA" then
					set shorterName to ((characters 15 thru -1 of taskName) as string)
					set name of currentTask to shorterName
					set taskID to id of currentTask
					do shell script "curl -X POST -d \"type=todo&text=" & shorterName & "&notes=" & "omnifocus:///task/" & taskID & "\" -H \"x-api-user: " & apiUser & "\" -H \"x-api-key: " & apiKey & "\" https://habitica.com/api/v3/tasks/user"
					
					
					repeat with aChildTask in currentTask's tasks
						set taskID to (id of aChildTask)
						set shorterName to name of (task id (id of aChildTask))
						do shell script "curl -X POST -d \"type=todo&text=" & shorterName & "&notes=" & "omnifocus:///task/" & taskID & "\" -H \"x-api-user: " & apiUser & "\" -H \"x-api-key: " & apiKey & "\" https://habitica.com/api/v3/tasks/user"
					end repeat
					
					
					
					
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