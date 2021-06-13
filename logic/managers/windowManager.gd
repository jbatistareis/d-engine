extends Node

var windowQueue : Array = []


func _init() -> void:
	Signals.connect("guiOpenWindow", self, "open")
	Signals.connect("guiCloseWindow", self, "close")


func open(window : GuiWindowModel, position : Vector2) -> void:
	window.position = position
	get_tree().get_nodes_in_group('gui')[0].addWindow(window)
	
	if window.foreground:
		windowQueue.push_front(window)


func close() -> void:
	if !windowQueue.empty():
		get_tree().get_nodes_in_group('gui')[0].removeWindow(windowQueue.front())
		windowQueue.pop_front()

