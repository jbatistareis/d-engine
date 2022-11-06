extends Tabs

var characterDto : CharacterDTO = CharacterDTO.new()

var characters : Array = []
var verdicts : Array = []
var inventories : Array = []
var models : Array = []


func _ready() -> void:
	loadAllData()
	setFields()


func loadCharacter(shortName : String) -> void:
	characterDto = Persistence.loadDTO(shortName, Enums.EntityType.CHARACTER)
	setFields()
	$background/mainSeparator/visualization.showData(-1)


func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = characterDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/container/txtShortName.text = characterDto.shortName
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/container/optType.select(characterDto.type)
	
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbBaseHp.value = characterDto.baseHp
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbCurrentHp.value = characterDto.currentHp
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbExtraHp.value = characterDto.extraHp
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbMaxHp.value = characterDto.baseHp + characterDto.constitution
	
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbStrength.value = characterDto.strength
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbDexterity.value = characterDto.dexterity
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbConstitution.value = characterDto.constitution
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbIntelligence.value = characterDto.intelligence
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbWisdom.value = characterDto.wisdom
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbCharisma.value = characterDto.charisma
	$background/mainSeparator/dataPanel/dataContainer/stats/fields/grid/sbBaseDamage.value = characterDto.baseDamage
	
	$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optVerdict.select(verdicts.find(characterDto.verdictShortName))
	$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optInventory.select(inventories.find(characterDto.inventoryShortName))
	$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optModel.select(models.find(characterDto.model))
	$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/chkVerdictAct.pressed = characterDto.verdictActive


func loadAllData() -> void:
	characters = Persistence.listEntities(Enums.EntityType.CHARACTER)
	$background/mainSeparator/fileList.clear()
	for character in characters:
		$background/mainSeparator/fileList.add_item(character)
	
	verdicts = Persistence.listEntities(Enums.EntityType.VERDICT)
	$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optVerdict.clear()
	for verdict in verdicts:
		$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optVerdict.add_item(verdict)
	
	inventories = Persistence.listEntities(Enums.EntityType.INVENTORY)
	$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optInventory.clear()
	for intentory in inventories:
		$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optInventory.add_item(intentory)
	
	models = Persistence.listEntities(Enums.EntityType.CHARACTER_MODEL)
	$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optModel.clear()
	for model in models:
		$background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optModel.add_item(model)



# files list
func _on_fileList_item_selected(index):
	loadCharacter($background/mainSeparator/fileList.get_item_text(index))



# identification
func _on_txtName_text_changed(new_text):
	characterDto.name = new_text


func _on_txtShortName_text_changed(new_text):
	characterDto.shortName = new_text


func _on_optType_item_selected(index):
	characterDto.type = index



# hp
func _on_sbBaseHp_value_changed(value):
	characterDto.baseHp = value
	
	var hp = characterDto.baseHp + characterDto.constitution
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbMaxHp.value = hp
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbCurrentHp.max_value = hp
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbCurrentHp.value = hp


func _on_sbCurrentHp_value_changed(value):
	characterDto.currentHp = value


func _on_sbExtraHp_value_changed(value):
	characterDto.extraHp = value



# stats
func _on_sbStrength_value_changed(value):
	characterDto.strength = value


func _on_sbDexterity_value_changed(value):
	characterDto.dexterity = value


func _on_sbConstitution_value_changed(value):
	characterDto.constitution = value
	
	var hp = characterDto.baseHp + characterDto.constitution
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbMaxHp.value = hp
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbCurrentHp.max_value = hp
	$background/mainSeparator/dataPanel/dataContainer/hp/fields/grid/sbCurrentHp.value = hp


func _on_sbIntelligence_value_changed(value):
	characterDto.intelligence = value


func _on_sbWisdom_value_changed(value):
	characterDto.wisdom = value


func _on_sbCharisma_value_changed(value):
	characterDto.charisma = value


func _on_sbBaseDamage_value_changed(value):
	characterDto.baseDamage = value



# misc
func _on_optVerdict_item_selected(index):
	characterDto.verdictShortName = $background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optVerdict.get_item_text(index)
	_on_btnViewVerdict_pressed()


func _on_optInventory_item_selected(index):
	characterDto.inventoryShortName = $background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optInventory.get_item_text(index)
	_on_btnViewInventory_pressed()


func _on_optModel_item_selected(index):
	characterDto.model = $background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/optModel.get_item_text(index)
	_on_btnViewModel_pressed()



# view
func _on_btnViewVerdict_pressed():
	$background/mainSeparator/visualization.showData(Enums.EntityType.VERDICT, characterDto.verdictShortName)


func _on_chkVerdictAct_pressed():
	characterDto.verdictActive = $background/mainSeparator/dataPanel/dataContainer/misc/fields/grid/chkVerdictAct.pressed


func _on_btnViewInventory_pressed():
	$background/mainSeparator/visualization.showData(Enums.EntityType.INVENTORY, characterDto.inventoryShortName)


func _on_btnViewModel_pressed():
	$background/mainSeparator/visualization.showData(Enums.EntityType.CHARACTER_MODEL, characterDto.model)



# buttons
func _on_btnSave_pressed():
	$saveConfigmation.entityName = characterDto.shortName
	$saveConfigmation.popup_centered()


func _on_saveConfigmation_confirmed():
	Persistence.saveDTO(characterDto)
	loadAllData()
	setFields()
	$background/mainSeparator/fileList.select(characters.find(characterDto.shortName))


func _on_btnReload_pressed():
	loadAllData()
	setFields()
	$background/mainSeparator/fileList.select(characters.find(characterDto.shortName))


func _on_tabs_tab_changed(tab : int):
	if tab == get_index():
		get_node("background/mainSeparator/visualization/Model/data/container/Viewport/area").visible = true
	else:
		get_node("background/mainSeparator/visualization/Model/data/container/Viewport/area").visible = false

