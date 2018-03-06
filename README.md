# [Omnifocus-Habitica-Link](http://seanlaidlaw.com/productivity/)
Scripts to allow a transfer of tasks from Omnifocus to Habitica.

## Installation

`git clone https://github.com/SL-LAIDLAW/Omnifocus-Habitica-Link`

For the Applescript to work properly, you'll have to create a script in the Script Editor saved as a binary .scpt file in the directory below. This script should have a simple "run script [ directory where you did the git clone]/Task to Habitica.applescript" command so you can use this script from the Omnifocus menu bar.

Another .scpt file should also be made in the omnifocus script folder but this time running the script "Autosort.applescript". In my own setup I have removed the sync button from the Omnifocus toolbar and in its place put the Autosort script as it also syncs and checks for new completed habitica tasks. I have also setup a cron job to run the Autosort script every 30 minutes to avoid having to manually think to check.

`~/Library/Application Scripts/com.omnigroup.OmniFocus2/`

In the git clone directory make sure to create a file "config.txt" where the first line is your user key and where the second line is your API code. You can get both of these from your Habitica settings page.

## How it works
When you flag one or multiple tasks and run the "Task to Habitica" script, a POST request will be made using your API details (taken from the config.txt file in the same repository) with the title of the task and with the Omnifocus task ID as the description.

Later on after having completed the task in Habitica, the Autosort script will be run (by your cronjob or manually) and will get the descriptions of all the completed Habitica tasks, and thus have the Omnifocus task IDs. These taks will be checked off in Omnifocus, and their IDs will be logged in a file in the script directory as they won't be used again, and to avoid progressivly slowing down the script with every new completed Habitica task.

## Autosorting
A more recent addition to the script is the ability to sort inbox tasks based on task name. For basic tasks with repetitive syntax you can write rules that'll be run whenever Autosort checks for new Habitica tasks, to automatically classify said tasks into certain projects, as demonstrated below:
```
-- Insert your own custom rules here:
		-- for example I have ones for automatically populating my shopping list
		-- my example requires GNU sed to be installed : brew install sed

	else if taskName starts with "Buy more" then
		set shorterName to do shell script "echo '" & taskName & "' | gsed 's/buy\\s*more\\s*//gI'"
		set MyProject to project "Shopping" of folder "Home"
		move currentTask to end of tasks of MyProject
		set name of currentTask to shorterName

```
