var http            = require('http'),
    url             = require('url'),
    readability     = require('./node-readability/lib/readability.js')
;


http.createServer(function(req, res){
    res.writeHead(200, {'Content-Type': 'text/html'});

    var remoteURL = url.parse(req.url.substr(1));

    if (remoteURL.protocol != 'http:')
        return; // prevent other requests (eg: /favicon.ico)

    // Fetch the requested URL
    console.log("Connecting to: " + remoteURL.host);
    var remote = http.createClient(80, remoteURL.host);
    var remoteReq = remote.request(
        'GET', remoteURL.pathname + (remoteURL.search || ''), {
            'host': remoteURL.host,
    });
    remoteReq.end();
    remoteReq.on('response', function(remoteRes){
        console.log('STATUS: ' + remoteRes.statusCode);
        console.log('HEADERS: ' + JSON.stringify(remoteRes.headers));
        remoteRes.setEncoding('utf8');
        var body = '';
        remoteRes.on('data', function(chunk){
            body += chunk;
        });
        remoteRes.on('end', function(){
            console.log('Retrieved full page');
            // Parse HTML using readability
            readability.parse(body, url.format(remoteURL), function(d){
                console.log('Parse complete.');
                res.write('<title>' + d.title + '</title>');
                res.write(d.content);
                res.end();
                console.log('Closed request');
            });
        });
    });

    // http://rentzsch.tumblr.com/post/664884799/
    remote.on('error', function(connectionException){
        if (connectionException.errno === process.ECONNREFUSED) {
            console.log('ECONNREFUSED: connection refused to '
                        +remote.host
                        +':'
                        +remote.port);
        } else {
            console.log(connectionException);
        }
        res.end();
    })
    ;
}).listen(8124, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8124/');


