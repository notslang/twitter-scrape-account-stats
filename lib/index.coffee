request = require 'request-promise'
cheerio = require 'cheerio'

getStatInt = ($, statName) ->
  stat = $("[data-element-term=\"#{statName}\"]").attr('title')
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
    return {
      description: $('.bio.profile-field').text()
      followers: getStatInt($, 'follower_stats')
      following: getStatInt($, 'following_stats')
      isVerified: $('.Icon--verified').length > 0
      name: $('.ProfileCard-avatarLink').attr('title')
      userId: data['user_id']
      username: data['screen_name']
      posts: getStatInt($, 'tweet_stats')
    }
  )

module.exports = {getAccountStats}
