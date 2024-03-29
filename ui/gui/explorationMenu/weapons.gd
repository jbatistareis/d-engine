extends PopupPanel

const _NAME_MASK : String = "%-20s [x%02d]"
const _EQUIPED_MASK : String = "[E]"
const _NOT_EQUIPED_MASK : String = ""
const _WEAPON_STATS_MASK_MAIN : String = "[center][ %s ]%s[/center][table=4][cell][left]Stat: [/left][/cell][cell][center]%s[/center][/cell][cell][left]   Damage: [/left][/cell][cell][center][bgcolor=%s][color=%s]%d[/color][/bgcolor][/center][/cell][cell][left]Crt.rt: [/left][/cell][cell][center][bgcolor=%s][color=%s]%s[/color][/bgcolor][/center][/cell][cell][left]   Crt.lv: [/left][/cell][cell][center][bgcolor=%s][color=%s]%s[/color][/bgcolor][/center][/cell][/table][center]Cooldown: [bgcolor=%s][color=%s]%0.2fs[/color][/bgcolor]/[bgcolor=%s][color=%s]%0.2fs[/color][/bgcolor][/center]"
const _WEAPON_NO_STATS_MASK : String = "[center] - - - - - [/center]"
const _WEAPON_STATS_MASK_MOVE : String = "\n[center]----------------------------[/center]\n>%s (%s)[table=4][cell][center]CD: [/center][/cell][cell]%0.2fs/%0.2fs[/cell][cell]   SCL:[/cell][cell]%s%%[/cell][/table]\n[table=4][cell][center]SLF:[/center][/cell][cell]%d/%d/%d[/cell][cell]      FOE:[/cell][cell]%d/%d/%d[/cell][/table]"
const _WEAPON_STATS_MASK_NO_MOVE : String = "\n[center]----------------------------[/center]\n>N/A\n \n "

var currentWpn : Weapon
var newWpn : Weapon

var character : Character
var inventorySummary : InventorySummary


func _on_about_to_popup(onIndex : int = 0) -> void:
	position = $"..".position + Vector2i($"..".size.x, 0)
	
	character = GameManager.party[$"..".get_focused_item()]
	$wpnList.visible = !character.inventory.weapons.is_empty()
	$lblNoWpns.visible = character.inventory.weapons.is_empty()
	
	if $lblNoWpns.visible:
		return
	
	$wpnList.clear()
	inventorySummary = InventorySummary.new(character.inventory.weapons)
	
	for itemSummary in inventorySummary.summary:
		$wpnList.add_item(_NAME_MASK % [itemSummary.name.substr(0, 20), itemSummary.amount])
	
	$wpnList.grab_focus()
	if !inventorySummary.summary.is_empty():
		var index = onIndex if (onIndex < $wpnList.item_count) else ($wpnList.item_count - 1)
		$wpnList.select(index)
		updateLabels()


func _on_popup_hide() -> void:
	pass


func _on_wpn_list_item_activated(index: int) -> void:
	$wpnList/wpnMenu.position = position + Vector2i(size.x, 0)
	$wpnList/wpnMenu.popup()
	$wpnList/wpnMenu.set_focused_item(0)
	$wpnList/wpnMenu.grab_focus()


func previousIndex() -> int:
	if inventorySummary.summary[$wpnList.get_selected_items()[0]].amount > 1:
		return $wpnList.get_selected_items()[0]
	else:
		return max(0, $wpnList.get_selected_items()[0] - 1)


func _on_wpn_menu_id_pressed(id: int) -> void:
	match id:
		0:
			Signals.characterEquipedWeapon.emit(
				character,
				inventorySummary.summary[$wpnList.get_selected_items()[0]].item)
			
			_on_about_to_popup($wpnList.get_selected_items()[0])
		
		1:
			Signals.characterDroppedWeapon.emit(
				character,
				inventorySummary.summary[$wpnList.get_selected_items()[0]].item)
			
			_on_about_to_popup(previousIndex())
	
	$wpnList/wpnMenu.hide()


func _on_wpn_list_item_selected(index: int) -> void:
	updateLabels()


func updateLabels() -> void:
	var index = $wpnList.get_selected_items()[0] if ($wpnList.get_selected_items().size() > 0) else ($wpnList.item_count - 1)
	
	currentWpn = character.inventory.weapon
	newWpn = inventorySummary.summary[index].item
	
	setWpnData(currentWpn, true)
	setWpnData(newWpn, false)
	
	$info.position = position + Vector2i(size.x + 10, 0)
	$info.popup()
	$info/container.visible = true


func setWpnData(weapon : Weapon, current : bool) -> void:
	var lbl = $info/container/current if current else $info/container/new
	var text = ""
	
	if weapon != null:
		text = _WEAPON_STATS_MASK_MAIN % [
			weapon.name.substr(0, 20),
			_EQUIPED_MASK if current else _NOT_EQUIPED_MASK,
			Enums.CharacterModifier.keys()[weapon.modifier],
			comparisonBgColor(newWpn.damage, currentWpn.damage),
			comparisonTextColor(newWpn.damage, currentWpn.damage, current),
			weapon.damage,
			comparisonBgColor(newWpn.modifierRollType, currentWpn.modifierRollType),
			comparisonTextColor(newWpn.modifierRollType, currentWpn.modifierRollType, current),
			critRateStr(weapon.modifierRollType),
			comparisonBgColor(newWpn.modifierDice, currentWpn.modifierDice),
			comparisonTextColor(newWpn.modifierDice, currentWpn.modifierDice, current),
			critLevelStr(weapon.modifierDice),
			comparisonBgColor(newWpn.cdPre, currentWpn.cdPre),
			comparisonTextColor(newWpn.cdPre, currentWpn.cdPre, current),
			1000.0 * GameParameters.GCD * weapon.cdPre / 1000.0,
			comparisonBgColor(newWpn.cdPos, currentWpn.cdPos),
			comparisonTextColor(newWpn.cdPos, currentWpn.cdPos, current),
			1000.0 * GameParameters.GCD * weapon.cdPos / 1000.0
		]
		
		for move in [weapon.move1, weapon.move2, weapon.move3]:
			if move != null:
				text += _WEAPON_STATS_MASK_MOVE % [
					move.name,
					targetTypeStr(move.targetType),
					1000.0 * GameParameters.GCD * move.cdPre / 1000.0,
					1000.0 * GameParameters.GCD * move.cdPos / 1000.0,
					move.modifierScale * 100,
					move.executorAtkModifier,
					move.executorDefModifier,
					move.executorCdModifier,
					move.targetAtkModifier,
					move.targetDefModifier,
					move.targetCdModifier
				]
			else:
				text += _WEAPON_STATS_MASK_NO_MOVE
	else:
		text = _WEAPON_NO_STATS_MASK
	
	lbl.bbcode_enabled = true
	lbl.text = text


func comparisonTextColor(input1, input2, current) -> String:
	var value1 = input1 if !current else input2
	var value2 = input2 if !current else input1
	
	if value1 == value2:
		return '#' + GuiTheme.TEXT_COLOR_NORMAL.to_html()
	elif value1 > value2:
		return '#' + GuiTheme.TEXT_COLOR_HIGH.to_html()
	else:
		return '#' + GuiTheme.TEXT_COLOR_LOW.to_html()


func comparisonBgColor(value1, value2) -> String:
	if value1 != value2:
		return '#' + GuiTheme.TEXT_BG_ACCENT.to_html()
	
	return '#' + GuiTheme.TEXT_BG_NORMAL.to_html()


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

