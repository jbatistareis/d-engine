extends Tabs

var armorDto : ArmorDTO = ArmorDTO.new()
var list : Array = []


func _ready() -> void:
	EditorSignals.connect("selectedArmor", self, "loadArmor")
	
	loadAllData()
	setFields()


func loadArmor(shortName : String) -> void:
	armorDto = Persistence.loadDTO(shortName, Enums.EntityType.ARMOR)
	setFields()
	
	$background/mainSeparator/fileList.select(list.find(shortName))

func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = armorDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtShortName.text = armorDto.shortName
	
	$background/mainSeparator/dataPanel/dataContainer/integrity/fields/grid/sbCurrIntegrity.value = armorDto.currentIntegrity
	$background/mainSeparator/dataPanel/dataContainer/integrity/fields/grid/sbMaxIntegrity.value = armorDto.maxIntegrity


func loadAllData() -> void:
	list = Persistence.listEntities(Enums.EntityType.ARMOR)
	
	$background/mainSeparator/fileList.clear()
	for armor in list:
		$background/mainSeparator/fileList.add_item(armor)



# files list
func _on_fileList_item_selected(index):
	loadArmor($background/mainSeparator/fileList.get_item_text(index))



# indentification
func _on_txtName_text_changed(new_text):
	armorDto.name = new_text


func _on_txtShortName_text_changed(new_text):
	armorDto.shortName = new_text



# integrity
func _on_sbCurrIntegrity_value_changed(value):
	armorDto.currentIntegrity = value
	$background/mainSeparator/dataPanel/dataContainer/integrity/fields/grid/sbMaxIntegrity.min_value = value


func _on_sbMaxIntegrity_value_changed(value):
	armorDto.maxIntegrity = value
	$background/mainSeparator/dataPanel/dataContainer/integrity/fields/grid/sbCurrIntegrity.max_value = value



# buttons
func _on_btnSave_pressed():
	$saveConfirm.entityName = armorDto.shortName
	$saveConfirm.popup_centered()


func _on_saveConfirm_confirmed():
	Persistence.saveDTO(armorDto)
	_on_btnReload_pressed()


func _on_btnReload_pressed():
	loadAllData()
	$background/mainSeparator/fileList.select(list.find(armorDto.shortName))

