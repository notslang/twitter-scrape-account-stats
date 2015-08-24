request = require 'request-promise'
cheerio = require 'cheerio'

STAT_NAME_MAP =
  followers: 'following_stats'
  following: 'follower_stats'
  posts: 'tweet_stats'

getStatInt = ($, statName) ->
  stat = $("[data-element-term=\"#{statName}\"]").attr('title')
  if not stat?
    throw new Error("couldn't get #{statName}")
  parseInt(stat.replace(/[^0-9]/g, ''))

getAccountStats = ({username, userId}) ->
  if not username? and not userId?
    throw new Error('A username or userId needs to be passed')

  # `queryString['_']` is actually for cache busting, so we probably don't need
  # it... but we want to emulate twitter closely, so we add it anyway
  queryString =
    'wants_hovercard': true
    '_': (new Date()).getTime()

  if userId?
    queryString['user_id'] = userId
  else
    queryString['screen_name'] = username

  data = undefined
  request.get(
    uri: 'https://twitter.com/i/profiles/popup'
    qs: queryString
  ).then((resp) ->
    data = JSON.parse(resp)
    cheerio.load(data.html)
  ).then(($) ->
    res = {
      description: $('.bio.profile-field').text()
      isVerified: $('.Icon--verified').length > 0
      name: $('.ProfileCard-avatarLink').attr('title')
      userId: data['user_id']
      username: data['screen_name']
    }

    for field, statName of STAT_NAME_MAP
      try
        res[field] = getStatInt($, statName)
      catch e
        throw new Error("Couldn't get #{field} stat for #{res.username}")

    return res
  )

module.exports = {getAccountStats}
