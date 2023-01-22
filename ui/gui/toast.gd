extends Control


func _ready() -> void:
	Signals.connect("permanentToast", self, "permanentToast")
	Signals.connect("hideToast", self, "hideToast")
	Signals.connect("normalToast", self, "normalToast")


func permanentToast(message : String) -> void:
	hideToast()
	
	$container/lblMessage.text = message.substr(0, 50)
	$animation.play("show")


func hideToast() -> void:
	if $container.rect_position.y > -35:
		$animation.play("hide")


func normalToast(message : String) -> void:
	hideToast()
	
	$container/lblMessage.text = message.substr(0, 50)
	$animation.play("normal")


