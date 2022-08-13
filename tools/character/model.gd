extends VBoxContainer


func _ready() -> void:
	get_viewport().connect("size_changed", self, "updateSize")


func updateSize() -> void:
	$container/Viewport.size.y *= GuiOverlayManager.ratioDiff
	print(GuiOverlayManager.ratioDiff)


func loadData(modelScene : PackedScene) -> void:
	$container/Viewport/area.view(modelScene.instance())

