extends Tabs


func _on_tabs_tab_changed(tab):
	if tab != get_index():
		get_node("background/mainContainer/parameters/Room/mainContainer/model/ViewportContainer/Viewport/area").visible = false

