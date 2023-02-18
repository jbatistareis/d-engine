extends Control


func _ready() -> void:
	Signals.permanentToast.connect(permanentToast)
	Signals.hideToast.connect(hideToast)
	Signals.normalToast.connect(normalToast)


func setToast(message : String) -> void:
	$container/lblMessage.text = message


func permanentToast(message : String) -> void:
	$animation.play("show")
	setToast(message)


func hideToast() -> void:
	$animation.play_backwards("show")


func normalToast(message : String) -> void:
	$animation.play("normal")
	setToast(message)


