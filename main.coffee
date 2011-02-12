# Run this script as `coffee main.coffee`

express = require 'express'
url = require 'url'
request = require 'request'
readability = require 'readability'


app = express.createServer()

app.get '/', (req, res) ->
    res.send 'Welcome, try /readable/<url>'

app.get /^\/readable\/(.+)/, (req, res) ->
    pageUrl = req.params[0]
    if pageUrl.indexOf('http') != 0  # http URLs only
        console.log 404
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
    app.listen 8124
    console.log 'Server running at http://127.0.0.1:8124/'
