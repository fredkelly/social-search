# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('input#query').focus().val($("input#query").val())
	$('.results li a').click (e) ->
		e.preventDefault()
		window.location = $(this).data('url')
  
  # retina images
  $('img').hisrc();
  
# show loader for turbolinks
$(document)
  # update search field
  .on('click', '#recents a', ->
    $('input#query').val($(this).text())
  )
  # disable input
  .on('page:fetch', ->
    $('.results').fadeOut('slow')
    $('form#search').addClass('loading');
    $('input#query', this).prop('disabled', true);
  )
  # load updates
  .on('page:change', ->
    $('.results').fadeIn('slow')
    $('form#search').removeClass('loading');
    $('input#query', this).prop('disabled', false);
  )