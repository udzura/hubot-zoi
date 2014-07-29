# Description:
#   今日も一日頑張るぞい！
#
# Commands:
#   hubot zoi - 今日も一日頑張る
#
# Author:
#   Uchio KONDO


request = require 'request'
uri     = 'http://zoi.herokuapp.com/js/services.js'

getZois = (cb) ->
  request(uri, (err, response, body) ->
    if err
      cb.onError(err)
    else
      zois = body.match(/image: 'https:\/\/pbs.twimg.com\/media\/.+.jpg:large'/mg).
                  map((l) -> l.match("'(https.+\.jpg):large'")[1])
      (cb.onZoi || cb.onSuccess)(zois)
  )

module.exports = (robot) ->
  robot.respond /zoi/i, (msg) ->
    getZois
      onZoi: (zois) -> msg.send msg.random zois
      onError: (err) -> msg.send "頑張れなかった...: #{err}"
    
