# readability-service
A node.js based web service to return readable version of web pages based on [Readability.js by Arc90](http://lab.arc90.com/experiments/readability/) 

## Requirements

    $ # http://agnoster.github.com/nodeready/
    $ U=http://agnoster.github.com/nodeready/;(curl $U||wget -O - $U||lynx -source $U)|bash
    $ nvm use latest
    $ npm install readability
    $ npm install coffee
    $ npm install request    
    $ npm install express

## Running

    $ bin/start-readability
    
Then open ``http://127.0.0.1:8124/readable/<web-page-url>`` in your web browser.
