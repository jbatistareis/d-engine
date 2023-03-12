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
		
		_itemList = valuesFunc.call()
		clear()
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

var multiDto : Array = [] :
	set(value):
		multiDto = value
		
		_itemList = valuesFunc.call()
		clear()
		for item in _itemList:
			add_item(item)
		
		if multiDto.is_empty():
			select(-1)
		else:
			match dataType:
				0:
					select(multiDto[0][property])
				
				1:
					var index = _itemList.find(multiDto[0][property]) 
					select(index if (index > -1) else 0)
		
		disabled = multiDto.is_empty()


func _ready() -> void:
	item_selected.connect(
		func(index):
			if dto != null:
				dto[property] = _getDtoPropertyValue(index)
			else:
				var value = _getDtoPropertyValue(index)
				for dto in multiDto:
					dto[property] = value)


func _getDtoPropertyValue(index : int):
	match dataType:
		0:
			return index
		
		1:
			return "" if (get_item_text(index) == "None") else _itemList[index]

