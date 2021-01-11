extends Node

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# use Dice.Type enum
func rollNormal(type : int, modifier : int = 0) -> int:
	rng.randomize()
	return rng.randi_range(1, type) + modifier

# use Dice.Type enum
func rollBest(type : int, modifier : int = 0) -> int:
	return max(rollNormal(type, modifier), rollNormal(type, modifier)) as int

# use Dice.Type enum
func rollWorst(type : int, modifier : int = 0) -> int:
	return min(rollNormal(type, modifier), rollNormal(type, modifier)) as int

# returns Dice.Outcome enum
func getOutcome(value : int, modifier : int = 0) -> int:
	value += modifier
	
	if (value >= 10):
		return Enums.DiceOutcome.BEST
	elif ((value >= 7) && (value <= 9)):
		return Enums.DiceOutcome.WITH_CONSEQUENCE
	else:
		return Enums.DiceOutcome.WORST

