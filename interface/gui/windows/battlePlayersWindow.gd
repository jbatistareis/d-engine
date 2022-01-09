class_name BattlePlayersWindow
extends GuiWindow


func _init(players : Array) -> void:
	type = Enums.GuiWindowType.PERMANENT
	
	for player in players:
		widgets.append(GuiCharVitalsWidget.new(player))

