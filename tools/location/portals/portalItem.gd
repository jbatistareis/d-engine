extends VBoxContainer

var portal : Portal setget setPortal,getPortal


func _ready() -> void:
	$HBoxContainer2/btnRemove.connect("button_up", self, "remove")


func setPortal(value : Portal) -> void:
	portal = value
	$HBoxContainer/lblId.text = ('ID: %d' % portal.id)
	$txtPassLogic.text = portal.passLogic
	$GridContainer/txtNewLocation.text = portal.newLocationShortName
	$GridContainer/txtToSpawn.text = str(portal.toSpawnId)


func getPortal() -> Portal:
	portal.passLogic = $txtPassLogic.text
	portal.newLocationShortName = $GridContainer/txtNewLocation.text
	portal.toSpawnId = int($GridContainer/txtToSpawn.text)
	
	return portal


func remove() -> void:
	get_parent().remove_child(self)

