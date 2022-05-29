class_name Fact
extends Entity

var description : String
var analyzeScript : String


func fromShortName(factShortName : String) -> Fact:
	return fromDTO(Persistence.loadDTO(factShortName, Enums.EntityType.FACT))


func fromDTO(factDto : FactDTO) -> Fact:
	self.name = factDto.name
	self.shortName = factDto.shortName
	self.description = factDto.description
	self.analyzeScript = factDto.analyzeScript
	
	return self


func toDTO() -> FactDTO:
	var factDto = FactDTO.new()
	factDto.name = self.name
	factDto.shortName = self.shortName
	factDto.description = self.description
	factDto.analyzeScript = self.analyzeScript
	
	return factDto


func analyze(auditorCharacter, suspects : Array) -> Array:
	return ScriptTool.getReference(analyzeScript).execute(auditorCharacter, suspects)

