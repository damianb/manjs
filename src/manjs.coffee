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
	if uri.pathname is '/' or uri.pathname.match /\/[\w\d]+/i is -1
		# basic response here, send search page html
		res.writeHead 200, {'Content-Type': 'text/html'}
		page = "<!DOCTYPE html><html>"
		page += "<head><title>manjs</title></head>"
		page += "<body>please request a valid manpage by sending an HTTP GET to <strong>http://localhost:#{port}/<em>command</em>/</strong>, where <em>command</em> is the command to look up</body>"
		page += "</html>"
		res.end page
	else
		# figure out the manpage to grab
		manpage = spawn('man', ['-Thtml', uri.pathname.substr 1, uri.pathname.length - 1])
		err = man = ''
		manpage.stdout.on 'data', (data) ->
			man += data
		manpage.stderr.on 'data', (data) ->
			err += data
		manpage.on 'close', (code) ->
			if code isnt 0
				res.writeHead 500, {'Content-Type': 'text/html'}
				res.write "<!DOCTYPE html><html><body>#{err}</body></html>"
			else
				res.writeHead 200, {'Content-Type': 'text/html'}
				res.write man
			res.end()
server.listen port
