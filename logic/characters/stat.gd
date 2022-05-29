class_name Stat

var score : int
var modifier : int setget ,getModifier

var canIncrease : bool setget ,getCanIncrease
var canDecrease : bool setget ,getCanDecrease


func _init(score : int) -> void:
	self.score = score


func getModifier() -> int:
	if score <= 3:
		return -3
	elif (score >= 4) && (score <= 5):
		return -2
	elif (score >= 6) && (score <= 8):
		return -1
	elif (score >= 9) && (score <= 12):
		return 0
	elif (score >= 13) && (score <= 15):
		return 1
	elif (score >= 16) && (score <= 17):
		return 2
	
	# elif (score >= 18):
	return 3


func getCanIncrease() -> bool:
	return score < 20


func getCanDecrease() -> bool:
	return score > 1


func increase() -> void:
	if self.canIncrease:
		score += 1


func decrease() -> void:
	if self.canDecrease:
		score -= 1

