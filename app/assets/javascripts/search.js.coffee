# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	# focus on search box
	$('input#query').focus().val($("input#query").val())
	
	# track result clicks
#	$('.results li a').click (e) ->
#		e.preventDefault()
#		window.location = $(this).data('url')
	
	# retina images
	$('img').hisrc()
	
	# show modals
	$('a[rel=modal]').click (e) ->
		e.preventDefault()
		$('.modal#' + $(this).data('modal')).fadeIn()
  
  # auto-close modals
  $('.modal *[rel=close]').click (e) ->
    $(this).parents('.modal').fadeOut()
  
  # completed feedback
  $('#comment form').on('ajax:success', (e, data, status, xhr) ->
    $(this).fadeOut('fast', ->
      $(this)[0].reset() # clear form
      $('#comment .success').fadeIn()
    )
  )
 	
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