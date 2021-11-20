extends VBoxContainer

var portal : RoomPortal setget setPortal,getPortal


func _ready() -> void:
	$HBoxContainer/btnRemove.connect("button_up", self, "remove")


func setPortal(value : RoomPortal) -> void:
	portal = value
	$HBoxContainer/lblId.text = ('ID: %d' % portal.id)
	$txtPassLogic.text = portal.passLogic
	$GridContainer/txtNewLocation.text = portal.newLocationShortName
	$GridContainer/spnToSpawn.value = portal.toSpawnId


func getPortal() -> RoomPortal:
	portal.passLogic = $txtPassLogic.text
	portal.newLocationShortName = $GridContainer/txtNewLocation.text
	portal.toSpawnId = int($GridContainer/spnToSpawn.value)
	
	return portal


func remove() -> void:
	get_parent().remove_child(self)

