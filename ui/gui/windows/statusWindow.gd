class_name StatusWindow
extends GuiWindow

const TEXT : String = ' |[ |%s| ]| >HP|%d/%d>LV|%d|[next: %d/%d]>Spare pts.|%d>  |-| |-| |-| |-| |-|  >Strength|%d>Dexterity|%d>Constitution|%d>Intelligence|%d>Wisdom|%d>Charisma|%d'


func _init() -> void:
	var player = LocationManager.player if (LocationManager.player != null) else Character.new()
	
	type = Enums.GuiWindowType.BACKGROUND
	widgets.append(GuiTextWidget.new(TEXT % [player.name, player.currentHp, player.maxHp, player.currentLevel, player.experiencePoints, player.experienceToNextLevel, player.sparePoints, player.strength.score, player.dexterity.score, player.constitution.score, player.intelligence.score, player.wisdom.score, player.charisma.score]))
	
	position = Vector2(25, GuiOverlayManager.windowSize().y / 2 - 141)

