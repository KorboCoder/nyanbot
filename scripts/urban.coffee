# Description:
#   Define terms via Urban Dictionary
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot what is <term>?         - Searches Urban Dictionary and returns definition
#   hubot define <key> as <definition> - set that as the definition from now on
#   hubot forget <key> - forgets that definition   
#
# Author:
#   Travis Jeffery (@travisjeffery)
#   Robbie Trencheny (@Robbie)
#
# Contributors:
#   Benjamin Eidelman (@beneidel)

module.exports = (robot) ->
  if not robot.brain.definitions
    robot.brain.definitions = {}

  robot.respond /define ([^\?]*)[\?]* as ([^\?]*)[\?]*/i, (msg) ->
    key = msg.match[1]
    value = msg.match[2]
    robot.brain.definitions[key.toLowerCase()] = value
    msg.send "Hai! Defining #{key} as #{value}"

  robot.respond /forget ([^\?]*)[\?]*/i, (msg) ->
    key = msg.match[1]
    robot.brain.definitions[key] = undefined
    msg.send "I forgot what #{key} is. Nyoron~"

  robot.respond /what ?is ([^\?]*)[\?]*/i, (msg) ->
    if robot.brain.definitions[msg.match[1].toLowerCase()]
      msg.send robot.brain.definitions[msg.match[1].toLowerCase()]
    else
      urbanDict msg, msg.match[1], (found, entry, sounds) ->
        if !found
          msg.send "I don't know what \"#{msg.match[1]}\" is nyaaaaa~"
          return
        msg.send "#{entry.definition}"



urbanDict = (msg, query, callback) ->
  msg.http("http://api.urbandictionary.com/v0/define?term=#{escape(query)}")
    .get() (err, res, body) ->
      result = JSON.parse(body)
      if result.list.length
        callback(true, result.list[0], result.sounds)
      else
        callback(false)

