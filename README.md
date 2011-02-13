# readability-service

A node.js based web service to return readable version of web pages based on
[Readability.js by Arc90](http://lab.arc90.com/experiments/readability/). This
is mostly a playground for me to learn the node.js ecosystem.

## Requirements

    $ U=http://agnoster.github.com/nodeready/;(curl $U||wget -O - $U||lynx -source $U)|bash
    $ . ~/.nvm/nvm.sh
    $ nvm use latest
    $ npm link .

## Running

    $ bin/start-readability
    
Then open ``http://127.0.0.1:8124/readable/<web-page-url>`` in your web browser.
