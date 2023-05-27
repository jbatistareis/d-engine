extends BaseParameters


func _ready() -> void:
	$equipGrid/optArmor.valuesFunc = func(): return Persistence.listEntities(Enums.EntityType.ARMOR)
	$equipGrid/optWpn.valuesFunc = func(): return Persistence.listEntities(Enums.EntityType.WEAPON)


func setDto(value : InventoryDTO) -> void:
	dto = value
	
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value
	$equipGrid/optArmor.dto = value
	$equipGrid/optWpn.dto = value
	$container/money/spnParameter.dto = value
	
	refreshItems()
	refreshWpns()
	
	$container/itemControl/optItems.clear()
	for item in Persistence.listEntities(Enums.EntityType.ITEM):
		$container/itemControl/optItems.add_item(item)
	
	$container/wpnControl/optWpns.clear()
	for wpn in Persistence.listEntities(Enums.EntityType.WEAPON):
		$container/wpnControl/optWpns.add_item(wpn)


func refreshItems() -> void:
	dto.itemShortNames.sort()
	$container/items.clear()
	for item in dto.itemShortNames:
		$container/items.add_item(item)


func refreshWpns() -> void:
	dto.weaponShortNames.sort()
	$container/weapons.clear()
	for wpn in dto.weaponShortNames:
		$container/weapons.add_item(wpn)



func _on_btn_add_item_pressed() -> void:
	dto.itemShortNames.append($container/itemControl/optItems.get_item_text($container/itemControl/optItems.selected))
	refreshItems()


func _on_btn_del_item_pressed() -> void:
	dto.itemShortNames.erase($container/itemControl/optItems.get_item_text($container/itemControl/optItems.selected))
	refreshItems()



func _on_btn_add_wpn_pressed() -> void:
	dto.weaponShortNames.append($container/wpnControl/optWpns.get_item_text($container/wpnControl/optWpns.selected))
	refreshWpns()


func _on_btn_del_wpn_pressed() -> void:
	dto.weaponShortNames.erase($container/wpnControl/optWpns.get_item_text($container/wpnControl/optWpns.selected))
	refreshWpns()

