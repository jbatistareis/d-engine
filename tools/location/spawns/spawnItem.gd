extends VBoxContainer

var spawn : Spawn setget setSpawn


func _ready() -> void:
	$GridContainer/btnRemove.connect("button_up", self, "remove")


func setSpawn(value : Spawn) -> void:
	spawn = value
	$GridContainer/txtShortName.text = spawn.shortName
	$GridContainer/txtToRoomId.text = str(spawn.toRoomId)
	$GridContainer/lblId.text = 'ID: ' + str(spawn.id)


func remove() -> void:
	get_parent().remove_child(self)
