extends MarginContainer

const _AMOUNT_MASK : String = "[x%d]"

var character : Character
var inventorySummary : InventorySummary


func _ready() -> void:
	Signals.connect("guiCancel", self, "hide")
	Signals.connect("guiCloseExploringMenu", self, "exit")


func showWindow(character : Character) -> void:
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
		
		print(itemName)
		
		for i in range(14 - itemName.length()):
			itemName += ' '
		
		$ItemList.add_item((itemName + _AMOUNT_MASK) % itemSummary.amount)
	
	visible = true
	$ItemList.grab_focus()
	if !$ItemList.items.empty():
		$ItemList.select(0)


func hide() -> void:
	if visible:
		visible = false
		get_parent().focus()


func exit() -> void:
	if visible:
		visible = false


# TODO
func _on_ItemList_item_activated(index: int) -> void:
	inventorySummary.summary[index].item

