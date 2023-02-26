extends OptionButton

@export
var parameter : String
@export_enum("Integer", "String")
var dataType : int = 0

var dto : DTO :
	set(value):
		dto = value
		
		if (dataType == 0):
			select(dto[parameter])
		elif !dto[parameter].is_empty():
			select(itemList.find(dto[parameter]))
		else:
			select(0)
		
		disabled = (dto == null)

var itemList : Array :
	set(value):
		itemList.clear()
		clear()
		
		itemList = value
		for item in itemList:
			add_item(item)


func _ready() -> void:
	item_selected.connect(func(index): dto[parameter] = _getDtoPropertyValue(index))


func _getDtoPropertyValue(index : int):
	if (dataType == 0):
		return index
	else:
		return "" if (get_item_text(index) == "None") else itemList[itemList.find(index)]

