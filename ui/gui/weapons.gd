extends MarginContainer

const _AMOUNT_MASK : String = "x%d"
const _EQUIPED_MASK : String = "[E]"
const _NOT_EQUIPED_MASK : String = ""
const _WEAPON_STATS_MASK_MAIN : String = "[center][ %s ]%s[/center][table=5][cell][center]STA[/center][/cell][cell][center]DMG[/center][/cell][cell][center]CRT[/center][/cell][cell][center]CLV[/center][/cell][cell][center]CD (base)[/center][/cell][cell][center]%s[/center][/cell][cell][center]%d[/center][/cell][cell][center]%s[/center][/cell][cell][center]%s[/center][/cell][cell][center]%0.2fs/%0.2fs[/center][/cell][/table]"
const _WEAPON_NO_STATS_MASK : String = "[center] - - - - - [/center]"
const _WEAPON_STATS_MASK_MOVE : String = "\n\n >%s (%s)[table=4][cell][center]CD: [/center][/cell][cell]%0.2fs/%0.2fs[/cell][cell]SCL:[/cell][cell]%s%%[/cell][cell][center]SLF:[/center][/cell][cell]%d/%d/%d[/cell][cell]FOE:[/cell][cell]%d/%d/%d[/cell][/table]"
const _WEAPON_STATS_MASK_NO_MOVE : String = "\n\n ----"

var id : int
var character : Character
var inventorySummary : InventorySummary


func updateLabels() -> void:
	setWpnData(character.inventory.weapon, true)
	setWpnData(
		inventorySummary.summary[$main/itemList.get_selected_items()[0]].item,
		false)


func setWpnData(weapon : Weapon, current : bool) -> void:
	var lbl = $main/cards/current/data if current else $main/cards/new/data
	
	if weapon != null:
		lbl.text = _WEAPON_STATS_MASK_MAIN % [
			weapon.name,
			_EQUIPED_MASK if current else _NOT_EQUIPED_MASK,
			Enums.CharacterModifier.keys()[weapon.modifier],
			weapon.damage,
			critRateStr(weapon.modifierRollType),
			critLevelStr(weapon.modifierDice),
			1000.0 * GameParameters.GCD * weapon.cdPre / 1000.0,
			1000.0 * GameParameters.GCD * weapon.cdPos / 1000.0
		]
		
		for move in [weapon.move1, weapon.move2, weapon.move3]:
			if move != null:
				lbl.text += _WEAPON_STATS_MASK_MOVE % [
					move.name,
					targetTypeStr(move.targetType),
					1000.0 * GameParameters.GCD * move.cdPre / 1000.0,
					1000.0 * GameParameters.GCD * move.cdPos / 1000.0,
					move.modifierScale * 100,
					Util.countAbsoluteModType(Enums.MoveModifierType.ATK, move.executorModifiers),
					Util.countAbsoluteModType(Enums.MoveModifierType.DEF, move.executorModifiers),
					Util.countAbsoluteModType(Enums.MoveModifierType.CD, move.executorModifiers),
					Util.countAbsoluteModType(Enums.MoveModifierType.ATK, move.targetModifiers),
					Util.countAbsoluteModType(Enums.MoveModifierType.DEF, move.targetModifiers),
					Util.countAbsoluteModType(Enums.MoveModifierType.CD, move.targetModifiers)
				]
			else:
				lbl.text += _WEAPON_STATS_MASK_NO_MOVE
	else:
		lbl.text = _WEAPON_NO_STATS_MASK
	
	lbl.bbcode_enabled = true


func critRateStr(modifierRollType : int) -> String:
	match modifierRollType:
		Enums.DiceRollType.BEST:
			return "Hi"
		Enums.DiceRollType.NORMAL:
			return "Nm"
		Enums.DiceRollType.WORST:
			return "Lo"
		_:
			return "--"


func critLevelStr(modifierDice : int) -> String:
	match Enums.DiceType.values()[modifierDice]:
		Enums.DiceType.D4:
			return "F"
		Enums.DiceType.D6:
			return "E"
		Enums.DiceType.D8:
			return "D"
		Enums.DiceType.D10:
			return "C"
		Enums.DiceType.D12:
			return "B"
		Enums.DiceType.D20:
			return "A"
		Enums.DiceType.D100:
			return "S"
		_:
			return "-"


func targetTypeStr(targetType : int) -> String:
	match targetType:
		Enums.MoveTargetType.ANY:
			return "Randon"
		Enums.MoveTargetType.ANY_ALL:
			return "Randon"
		Enums.MoveTargetType.FOE:
			return "Foe"
		Enums.MoveTargetType.FOE_ALL:
			return "All Foes"
		Enums.MoveTargetType.FRIENDLY:
			return "Friend"
		Enums.MoveTargetType.FRIENDLY_ALL:
			return "All friends"
		_:
			return "None"


func _on_itemList_item_selected(index: int) -> void:
	updateLabels()


func showWindow() -> void:
	Signals.connect("guiPartyMenuPick",Callable(self,"partyPick"))
	Signals.connect("guiCancel",Callable(self,"back"))
	Signals.connect("guiCloseExploringMenu",Callable(self,"exit"))
	
	Signals.emit_signal("guiPopupPartyMenu", $"../menu/box/btnWpns".global_position + Vector2($"../menu/box/btnWpns".size.x + 10, 0))


func partyPick(id: int) -> void:
	self.id = id
	self.character = GameManager.party[id]
	
	$main/itemList.visible = !character.inventory.weapons.is_empty()
	$main/lblNoWeap.visible = character.inventory.weapons.is_empty()
	
	$main/itemList.modulate = $main/itemList.modulate.lightened(1)
	$Panel.modulate = $Panel.modulate.lightened(1)
	
	var currentIndex = 0
	if !$main/itemList.get_selected_items().is_empty():
		currentIndex = $main/itemList.get_selected_items()[0]
	
	$itemMenu.hide()
	Signals.emit_signal("guiHidePartyMenu")
	$main/itemList.clear()
	
	inventorySummary = InventorySummary.new(character.inventory.weapons)
	
	for itemSummary in inventorySummary.summary:
		var amountTxt = _AMOUNT_MASK % itemSummary.amount
		var maxSize = 30 - (amountTxt.length() + 1)
		var itemName = itemSummary.name.substr(0, maxSize)
		
		for i in range(maxSize - itemName.length()):
			itemName += ' '
		
		$main/itemList.add_item(' ' + itemName + amountTxt)
	
	visible = true
	
	if currentIndex >= $main/itemList.get_item_count():
		currentIndex -= 1
	
	$main/itemList.grab_focus()
	if !$main/itemList.items.is_empty():
		$main/itemList.select(currentIndex)
	
	updateLabels()


func back() -> void:
	if $itemMenu.visible:
		$main/itemList.modulate = $main/itemList.modulate.lightened(1)
		$Panel.modulate = $Panel.modulate.lightened(1)
		$itemMenu.hide()
	elif !$itemMenu.visible:
		exit()
		Signals.emit_signal("guiBack")


func exit() -> void:
	Signals.disconnect("guiPartyMenuPick",Callable(self,"partyPick"))
	Signals.disconnect("guiCancel",Callable(self,"back"))
	Signals.disconnect("guiCloseExploringMenu",Callable(self,"exit"))
	if Signals.is_connected("guiPartyMenuHidden",Callable(self,"back")):
		Signals.disconnect("guiPartyMenuHidden",Callable(self,"back"))
	
	visible = false
	$itemMenu.hide()
	Signals.emit_signal("guiHidePartyMenu")


func _on_itemList_item_activated(index : int) -> void:
	$main/itemList.modulate = $main/itemList.modulate.darkened(0.25)
	$Panel.modulate = $Panel.modulate.darkened(0.25)
	$itemMenu.modulate = $itemMenu.modulate.lightened(1)
	
	var item = inventorySummary.summary[index].item
	var menuPosition = $main/itemList.global_position + Vector2((index % 2) * 312 + 190, floor(index / 2) * 27 + 10)
	
	$itemMenu.position = menuPosition
	$itemMenu.popup()
	$itemMenu.grab_focus()
	$itemMenu.set_current_index(0)


# TODO party
func _on_itemMenu_id_pressed(menuId : int) -> void:
	match menuId:
		0:
			Signals.emit_signal(
				"characterEquipedWeapon",
				character,
				inventorySummary.summary[$main/itemList.get_selected_items()[0]].item)
			partyPick(id)
		
		1:
			Signals.emit_signal("characterDroppedWeapon",
				character,
				inventorySummary.summary[$main/itemList.get_selected_items()[0]].item)
			partyPick(id)
		
		_:
			$main/itemList.modulate = $main/itemList.modulate.lightened(1)
			$Panel.modulate = $Panel.modulate.lightened(1)
			$itemMenu.hide()

