# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
$(document).ready ->
  test = $('#type-test').text().split ' '
  temp = ""
  for word,i in test
     temp += '<span class="" id="'+i+'">'+word+'</span> '
  $('#type-test').html temp
  $('#0').addClass "highlight"
  i = 0
  $('#typed').val ' '
  $('#typed').keypress (e) ->
    console.log i
    if e.key == " "
      console.log $('#typed').val().slice(1)
      console.log test[i]
      if $('#typed').val().slice(1) == test[i]
        $('#'+i).addClass('correct').remove('highlight')
      else
        $('#'+i).addClass('wrong').remove('highlight')
      $('#'+(i+1)).addClass('highlight')
      i++
      $('#typed').val ''
    return
  return