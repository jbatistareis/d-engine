class_name Portal
extends Entity

const NOOP : String = 'func execute(character : Character) -> bool:\n\treturn true'

var passLogic : String = NOOP
var newLocationName : String = ''
var toSpawnId : int = -1


func canPass(character : Character) -> bool:
	return ScriptTool.getReference(passLogic).execute(character)

