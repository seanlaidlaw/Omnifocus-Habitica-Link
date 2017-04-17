set clipboardData to (the clipboard as text)
set thisFolder to POSIX path of ((path to me as text) & "::")
set configFile to ((path to me as text) & "::") & "config.txt"
set lns to paragraphs of (read file configFile as Çclass utf8È)
set apiUser to first item of lns
set apiKey to second item of lns

tell application "OmniFocus"
	tell front document
		set theInbox to every inbox task
		if theInbox is not equal to {} then
			repeat with n from 1 to length of theInbox
				set currentTask to item n of theInbox
				set taskName to name of currentTask
				
				--Shopping		
				-- Look for tasks starting with "Buy More..." and move to shopping list, while deleting "Buy more" prefix
				if taskName starts with "Buy more" then
					set shorterName to ((characters 9 thru -1 of taskName) as string)
					
					set nameWtProj to shorterName & " ::Shopping"
					
					set newTask to parse tasks into with transport text nameWtProj with as single task
					
					delete currentTask
					
					
					-- Look for tasks starting with "Buy a..." and move to shopping list, while deleting "Buy a" prefix	
				else if taskName starts with "Buy a" then
					set shorterName to ((characters 6 thru -1 of taskName) as string)
					
					set nameWtProj to shorterName & " ::Shopping"
					
					set newTask to parse tasks into with transport text nameWtProj with as single task
					
					delete currentTask
					
					
					-- Look for tasks starting with "Buy..." and move to shopping list, while deleting "Buy" prefix	
				else if taskName starts with "Buy" then
					set shorterName to ((characters 5 thru -1 of taskName) as string)
					
					set nameWtProj to shorterName & " ::Shopping"
					
					set newTask to parse tasks into with transport text nameWtProj with as single task
					
					delete currentTask
					
					
					--University			
					-- Look for tasks starting with "S4Task - " and move to S4 Catch-up list, while deleting "S4Task - " prefix	
				else if taskName starts with "S4Task" then
					set shorterName to ((characters 7 thru -1 of taskName) as string)
					
					set nameWtProj to shorterName & " ::S4 Catch-Up"
					
					set newTask to parse tasks into with transport text nameWtProj with as single task
					
					delete currentTask
					
					
					-- Look for tasks starting with "Waiting4" and set context to "#Waiting for..", while deleting "Waiting4" prefix	
				else if taskName starts with "Waiting4" then
					
					set shorterName to ((characters 9 thru -1 of taskName) as string)
					
					set theContext to (first flattened context where its name = "#Waiting for..")
					
					set newTask to make new inbox task with properties {name:shorterName, context:theContext}
					
					delete currentTask
					
					
					--Contexts
					-- Look for tasks starting with "SmDyMyB" and set context to "Someday/Maybe", while deleting "SmDyMyB" prefix	
				else if taskName starts with "SmDyMyB" then
					
					set shorterName to ((characters 8 thru -1 of taskName) as string)
					
					set theContext to (first flattened context where its name = "Someday/Maybe")
					
					set newTask to make new inbox task with properties {name:shorterName, context:theContext}
					
					delete currentTask
					
					
					-- Look for tasks starting with "3MarkPriority" and set context to "!!!", while deleting "3MarkPriority" prefix	
				else if taskName starts with "3MarkPriority" then
					
					set shorterName to ((characters 14 thru -1 of taskName) as string)
					
					set theContext to (first flattened context where its name = "!!!")
					
					set newTask to make new inbox task with properties {name:shorterName, context:theContext}
					
					delete currentTask
					
					
					-- Look for tasks starting with "2MarkPriority" and set context to "!!", while deleting "2MarkPriority" prefix	
				else if taskName starts with "2MarkPriority" then
					
					set shorterName to ((characters 14 thru -1 of taskName) as string)
					
					set theContext to (first flattened context where its name = "!!")
					
					set newTask to make new inbox task with properties {name:shorterName, context:theContext}
					
					delete currentTask
					
					
					-- Look for tasks starting with "1MarkPriority" and set context to "!", while deleting "1MarkPriority" prefix	
				else if taskName starts with "1MarkPriority" then
					
					set shorterName to ((characters 14 thru -1 of taskName) as string)
					
					set theContext to (first flattened context where its name = "!")
					
					set newTask to make new inbox task with properties {name:shorterName, context:theContext}
					
					delete currentTask
					
					
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