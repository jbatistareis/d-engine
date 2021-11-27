class_name BattleTimerPlayersWindow
extends GuiWindow


func _init(players : Array) -> void:
	type = Enums.GuiWindowType.PERMANENT
	
	for player in players:
		widgets.append(GuiCommandProgressWidget.new(player))

