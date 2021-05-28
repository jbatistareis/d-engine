extends Tabs

var portalItemScene : PackedScene = preload("res://tools/location/portals/portalItem.tscn")


func _ready() -> void:
	LocationEditorSignals.connect("loadedLocation", self, "loadPortals")
	$VBoxContainer/btnNewPortal.connect("button_up", self, "addPortal")


func loadPortals(location : Location) -> void:
	for portal in location.portals:
		var portalItem = portalItemScene.instance()
		$VBoxContainer/ScrollContainer/portalsContainer.add_child(portalItem)
		portalItem.portal = portal


func collectPortals() -> Array:
	var portals = []
	for portalItem in $VBoxContainer/ScrollContainer/portalsContainer.get_children():
		portals.append(portalItem.portal)
	return portals


func addPortal() -> void:
	var portal = Portal.new()
	portal.id = LocationIdGenerator.id
	
	var portalItem = portalItemScene.instance()
	$VBoxContainer/ScrollContainer/portalsContainer.add_child(portalItem)
	portalItem.portal = portal

