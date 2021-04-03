extends Tabs

var txtGroupRegex : RegEx = RegEx.new()
var room : Room setget setRoom


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


func setRoom(value : Room) -> void:
	room = value
	get_parent().set_tab_disabled(1, (room == null))
	get_parent().current_tab = 0 if (room == null) else 1
	
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = false
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = false
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = false
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = false
	
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 0.5
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 0.5
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 0.5
	$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 0.5
	
	if room != null:
		$VBoxContainer/HBoxContainer/lblId.text = ('ID: %d  /  x: %d, y: %d' % [room.id, room.x, room.y])
		$VBoxContainer/ScrollContainer/VBoxContainer/mesh/spnMesh.value = room.mesh
		$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.value = room.getPortal(Enums.Direction.NORTH)
		$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.value = room.getPortal(Enums.Direction.EAST)
		$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.value = room.getPortal(Enums.Direction.WEST)
		$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.value = room.getPortal(Enums.Direction.SOUTH)
		$VBoxContainer/ScrollContainer/VBoxContainer/alert/sldAlert.value = room.alert
		enemyGroups2Txt()
		friendlyGroup2Txt()
		$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtEntranceLogic.text = room.entranceLogic
		$VBoxContainer/ScrollContainer/VBoxContainer/logic/txtExitLogic.text = room.exitLogic
		
		match room.type:
			Enums.RoomType._1_EXIT:
				match room.orientation:
					Enums.Direction.NORTH:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
						
					Enums.Direction.EAST:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
						
					Enums.Direction.SOUTH:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
						
					Enums.Direction.WEST:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
			
			Enums.RoomType._2_EXITS_I:
				if (room.orientation == Enums.Direction.NORTH) || (room.orientation == Enums.Direction.SOUTH):
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
					
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
				
				elif (room.orientation == Enums.Direction.EAST) || (room.orientation == Enums.Direction.WEST):
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
					
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
					$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
			
			Enums.RoomType._2_EXITS_L:
				match room.orientation:
					Enums.Direction.NORTH:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
					
					Enums.Direction.EAST:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
					
					Enums.Direction.SOUTH:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
					
					Enums.Direction.WEST:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
			
			Enums.RoomType._3_EXITS:
				match room.orientation:
					Enums.Direction.NORTH:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
					
					Enums.Direction.EAST:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
					
					Enums.Direction.SOUTH:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
					
					Enums.Direction.WEST:
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
						
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
						$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
			
			Enums.RoomType._4_EXITS:
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.editable = true
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.editable = true
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.editable = true
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.editable = true
				
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnEastPortal.modulate.a = 1
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/eastWest/spnWestPortal.modulate.a = 1
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/north/spnNorthPortal.modulate.a = 1
				$VBoxContainer/ScrollContainer/VBoxContainer/portals/south/spnSouthPortal.modulate.a = 1
			
			_: # _0_EXITS
				pass


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

