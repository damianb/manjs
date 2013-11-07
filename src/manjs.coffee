# configuration
port = 8330

http = require 'http'
{spawn} = require 'child_process'
url = require 'url'

server = http.createServer (req, res) ->
	# localhost only
	if req.connection.remoteAddress isnt '127.0.0.1'
		res.writeHead 403, {'Content-Type': 'text/plain'}
		res.end '403 Forbidden'
		return

	uri = url.parse req.url
	res.writeHead 200, {'Content-Type': 'text/html'}
	if uri.pathname is '/' or uri.pathname.match /\/[\w\d]+/i is -1
		# basic response here, send search page html
		page = "<!DOCTYPE html><html>"
		page += "<head><title>manjs</title></head>"
		page += "<body>please request a valid manpage by sending an HTTP GET to <strong>http://localhost:#{port}/<em>command</em>/</strong>, where <em>command</em> is the command to look up</body>"
		page += "</html>"
		res.end page
	else
		# figure out the manpage to grab
		manpage = spawn('man', ['-Thtml', uri.pathname.substr 1, uri.pathname.length - 1])
		manpage.stdout.on 'data', (data) ->
			res.write data
		manpage.stderr.on 'data', (data) ->
			res.write "<!DOCTYPE html><html><body>#{data}</body></html>"
		manpage.on 'close', ->
			res.end()
, port
