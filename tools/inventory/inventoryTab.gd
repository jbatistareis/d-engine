extends Tabs

var inventoryDto : InventoryDTO = InventoryDTO.new()
var list : Array = []

var itemsList : Array = []
var weaponsList : Array = []
var armorsList : Array = []


func _ready() -> void:
	EditorSignals.connect("selectedInventory", self, "loadInventory")
	
	loadAllData()
	setFields()


func loadInventory(shortName : String) -> void:
	inventoryDto = Persistence.loadDTO(shortName, Enums.EntityType.INVENTORY)
	$background/mainSeparator/fileList.select(list.find(shortName))
	setFields()


func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = inventoryDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtShortName.text = inventoryDto.shortName
	$background/mainSeparator/dataPanel/dataContainer/Contents/fields/grid/spnMoney.value = inventoryDto.money
	
	$background/mainSeparator/dataPanel/dataContainer/Contents/fields/grid/optWeapon.select(weaponsList.find(inventoryDto.weaponShortName))
	$background/mainSeparator/dataPanel/dataContainer/Contents/fields/grid/optArmor.select(armorsList.find(inventoryDto.armorShortName))
	
	for item in inventoryDto.itemShortNames:
		$background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/itemsContainer/items.select(itemsList.find(item), false)
	
	for weapon in inventoryDto.weaponShortNames:
		$background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/weaponsContainer/weapons.select(weaponsList.find(weapon), false)


func loadAllData() -> void:
	list = Persistence.listEntities(Enums.EntityType.INVENTORY)
	itemsList = Persistence.listEntities(Enums.EntityType.ITEM)
	weaponsList = Persistence.listEntities(Enums.EntityType.WEAPON)
	armorsList = Persistence.listEntities(Enums.EntityType.ARMOR)
	
	$background/mainSeparator/fileList.clear()
	for inventory in list:
		$background/mainSeparator/fileList.add_item(inventory)
	
	$background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/itemsContainer/items.clear()
	for item in itemsList:
		$background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/itemsContainer/items.add_item(item)
	
	$background/mainSeparator/dataPanel/dataContainer/Contents/fields/grid/optArmor.clear()
	for armor in armorsList:
		$background/mainSeparator/dataPanel/dataContainer/Contents/fields/grid/optArmor.add_item(armor)
	
	$background/mainSeparator/dataPanel/dataContainer/Contents/fields/grid/optWeapon.clear()
	$background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/weaponsContainer/weapons.clear()
	for weapon in weaponsList:
		$background/mainSeparator/dataPanel/dataContainer/Contents/fields/grid/optWeapon.add_item(weapon)
		$background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/weaponsContainer/weapons.add_item(weapon)


func _on_fileList_item_selected(index):
	loadInventory($background/mainSeparator/fileList.get_item_text(index))


func _on_btnSave_pressed():
	$saveConfirm.entityName = inventoryDto.shortName
	$saveConfirm.popup_centered()


func _on_saveConfirm_confirmed() -> void:
	inventoryDto.itemShortNames.clear()
	for index in $background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/itemsContainer/items.get_selected_items():
		inventoryDto.itemShortNames.append(itemsList[index])
	
	inventoryDto.weaponShortNames.clear()
	for index in $background/mainSeparator/dataPanel/dataContainer/Contents/listsContainer/weaponsContainer/weapons.get_selected_items():
		inventoryDto.weaponShortNames.append(weaponsList[index])
	
	Persistence.saveDTO(inventoryDto)
	_on_btnReload_pressed()


func _on_btnReload_pressed():
	loadAllData()
	$background/mainSeparator/fileList.select(list.find(inventoryDto.shortName))


func _on_txtName_text_changed(new_text: String) -> void:
	inventoryDto.name = new_text


func _on_txtShortName_text_changed(new_text: String) -> void:
	inventoryDto.shortName = new_text


func _on_optWeapon_item_selected(index: int) -> void:
	inventoryDto.weaponShortName = weaponsList[index]


func _on_optArmor_item_selected(index: int) -> void:
	inventoryDto.armorShortName = armorsList[index]


func _on_spnMoney_value_changed(value: float) -> void:
	inventoryDto.money = int(value)

