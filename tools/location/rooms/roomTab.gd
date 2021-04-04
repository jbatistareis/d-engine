extends Tabs

var txtGroupRegex : RegEx = RegEx.new()
var room : Room setget setRoom

var portalFields : Array = []


func _ready() -> void:
	self.room = null
	txtGroupRegex.compile('(,$)|(,[\n\r])')
	
	LocationEditorSignals.connect("selectedRoom", self, "setRoom")
	$VBoxContainer/ScrollContainer/VBoxContainer/mesh/spnMesh.connect("value_changed", self, "setMesh")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.connect("value_changed", self, "setNorthPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.connect("value_changed", self, "setEastPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.connect("value_changed", self, "setSouthPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.connect("value_changed", self, "setWestPortal")
	$VBoxContainer/ScrollContainer/VBoxContainer/alert/sldAlert.connect("value_changed", self, "changeAlertLabel")
	$VBoxContainer/ScrollContainer/VBoxContainer/enemies/txtEnemyGroups.connect("text_changed", self, "txt2EnemyGroups")
	$VBoxContainer/ScrollContainer/VBoxContainer/friendNpcs/txtFriendNpcs.connect("text_changed", self, "txt2FriendlyGroup")
	$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtEntranceLogic.connect("text_changed", self, "setEntranceLogic")
	$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtExitLogic.connect("text_changed", self, "setExitLogic")
	
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal)
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal)
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal)
	portalFields.append($VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal)


func setRoom(value : Room) -> void:
	room = value
	get_parent().set_tab_disabled(1, (room == null))
	get_parent().current_tab = 0 if (room == null) else 1
	
	if room != null:
		$VBoxContainer/HBoxContainer/lblId.text = ('ID: %d  /  x: %d, y: %d' % [room.id, room.x, room.y])
		$VBoxContainer/ScrollContainer/VBoxContainer/mesh/spnMesh.value = room.mesh
		$VBoxContainer/ScrollContainer/VBoxContainer/alert/sldAlert.value = room.alert
		$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtEntranceLogic.text = room.entranceLogic
		$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtExitLogic.text = room.exitLogic
		
		for i in portalFields.size():
			portalFields[i].value = room.getPortal(i)
		
		enemyGroups2Txt()
		friendlyGroup2Txt()
		
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


func setMesh(value : float) -> void:
	if room != null:
		room.mesh = int(value)


func setNorthPortal(value : float) -> void:
	if room != null:
		room.portals[Enums.Direction.NORTH] = int(value)


func setEastPortal(value : float) -> void:
	if room != null:
		room.portals[Enums.Direction.EAST] = int(value)


func setSouthPortal(value : float) -> void:
	if room != null:
		room.portals[Enums.Direction.SOUTH] = int(value)


func setWestPortal(value : float) -> void:
	if room != null:
		room.portals[Enums.Direction.WEST] = int(value)


func changeAlertLabel(value : float) -> void:
	if room != null:
		room.alert = value
	
	$VBoxContainer/ScrollContainer/VBoxContainer/alert/lblAlert.text = ('Alert: %d' % (value * 100)) + '%'


func enemyGroups2Txt() -> void:
	var result = ''
	
	for group in room.foeShortNameGroups:
		if !group.empty():
			for enemy in group:
				result += enemy + ','
			result += '\n'
	
	result = txtGroupRegex.sub(result, '\n', true)
	
	$VBoxContainer/ScrollContainer/VBoxContainer/enemies/txtEnemyGroups.text = result


func txt2EnemyGroups() -> void:
	if room != null:
		var result = []
		var text = $VBoxContainer/ScrollContainer/VBoxContainer/enemies/txtEnemyGroups.text
		text = txtGroupRegex.sub(text, '', true)
		
		if !text.empty():
			for txtGroup in text.split('\n'):
				if !txtGroup.empty():
					var group = []
					result.append(group)
					
					for txtEnemy in txtGroup.split(','):
						group.append(txtEnemy)
		
		room.foeShortNameGroups = result


func friendlyGroup2Txt() -> void:
	var result = ''
	
	for txtFriend in room.friendlyShortNames:
		result += txtFriend + ','
	
	result = txtGroupRegex.sub(result, '', true)
	
	$VBoxContainer/ScrollContainer/VBoxContainer/friendNpcs/txtFriendNpcs.text = result


func txt2FriendlyGroup(text : String) -> void:
	if room != null:
		var result = []
		text = txtGroupRegex.sub(text, '', true)
		
		if !text.empty():
			for txtFriend in text.split(','):
				result.append(txtFriend)
		
		if room != null:
			room.friendlyShortNames = result


func setEntranceLogic() -> void:
	if room != null:
		room.entranceLogic = $VBoxContainer/ScrollContainer/VBoxContainer/logic/txtEntranceLogic.text


func setExitLogic() -> void:
	if room != null:
		room.exitLogic = $VBoxContainer/ScrollContainer/VBoxContainer/logic/txtExitLogic.text


func setPortalFieldsState(room : Room, directions : Array) -> void:
	for i in portalFields.size():
		if directions.has(i):
			portalFields[i].editable = true
			portalFields[i].modulate.a = 1
		else:
			portalFields[i].editable = false
			portalFields[i].modulate.a = 0.5

