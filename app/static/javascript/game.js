// Generated by CoffeeScript 1.8.0
(function() {
  var Game, allTrue,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  allTrue = function(thing) {
    return thing.reduce(function(t, s) {
      return (t === s && s === true);
    });
  };

  Game = (function() {
    var currentScore, diceRemaining, heldDice, i, player, rollingAgain, roundDice, roundScore, selectedDice, totalScore, _i;

    function Game(player) {
      this.player = player;
    }

    diceRemaining = 6;

    heldDice = [];

    selectedDice = [];

    roundDice = [];

    roundScore = 0;

    currentScore = 0;

    totalScore = 0;

    rollingAgain = false;

    player = null;

    for (i = _i = 0; _i < 6; i = ++_i) {
      roundDice[i] = {};
      roundDice[i].value = i;
      roundDice[i].state = 0;
      roundDice[i].id = i;
    }

    Game.prototype.rollDice = function() {
      var _j;
      if (diceRemaining === 0) {
        this.rollAgain();
      }
      for (i = _j = 0; _j < 6; i = ++_j) {
        if (roundDice[i].state === 0) {
          roundDice[i].value = Math.floor(Math.random() * 6) + 1;
        }
      }
      return roundDice;
    };

    Game.prototype.rollAgain = function() {
      diceRemaining = 6;
      roundScore = currentScore;
      currentScore = 0;
      return rollingAgain = true;
    };

    Game.prototype.resetDice = function() {
      var rollAgain;
      roundDice = [];
      rollAgain = false;
      diceRemaining = 6;
      currentScore = 0;
      return roundScore = 0;
    };

    Game.prototype.bank = function() {
      totalScore += currentScore + roundScore;
      return this.resetdice();
    };

    Game.prototype.saveDice = function() {
      return currentScore += this.calculateScore();
    };

    Game.prototype.validateSave = function() {};

    Game.prototype.getTotalScore = function() {
      return totalScore;
    };

    Game.prototype.getRoundScore = function() {
      return roundScore;
    };

    Game.prototype.getCurrentScore = function() {
      return currentScore;
    };

    Game.prototype.addSelectedDie = function(die) {
      return selectedDice.push(roundDice[die]);
    };

    Game.prototype.removeSelectedDie = function(die) {
      return selectedDice.slice(die, 1);
    };

    Game.prototype.setRoundDice = function(dice) {
      return roundDice = dice;
    };

    Game.prototype.setHeldDice = function(list) {
      var item, _j, _len;
      for (_j = 0, _len = list.length; _j < _len; _j++) {
        item = list[_j];
        heldDice.push(roundDice[item]);
        roundDice.splice(item, 1);
      }
      return diceRemaining = diceRemaining - list.length;
    };

    Game.prototype.isFarkle = function() {
      var allStates, score;
      score = this.calculateScore(true);
      allStates = (roundDice.map(function(i) {
        return i.state;
      })).reduce(function(t, s) {
        return t + s;
      });
      console.log(allStates);
      console.log(score);
      if (allStates !== 0) {
        if (score === 0) {
          return true;
        }
      }
      return false;
    };

    Game.prototype.calculateScore = function(farkle) {
      var checkState, count, diceCounts, diceNum, diceNumbers, die, dieItems, index, isFullHouse, isStraight, isThreePairs, isTwoTriplets, key, score, tempScore, value;
      if (farkle == null) {
        farkle = false;
      }
      if (farkle === true) {
        checkState = 0;
      } else {
        checkState = 1;
      }
      tempScore = 0;
      diceNumbers = {
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0
      };
      score = 0;
      for (index in roundDice) {
        dieItems = roundDice[index];
        if (dieItems.state === checkState) {
          die = parseInt(dieItems.value);
          switch (die) {
            case 1:
              diceNumbers[1]++;
              break;
            case 2:
              diceNumbers[2]++;
              break;
            case 3:
              diceNumbers[3]++;
              break;
            case 4:
              diceNumbers[4]++;
              break;
            case 5:
              diceNumbers[5]++;
              break;
            case 6:
              diceNumbers[6]++;
          }
        }
      }
      diceCounts = (function() {
        var _results;
        _results = [];
        for (key in diceNumbers) {
          value = diceNumbers[key];
          _results.push(value);
        }
        return _results;
      })();
      isStraight = allTrue(diceCounts.map(function(v) {
        return v === 1;
      }));
      isTwoTriplets = ((diceCounts.map(function(v) {
        return v === 3;
      })).filter(function(v) {
        return v === true;
      })).length === 2;
      isThreePairs = ((diceCounts.map(function(v) {
        return v === 2;
      })).filter(function(v) {
        return v === true;
      })).length === 3;
      isFullHouse = __indexOf.call(diceCounts, 4) >= 0 && __indexOf.call(diceCounts, 2) >= 0;
      for (diceNum in diceNumbers) {
        count = diceNumbers[diceNum];
        diceNum = parseInt(diceNum);
        if (diceNum === 5 && count < 3) {
          score += 50 * count;
        }
        if (diceNum === 1 && count < 3) {
          score += 100 * count;
        }
        if (diceNum === 2 && count === 3) {
          score = 200;
          continue;
        }
        if (count === 3) {
          score += diceNum !== 1 ? diceNum * 100 : 300;
        }
        if (count === 4) {
          score += 1000;
        }
        if (count === 5) {
          score = 2000;
        }
        if (count === 6) {
          score = 3000;
        }
      }
      if (isStraight) {
        score = 1500;
      }
      if (isTwoTriplets) {
        score = 2500;
      }
      if (isThreePairs) {
        score = 1500;
      }
      if (isFullHouse) {
        score = 1500;
      }
      return score;
    };

    return Game;

  })();

  window.Game = Game;

}).call(this);
