-- Get Habitica API credentials
set configFile to ((path to me as text) & "::") & "config.txt"
set completed_habticas to paragraphs of (read file configFile as Çclass utf8È)
set apiUser to first item of completed_habticas
set apiKey to second item of completed_habticas


-- Get contents of Task log to make sure we're not dealing with duplicates
set taskLog to ((path to me as text) & "::") & "TaskLog.txt"
set urlLog to read alias taskLog


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

on completeTask()
	tell application "OmniFocus"
		tell front window
			set my_sel to selected trees of content
			if my_sel is not equal to {} then
				set my_selection to value of item 1 of my_sel
				if my_selection is not equal to {} then
					set completed of my_selection to true
				end if
			end if
		end tell
	end tell
end completeTask




-- Run python script to get API return
set thisFolder to POSIX path of ((path to me as text) & "::")
set pythonOut to (do shell script ("python '" & thisFolder & "Habitica.py' " & apiUser & " " & apiKey))
set completed_habticas to paragraphs of pythonOut


-- Check off omnifocus task if url is not found in log
repeat with habtica_task in completed_habticas
	set current_Url to "omnifocus:///task/" & habtica_task
	if current_Url is not in urlLog then
		set url_2_log to return & current_Url & return
		do shell script "open " & current_Url
		delay 0.5
		completeTask()
		delay 2
		my write_to_file(url_2_log, taskLog, true)
	end if
end repeat