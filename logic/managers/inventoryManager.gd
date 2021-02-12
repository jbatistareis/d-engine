extends Node


func _ready():
	Signals.connect("characterEquipedArmor", self, "equiArmor")
	Signals.connect("characterEquipedWeapon", self, "equipWeapon")
	Signals.connect("characterUsedItem", self, "useItem")
	Signals.connect("characterReceivedItemOrWeapon", self, "receiveItemOrWeapon")
	Signals.connect("characterDroppedItem", self, "dropItem")
	Signals.connect("characterDroppedWeapon", self, "removeWeapon")


func equipArmor(character : Character, armor : Armor) -> void:
	character.inventory.equipArmor(armor)


func equipWeapon(character : Character, index : int) -> void:
	character.inventory.equipWeapon(index)


func useItem(character : Character, index : int) -> void:
	var item = character.inventory.removeItem(index)
	
	var node = ScriptTool.getNode(item.interactScript)
	node.execute(character)
	node.queue_free()


func receiveItemOrWeapon(character : Character, entity : Entity) -> void:
	character.inventory.add(entity)


func dropItem(character : Character, index : int) -> void:
	character.inventory.removeItem(index)


func removeWeapon(character : Character, index : int) -> void:
	character.inventory.removeWeapon(index)

