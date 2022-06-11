extends TabContainer


func _ready() -> void:
	EditorSignals.connect("selectedArmor", self, "changeTab", [0])
	EditorSignals.connect("selectedInventory", self, "changeTab", [3])
	EditorSignals.connect("selectedMove", self, "changeTab", [7])
	EditorSignals.connect("selectedVerdict", self, "changeTab", [8])
	EditorSignals.connect("selectedWeapon", self, "changeTab", [9])
	
	GameManager.testing = true


func _exit_tree() -> void:
	GameManager.testing = false


func changeTab(ignore, index : int) -> void:
	current_tab = index

