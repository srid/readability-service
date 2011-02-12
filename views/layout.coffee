doctype 5
html ->
  head ->
    meta charset: 'utf-8'

    title "#{tit} | Readability Service"

    link rel: 'stylesheet', href: '/readability.css'
    link rel: 'stylesheet', href: '/site.css'

  body ->
    div id: 'content', ->
      @body
