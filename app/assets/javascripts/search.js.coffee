jQuery ->
  $('ul.clusters').masonry
    isAnimated: true
    gutterWidth: 20
    columnWidth: 300
  
  tick = (obj) ->
    $('li:first', obj).slideUp ->
      #$(this).parent().append($(this))
      $(this).appendTo($(this).parent()).slideDown()

  $('ul.tweets').each (i, tweet) ->
    setInterval ->
      tick(tweet)
    , (Math.random()+1)*10000
  
  $('ul.media img').load (event) ->
    $('ul.clusters').masonry()