extends VBoxContainer

var spawn : Spawn setget setSpawn,getSpawn


func _ready() -> void:
	$HBoxContainer/btnRemove.connect("button_up", self, "remove")


func setSpawn(value : Spawn) -> void:
	spawn = value
	$HBoxContainer/lblId.text = ('ID: %d' % spawn.id)
	$HBoxContainer2/spnToRoomId.value = spawn.toRoomId
	$HBoxContainer2/optDirection.select(spawn.direction)
	


func getSpawn() -> Spawn:
	spawn.toRoomId = int($HBoxContainer2/spnToRoomId.value)
	spawn.direction = $HBoxContainer2/optDirection.selected
	
	return spawn


func remove() -> void:
	get_parent().remove_child(self)
