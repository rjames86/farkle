allTrue = (thing) -> thing.reduce (t, s) -> t == s == true

class Game
  constructor: (@player) ->
  diceRemaining = 6
  heldDice = []
  selectedDice = []
  roundDice = []
  roundScore = 0
  currentScore = 0
  totalScore = 0
  rollingAgain = false
  player = null

  for i in [0...6]
    roundDice[i] = {}
    roundDice[i].value = i
    roundDice[i].state = 0
    roundDice[i].id = i

  rollDice: () ->
    if diceRemaining == 0
      @rollAgain()
    for i in [0...6]
      if roundDice[i].state == 0
        roundDice[i].value = Math.floor(Math.random() * 6) + 1
    return roundDice

  rollAgain: () ->
    diceRemaining = 6
    roundScore = currentScore
    currentScore = 0
    rollingAgain = true

  resetDice: () ->
    roundDice = []
    rollAgain = false
    diceRemaining = 6
    currentScore = 0
    roundScore = 0

  bank: () ->
    totalScore += currentScore + roundScore
    @resetdice()

  saveDice: () ->
    currentScore += @calculateScore()
    # @bank()

  validateSave: () ->
    # make sure the numbers being saved are okay to save
    return

  getTotalScore: () ->
    return totalScore
  getRoundScore: () ->
    return roundScore
  getCurrentScore: () ->
    return currentScore

  addSelectedDie: (die) ->
    selectedDice.push roundDice[die]
  removeSelectedDie: (die) ->
    selectedDice.slice(die, 1)

  setRoundDice: (dice) ->
    roundDice = dice

  setHeldDice: (list) ->
    for item in list
      heldDice.push(roundDice[item])
      roundDice.splice(item, 1)
    diceRemaining = diceRemaining - list.length

  isFarkle: () ->
    score = @calculateScore(true)
    allStates = (roundDice.map (i) -> i.state).reduce (t,s) -> t + s
    console.log allStates
    console.log score
    if allStates != 0
      if score == 0
        return true
    return false

  calculateScore: (farkle = false) ->
    if farkle == true
      checkState = 0
    else
      checkState = 1
    tempScore = 0
    diceNumbers =
      1: 0
      2: 0
      3: 0
      4: 0
      5: 0
      6: 0
    score = 0

    for index, dieItems of roundDice
      if dieItems.state == checkState
        die = parseInt dieItems.value
        switch die
          when 1 then diceNumbers[1]++
          when 2 then diceNumbers[2]++
          when 3 then diceNumbers[3]++
          when 4 then diceNumbers[4]++
          when 5 then diceNumbers[5]++
          when 6 then diceNumbers[6]++

    diceCounts = (value for key,value of diceNumbers)

    isStraight = allTrue(diceCounts.map (v) -> v == 1)
    isTwoTriplets = ((diceCounts.map (v) -> v == 3).filter (v) -> v == true).length == 2
    isThreePairs = ((diceCounts.map (v) -> v == 2).filter (v) -> v == true).length == 3
    isFullHouse = (4 in diceCounts and 2 in diceCounts)

    for diceNum, count of diceNumbers
      diceNum = parseInt diceNum

      if diceNum == 5 and count < 3
        score += 50*count
      if diceNum == 1 and count < 3
        score += 100*count
      if diceNum == 2 and count == 3
        score = 200
        continue
      if count == 3
        score += diceNum * 100
      if count == 4
        score += 1000
      if count == 5
        score = 2000
      if count == 6
        score = 3000

    if isStraight
      score = 1500
    if isTwoTriplets
      score = 2500
    if isThreePairs
      score = 1500
    if isFullHouse
      score = 1500
    return score

window.Game = Game
