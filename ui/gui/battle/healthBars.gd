extends MarginContainer

var character : Character


func _ready() -> void:
	Signals.armorChangedIntegrity.connect(armorBarChange)
	Signals.characterChangedHp.connect(hpBarChange)
#	Signals.characterChangedExtraHp.connect(extraHpBarChange) # necessary?
	
	$armor.value = 0 if (character.inventory.armor == null) else (character.inventory.armor.currentIntegrity * 100.0 / character.inventory.armor.maxIntegrity)
	$hp.value = character.currentHp * 100.0 / character.maxHp


func armorBarChange(armor : Armor, _amount : int) -> void:
	if armor == character.inventory.armor:
		barChange($armor, armor.currentIntegrity * 100.0 / armor.maxIntegrity)


func hpBarChange(character : Character, _amount : int) -> void:
	if character == self.character:
		barChange($hp, character.currentHp * 100.0 / character.maxHp)


func barChange(bar : ProgressBar, end : float) -> void:
	var tween = create_tween()
	tween.remove_all()
	tween.tween_property(bar, "value", end, 0.25)
	tween.play()

