/proc/send2slack(var/channel, var/msg)
	if(!config.use_slack_bot || !config.slack_bot_token || !config.slack_team || !channel || !msg)
		return 0

	//more info here: https://api.slack.com/docs/formatting
	//msg = html_decode(msg)
	msg = sanitize_plus_popup(html_decode(revert_ja(msg)))

	var/formatted_command = "curl --data \"[msg]\" 'https://[config.slack_team].slack.com/services/hooks/slackbot?token=[config.slack_bot_token]&channel=%23[channel]'"

	//world.log << formatted_command
	shell(formatted_command)

/proc/send2slack_service(var/msg)
	if(!msg)
		return
	var/server_name = config.server_name ? config.server_name : "Noname server"
	msg = server_name + " reports: " + msg

	send2slack("service", msg)

/proc/send2slack_admincall(var/msg)
	if(!msg)
		return
	var/server_name = config.server_name ? config.server_name : "Noname server"
	msg = server_name + " reports: " + msg

	send2slack("everything-talks", msg)

/proc/slack_startup()
	send2slack_service("server starting up")

/proc/slack_roundstart()
	send2slack_service("round is started, gamemode - [master_mode]")

/proc/slack_roundend()
	send2slack_service("round is over")
