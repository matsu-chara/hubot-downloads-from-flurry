# Description:
#

cronJob = require('cron').CronJob
moment = require('moment')

getDownloads = (robot, room) ->
  apiAccessCode = process.env.FLURRY_API_ACCESSCODE
  apiKey = process.env.FLURRY_API_KEY

  yesterday = moment().subtract(1, 'days').format("YYYY-MM-DD")
  yesterday_ja = moment().subtract(1, 'days').format("M月D日")
  url = "http://api.flurry.com/appMetrics/NewUsers?apiAccessCode=\
#{apiAccessCode}&apiKey=#{apiKey}&startDate=#{yesterday}&endDate=#{yesterday}"

  http = robot.http(url).get()
  http (err, res, body) ->
    if(!err)
      json = JSON.parse body
      robot.send(
        room
        "#{yesterday_ja} の新規ダウンロード: #{json.day?["@value"]}"
      )

module.exports = (robot) ->
  new cronJob('0 11-23/12 * * *', () ->
    getDownloads(robot, { room: '#bot' })
  ).start()

  robot.respond /down$/i, (msg) ->
    getDownloads(robot, { room: msg.envelope.room })
