# Description:
#   今日も一日頑張るぞい！
#
# Commands:
#   hubot zoi - 今日も一日頑張る
#
# Configuration:
#   HUBOT_ZOI_SOURCE_URL
#
# Author:
#   Uchio KONDO


request = require 'request'
uri     = process.env.HUBOT_ZOI_SOURCE_URL
zois    = false

throw new Error('Please set HUBOT_ZOI_SOURCE_URL env') unless uri?

getZois = (cb) ->
  if zois
    (cb.onZoi || cb.onSuccess)(zois)
    return
  request(uri, (err, response, body) ->
    if err
      cb.onError(err)
    else
      zois = body.match(/image: ['"]?https?:\/\/.+.(jpg|png|gif).*["']?/mg).
                  map((l) -> l.match("'(https.+\.jpg):large'")[1])
      (cb.onZoi || cb.onSuccess)(zois)
  )

module.exports = (robot) ->
  robot.respond /zoi/i, (msg) ->
    getZois
      onZoi: (zois) -> msg.send msg.random zois
      onError: (err) -> msg.send "頑張れなかった...: #{err}"
    
