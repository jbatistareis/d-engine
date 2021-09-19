extends Node

var windowQueue : Array = []


func isCurrentWindow(window : GuiWindow) -> bool:
	return (windowQueue.front() == window) if !windowQueue.empty() else false


func lastPosition() -> Vector2:
	return windowQueue.front().position if !windowQueue.empty() else Vector2.ZERO


func lastSize() -> Vector2:
	return windowQueue.front().rect_size if !windowQueue.empty() else Vector2.ZERO


func windowSize() -> Vector2:
	return OS.get_real_window_size()

