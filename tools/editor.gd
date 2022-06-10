extends TabContainer


func _ready() -> void:
	EditorSignals.connect("selectedArmor", self, "changeTab", [0])
	
	GameManager.testing = true


func _exit_tree() -> void:
	GameManager.testing = false


func changeTab(ignore, index : int) -> void:
	current_tab = index

