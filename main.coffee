# Run this script as `coffee main.coffee`

http = require 'http'
url = require 'url'
request = require 'request'
readability = require 'readability'


server = http.createServer (req, res) ->
    pageUrl = (req.url.substr 1)
    if pageUrl.indexOf('http') != 0  # http URLs only
        res.writeHead 404
        return

    res.writeHead 200, {'Content-Type': 'text/html'}

    console.log 'Page: ' + pageUrl
    request {uri: pageUrl}, (error, response, body) ->
        if not error and response.statusCode is 200
            readability.parse body, pageUrl, (d) ->
                console.log 'Parse complete.'
                res.write '<title>' + d.title + '</title>'
                res.end d.content
                console.log 'Closed request'


exports.run = () ->
    server.listen 8124, '127.0.0.1'
    console.log 'Server running at http://127.0.0.1:8124/'


