# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

oneMinute = 10000
correctWords = 0
wrongWords = 0
j = 0
gameBufferTime = 1   # in minutes
gamePlayTime = 1     # in minutes
gameStart = ->
  $('#typed').prop 'disabled',false
  $('#typed').focus()
  $('#timer').text "#{gamePlayTime*oneMinute/1000}"
  j = 0
  $('#timerText').text "Game will finish in"

gameFinish = ->
  $('#typed').prop 'disabled',true
  $.ajax "/game/#{gameID}" ,
        type: "GET",
        dataType: "JSON",
        success: (data) ->
          console.log data
  console.log correctWords
  console.log wrongWords

gameTimer = ->
  j++
  $('#timer').text "#{(gameBufferTime*oneMinute/1000)-j}"

$(document).ready ->
  test = $('#type-test').text().split ' '
  temp = ""
  for word,i in test
     temp += '<span class="" id="'+i+'">'+word+'</span> '
  $('#type-test').html temp
  $('#0').addClass "highlight"
  i = 0
  $('#typed').val ' '
  $('#timer').text "#{gameBufferTime*oneMinute/1000}"
  $('#typed').prop 'disabled',true
  setTimeout gameStart,gameBufferTime*oneMinute
  setTimeout gameFinish,(gameBufferTime+gamePlayTime)*oneMinute
  setInterval gameTimer,1000
  gameID = window.location.pathname.slice 6
  console.log gameID
  $('#typed').keypress (e) ->
    console.log i
    if e.key == " "
      gameData = {
        typedWord: $('#typed').val().slice(1),
        postion: i
      }
      $.ajax "/game/#{gameID}" ,
        type: "PATCH",
        dataType: "JSON",
        data: gameData,
        success: (data) ->
          console.log data
      if $('#typed').val().slice(1) == test[i]
        $('#'+i).addClass('correct').remove('highlight')
        correctWords++
      else
        $('#'+i).addClass('wrong').remove('highlight')
        wrongWords++
      $('#'+(i+1)).addClass('highlight')
      i++
      $('#typed').val ''
    return
  return