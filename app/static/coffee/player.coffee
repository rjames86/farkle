class Player
  constructor: (@name) ->

  currentRoll = []
  totalScore = []
  tempScore = 0
  isTurn = false

  getName: () ->
    @name

  setTotalScore: (amount) ->
    totalScore = amount
  getTotalScore: () ->
    return totalScore

  setTurn: (t) ->
    isTurn = t
    console.log "#{@name} turn is now #{isTurn}"
  isTurn: () ->
    return isTurn


  setTempScore: (score) ->
    tempScore = score
  addTempScore: (score) ->
    tempScore += score
  getTempScore: (score) ->
    return tempScore

  saveRound: () ->
    @setTempScore(0)
    @setTurn(false)

window.Player = Player
