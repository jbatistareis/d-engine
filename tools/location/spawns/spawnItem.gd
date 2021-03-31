extends VBoxContainer

var spawn : Spawn setget setSpawn,getSpawn


func _ready() -> void:
	$GridContainer/btnRemove.connect("button_up", self, "remove")


func setSpawn(value : Spawn) -> void:
	spawn = value
	$GridContainer/txtToRoomId.text = str(spawn.toRoomId)
	$HBoxContainer/lblId.text = ('ID: %d' % spawn.id)


func getSpawn() -> Spawn:
	spawn.toRoomId = int($GridContainer/txtToRoomId.text)
	
	return spawn


func remove() -> void:
	get_parent().remove_child(self)
