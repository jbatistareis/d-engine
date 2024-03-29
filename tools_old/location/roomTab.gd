extends TabBar

signal changeModel(locationShortName, model, orientation)

const _DETAILS_SINGLE_TEXT = 'id: %d @ (%d, %d)'
const _DETAILS_MULTI_TEXT = 'Multiple rooms'

var locationDto : LocationDTO
var rooms : Array = [] : set = setRooms

@onready var grid : GridContainer = get_node("../../map/scroll/container/grid")


func _ready() -> void:
	EditorSignals.connect("mapSelectedRoom",Callable(self,"selectedRoom"))
	EditorSignals.connect("mapSelectedMultiRooms",Callable(self,"selectedMultiRooms"))


func setRooms(value : Array):
	rooms = value
	
	if rooms.size() == 1:
		$mainContainer/model/controls/lblDetails.text = _DETAILS_SINGLE_TEXT % [rooms[0].id, rooms[0].x, rooms[0].y]
	else:
		$mainContainer/model/controls/lblDetails.text = _DETAILS_MULTI_TEXT
	
	var optModel = $mainContainer/model/controls/optModel
	for index in optModel.get_item_count():
		if (rooms[0].type != Enums.RoomType.DUMMY) && (optModel.get_item_text(index) == rooms[0].model):
			optModel.select(index)
			break


func saveLogic() -> void:
	for singleRoom in rooms:
		setRoomFields(singleRoom)


func setRoomFields(room : Dictionary) -> void:
	var enemiesText = $mainContainer/logic/Enemies/txtEnemyGroups.text.replace(' ', '')
	room.foeShortNameGroups.clear()
	for groupText in enemiesText.split('\n'):
		if !groupText.is_empty():
			room.foeShortNameGroups.append(groupText.split(','))
	
	room.canEnterLogic = $"mainContainer/logic/Can enter/txtCanEnter".text
	room.enteringLogic = $mainContainer/logic/Entering/txtEntering.text
	room.exitingLogic = $mainContainer/logic/Exiting/txtExiting.text


func setLogic() -> void:
	if rooms[0].type != Enums.RoomType.DUMMY:
		var enemyGroups = $mainContainer/logic/Enemies/txtEnemyGroups
		for group in rooms[0].foeShortNameGroups:
			if !group.is_empty():
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


func selectedRoom(room : Dictionary):
	if room.type != Enums.RoomType.DUMMY:
		self.rooms = [room]
		emit_signal("changeModel", locationDto.shortName, room.model, room.orientation)
	
		clearLogic()
		setLogic()


func selectedMultiRooms(rooms : Array):
	self.rooms = rooms
	emit_signal("changeModel", locationDto.shortName, rooms[0].model, rooms[0].orientation)
	
	clearLogic()
	setLogic()


func _on_btnSave_pressed():
	saveLogic()


func _on_btnBitmask_pressed():
	for item in grid.multiRooms:
		var room = DefaultValues.roomBase.duplicate(true)
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
			
			if index < 0:
				continue
			
			for cell in grid.multiRooms:
				if (cell.id == index) || (grid.get_child(index).room.type != Enums.RoomType.DUMMY):
					value += DefaultValues.BitmaskDirections[direction]
					break
		
		if value > 0:
			room.type = DefaultValues.BimaskTileset[value].type
			room.orientation = DefaultValues.BimaskTileset[value].orientation
			room.model = DefaultValues.BimaskTileset[value].model
			
			if grid.get_child(room.id).room.type == Enums.RoomType.DUMMY:
				grid.get_child(room.id).room = room
			else:
				grid.get_child(room.id).room.type = DefaultValues.BimaskTileset[value].type
				grid.get_child(room.id).room.orientation = DefaultValues.BimaskTileset[value].orientation
				grid.get_child(room.id).room.model = DefaultValues.BimaskTileset[value].model

		
		value = 0


func _on_btnDelete_pressed():
	for item in grid.multiRooms:
		grid.get_child(item.id).room = DefaultValues.roomBase

