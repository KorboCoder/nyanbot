# Description:
#   Natural availability tracking.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   brb (or afk, or bbl)
#
# Author:
#   jmhobbs

module.exports = (robot) ->

	users_away = {}

	getName = (user) ->
		name = user.name
		if user.nickname
			name = user.nickname
		return name

	robot.hear( /./i, (msg) ->
		if users_away[msg.message.user.name] and msg.message.text != 'brb'
			if not process.env.HUBOT_BRB_WAIT_DELAY?
				msg.robot.logger.error "HUBOT_BRB_WAIT_DELAY is not set for environment"
			if not process.env.HUBOT_BRB_WAIT_DELAY? || (new Date().getTime() / 1000)  - users_away[msg.message.user.name]> process.env.HUBOT_BRB_WAIT_DELAY
				msg.send "Welcome back " + getName(msg.message.user) + "!"
				delete users_away[msg.message.user.name]
			else
				users_away[msg.message.user.name] =  new Date().getTime() / 1000;
		else
			for user, state of users_away
				substr = msg.message.text.substring(0, user.length+1)
				if substr == user + ':'
					msg.send user + " is currently away."
					break
		)

	robot.hear /\b(brb|afk|bbl|bbiab|bye|gtg|bbiaf)\b/i, (msg) ->
		users_away[msg.message.user.name] =  new Date().getTime() / 1000;
		msg.send "See you later, #{getName(msg.envelope.user)}-nyan~"

