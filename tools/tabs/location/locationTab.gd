extends HSplitContainer

const _ENCOUNTER_LABEL : String = "Enc.: %3d%% "
var _cellScene : PackedScene = preload("res://tools/tabs/location/cell.tscn")

var location : LocationDTO : set = setLocation
var selectedRooms : Array = [] : set = setSelectedRooms


func _ready() -> void:
	self.location = LocationDTO.new()
	
	ToolSignals.hoveredRoom.connect(hoveredRoom)
	
	$parameters/tabs/Room/tabs/Tile/container/parameters/settings/appearenceGrid/optType.valuesFunc = func():
		return ["None", "0 Exits", "1 Exit", "2 Exits I", "2 Exits L", "3 Exits", "4 Exits"]
	
	$parameters/tabs/Room/tabs/Tile/container/parameters/settings/appearenceGrid/optModel.valuesFunc = func():
		return Persistence.listEntities(Enums.EntityType.LOCATION_MODELS, self.location.shortName)
	
	fillRooms()



# general
func setLocation(value : LocationDTO) -> void:
	location = value
	
	$parameters/tabs/General/parameters/idGrid/txtName.dto = location
	$parameters/tabs/General/parameters/idGrid/txtShortname.dto = location
	$parameters/tabs/General/parameters/idGrid/txtDescription.dto = location
	$parameters/tabs/General/parameters/idGrid/sldEnc.value = location.encounterRate


func setSelectedRooms(value : Array) -> void:
	selectedRooms = value
	
	$parameters/tabs/Room/tabs/Tile/container/parameters/settings/appearenceGrid/optType.multiDto = selectedRooms
	$parameters/tabs/Room/tabs/Tile/container/parameters/settings/appearenceGrid/optModel.multiDto = selectedRooms
	
	$"parameters/tabs/Room/tabs/Entry check/cdeEntry".multiDto = selectedRooms
	$"parameters/tabs/Room/tabs/Entrance logic/cdeEntrance".multiDto = selectedRooms
	$"parameters/tabs/Room/tabs/Exit logic/cdeExit".multiDto = selectedRooms


func _on_sld_enc_value_changed(value: float) -> void:
	$parameters/tabs/General/parameters/idGrid/lblEnc.text = _ENCOUNTER_LABEL % (100 * value)
	location.encounterRate = value


func hoveredRoom(room : Dictionary) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		self.selectedRooms = [room]
		
		ToolSignals.selectedRooms.emit(selectedRooms)
		$parameters/tabs.current_tab = 1
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if !selectedRooms.has(room):
			self.selectedRooms += [room]
		ToolSignals.selectedRooms.emit(selectedRooms)
		$parameters/tabs.current_tab = 1


func fillRooms() -> void:
	for child in $map/grid.get_children():
		child.queue_free()
	
	for i in range(pow($map/grid.columns, 2)):
		var cell = _cellScene.instantiate()
		cell.room.id = i
		cell.room.x = (i % $map/grid.columns)
		cell.room.y = (i / $map/grid.columns)
		
		$map/grid.add_child(cell)


# room direction
func _on_btn_north_pressed() -> void:
	for room in selectedRooms:
		room.orientation = Enums.Direction.NORTH


func _on_btn_west_pressed() -> void:
	for room in selectedRooms:
		room.orientation = Enums.Direction.WEST


func _on_btn_east_pressed() -> void:
	for room in selectedRooms:
		room.orientation = Enums.Direction.EAST


func _on_btn_south_pressed() -> void:
	for room in selectedRooms:
		room.orientation = Enums.Direction.SOUTH



# controls
func _on_btn_autotile_pressed() -> void:
	for item in selectedRooms:
		var room = DefaultValues.roomBase.duplicate(true)
		room.id = item.id
		room.x = item.x
		room.y = item.y
		
		var value = 0
		
		for direction in range(4): # 6 for up/down
			var index = 0
			
			if direction == Enums.Direction.NORTH:
				index = room.x + (room.y - 1) * $map/grid.columns
			elif direction == Enums.Direction.EAST:
				index = (room.x + 1) + room.y * $map/grid.columns
			elif direction == Enums.Direction.SOUTH:
				index = room.x + (room.y + 1) * $map/grid.columns
			elif direction == Enums.Direction.WEST:
				index = (room.x - 1) + room.y * $map/grid.columns
			
			if index < 0:
				continue
			
			for cell in selectedRooms:
				if (cell.id == index) || ($map/grid.get_child(index).room.type != Enums.RoomType.DUMMY):
					value += DefaultValues.BitmaskDirections[direction]
					break
		
		if value > 0:
			room.type = DefaultValues.BimaskTileset[value].type
			room.orientation = DefaultValues.BimaskTileset[value].orientation
			room.model = DefaultValues.BimaskTileset[value].model
			
			if $map/grid.get_child(room.id).room.type == Enums.RoomType.DUMMY:
				$map/grid.get_child(room.id).room = room
			else:
				$map/grid.get_child(room.id).room.type = DefaultValues.BimaskTileset[value].type
				$map/grid.get_child(room.id).room.orientation = DefaultValues.BimaskTileset[value].orientation
				$map/grid.get_child(room.id).room.model = DefaultValues.BimaskTileset[value].model
		
		value = 0


func _on_btn_rotate_left_pressed() -> void:
	pass # Replace with function body.


func _on_btn_rotate_right_pressed() -> void:
	pass # Replace with function body.


func _on_btn_delete_pressed() -> void:
	for room in self.selectedRooms:
		room.type = Enums.RoomType.DUMMY


# persistence
func _on_btn_open_pressed() -> void:
	pass


func _on_btn_save_pressed() -> void:
	pass


func _on_btn_preview_pressed() -> void:
	pass

