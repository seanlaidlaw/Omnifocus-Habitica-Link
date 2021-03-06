-- Get Habitica API credentials
set configFile to ((path to me as text) & "::") & "config.txt"
set completed_habticas to paragraphs of (read file configFile as �class utf8�)
set apiUser to first item of completed_habticas
set apiKey to second item of completed_habticas


-- Get contents of Task log to make sure we're not dealing with duplicates
try
	set errorLog to alias (((path to me as text) & "::") & "ErrorLog.txt")
on error number -43
	set posixerrorLog to (quoted form of POSIX path of (((path to me as text) & "::") & "ErrorLog.txt"))
	do shell script ("echo \"\" > " & posixerrorLog)
end try
set errorLog to ((path to me as text) & "::") & "ErrorLog.txt"


try
	set taskLog to alias (((path to me as text) & "::") & "TaskLog.txt")
on error number -43
	set posixtaskLog to (quoted form of POSIX path of (((path to me as text) & "::") & "TaskLog.txt"))
	do shell script ("echo \"\" > " & posixtaskLog)
end try
set taskLog to ((path to me as text) & "::") & "TaskLog.txt"


set urlLog to read alias taskLog
set urlerrorLog to read alias errorLog


-- Set up functions to use later for completing omnifocus tasks
on write_to_file(this_data, target_file, append_data)
	try
		set the target_file to the target_file as string
		set the open_target_file to open for access file target_file with write permission
		if append_data is false then set eof of the open_target_file to 0
		write this_data to the open_target_file starting at eof
		close access the open_target_file
		return true
	on error
		try
			close access file target_file
		end try
		return false
	end try
end write_to_file



-- Run python script to get API return
set thisFolder to POSIX path of ((path to me as text) & "::")
set pythonOut to (do shell script ("python '" & thisFolder & "/scripts/Habitica.py' " & apiUser & " " & apiKey))
set completed_habticas to paragraphs of pythonOut


-- Check off omnifocus task if url is not found in log
repeat with habtica_task in completed_habticas
	set current_Url to "omnifocus:///task/" & habtica_task
	if current_Url is not in urlLog then
		if current_Url is not in urlerrorLog then
			set url_2_log to return & current_Url & return
			tell application "OmniFocus"
				tell default document
					try
						set individual_habT to (task id (habtica_task))
						mark complete individual_habT
						my write_to_file(url_2_log, taskLog, true)
						
					on error error_message number error_number
						if error_number = -1728 then
							set errorWrite to "Encountered error trying to open task : " & habtica_task & return & current_Url & return
							my write_to_file(errorWrite, errorLog, true)
							display notification "Omnifocus-CrossOff encountered an error, please see errorLog.txt"
						else
							set errorWrite to "Encountered error" & error_number & " : " & error_message & return & current_Url & return
							my write_to_file(errorWrite, errorLog, true)
							display notification "Omnifocus-CrossOff encountered an error, please see errorLog.txt"
						end if
						
					end try
				end tell
			end tell
		end if
	end if
end repeat