class Player
  constructor: (@name) ->

  currentRoll = []
  totalScore = []
  roundScore = 0
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

  setRoundScore: (score) ->
    roundScore = score
  addRoundScore: (score) ->
    roundScore += score
  removeRoundScore: (score) ->
    roundScore -= score
  getRoundScore: () ->
    return roundScore

  setTempScore: (score) ->
    tempScore = score
  addTempScore: (score) ->
    tempScore += score
  getTempScore: (score) ->
    return tempScore

  saveRound: () ->
    @setRoundScore(roundScore)
    @setTempScore(0)
    @setTurn(false)

window.Player = Player
