class_name Fact
extends Entity

var description : String
var analyzeScript : String


func _init(factShortName : String) -> void:
	var dto = Persistence.loadDTO(factShortName, Enums.EntityType.FACT)
	
	self.name = dto.name
	self.shortName = dto.shortName
	self.description = dto.description
	self.analyzeScript = dto.analyzeScript


func analyze(auditorCharacter, suspects : Array) -> Array:
	return ScriptTool.getReference(analyzeScript).execute(auditorCharacter, suspects)

