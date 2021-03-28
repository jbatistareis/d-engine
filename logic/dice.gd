class_name Dice


# use Dice.Type enum
static func rollNormal(type : int, modifier : int = 0) -> int:
	return RandomNumberGenerator.new().randi_range(1, type) + modifier

# use Dice.Type enum
static func rollBest(type : int, modifier : int = 0) -> int:
	return max(rollNormal(type, modifier), rollNormal(type, modifier)) as int

# use Dice.Type enum
static func rollWorst(type : int, modifier : int = 0) -> int:
	return min(rollNormal(type, modifier), rollNormal(type, modifier)) as int

# returns Dice.Outcome enum
static func getOutcome(value : int, modifier : int = 0) -> int:
	value += modifier
	
	if (value >= 10):
		return Enums.DiceOutcome.BEST
	elif ((value >= 7) && (value <= 9)):
		return Enums.DiceOutcome.WITH_CONSEQUENCE
	else:
		return Enums.DiceOutcome.WORST

