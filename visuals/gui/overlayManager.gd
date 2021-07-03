extends Node

var windowQueue : Array = []


func isCurrentWindow(window : GuiWindowModel) -> bool:
	return (windowQueue.front() == window) if !windowQueue.empty() else false


func lastPosition() -> Vector2:
	return windowQueue.front().position if !windowQueue.empty() else Vector2.ZERO


func lastSize() -> Vector2:
	return windowQueue.front().rect_size if !windowQueue.empty() else Vector2.ZERO


func windowSize() -> Vector2:
	return get_tree().get_nodes_in_group('gui')[0].rect_size

