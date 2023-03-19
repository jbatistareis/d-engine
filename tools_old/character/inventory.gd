extends VBoxContainer

var inventoryDto : InventoryDTO


func loadData(inventoryDto : InventoryDTO) -> void:
	self.inventoryDto = inventoryDto
	$identification/lblInvNameData.text = inventoryDto.name
	$identification/lblInvMoneyData.text = str(inventoryDto.money)
	
	var weapon = Persistence.loadDTO(inventoryDto.weaponShortName, Enums.EntityType.WEAPON)
	$weapon1/lblWpnNameData.text = weapon.name
	$weapon1/lnkWpnShortNameData.text = weapon.shortName
	$weapon1/lblWpnDamageData.text = str(weapon.damage)
	
	$weaponMod/lblWpnModifierDiceData.text = Enums.DiceType.keys()[weapon.modifierDice]
	$weaponMod/lblWpModifierRollData.text = Enums.DiceRollType.keys()[weapon.modifierRollType]
	$weaponMod/lblWpnModifierData.text = Enums.CharacterModifier.keys()[weapon.modifier]
	
	var armor = Persistence.loadDTO(inventoryDto.armorShortName, Enums.EntityType.ARMOR)
	$armor/lblArmNameData.text = armor.name
	$armor/lnkArmShortNameData.text = armor.shortName
	$armor/lblArmMaxIntegrityData.text = str(armor.maxIntegrity)
	
	for child in $itmWpnGrid/itemsContainer/grid.get_children():
		child.queue_free()
	for itemSn in inventoryDto.itemShortNames:
		var lbl = Label.new()
		lbl.text = itemSn
		$itmWpnGrid/itemsContainer/grid.add_child(lbl)
	
	for child in $itmWpnGrid/weaponsContainer/grid.get_children():
		child.queue_free()
	for weaponSn in inventoryDto.weaponShortNames:
		var lbl = Label.new()
		lbl.text = weaponSn
		$itmWpnGrid/weaponsContainer/grid.add_child(lbl)


func _on_lnkWpnShortNameData_pressed():
	EditorSignals.emit_signal("selectedWeapon", inventoryDto.weaponShortName)


func _on_lnkArmShortNameData_pressed():
	EditorSignals.emit_signal("selectedArmor", inventoryDto.armorShortName)


func _on_btnEditInventory_pressed():
	EditorSignals.emit_signal("selectedInventory", inventoryDto.shortName)

