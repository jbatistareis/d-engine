extends VBoxContainer


func loadData(modelScene : PackedScene) -> void:
	$container/Viewport.size = $container.rect_size
	$container/Viewport/area.view(modelScene.instance())

