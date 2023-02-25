extends HBoxContainer

@export
var dtoType : Enums.EntityType
@export
var parametersScene : PackedScene

var list : Array


func _ready() -> void:
	var parameters = parametersScene.instantiate()
	parameters.name = "parameters"
	$fields/container/scroll.add_child(parameters)
	
	reload()
	$fields/container/persistenceBtns.reloadFunc = reload
	$files.item_selected.connect(itemSelected)


func reload() -> void:
	list.clear()
	$files.clear()
	
	list = Persistence.listEntities(dtoType)
	
	for item in list:
		$files.add_item(item)


func itemSelected(index : int) -> void:
	var dto = Persistence.loadDTO(list[index], dtoType)
	$fields/container/scroll/parameters.dto = dto
	$fields/container/persistenceBtns.dto = dto

