extends Tabs

const _PROP_MASK : String = 'move%dShortName'
const _OPT_MASK : String = 'background/mainSeparator/dataPanel/dataContainer/moves/fields/grid/moveBtn%d/optMove%d'

var weaponDto : WeaponDTO = WeaponDTO.new()
var weaponList : Array = []
var moveList : Array = []


func _ready() -> void:
	EditorSignals.connect("selectedWeapon", self, "loadWeapon")
	
	loadAllData()
	setFields()


func loadWeapon(shortName : String) -> void:
	weaponDto = Persistence.loadDTO(shortName, Enums.EntityType.WEAPON)
	$background/mainSeparator/fileList.select(weaponList.find(shortName))
	setFields()


func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = weaponDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtShortName.text = weaponDto.shortName
	
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbDamage.value = weaponDto.damage
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/optModifier.select(weaponDto.modifierDice)
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/optRoll.select(weaponDto.modifierRollType)
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/optStat.select(weaponDto.modifier)
	
	$background/mainSeparator/dataPanel/dataContainer/cd/fields/grid/sbCdPre.value = weaponDto.cdPre
	$background/mainSeparator/dataPanel/dataContainer/cd/fields/grid/sbCdPos.value = weaponDto.cdPos
	
	selectCurrentMoves()


func loadAllData() -> void:
	weaponList = Persistence.listEntities(Enums.EntityType.WEAPON)
	moveList = Persistence.listEntities(Enums.EntityType.MOVE)
	
	$background/mainSeparator/fileList.clear()
	for weapon in weaponList:
		$background/mainSeparator/fileList.add_item(weapon)
	
	for i in range(4):
		var idx = i + 1
		var opt = get_node(_OPT_MASK % [idx, idx])
		
		opt.clear()
		opt.add_item("None")
		
		for move in moveList:
			opt.add_item(move)



# files list
func _on_fileList_item_selected(index):
	loadWeapon($background/mainSeparator/fileList.get_item_text(index))



# indentification
func _on_txtName_text_changed(new_text):
	weaponDto.name = new_text


func _on_txtShortName_text_changed(new_text):
	weaponDto.shortName = new_text



# stats
func _on_sbDamage_value_changed(value):
	weaponDto.damage = value


func _on_optModifier_item_selected(index):
	weaponDto.modifierDice = index


func _on_optRoll_item_selected(index):
	weaponDto.modifierRollType = index

func _on_optStat_item_selected(index):
	weaponDto.modifier = index



# cooldowns
func _on_sbCdPre_value_changed(value):
	weaponDto.cdPre = value


func _on_sbCdPos_value_changed(value):
	weaponDto.cdPos = value



# moves
func _on_optMove1_item_selected(index):
	if index == 0:
		weaponDto.move1ShortName = ''
	else:
		weaponDto.move1ShortName = moveList[$background/mainSeparator/dataPanel/dataContainer/moves/fields/grid/moveBtn1/optMove1.selected - 1]


func _on_btnEditMove1_pressed():
	if !weaponDto.move1ShortName.empty():
		EditorSignals.emit_signal("selectedMove", weaponDto.move1ShortName)


func _on_optMove2_item_selected(index):
	if index == 0:
		weaponDto.move2ShortName = ''
	else:
		weaponDto.move2ShortName = moveList[$background/mainSeparator/dataPanel/dataContainer/moves/fields/grid/moveBtn2/optMove2.selected - 1]


func _on_btnEditMove2_pressed():
	if !weaponDto.move2ShortName.empty():
		EditorSignals.emit_signal("selectedMove", weaponDto.move2ShortName)


func _on_optMove3_item_selected(index):
	if index == 0:
		weaponDto.move3ShortName = ''
	else:
		weaponDto.move3ShortName = moveList[$background/mainSeparator/dataPanel/dataContainer/moves/fields/grid/moveBtn3/optMove3.selected - 1]


func _on_btnEditMove3_pressed():
	if !weaponDto.move3ShortName.empty():
		EditorSignals.emit_signal("selectedMove", weaponDto.move3ShortName)


func _on_optMove4_item_selected(index):
	if index == 0:
		weaponDto.move4ShortName = ''
	else:
		weaponDto.move4ShortName = moveList[$background/mainSeparator/dataPanel/dataContainer/moves/fields/grid/moveBtn4/optMove4.selected - 1]


func _on_btnEditMove4_pressed():
	if !weaponDto.move4ShortName.empty():
		EditorSignals.emit_signal("selectedMove", weaponDto.move4ShortName)



# buttons
func _on_btnSave_pressed():
	$saveConfirm.entityName = weaponDto.shortName
	$saveConfirm.popup_centered()


func _on_saveConfirm_confirmed():
	Persistence.saveDTO(weaponDto)
	loadAllData()
	
	$background/mainSeparator/fileList.select(weaponList.find(weaponDto.shortName))
	selectCurrentMoves()


func _on_btnReload_pressed():
	loadAllData()
	
	$background/mainSeparator/fileList.select(weaponList.find(weaponDto.shortName))
	selectCurrentMoves()


func selectCurrentMoves() -> void:
	for i in range(4):
		var idx = i + 1
		var opt = get_node(_OPT_MASK % [idx, idx])
		var propName = _PROP_MASK % idx
		
		opt.select(0 if weaponDto[propName].empty() else (moveList.find(weaponDto[propName]) + 1))

