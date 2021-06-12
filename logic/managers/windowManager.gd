extends Node

var windowQueue : Array = []
var currentWindow : GuiWindowModel


func _init() -> void:
	Signals.connect("guiOpenWindow", self, "open")
	Signals.connect("guiCloseWindow", self, "close")


func open(window : GuiWindowModel) -> void:
	get_tree().get_nodes_in_group('gui')[0].addWindow(window)
	windowQueue.push_front(window)
	currentWindow = window


func close() -> void:
	windowQueue.pop_front()
	currentWindow.queue_free()

