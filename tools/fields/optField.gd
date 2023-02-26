extends OptionButton

@export
var property : String
@export_enum("Integer", "String")
var dataType : int = 0
var valuesFunc : Callable = Callable(func(): return [])
var _itemList : Array


var dto : DTO :
	set(value):
		dto = value
		
		clear()
		_itemList = valuesFunc.call()
		for item in _itemList:
			add_item(item)
		
		if dto == null:
			select(-1)
		else:
			match dataType:
				0:
					select(dto[property])
				
				1:
					var index = _itemList.find(dto[property]) 
					select(index if (index > -1) else 0)
		
		disabled = (dto == null)


func _ready() -> void:
	item_selected.connect(func(index): dto[property] = _getDtoPropertyValue(index))


func _getDtoPropertyValue(index : int):
	match dataType:
		0:
			return index
		
		1:
			return "" if (get_item_text(index) == "None") else _itemList[_itemList.find(index)]
	
	return null

