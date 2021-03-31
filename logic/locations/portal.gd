class_name Portal
extends Entity

const NOOP : String = 'func execute(character : Character) -> bool:\n\treturn true'

var passLogic : String = NOOP
var newLocationShortName : String = ''
var toSpawnId : int = 0


func canPass(character : Character) -> bool:
	return ScriptTool.getReference(passLogic).execute(character)

