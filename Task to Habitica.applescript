try
	set clipboardData to (the clipboard as text)
end try
set thisFolder to POSIX path of ((path to me as text) & "::")
set configFile to ((path to me as text) & "::") & "config.txt"
set lns to paragraphs of (read file configFile as Çclass utf8È)
set apiUser to first item of lns
set apiKey to second item of lns



tell application "OmniFocus"
	tell default document
		set flaggedTasks to every flattened task whose flagged is true and completed is false
		
		repeat with a from 1 to length of flaggedTasks
			
			set currentTask to item a of flaggedTasks
			
			set taskName to name of currentTask
			set the clipboard to taskName
			set taskName to (do shell script "python '" & thisFolder & "EscapeChar.py'")
			
			set taskID to id of currentTask
			
			
			do shell script "curl -X POST -d \"type=todo&text=" & taskName & "&notes=" & "omnifocus:///task/" & taskID & "\" -H \"x-api-user: " & apiUser & "\" -H \"x-api-key: " & apiKey & "\" https://habitica.com/api/v3/tasks/user"
			
			
			set flagged of currentTask to false
			
		end repeat
	end tell
end tell
try
	set the clipboard to clipboardData
end try