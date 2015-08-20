{getAccountStats} = require './'
packageInfo = require '../package'
ArgumentParser = require('argparse').ArgumentParser

argparser = new ArgumentParser(
  version: packageInfo.version
  addHelp: true
  description: packageInfo.description
)

group = argparser.addMutuallyExclusiveGroup(required: true)
group.addArgument(
  ['--id']
  type: 'string'
  help: 'The userId of the account to scrape.'
  dest: 'userId'
)
group.addArgument(
  ['--username', '-u']
  type: 'string'
  help: 'Username of the account to scrape.  Within Twitter, this is called the
  "screen_name".'
)

argv = argparser.parseArgs()
getAccountStats(argv).then((res) ->
  console.log(JSON.stringify(res))
)
