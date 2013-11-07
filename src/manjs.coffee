#
# configuration
#
port = 8330

#
# yes, that's all for configuration. could make a single dep on commander so we can do commandline config, but...eh.
#

http = require 'http'
{spawn} = require 'child_process'
url = require 'url'

server = http.createServer (req, res) ->
	uri = url.parse req.url
	res.writeHead 200, {'Content-Type': 'text/html'}
	if uri.pathname is '/' or uri.pathname.match /\/[\w\d]+/i is -1
		# basic response here, send search page html
		# todo input form for sanity's sake, just to make it easier to find commands or something
		page = "<!DOCTYPE html><html>"
		page += "<head><title>manj</title></head>"
		page += "<body>please request a valid manpage by sending an HTTP GET to <strong>http://localhost:#{port}/<em>command</em>/</strong>, where <em>command</em> is the command to look up</body>"
		page += "</html>"
		res.end page
	else
		# figure out the manpage to grab
		manpage = uri.pathname.substr 1, uri.pathname.length - 1
		manpage = spawn('man', ['-Thtml', manpage])
		manpage.stdout.on 'data', (data) ->
			res.write data
		manpage.stderr.on 'data', (data) ->
			res.write "<!DOCTYPE html><html><body>#{data}</body></html>"
		manpage.on 'close', ->
			res.end()
, port
