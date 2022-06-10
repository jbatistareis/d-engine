extends Tabs

signal changeModel(locationShortName, model, orientation)

const _DETAILS_SINGLE_TEXT = 'id: %d @ (%d, %d)'
const _DETAILS_MULTI_TEXT = 'Multiple rooms'

var locationDto : LocationDTO
var room : Dictionary = {} setget setRoom
var multiRoom : Array = []


func setRoom(value : Dictionary):
	saveLogic()
	room = value
	
	if multiRoom.empty():
		$mainContainer/model/controls/lblDetails.text = _DETAILS_SINGLE_TEXT % [room.id, room.x, room.y]
	else:
		$mainContainer/model/controls/lblDetails.text = _DETAILS_MULTI_TEXT
	
	var optModel = $mainContainer/model/controls/optModel
	for index in optModel.get_item_count():
		if optModel.get_item_text(index) == room.model:
			optModel.select(index)
			break


func saveLogic() -> void:
	if multiRoom.empty():
		setRoomFields(room)
	else:
		for singleRoom in multiRoom:
			setRoomFields(singleRoom)


func setRoomFields(data : Dictionary) -> void:
	if !data.empty():
		var enemiesText = $mainContainer/logic/Enemies/txtEnemyGroups.text.replace(' ', '')
		data.foeShortNameGroups.clear()
		for groupText in enemiesText.split('\n'):
			if !groupText.empty():
				data.foeShortNameGroups.append(groupText.split(','))
		
		data.canEnterLogic = $"mainContainer/logic/Can enter/txtCanEnter".text
		data.enteringLogic = $mainContainer/logic/Entering/txtEntering.text
		data.exitingLogic = $mainContainer/logic/Exiting/txtExiting.text


func setLogic() -> void:
	var enemyGroups = $mainContainer/logic/Enemies/txtEnemyGroups
	for group in room.foeShortNameGroups:
		if !group.empty():
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
	
	for item in Persistence.listEntities(Enums.EntityType.LOCATION_MODELS, self.locationDto.shortName):
		$mainContainer/model/controls/optModel.add_item(item)


func _on_grid_selectedRoom(room : Dictionary):
	if !room.empty():
		self.room = room
		emit_signal("changeModel", locationDto.shortName, room.model, room.orientation)
		
		clearLogic()
		setLogic()
		multiRoom.clear()


func _on_optModel_item_selected(index : int):
	if multiRoom.empty():
		room.model = $mainContainer/model/controls/optModel.get_item_text(index)
	else:
		for singleRoom in multiRoom:
			singleRoom.model = $mainContainer/model/controls/optModel.get_item_text(index)
	
	emit_signal("changeModel", locationDto.shortName, room.model, room.orientation)


func _on_parameters_tab_changed(tab : int):
	saveLogic()



func _on_grid_selectedMultiRoom(rooms : Array):
	multiRoom = rooms
	self.room = rooms[0]
	
	clearLogic()
	setLogic()

