extends TabBar

var itemDto : ItemDTO = ItemDTO.new()
var list : Array = []


func _ready() -> void:
	EditorSignals.connect("selectedItem",Callable(self,"loadItem"))
	
	loadAllData()
	setFields()


func loadItem(shortName : String) -> void:
	itemDto = Persistence.loadDTO(shortName, Enums.EntityType.ITEM)
	$background/mainSeparator/fileList.select(list.find(shortName))
	setFields()


func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = itemDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtShortName.text = itemDto.shortName
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtDescription.text = itemDto.description
	$background/mainSeparator/dataPanel/dataContainer/parameters/fields/grid/optType.select(itemDto.type)
	$background/mainSeparator/dataPanel/dataContainer/parameters/fields/grid/optTarget.select(itemDto.targetType)
	$background/mainSeparator/dataPanel/dataContainer/logic/txtExpression.text = itemDto.actionExpression


func loadAllData() -> void:
	list = Persistence.listEntities(Enums.EntityType.ITEM)
	
	$background/mainSeparator/fileList.clear()
	for item in list:
		$background/mainSeparator/fileList.add_item(item)


# files list
func _on_fileList_item_selected(index):
	loadItem($background/mainSeparator/fileList.get_item_text(index))


func _on_btnSave_pressed():
	$saveConfirm.entityName = itemDto.shortName
	$saveConfirm.popup_centered()


func _on_saveConfirm_confirmed() -> void:
	Persistence.saveDTO(itemDto)
	_on_btnReload_pressed()


func _on_btnReload_pressed():
	loadAllData()
	$background/mainSeparator/fileList.select(list.find(itemDto.shortName))


func _on_txtName_text_changed(new_text: String) -> void:
	itemDto.name = new_text


func _on_txtShortName_text_changed(new_text: String) -> void:
	itemDto.shortName = new_text


func _on_txtDescription_text_changed(new_text: String) -> void:
	itemDto.description = new_text


func _on_spnPrice_value_changed(value: float) -> void:
	itemDto.price = int(value)


func _on_optType_item_selected(index: int) -> void:
	itemDto.type = index


func _on_optTarget_item_selected(index: int) -> void:
	itemDto.targetType = index


func _on_txtExpression_text_changed() -> void:
	itemDto.actionExpression = $background/mainSeparator/dataPanel/dataContainer/logic/txtExpression.text

