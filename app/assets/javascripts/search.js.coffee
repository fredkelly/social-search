# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	# focus on search box
	$('input#query').focus().val($("input#query").val()).typeahead(
		name: 'search'
		prefetch: './search/recents.json'
		limit: 10
	)
	
	$('a.modal-link').fancybox(
    onComplete: ->
      # completed feedback
      $('form').on('ajax:success', (e, data, status, xhr) ->
        $(this).fadeOut('fast', ->
          $(this)[0].reset() # clear form
          $('#comment .success').fadeIn()
        )
      )   
  )
  $('.thumbs a').fancybox(
    type: 'image'
  )

	# retina images (hisrc patch)
	if window.devicePixelRatio >= 2
		$('img').each (i, img) ->
			if big = $(img).attr('data-2x')
				$('img').attr('src', big)

# show loader for turbolinks
$(document)
	# manually trigger loading for form(hack)
	.on('submit', 'form#search', ->
		$('body').addClass('loading')
	)
	# update search field
	.on('click', '#recents a', ->
		$('input#query').val($(this).text())
	)
	# disable input
	.on('page:fetch', ->
		$('body').addClass('loading')
		$('input#query', this).prop('disabled', true)
	)
	# load updates
	.on('page:change', ->
		$('body').removeClass('loading')
		$('input#query', this).prop('disabled', false)
	)