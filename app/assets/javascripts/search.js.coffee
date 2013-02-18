# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('input#query').focus().val($("input#query").val())
	$('.result a').click (e) ->
		e.preventDefault()
		window.location = $(this).data('url')
	
	# replace retina images
	if (window.devicePixelRatio == 2)
		$('img').each (i, img) ->
			str = $(img).attr('src')
			pos = str.lastIndexOf('.')
			$(img).attr('src', str.substr(0, pos) + "@2x" + str.substr(pos)) if pos != -1
			
	# 'instant' search
	$('input#query').keyup (e) ->
		console.log "Searching..."
		
		#e.preventDefault()
		$.getJSON('./search.json', { 'query': encodeURIComponent($(this).val()) }, (results) ->
			console.log results
		)