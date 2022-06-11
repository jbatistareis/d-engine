class_name StatusWindow
extends GuiWindow

const TEXT : String = ' |[ |%s| ]| >HP|%d/%d>LV|%d|[next: %d/%d]>Spare pts.|%d>  |-| |-| |-| |-| |-|  >Strength|%d>Dexterity|%d>Constitution|%d>Intelligence|%d>Wisdom|%d>Charisma|%d'


func _init() -> void:
	type = Enums.GuiWindowType.BACKGROUND
	widgets.append(GuiTextWidget.new(TEXT % [
		GameManager.player.name,
		GameManager.player.currentHp,
		GameManager.player.maxHp,
		GameManager.player.currentLevel,
		GameManager.player.experiencePoints,
		GameManager.player.experienceToNextLevel,
		GameManager.player.sparePoints,
		GameManager.player.strength.score,
		GameManager.player.dexterity.score,
		GameManager.player.constitution.score,
		GameManager.player.intelligence.score,
		GameManager.player.wisdom.score,
		GameManager.player.charisma.score
	]))
	
	position = Vector2(25, GuiOverlayManager.currentSize.y / 2 - 141)

