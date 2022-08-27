extends Tabs

var moveDto : MoveDTO = MoveDTO.new()
var list : Array = []


func _ready() -> void:
	EditorSignals.connect("selectedMove", self, "loadMove")
	
	loadAllData()
	setFields()


func loadMove(shortName : String) -> void:
	moveDto = Persistence.loadDTO(shortName, Enums.EntityType.MOVE)
	setFields()
	
	$background/mainSeparator/fileList.select(list.find(shortName))


func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = moveDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtShortName.text = moveDto.shortName
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtDescription.text = moveDto.description
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/optTarget.select(moveDto.targetType)
	
	$background/mainSeparator/dataPanel/dataContainer/cd/fields/grid/sbCdPre.value = moveDto.cdPre
	$background/mainSeparator/dataPanel/dataContainer/cd/fields/grid/sbCdPos.value = moveDto.cdPos
	
	$background/mainSeparator/dataPanel/dataContainer/animations/fields/grid/txtAnimPrepare.text = moveDto.prepareAnimation
	$background/mainSeparator/dataPanel/dataContainer/animations/fields/grid/txtAnimAttack.text = moveDto.attackAnimation
	
	$background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModScale.value = moveDto.modifierScale
	
	$background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModAtkEx.value = Util.countAbsoluteModType(Enums.MoveModifierType.ATK, moveDto.executorModifiers)
	$background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModDefEx.value = Util.countAbsoluteModType(Enums.MoveModifierType.DEF, moveDto.executorModifiers)
	$background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModCdEx.value = Util.countAbsoluteModType(Enums.MoveModifierType.CD, moveDto.executorModifiers)
	
	$background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModAtkTgt.value = Util.countAbsoluteModType(Enums.MoveModifierType.ATK, moveDto.targetModifiers)
	$background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModDefTgt.value = Util.countAbsoluteModType(Enums.MoveModifierType.DEF, moveDto.targetModifiers)
	$background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModCdTgt.value = Util.countAbsoluteModType(Enums.MoveModifierType.CD, moveDto.targetModifiers)
	
	$background/mainSeparator/PanelContainer/logic/tabs/Value/txtValue.text = moveDto.valueExpression
	$background/mainSeparator/PanelContainer/logic/tabs/Outcome/txtOutcome.text = moveDto.outcomeExpression
	$background/mainSeparator/PanelContainer/logic/tabs/Pick/txtPick.text = moveDto.pickExpression
	$background/mainSeparator/PanelContainer/logic/tabs/Execute/txtExecute.text = moveDto.excuteExpression


func loadAllData() -> void:
	list = Persistence.listEntities(Enums.EntityType.MOVE)
	
	$background/mainSeparator/fileList.clear()
	for move in list:
		$background/mainSeparator/fileList.add_item(move)



# files list
func _on_fileList_item_selected(index):
	loadMove($background/mainSeparator/fileList.get_item_text(index))



# identification
func _on_txtName_text_changed(new_text):
	moveDto.name = new_text


func _on_txtShortName_text_changed(new_text):
	moveDto.shortName = new_text


func _on_txtDescription_text_changed(new_text):
	moveDto.description = new_text


func _on_optTarget_item_selected(index):
	moveDto.targetType = index



# cooldowns
func _on_sbCdPre_value_changed(value):
	moveDto.cdPre = value


func _on_sbCdPos_value_changed(value):
	moveDto.cdPos = value



# animations
func _on_txtAnimPrepare_text_changed(new_text):
	moveDto.prepareAnimation = new_text


func _on_txtAnimAttack_text_changed(new_text):
	moveDto.attackAnimation = new_text


# modifiers
func _on_sbModScale_value_changed(value):
	moveDto.modifierScale = value


# buttons
func _on_btnSave_pressed():
	$saveConfirm.entityName = moveDto.shortName
	$saveConfirm.popup_centered()


func _on_saveConfirm_confirmed():
	moveDto.valueExpression = $background/mainSeparator/PanelContainer/logic/tabs/Value/txtValue.text
	moveDto.outcomeExpression = $background/mainSeparator/PanelContainer/logic/tabs/Outcome/txtOutcome.text
	moveDto.pickExpression = $background/mainSeparator/PanelContainer/logic/tabs/Pick/txtPick.text
	moveDto.excuteExpression = $background/mainSeparator/PanelContainer/logic/tabs/Execute/txtExecute.text
	
	
	var ex_atk = $background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModAtkEx.value
	var ex_def = $background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModDefEx.value
	var ex_cd = $background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModCdEx.value
	
	var tgt_atk = $background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModAtkTgt.value
	var tgt_def = $background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModDefTgt.value
	var tgt_cd = $background/mainSeparator/dataPanel/dataContainer/Modifiers/fields/grid/sbModCdTgt.value
	
	moveDto.executorModifiers.clear()
	moveDto.targetModifiers.clear()
	
	match int(sign(ex_atk)):
		-1:
			for i in range(abs(ex_atk)):
				moveDto.executorModifiers.append(Enums.MoveModifierProperty.ATK_M)
		
		1:
			for i in range(ex_atk):
				moveDto.executorModifiers.append(Enums.MoveModifierProperty.ATK_P)
	
	match int(sign(ex_def)):
		-1:
			for i in range(abs(ex_def)):
				moveDto.executorModifiers.append(Enums.MoveModifierProperty.DEF_M)
		
		1:
			for i in range(ex_def):
				moveDto.executorModifiers.append(Enums.MoveModifierProperty.DEF_P)
	
	match int(sign(ex_cd)):
		-1:
			for i in range(abs(ex_cd)):
				moveDto.executorModifiers.append(Enums.MoveModifierProperty.CD_M)
		
		1:
			for i in range(ex_cd):
				moveDto.executorModifiers.append(Enums.MoveModifierProperty.CD_P)
	
	
	match int(sign(tgt_atk)):
		-1:
			for i in range(abs(tgt_atk)):
				moveDto.targetModifiers.append(Enums.MoveModifierProperty.ATK_M)
		
		1:
			for i in range(tgt_atk):
				moveDto.targetModifiers.append(Enums.MoveModifierProperty.ATK_P)
	
	match int(sign(tgt_def)):
		-1:
			for i in range(abs(tgt_def)):
				moveDto.targetModifiers.append(Enums.MoveModifierProperty.DEF_M)
		
		1:
			for i in range(tgt_def):
				moveDto.targetModifiers.append(Enums.MoveModifierProperty.DEF_P)
	
	match int(sign(tgt_cd)):
		-1:
			for i in range(abs(tgt_cd)):
				moveDto.targetModifiers.append(Enums.MoveModifierProperty.CD_M)
		
		1:
			for i in range(tgt_cd):
				moveDto.targetModifiers.append(Enums.MoveModifierProperty.CD_P)
	
	Persistence.saveDTO(moveDto)
	_on_btnReload_pressed()



func _on_btnReload_pressed():
	loadAllData()
	$background/mainSeparator/fileList.select(list.find(moveDto.shortName))

