extends VBoxContainer


func loadData(modelScene : PackedScene) -> void:
	$container/Viewport/area.visible = true
	$container/Viewport/area.view(modelScene.instance())
	$container/Viewport.size.y = $container.rect_size.y - 10	

