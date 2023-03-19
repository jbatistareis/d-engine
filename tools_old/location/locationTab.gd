extends TabBar


func _on_tabs_tab_changed(tab):
	if tab != get_index():
		get_node("background/mainContainer/parameters/Node3D/mainContainer/model/SubViewportContainer/SubViewport/area").visible = false

