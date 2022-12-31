extends MarginContainer

const _STATUS_NAME : String = "[center][ %s ][/center]"
const _STATUS_VALUE_1 : String = "[right]%d/%d [/right][right]%d [/right][right]%d/%d [/right][right]%d [/right]"
const _STATUS_VALUE_2 : String = "[right]%d [/right][right]%d [/right][right]%d [/right]"
const _ARMOR_VALUES : String = "[right]%d/%d [/right][right]+%d%%/-%d%% [/right]"


func setCharacter(character : Character) -> void:
	$vContainer/lblName.bbcode_text = _STATUS_NAME % character.name
	
	$vContainer/stats1/lblValues1.bbcode_text = _STATUS_VALUE_1 % [
		character.currentHp,
		character.maxHp,
		character.currentLevel,
		character.experiencePoints,
		character.experienceToNextLevel,
		character.sparePoints,
	]
	
	if character.inventory.armor == null:
		$vContainer/armor/lblArmorValues.bbcode_text = _ARMOR_VALUES % [0, 0, 0, 0]
	else:
		$vContainer/armor/lblArmorValues.bbcode_text = _ARMOR_VALUES % [
			character.inventory.armor.currentIntegrity,
			character.inventory.armor.maxIntegrity,
			character.inventory.armor.positiveScale * 100,
			character.inventory.armor.negativeScale * 100
		]
	
	$vContainer/stats2/lblValues2.bbcode_text = _STATUS_VALUE_2 % [
		character.getScore(Enums.CharacterAbility.STRENGTH),
		character.getScore(Enums.CharacterAbility.DEXTERITY),
		character.getScore(Enums.CharacterAbility.CONSTITUTION)
	]
	
	$vContainer/lblName.bbcode_enabled = true
	$vContainer/stats1/lblValues1.bbcode_enabled = true
	$vContainer/armor/lblArmorValues.bbcode_enabled = true
	$vContainer/stats2/lblValues2.bbcode_enabled = true

