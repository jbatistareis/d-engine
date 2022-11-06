extends Node


func _ready():
	Signals.connect("characterEquipedArmor", self, "equipArmor")
	Signals.connect("characterEquipedWeapon", self, "equipWeapon")
	Signals.connect("characterUsedItem", self, "useItem")
	
	Signals.connect("characterReceivedWeapon", self, "receiveWeapon")
	Signals.connect("characterReceivedArmor", self, "receiveArmor")
	Signals.connect("characterReceivedItem", self, "receiveItem")
	
	Signals.connect("characterDroppedWeapon", self, "dropWeapon")
	Signals.connect("characterDroppedArmor", self, "dropArmor")
	Signals.connect("characterDroppedItem", self, "dropItem")


func equipWeapon(character : Character, weapon : Weapon) -> void:
	pass


func equipArmor(character : Character, armor : Armor) -> void:
	pass


func useItem(character : Character, item : Item) -> void:
	pass




func receiveWeapon(character : Character, weapon : Weapon) -> void:
	pass


func receiveArmor(character : Character, armor : Armor) -> void:
	pass


func receiveItem(character : Character, entity : Entity) -> void:
	pass




func dropWeapon(character : Character, weapon : Weapon) -> void:
	pass


func dropArmor(character : Character, armor : Armor) -> void:
	pass


func dropItem(character : Character, index : int) -> void:
	pass

