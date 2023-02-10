extends TabContainer


func _ready() -> void:
	EditorSignals.connect("selectedArmor",Callable(self,"changeTab").bind(0))
	EditorSignals.connect("selectedInventory",Callable(self,"changeTab").bind(3))
	EditorSignals.connect("selectedItem",Callable(self,"changeTab").bind(4))
	EditorSignals.connect("selectedMove",Callable(self,"changeTab").bind(7))
	EditorSignals.connect("selectedVerdict",Callable(self,"changeTab").bind(8))
	EditorSignals.connect("selectedWeapon",Callable(self,"changeTab").bind(9))
	
	GameManager.testing = true


func _exit_tree() -> void:
	GameManager.testing = false


func changeTab(ignore, index : int) -> void:
	current_tab = index

