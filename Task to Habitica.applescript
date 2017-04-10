-- Declare Variables
--  put your api user string here
set apiUser to ""
--  put your api key here
set apiKey to ""


tell application "OmniFocus"
	tell default document
		set flaggedTasks to every flattened task whose flagged is true and completed is false
		
		repeat with a from 1 to length of flaggedTasks
			
			set currentTask to item a of flaggedTasks
			
			set taskName to name of currentTask
			
			set taskID to id of currentTask
			
			
			do shell script "curl -X POST -d \"type=todo&text=" & taskName & "&notes=" & "omnifocus:///task/" & taskID & "\" -H \"x-api-user: " & apiUser & "\" -H \"x-api-key: " & apiKey & "\" https://habitica.com/api/v3/tasks/user"
			
			
			set flagged of currentTask to false
			
		end repeat
	end tell
end tell
