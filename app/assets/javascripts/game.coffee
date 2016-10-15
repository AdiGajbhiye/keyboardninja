# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

gameID = ""

getGameTime =(time) ->
  if time < 0
    return Math.abs time
  else 
    return 10-time

gameStart = ->
  $('#typed').prop 'disabled',false
  $('#typed').focus()
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
  $.ajax "/game/#{gameID}/status" ,
    type: "GET"
    dataType: "JSON"
    success: (data) ->
      console.log data.timeSinceCreate
      time = data.timeSinceCreate
      time = getGameTime time
      $('#timer').text "#{time}"
    error: (err) ->
      window.location.replace "/game/#{gameID}/result"

$(document).ready ->
  if $('#actualgame').length > 0
    time = $('#type-test').data "time"
    time = Math.abs time
    console.log time
    gameID = $('#type-test').data "gameid"
    console.log gameID
    # Initialize
    test = $('#type-test').text().split ' '
    temp = ""
    for word,i in test
      temp += '<span class="" id="'+i+'">'+word+'</span> '
    $('#type-test').html temp
    $('#0').addClass "highlight"
    i = 0
    $('#typed').val ' '
    $('#timer').text "#{time}"
    $('#typed').prop 'disabled',true
    setTimeout gameStart,time*1000
    setInterval gameTimer,1000
    $('#typed').keypress (e) ->
      console.log i
      if e.key == " "
        gameData = {
          typedWord: $('#typed').val().slice(1),
          position: i
        }
        $.ajax "/game/#{gameID}" ,
          type: "PATCH",
          dataType: "JSON",
          data: gameData,
          success: (data) ->
            console.log data
        if $('#typed').val().slice(1) == test[i]
          $('#'+i).addClass('correct').remove('highlight')
        else
          $('#'+i).addClass('wrong').remove('highlight')
        $('#'+(i+1)).addClass('highlight')
        i++
        $('#typed').val ''
      return
  return