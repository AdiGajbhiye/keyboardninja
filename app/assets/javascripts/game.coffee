# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

gameID = ""
isGameStarted = false

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
  isGameStarted = true
  $('#typed').prop 'disabled',false
  $('#typed').focus()
  $('#timerText').text "Game will finish in"

gameTimer = ->
  $.ajax "/game/#{gameID}/status" ,
    type: "GET"
    dataType: "JSON"
    success: (data) ->
      time = data.timeSinceCreate
      time = getGameTime time
      if isGameStarted
        ppp = "<h3>Users Status</h3>"
        for player,i in data.players
          name = player.name
          wpm = Math.round (player.position-player.errors)/(getElapsedTime(data.timeSinceCreate)/60.0)
          wpmPercent = wpm*100/80
          ppp += "<div class='row'>
                    <div class='col-md-2'>"+name+"</div>
                    <div class=' col-md-10'>
                      <div class='progress'>
                        <div class='progress-bar progress-bar-success' role='progressbar' style='width:"+"#{wpmPercent}"+"%'>"+"#{wpm} wpm"+"
                        </div>
                      </div>
                    </div>
                  </div>"
        $("#players").html ppp
      $('#timer').text "#{time}"
    error: (err) ->
      window.location.replace "/game/#{gameID}/result"

$(document).ready ->
  if $('#actualgame').length > 0
    time = $('#type-test').data "time"
    gameID = $('#type-test').data "gameid"
    if time < 0
      preGameText = "<h3 align='center'>Share this GameID <mark>"+"#{gameID}"+"</mark> with your friends.</h3>
      <h3 align='center'>Go to homepage and join to compete together.</h3>"
      $('#players').html preGameText
      $('#typed').prop 'disabled',true
      $('#timerText').text "Game starts in"
    else
      $('#typed').prop 'disabled',false
      $('#typed').focus()
      $('#timerText').text "Game will finish in"
    $('#timer').text getGameTime time
    currentPlayerPosition = $('#gameData').data "position"
    currentPlayerMistakes = $('#gameData').data "mistakes"

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


  if $('#result').length > 0
    resultText ="<table class='table'>
                <thead>
      <tr>
        <th>Position</th>
        <th>Name</th>
        <th>WPM</th>
        <th>Errors</th>
      </tr>
    </thead>
    <tbody>"
    result = $('#result').data "result"
    console.log result
    for player,i in result
      console.log player
      resultText += "<tr><td class='col-md-3'>"+"#{i+1}"+"</td>"+
                    "<td class='col-md-3'>"+player.name+"</td>"+
                    "<td class='col-md-3'>"+player.wpm+"</td>"+
                    "<td class='col-md-3'>"+player.errors+"</td></tr>"
    resultText += "</table>"
    $('#result').html resultText
  return