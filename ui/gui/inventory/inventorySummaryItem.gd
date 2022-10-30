class_name InventorySummaryItem

var item : Item
var amount : int

var name : String setget ,getName


func _init(item : Item, amount : int) -> void:
	self.item = item
	self.amount = amount


func getName() -> String:
	return item.name

