extends VBoxContainer


func loadData(modelScene : PackedScene) -> void:
	$container/Viewport/area.view(modelScene.instance())

