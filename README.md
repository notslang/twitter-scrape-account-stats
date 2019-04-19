# Twitter Scrape Account Stats
[![Build Status](http://img.shields.io/travis/slang800/twitter-scrape-account-stats.svg?style=flat-square)](https://travis-ci.org/slang800/twitter-scrape-account-stats) [![NPM version](http://img.shields.io/npm/v/twitter-scrape-account-stats.svg?style=flat-square)](https://www.npmjs.org/package/twitter-scrape-account-stats) [![NPM license](http://img.shields.io/npm/l/twitter-scrape-account-stats.svg?style=flat-square)](https://www.npmjs.org/package/twitter-scrape-account-stats)

A tool for scraping public data from Twitter, without needing to get permission from Twitter. It scrapes the following fields:
- description
- followers
- following
- isVerified
- name
- posts
- userId
- username
- photo

See `lib/response.schema.json` for further details.

## Example
### CLI
The CLI operates entirely over STDOUT, and will output the account stats as JSON.

```bash
$ twitter-scrape-account-stats -u slang800
{"description":"","followers":97,"following":102,"isVerified":false,"name":"Sean Lang","userId":"1343446141","username":"slang800","posts":65}
```

### JavaScript Module
The following example is in CoffeeScript.

```coffee
{getAccountStats} = require 'twitter-scrape-account-stats'

getAccountStats(username: 'slang800').then((account) ->
  console.log "#{account.username} has #{account.followers} followers."
)
```

The following example is the same as the last one, but in JavaScript.

```js
var getAccountStats = require('twitter-scrape-account-stats').getAccountStats;

getAccountStats({username: 'slang800'}).then(function(account) {
  console.log(account.username + " has " + account.followers + " followers.");
});
```

## Why?
Twitter doesn't provide an open, structured, and machine readable API, so, we're forced to scrape their user-facing site.

## Caveats
- This is probably against the Twitter TOS, so don't use it if that sort of thing worries you.
- Whenever Twitter updates certain parts of their front-end this scraper will need to be updated to support the new API.
- You can't scrape protected accounts (cause it's not public duh).
