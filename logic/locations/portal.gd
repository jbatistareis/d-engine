class_name Portal
extends Entity

const PASS_NOOP : String = 'func execute(character : Character) -> bool:\n\treturn true'

var passLogic : String = PASS_NOOP
var newLocationName : String = ''
var toSpawnId : int = -1


func canPass(character : Character) -> bool:
	return ScriptTool.getReference(passLogic).execute(character)

