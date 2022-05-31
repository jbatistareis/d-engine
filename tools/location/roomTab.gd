extends Tabs

const _DETAILS_TEXT = 'id: %d @ (%d, %d)'

var extensionRegex : RegEx = RegEx.new()
var locationDto : LocationDTO
var room : Dictionary = {} setget setRoom


func _init() -> void:
	extensionRegex.compile(GamePaths.EXTENSION_REGEX)


func setRoom(value : Dictionary):
	room = value
	$mainContainer/details/lblDetails.text = _DETAILS_TEXT % [room.id, room.x, room.y]
	
	var optModel = $mainContainer/scroll/parameters/model/controls/optModel
	for index in optModel.get_item_count():
		if optModel.get_item_text(index) == room.model:
			optModel.select(index)
			break


func _on_General_loadedLocationDto(locationDto : LocationDTO):
	self.locationDto = locationDto
	$mainContainer/scroll/parameters/model/controls/optModel.items.clear()
	
	var dir = Directory.new()
	if dir.open(GamePaths.LOCATION_MODELS % self.locationDto.shortName) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		
		while !file.empty():
			if !dir.current_is_dir():
				$mainContainer/scroll/parameters/model/controls/optModel.add_item(extensionRegex.sub(file, ''))
			file = dir.get_next()


func _on_grid_selectedRoom(room : Dictionary):
	if !room.empty():
		self.room = room


func _on_optModel_item_selected(index : int):
	room.model = $mainContainer/scroll/parameters/model/controls/optModel.get_item_text(index)
