#
# requires, vars, and autoconfiguration
#

{spawn, exec} = require 'child_process'
path = require 'path'
util = require 'util'

# ANSI Terminal Colors
bold = '\x1b[0;1m'
green = '\x1b[0;32m'
reset = '\x1b[0m'
red = '\x1b[0;31m'

#
# build configuration (for tools and such)
#

coffeeOpts = '-bmc'

#
# mega tasks
#

task 'build', 'compile coffeescript', ->
	exec "coffee #{coffeeOpts} -o #{path.normalize('./lib/')} #{path.normalize('./src/')}", (err, stdout, stderr) ->
		if err then log stdout, stderr, err else log '[coffee] compiled successfully'

log = (message, explanation, isError = false) ->
	if isError
		message = "#{red} err: #{message}#{reset}"
	else
		message = "#{green} #{message.trim()} #{reset}"
	util.log message + ' ' + (explanation or '')
