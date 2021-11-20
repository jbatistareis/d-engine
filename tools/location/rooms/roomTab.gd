extends Tabs

var txtGroupRegex : RegEx = RegEx.new()
var rooms : Array = []

var portalFields : Array = []


func _ready() -> void:
	get_parent().set_tab_disabled(1, true)
	get_parent().connect("tab_changed", self, "loadMeshes")
	
	txtGroupRegex.compile('(,$)|(,[\n\r])')
	
	LocationEditorSignals.connect("selectedRoom", self, "addRoom")
	LocationEditorSignals.connect("deselectedRoom", self, "removeRoom")
	
	$VBoxContainer/ScrollContainer/VBoxContainer/mesh/cmbMesh.connect("item_selected", self, "setMesh")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.connect("value_changed", self, "setNorthPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.connect("value_changed", self, "setEastPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.connect("value_changed", self, "setWestPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.connect("value_changed", self, "setSouthPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/alert/sldAlert.connect("value_changed", self, "changeAlertLabel")
	$VBoxContainer/ScrollContainer/VBoxContainer/enemies/txtEnemyGroups.connect("text_changed", self, "txt2EnemyGroups")
	$VBoxContainer/ScrollContainer/VBoxContainer/friendNpcs/txtFriendNpcs.connect("text_changed", self, "txt2FriendlyGroup")
	$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtEntranceLogic.connect("text_changed", self, "setEntranceLogic")
	$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtExitLogic.connect("text_changed", self, "setExitLogic")
	
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal)
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal)
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal)
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal)


func loadMeshes(tabId : int) -> void:
	if tabId == 1:
		var previewArea = $VBoxContainer/ScrollContainer/VBoxContainer/ViewportContainer/preview/area
		previewArea.blocks.clear()
		
		var shortName = $"../Location/VBoxContainer/GridContainer/txtShortName".text
		var directory = Directory.new()
		var path = GamePaths.MAP_DATA % (shortName if !shortName.empty() else 'baseLocation')
		
		directory.open(path)
		directory.list_dir_begin(true, true)
		
		var filename = directory.get_next()
		while !filename.empty():
			if filename.ends_with('.tscn'):
				previewArea.blocks[filename.substr(0, filename.find_last('.'))] = load(path + '/' + filename)
			filename = directory.get_next()
		
		for key in previewArea.blocks.keys():
			$VBoxContainer/ScrollContainer/VBoxContainer/mesh/cmbMesh.add_item(key)


func enableTab(value : bool) -> void:
	get_parent().set_tab_disabled(1, value)
	get_parent().current_tab = 0 if value else 1


func setRoom(room : RoomTile) -> void:
	$VBoxContainer/HBoxContainer/lblId.text = ('ID: %d  /  x: %d, y: %d' % [room.id, room.x, room.y])
	
	for id in $VBoxContainer/ScrollContainer/VBoxContainer/mesh/cmbMesh.get_item_count():
		if $VBoxContainer/ScrollContainer/VBoxContainer/mesh/cmbMesh.get_item_text(id) == room.mesh:
			$VBoxContainer/ScrollContainer/VBoxContainer/mesh/cmbMesh.select(id)
			break
	
	$VBoxContainer/ScrollContainer/VBoxContainer/alert/sldAlert.value = room.alert
	$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtEntranceLogic.text = room.entranceLogic
	$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtExitLogic.text = room.exitLogic
	
	for i in portalFields.size():
		portalFields[i].value = room.getPortal(i)
	
	enemyGroups2Txt(room)
	friendlyGroup2Txt(room)
	
	match room.type:
		Enums.RoomType._1_EXIT:
			setPortalFieldsState(room, [room.orientation])
		
		Enums.RoomType._2_EXITS_I:
			if (room.orientation == Enums.Direction.NORTH) || (room.orientation == Enums.Direction.SOUTH):
				setPortalFieldsState(room, [Enums.Direction.NORTH, Enums.Direction.SOUTH])
			
			elif (room.orientation == Enums.Direction.EAST) || (room.orientation == Enums.Direction.WEST):
				setPortalFieldsState(room, [Enums.Direction.EAST, Enums.Direction.WEST])
		
		Enums.RoomType._2_EXITS_L:
			match room.orientation:
				Enums.Direction.NORTH:
					setPortalFieldsState(room, [Enums.Direction.NORTH, Enums.Direction.EAST])
				
				Enums.Direction.EAST:
					setPortalFieldsState(room, [Enums.Direction.EAST, Enums.Direction.SOUTH])
				
				Enums.Direction.SOUTH:
					setPortalFieldsState(room, [Enums.Direction.SOUTH, Enums.Direction.WEST])
				
				Enums.Direction.WEST:
					setPortalFieldsState(room, [Enums.Direction.WEST, Enums.Direction.NORTH])
		
		Enums.RoomType._3_EXITS:
			match room.orientation:
				Enums.Direction.NORTH:
					setPortalFieldsState(room, [Enums.Direction.WEST, Enums.Direction.NORTH, Enums.Direction.EAST])
				
				Enums.Direction.EAST:
					setPortalFieldsState(room, [Enums.Direction.NORTH, Enums.Direction.EAST, Enums.Direction.SOUTH])
				
				Enums.Direction.SOUTH:
					setPortalFieldsState(room, [Enums.Direction.EAST, Enums.Direction.SOUTH, Enums.Direction.WEST])
				
				Enums.Direction.WEST:
					setPortalFieldsState(room, [Enums.Direction.SOUTH, Enums.Direction.WEST, Enums.Direction.NORTH])
		
		Enums.RoomType._4_EXITS:
			setPortalFieldsState(room, [Enums.Direction.NORTH, Enums.Direction.EAST, Enums.Direction.SOUTH, Enums.Direction.WEST])
		
		_: # _0_EXITS
			setPortalFieldsState(room, [])


func addRoom(room : RoomTile, soloSelect : bool) -> void:
	if (room != null):
		if soloSelect:
			for room in rooms:
				LocationEditorSignals.emit_signal("deselectedItem", room)
			rooms.clear()
		
		if !rooms.has(room):
			rooms.push_back(room)
		
		setRoom(room)
		LocationEditorSignals.emit_signal("selectedItem", room)
	
	enableTab(room == null)


func removeRoom(room : RoomTile) -> void:
	if rooms.has(room):
		var oldIndex = rooms.find(room)
		rooms.erase(room)
		
		if oldIndex >= 1:
			setRoom(rooms[oldIndex - 1])
		elif !rooms.empty():
			setRoom(rooms[0])
	
	enableTab(rooms.empty())


func setMesh(value : int) -> void:
	var mesh = $VBoxContainer/ScrollContainer/VBoxContainer/mesh/cmbMesh.get_item_text(value)
	
	for room in rooms:
		room.mesh = mesh
	
	LocationEditorSignals.emit_signal("changedRoomMesh", rooms[rooms.size() - 1], true)


func setNorthPortal(value : float) -> void:
	for room in rooms:
		room.portals[Enums.Direction.NORTH] = int(value)


func setEastPortal(value : float) -> void:
	for room in rooms:
		room.portals[Enums.Direction.EAST] = int(value)


func setSouthPortal(value : float) -> void:
	for room in rooms:
		room.portals[Enums.Direction.SOUTH] = int(value)


func setWestPortal(value : float) -> void:
	for room in rooms:
		room.portals[Enums.Direction.WEST] = int(value)


func changeAlertLabel(value : float) -> void:
	for room in rooms:
		room.alert = value
	
	$VBoxContainer/ScrollContainer/VBoxContainer/alert/lblAlert.text = ('Alert: %d' % (value * 100)) + '%'


func enemyGroups2Txt(room : RoomTile) -> void:
	var result = ''
	
	for group in room.foeShortNameGroups:
		if !group.empty():
			for enemy in group:
				result += enemy + ','
			result += '\n'
	
	result = txtGroupRegex.sub(result, '\n', true)
	
	$VBoxContainer/ScrollContainer/VBoxContainer/enemies/txtEnemyGroups.text = result


func txt2EnemyGroups() -> void:
	var result = []
	var text = $VBoxContainer/ScrollContainer/VBoxContainer/enemies/txtEnemyGroups.text
	text = txtGroupRegex.sub(text, '', true).replace(' ', '')
	
	if !text.empty():
		for txtGroup in text.split('\n'):
			if !txtGroup.empty():
				var group = []
				result.append(group)
				
				for txtEnemy in txtGroup.split(','):
					group.append(txtEnemy)
	
	for room in rooms:
		room.foeShortNameGroups = result


func friendlyGroup2Txt(room : RoomTile) -> void:
	var result = ''
	
	for txtFriend in room.friendlyShortNames:
		result += txtFriend + ','
	
	result = txtGroupRegex.sub(result, '', true)
	
	$VBoxContainer/ScrollContainer/VBoxContainer/friendNpcs/txtFriendNpcs.text = result


func txt2FriendlyGroup(text : String) -> void:
	var result = []
	text = txtGroupRegex.sub(text, '', true)
	
	if !text.empty():
		for txtFriend in text.split(','):
			result.append(txtFriend)
	
	for room in rooms:
		room.friendlyShortNames = result


func setEntranceLogic() -> void:
	for room in rooms:
		room.entranceLogic = $VBoxContainer/ScrollContainer/VBoxContainer/logic/txtEntranceLogic.text


func setExitLogic() -> void:
	for room in rooms:
		room.exitLogic = $VBoxContainer/ScrollContainer/VBoxContainer/logic/txtExitLogic.text


func setPortalFieldsState(room : RoomTile, directions : Array) -> void:
	for i in portalFields.size():
		if directions.has(i):
			portalFields[i].editable = true
			portalFields[i].modulate.a = 1
		else:
			portalFields[i].editable = false
			portalFields[i].modulate.a = 0.5

