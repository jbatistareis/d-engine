extends Node

const TEXT_COLOR : Color = Color.WHITE

const BG_COLOR : Color = Color.DODGER_BLUE
const HOVER_COLOR : Color = Color.DARK_SLATE_GRAY
const UNSELECTED_COLOR : Color = Color.TRANSPARENT

var hoveStyle : StyleBoxFlat = StyleBoxFlat.new()

const COMMAND_PRG_PRE = Color.TOMATO
const COMMAND_PRG_POS = Color.WHITE
const COMMAND_DEAD = Color.TEAL

const HP_BAR = Color.LIME_GREEN
const ARMOR_BAR = Color.ORANGE
const DEAD_BAR = Color.TEAL

const WIDGET_PADDING : Vector2 = Vector2(4, 4)


func _ready() -> void:
	hoveStyle.bg_color = HOVER_COLOR

