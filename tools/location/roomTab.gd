extends Tabs

signal changeModel(locationShortName, model, orientation)

const _DETAILS_SINGLE_TEXT = 'id: %d @ (%d, %d)'
const _DETAILS_MULTI_TEXT = 'Multiple rooms'

var locationDto : LocationDTO
var rooms : Array = [] setget setRooms

onready var grid : GridContainer = get_node("../../map/scroll/container/grid")


func setRooms(value : Array):
	changeCellSelection(false)
	
	rooms = value
	
	changeCellSelection(true)
	
	if (rooms.size() == 1) &&  !rooms[0].empty():
		$mainContainer/model/controls/lblDetails.text = _DETAILS_SINGLE_TEXT % [rooms[0].id, rooms[0].x, rooms[0].y]
	elif rooms.size() > 1:
		$mainContainer/model/controls/lblDetails.text = _DETAILS_MULTI_TEXT
	
	var optModel = $mainContainer/model/controls/optModel
	for index in optModel.get_item_count():
		if !rooms[0].empty() && (optModel.get_item_text(index) == rooms[0].model):
			optModel.select(index)
			break


func changeCellSelection(state : bool) -> void:
	for room in rooms:
		if !room.empty():
			grid.get_child(room.id).select(state, false)


func saveLogic() -> void:
	for singleRoom in rooms:
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
	if !rooms.empty() && !rooms[0].empty():
		var enemyGroups = $mainContainer/logic/Enemies/txtEnemyGroups
		for group in rooms[0].foeShortNameGroups:
			if !group.empty():
				var line = ''
				for enemy in group:
					line += enemy + ', '
				
				enemyGroups.text += line.substr(0, line.length() - 2) + '\n'
		
		enemyGroups.text = enemyGroups.text.substr(0, enemyGroups.text.length() - 1)
		
		$"mainContainer/logic/Can enter/txtCanEnter".text = rooms[0].canEnterLogic
		$mainContainer/logic/Entering/txtEntering.text = rooms[0].enteringLogic
		$mainContainer/logic/Exiting/txtExiting.text = rooms[0].exitingLogic


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


func _on_optModel_item_selected(index : int):
	for singleRoom in rooms:
		singleRoom.model = $mainContainer/model/controls/optModel.get_item_text(index)
	
	emit_signal("changeModel", locationDto.shortName, rooms[0].model, rooms[0].orientation)


func _on_grid_selectedMultiRoom(rooms : Array):
	if !rooms[0].empty():
		self.rooms = rooms
		emit_signal("changeModel", locationDto.shortName, rooms[0].model, rooms[0].orientation)
		
		clearLogic()
		setLogic()


func _on_btnSave_pressed():
	saveLogic()


func _on_btnBitmask_pressed():
	for item in grid.altSelection:
		var room = DefaultValues.roomBase
		room.id = item.id
		room.x = item.x
		room.y = item.y
		
		var value = 0
		
		for direction in range(4): # 6 for up/down
			var index = 0
			
			if direction == Enums.Direction.NORTH:
				index = room.x + (room.y - 1) * grid.columns
			elif direction == Enums.Direction.EAST:
				index = (room.x + 1) + room.y * grid.columns
			elif direction == Enums.Direction.SOUTH:
				index = room.x + (room.y + 1) * grid.columns
			elif direction == Enums.Direction.WEST:
				index = (room.x - 1) + room.y * grid.columns
			
			if index < 1:
				break
			
			for cell in grid.altSelection:
				if (cell.id == index) || !grid.get_child(index).room.empty():
					value += DefaultValues.BitmaskDirections[direction]
					break
		
		if value > 0:
			room.type = DefaultValues.BimaskTileset[value].type
			room.orientation = DefaultValues.BimaskTileset[value].orientation
			room.model = DefaultValues.BimaskTileset[value].model
			
			if grid.get_child(room.id).room.empty():
				grid.get_child(room.id).room = room
			else:
				grid.get_child(room.id).room.type = DefaultValues.BimaskTileset[value].type
				grid.get_child(room.id).room.orientation = DefaultValues.BimaskTileset[value].orientation
				grid.get_child(room.id).room.model = DefaultValues.BimaskTileset[value].model

		
		value = 0


func _on_btnDelete_pressed():
	for item in grid.altSelection:
		grid.get_child(item.id).room = {}

