extends HBoxContainer

@export
var dtoType : Enums.EntityType
@export
var parametersScene : PackedScene

var list : Array
var currentIndex : int = -1


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
	if list.is_empty():
		return
	
	for item in list:
		$files.add_item(item)
	
	if currentIndex == -1:
		currentIndex = 0
	else:
		currentIndex = clamp(currentIndex, 0, list.size() - 1)
	
	$files.select(currentIndex)
	itemSelected(currentIndex)


func itemSelected(index : int) -> void:
	var dto = Persistence.loadDTO(list[index], dtoType)
	$fields/container/scroll/parameters.dto = dto
	$fields/container/persistenceBtns.dto = dto
	
	currentIndex = index

