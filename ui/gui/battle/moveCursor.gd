extends MarginContainer

signal confirmed

const _NAME : String = '%s'

@onready var button : Button = $btnConfirm

var executor : Character
var target : Character
var move : Move


func _ready() -> void:
	$lblName.text = _NAME % target.name


func _process(delta : float) -> void:
	if target.currentHp <= 0:
		queue_free()


func _on_btnConfirm_pressed() -> void:
	var command
	match move.type:
		Enums.MoveType.ITEM:
			command = UseItemCommand.new(executor, [target], move)
		
		Enums.MoveType.SKILL:
			command = ExecuteMoveCommand.new(executor, [target], move)
	
	Signals.commandPublished.emit(command)
	confirmed.emit()


func _on_btnConfirm_focus_entered() -> void:
	modulate.a = 1.0


func _on_btn_confirm_focus_exited() -> void:
	modulate.a = 0.15

