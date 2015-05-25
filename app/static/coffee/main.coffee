d = React.DOM

Width = React.createClass
  getInitialState: () ->
    width: window.innerWidth

  handleResize: (e) ->
    @setState width: window.innerWidth

  handleClick: (e) ->
    console.log "clicky clicky"

  componentDidMount: () ->
    window.addEventListener "resize", @handleResize
    window.addEventListener "click", @handleClick

  render: () ->
    d.p {}, @state.width



DiceView = React.createClass
  getInitialState: () ->
    dice = []
    for i in [0...6]
      dice[i] = {}
      dice[i].value = i + 1
      dice[i].state = 0
      dice[i].id = i

    return {
      dice: dice
      heldDice: []
      rollScore: 0
      totalScore: 0
      roundScore: 0
      selectedDice: []
      canSelect: false
      farkled: false
    }

  selectDice: (override = false) ->
    # Allow the user to select the dice
    if not @state.canSelect
      console.log "now can select"
      $('img').removeClass("more-faded").removeClass('faded')
      $('img').on "click", @imageClick
      @setState canSelect: true
    if override
      $('img').off "click", @imageClick

  farkled: () ->
    @setState
      rollScore: @props.player.setTempScore(0)
      roundScore: 0
      farkled: true
    @resetDice()
    @selectDice(true)
    @setState canSelect: false

  checkCalculated: () ->
    for index, items of @state.dice
      if items.state == 1
        console.log "setting to -1"
        @setDiceState(index, -1)
        $("#die#{items.id}").off "click", @imageClick

  resetDice: () ->
    for index, items of @state.dice
      @setDiceState(index, 0)
      $("#die#{items.id}").removeClass("faded").addClass("more-faded")
    @selectDice(true)

  setDiceState: (index, state) ->
    currentDice = @state.dice
    currentDice[index].state = state
    @setState dice: currentDice

  imageClick: (e) ->
    console.log "click"
    selectedIndex = $(e.target).data "number"
    $(e.target).toggleClass("faded");
    currentDice = @state.dice
    rollScore = @state.rollScore
    if currentDice[selectedIndex].state in [0,1]
      @setDiceState(selectedIndex, if currentDice[selectedIndex].state == 0 then 1 else 0)

    score = @props.game.calculateScore()
    @setState rollScore: @props.player.setTempScore(score)


  updateDice: () ->
    @checkCalculated()
    currentRoundScore = @state.roundScore
    @setState
      farkled: false
      roundScore: currentRoundScore + @props.player.getTempScore()
      rollScore: @props.player.setTempScore(0)
      dice: @props.game.rollDice()
    @selectDice()

    if @props.game.isFarkle()
      console.log "farkled!"
      @farkled()

  saveDice: () ->
    roundScore = @state.roundScore
    currentTotalScore = @state.totalScore
    currentRollScore = @state.rollScore
    @setState
      roundScore: 0
      rollScore: @props.player.setTempScore(0)
      canSelect: false
      totalScore: currentTotalScore + roundScore + currentRollScore
    @resetDice()

  authDropbox: (e) ->
    e.preventDefault();
    dbclient.authenticate(updateAuthenticationStatus);


  render: () ->
    d.div {},
      d.p {}, "Hello there"
      d.p {}, "Round Score: #{@state.roundScore}"
      d.p {}, "This Roll: #{@state.rollScore}"
      d.p {}, "Total Score: #{@state.totalScore}"
      d.div {className: "row"},
        for index, items of @state.dice
          d.div { className: "col-md-1 col-xs-3"},
            d.img {src: "/static/images/#{items.value}.png", "data-number": "#{index}", id: "die#{items.id}"}
      if @state.farkled
        d.h2 {}, "Farkled!!"
      d.div {className: "btn-group btn-group-justified", role:"group"},
          d.div { className: "btn-group", role:"group"},
            d.button {type:"button", className: "btn btn-default", onClick: @updateDice}, "Roll"
            d.button {type:"button", className: "btn btn-default", onClick: @saveDice}, "Save"
            if not dbclient.isAuthenticated()
              d.button {type:"button", className: "btn btn-default", onClick: @authDropbox}, "Login"


Page = React.createClass
  getInitialState: () ->
    player = @getPlayer("Ryan")
    game = @getGame(player)

    return {
      player: player
      game: game
    }

  getPlayer: (name) ->
    return new Player(name)

  getGame: (p) ->
    return new Game(p)

  render: () ->
    DiceView({game: @state.game, player: @state.player})

$ ->
  React.render(
    Page({}),
    document.getElementById('container')
    )

