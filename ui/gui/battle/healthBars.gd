extends MarginContainer

var character : Character

func _ready() -> void:
	Signals.connect("armorChangedIntegrity",Callable(self,"armorBarChange"))
	Signals.connect("characterChangedHp",Callable(self,"hpBarChange"))
	Signals.connect("characterChangedExtraHp",Callable(self,"extraHpBarChange")) # necessary?
	
	$armor.value = 0 if (character.inventory.armor == null) else (character.inventory.armor.currentIntegrity * 100.0 / character.inventory.armor.maxIntegrity)
	$hp.value = character.currentHp * 100.0 / character.maxHp


func armorBarChange(armor : Armor, amount : int) -> void:
	if armor == character.inventory.armor:
		barChange($armorTween, $armor, armor.currentIntegrity * 100.0 / armor.maxIntegrity)


func hpBarChange(character : Character, amount : int) -> void:
	if character == self.character:
		barChange($hpTween, $hp, character.currentHp * 100.0 / character.maxHp)


func barChange(tween : Tween, bar : ProgressBar, end : float) -> void:
	tween.remove_all()
	tween.interpolate_property(bar, "value", bar.value, end, 0.25)
	tween.start()

