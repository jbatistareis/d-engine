class_name InventorySummaryItem

var item : Item
var amount : int

var name : String : get = getName


func _init(item : Item,amount : int):
	self.item = item
	self.amount = amount


func getName() -> String:
	return item.name

