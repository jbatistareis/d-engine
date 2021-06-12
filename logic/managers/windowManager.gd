extends Node

var windowQueue : Array = []


func _init() -> void:
	Signals.connect("guiOpenWindow", self, "open")
	Signals.connect("guiCloseWindow", self, "close")


func open(window : GuiWindowModel) -> void:
	get_tree().get_nodes_in_group('gui')[0].addWindow(window)
	windowQueue.push_front(window)


func close() -> void:
	if !windowQueue.empty():
		get_tree().get_nodes_in_group('gui')[0].removeWindow(windowQueue.front())
		windowQueue.pop_front()

