# Run this script as `coffee main.coffee`

http = require 'http'
url = require 'url'
readability = require 'readability'


server = http.createServer (req, res) ->
    res.writeHead 200, {'Content-Type': 'text/html'}

    remoteURL = url.parse (req.url.substr 1)
    return if remoteURL.protocol != 'http:'

    # Fetch the requested URL
    console.log 'Connecting to: ' + remoteURL.host
    remote = http.createClient 80, remoteURL.host
    remotePath = remoteURL.pathname + (remoteURL.search || '')
    remoteReq = remote.request 'GET', remotePath, {host: remoteURL.host}
    remoteReq.end()

    remoteReq.on 'response', (remoteRes) ->
        console.log 'STATUS: ' + remoteRes.statusCode
        console.log 'HEADERS: ' + JSON.stringify(remoteRes.headers)
        remoteRes.setEncoding 'utf8'
        body = ''
        remoteRes.on 'data', (chunk) ->
            body += chunk
        remoteRes.on 'end', () ->
            console.log 'Retrieved full page'
            # Parse HTML using readability
            readability.parse body, url.format(remoteURL), (d) ->
                console.log 'Parse complete.'
                res.write '<title>' + d.title + '</title>'
                res.end d.content
                console.log 'Closed request'

    # http://rentzsch.tumblr.com/post/664884799/
    remote.on 'error', (connectionException) ->
        if connectionException.errno == process.ECONNREFUSED
            console.log 'ECONNREFUSED: connection refused to ' \
                        +remote.host \
                        +':' \
                        +remote.port
        else
            console.log connectionException
        res.end()

exports.run = () ->
    server.listen 8124, '127.0.0.1'
    console.log 'Server running at http://127.0.0.1:8124/'


