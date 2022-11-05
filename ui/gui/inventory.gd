extends MarginContainer

const _AMOUNT_MASK : String = "[x%d]"

var character : Character
var inventorySummary : InventorySummary


func _ready() -> void:
	Signals.connect("guiCancel", self, "hide")
	Signals.connect("guiCloseExploringMenu", self, "exit")


func showWindow(character : Character) -> void:
	var currentIndex = 0
	if !$ItemList.get_selected_items().empty():
		currentIndex = $ItemList.get_selected_items()[0]
	
	$menu.visible = false
	$ItemList.clear()
	get_parent().unfocus()
	self.character = character
	
	if character.inventory.items.empty():
		# TODO show message
		print('Your inventory is empty')
	
	inventorySummary = InventorySummary.new(character)
	
	for itemSummary in inventorySummary.summary:
		var itemName = itemSummary.name.substr(0, 14)
		
		var prefix = ""
		for i in range((14 - itemName.length()) / 2):
			prefix += ' '
		itemName = prefix + itemName
		
		for i in range(14 - itemName.length()):
			itemName += ' '
		
		$ItemList.add_item((itemName + _AMOUNT_MASK) % itemSummary.amount)
	
	visible = true
	
	if currentIndex >= $ItemList.get_item_count():
		currentIndex -= 1
	
	itemFocus(currentIndex)


func itemFocus(index : int) -> void:
	$ItemList.grab_focus()
	if !$ItemList.items.empty():
		$ItemList.select(index)


func hide() -> void:
	if visible:
		visible = false
		$menu.visible = false
		$party.close()
		get_parent().focus()


func exit() -> void:
	if visible:
		visible = false
		$menu.visible = false
		$party.close()


func _on_ItemList_item_activated(index : int) -> void:
	var item = inventorySummary.summary[index].item
	var menuPosition = $ItemList.rect_position + Vector2(index * 152, floor(index / 4) * 51) + Vector2(100, 30)
	
	$menu.visible = true
	$menu.set_deferred("rect_position", menuPosition)
	$menu/container/btnUse.grab_focus()


func _on_btnUse_pressed() -> void:
	var item = inventorySummary.summary[$ItemList.get_selected_items()[0]].item
	$party.open(item, $menu.rect_position + Vector2($menu.rect_position.x * 2, 0))


func _on_btnDrop_pressed() -> void:
	var item = inventorySummary.summary[$ItemList.get_selected_items()[0]].item
	var inventoryItem = character.inventory.items.bsearch_custom(item.shortName, EntityArrayHelper, 'shortNameFind')
	character.inventory.removeItem(inventoryItem)
	
	showWindow(character)


func _on_btnCancel_pressed() -> void:
	$menu.visible = false
	showWindow(character)

