extends VBoxContainer


func _ready() -> void:
	get_viewport().connect("size_changed",Callable(self,"updateSize"))


func updateSize() -> void:
	$container/SubViewport.size.y *= GuiOverlayManager.ratioDiff
	print(GuiOverlayManager.ratioDiff)


func loadData(modelScene : PackedScene) -> void:
	$container/SubViewport/area.view(modelScene.instantiate())

