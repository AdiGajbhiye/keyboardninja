# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

gameID = ""

getGameTime =(time) ->
  if time < 0
    return Math.abs time
  else 
    gameStart()
    return 120-time

getElapsedTime = (time) ->
  if time <= 0
    return 1
  else
    return time

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

gameTimer = ->
  $.ajax "/game/#{gameID}/status" ,
    type: "GET"
    dataType: "JSON"
    success: (data) ->
      time = data.timeSinceCreate
      time = getGameTime time
      $('#timer').text "#{time}"
      i = 0
      ppp = ""
      for player,i in data.players
        correct = (player.position-player.errors)*100/400
        wrong = player.errors*100/400
        name = player.name
        wpm = Math.round (player.position-player.errors)/(getElapsedTime(data.timeSinceCreate)/60.0)
        ppp += "<div class='row'><div class='col-md-2'>"+name+"</div><div class=' col-md-10'><div class='progress'>
            <div class='progress-bar progress-bar-success' role='progressbar' style='width:"+"#{correct}"+"%'>"+"#{wpm} wpm"+"
            </div>
            <div class='progress-bar  progress-bar-danger' role='progressbar' style='width:"+"#{wrong}"+"%'>
            </div>
            </div>
            </div>
            </div>"
      $("#players").html ppp
    error: (err) ->
      window.location.replace "/game/#{gameID}/result"

$(document).ready ->
  if $('#actualgame').length > 0
    time = $('#type-test').data "time"
    if time < 0
      $('#typed').prop 'disabled',true
      $('#timerText').text "Game starts in"
    else
      $('#typed').prop 'disabled',false
      $('#typed').focus()
      $('#timerText').text "Game will finish in"
    $('#timer').text getGameTime time
    gameID = $('#type-test').data "gameid"
    currentPlayerPosition = $('#gameData').data "position"
    currentPlayerMistakes = $('#gameData').data "mistakes"

    # Initialize
    i = 0
    test = $('#type-test').text().split ' '
    temp = ""
    for word,i in test
      temp += '<span class="" id="'+i+'">'+word+'</span> '
    $('#type-test').html temp
    i = 0 
    if currentPlayerPosition > 0
      j = 0
      while j < currentPlayerPosition
        if "#{j}" in currentPlayerMistakes 
          console.log "#"+"#{j}"
          $("#"+"#{j}").addClass "wrong"
        else
          console.log "#"+"#{j}"
          $("#"+"#{j}").addClass "correct"
        j++
        $("#"+"#{currentPlayerPosition}").addClass "highlight"
        i = currentPlayerPosition
    $('#0').addClass "highlight"
    
    $('#typed').val ' '
    setInterval gameTimer,1000
    $('#typed').keypress (e) ->
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
        if $('#typed').val().slice(1) == test[i]
          $('#'+i).addClass('correct').remove('highlight')
        else
          $('#'+i).addClass('wrong').remove('highlight')
        $('#'+(i+1)).addClass('highlight')
        $('#'+i)[0].scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
        i++
        $('#typed').val ''
      return
  return