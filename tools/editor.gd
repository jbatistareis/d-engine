extends Control


func _ready() -> void:
	GameManager.testing = true


func _exit_tree() -> void:
	GameManager.testing = false

