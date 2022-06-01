extends Tabs

signal changeModel(locationShortName, model, orientation)

const _DETAILS_TEXT = 'id: %d @ (%d, %d)'

var extensionRegex : RegEx = RegEx.new()
var locationDto : LocationDTO
var room : Dictionary = {} setget setRoom


func _init() -> void:
	extensionRegex.compile(GamePaths.EXTENSION_REGEX)


func setRoom(value : Dictionary):
	saveLogic()
	room = value
	$mainContainer/model/controls/lblDetails.text = _DETAILS_TEXT % [room.id, room.x, room.y]
	
	var optModel = $mainContainer/model/controls/optModel
	for index in optModel.get_item_count():
		if optModel.get_item_text(index) == room.model:
			optModel.select(index)
			break


func saveLogic() -> void:
	if !room.empty():
		var enemiesText = $mainContainer/logic/Enemies/txtEnemyGroups.text.replace(' ', '')
		room.foeShortNameGroups.clear()
		for groupText in enemiesText.split('\n'):
			room.foeShortNameGroups.append(groupText.split(','))
		
		room.canEnterLogic = $"mainContainer/logic/Can enter/txtCanEnter".text
		room.enteringLogic = $mainContainer/logic/Entering/txtEntering.text
		room.exitingLogic = $mainContainer/logic/Exiting/txtExiting.text


func setLogic() -> void:
	var enemyGroups = $mainContainer/logic/Enemies/txtEnemyGroups
	for group in room.foeShortNameGroups:
		var line = ''
		for enemy in group:
			line += enemy + ', '
		
		enemyGroups.text += line.substr(0, line.length() - 2) + '\n'
	
	enemyGroups.text = enemyGroups.text.substr(0, enemyGroups.text.length() - 1)
	
	$"mainContainer/logic/Can enter/txtCanEnter".text = room.canEnterLogic
	$mainContainer/logic/Entering/txtEntering.text = room.enteringLogic
	$mainContainer/logic/Exiting/txtExiting.text = room.exitingLogic


func clearLogic() -> void:
	$mainContainer/logic/Enemies/txtEnemyGroups.text = ''
	$"mainContainer/logic/Can enter/txtCanEnter".text = ''
	$mainContainer/logic/Entering/txtEntering.text = ''
	$mainContainer/logic/Exiting/txtExiting.text = ''


func _on_General_loadedLocationDto(locationDto : LocationDTO):
	self.locationDto = locationDto
	$mainContainer/model/controls/optModel.items.clear()
	
	var dir = Directory.new()
	if dir.open(GamePaths.LOCATION_MODELS % self.locationDto.shortName) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		
		while !file.empty():
			if !dir.current_is_dir():
				$mainContainer/model/controls/optModel.add_item(extensionRegex.sub(file, ''))
			file = dir.get_next()


func _on_grid_selectedRoom(room : Dictionary):
	if !room.empty():
		self.room = room
		emit_signal("changeModel", locationDto.shortName, room.model, room.orientation)
		
		clearLogic()
		setLogic()


func _on_optModel_item_selected(index : int):
	room.model = $mainContainer/model/controls/optModel.get_item_text(index)
	emit_signal("changeModel", locationDto.shortName, room.model, room.orientation)


func _on_parameters_tab_changed(tab):
	saveLogic()

