extends MarginContainer

signal hovered(move)

const _NAME : String = '[ %s ]'
const _TIMER : String = '%0.2fs / %0.2fs'

onready var button : Button = $btnConfirm

var character : Character
var move : Move


func _ready() -> void:
	$text/lblName.text = _NAME % move.name
	$text/lblTimer.text = _TIMER % [move.cdPre * GameParameters.GCD, move.cdPos * GameParameters.GCD]


func _on_btnConfirm_pressed():
	Signals.emit_signal("battleHideCharacterMoves")
	Signals.emit_signal("battleCursorOpen", character, move)



func _on_btnConfirm_focus_entered():
	emit_signal("hovered", move)

