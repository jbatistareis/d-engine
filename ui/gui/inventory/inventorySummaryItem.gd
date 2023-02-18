class_name InventorySummaryItem

var item : Entity
var amount : int

var name : String : get = getName


func _init(item : Entity, amount : int):
	self.item = item
	self.amount = amount


func getName() -> String:
	return item.name

