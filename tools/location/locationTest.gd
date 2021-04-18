extends WindowDialog


func _ready() -> void:
	connect("about_to_show", self, "show")
	connect("hide", self, "hide")


func show() -> void:
	$ViewportContainer/Viewport/terrain.visible = true


func hide() -> void:
	$ViewportContainer/Viewport/terrain.visible = false

