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
  
  # recent links
  $('#recents a').click (e) ->
    $('input#query').val($(this).text())
  
# show loader for turbolinks
$(document)
  .on('page:fetch', ->
    $('form#search').addClass('loading');
    $('input#query', this).prop('disabled', true);
  )
  .on('page:change', ->
    $('form#search').removeClass('loading');
    $('input#query', this).prop('disabled', false);
  )