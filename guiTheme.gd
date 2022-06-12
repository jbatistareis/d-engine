extends Node

const TEXT_COLOR : Color = Color.white

const BG_COLOR : Color = Color.dodgerblue
const HOVER_COLOR : Color = Color.darkslategray
const UNSELECTED_COLOR : Color = Color.transparent

var hoveStyle : StyleBoxFlat = StyleBoxFlat.new()

const COMMAND_PRG_PRE = Color.tomato
const COMMAND_PRG_POS = Color.white
const COMMAND_DEAD = Color.teal

const HP_BAR = Color.limegreen
const ARMOR_BAR = Color.orange
const DEAD_BAR = Color.teal

const WIDGET_PADDING : Vector2 = Vector2(4, 4)


func _ready() -> void:
	hoveStyle.bg_color = HOVER_COLOR

