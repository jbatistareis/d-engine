extends MarginContainer

const _TIME : float = 0.30

var character : Character
var armorTween : Tween
var hpTween : Tween


func _ready() -> void:
	Signals.armorChangedIntegrity.connect(armorBarChange)
	Signals.characterChangedHp.connect(hpBarChange)
#	Signals.characterChangedExtraHp.connect(extraHpBarChange) # necessary?
	
	$armor.value = 0 if (character.inventory.armor == null) else (character.inventory.armor.currentIntegrity * 100.0 / character.inventory.armor.maxIntegrity)
	$hp.value = character.currentHp * 100.0 / character.maxHp


func armorBarChange(armor : Armor, _amount : int) -> void:
	if armor == character.inventory.armor:
		if armorTween:
			armorTween.kill()
		
		armorTween = create_tween()
		armorTween.tween_property($armor, "value", armor.currentIntegrity * 100.0 / armor.maxIntegrity, _TIME)


func hpBarChange(character : Character, _amount : int) -> void:
	if character == self.character:
		if hpTween:
			hpTween.kill()
		
		hpTween = create_tween()
		hpTween.tween_property($hp, "value", character.currentHp * 100.0 / character.maxHp, _TIME)

