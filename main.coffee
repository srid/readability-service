express = require 'express'
url = require 'url'
request = require 'request'
readability = require 'readability'


readable = (pageUrl, cb) ->
    # TODO: use mongodb as cache
    # TODO: spread requests to same domain in single HTTP conn
    console.log "Page: #{pageUrl}"
    request {uri: pageUrl, encoding: 'utf-8'}, (error, response, body) ->
        if not error and response.statusCode is 200
            readability.parse body, pageUrl, (d) ->
                console.log "Parse complete for #{d.title}"
                cb(d)
        else
            throw error


# Express web app
# ###############

app = express.createServer()
app.register '.coffee', require('coffeekup')
app.set 'view engine', 'coffee'  # not being used yet
app.configure () ->
    app.use express.staticProvider("#{__dirname}/static")


app.get '/', (req, res) ->
    res.send 'Welcome, try /readable/$url'

app.get /^\/readable\/(.+)/, (req, res) ->
    pageUrl = req.params[0]
    if pageUrl.indexOf('http') != 0  # http URLs only
        res.send 404
        return

    readable pageUrl, (d) ->
        res.end JSON.stringify(d)


exports.run = () ->
    app.listen 8124
    console.log 'Server running at http://127.0.0.1:8124/'
