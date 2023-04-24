extends MarginContainer

signal hovered(move)

const _NAME : String = '[ %s ]'
const _TIMER : String = '%0.2fs / %0.2fs'

@onready var button : Button = $btnConfirm

var character : Character
var move : Move = Move.new()


func _init():
	move.description = 'Opens inventory'


func _ready() -> void:
	var cd = 1000 * GameParameters.GCD * GameParameters.MIN_CD / 1000.0
	
	$text/lblName.text = _NAME % 'Inventory'
	$text/lblTimer.text = _TIMER % [cd, cd]
	
	Signals.battleCursorShow.connect(func(character, move): queue_free())


func _on_btnConfirm_pressed():
	Signals.emit_signal("battleInventoryShow", character)


func _on_btnConfirm_focus_entered():
	emit_signal("hovered", move)

