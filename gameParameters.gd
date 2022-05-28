class_name GameParameters

const GCD : float = 0.25
const WAIT_TICKS : int = 20

const MOVE_BASE_VALUE : String = 'func getValue(character : Character) -> int:\n\treturn -(character.baseDamage + character.strength.score + character.inventory.weapon.calculateDamage(character))'
const MOVE_BASE_OUTCOME : String = 'func getOutcome(character : Character) -> int:\n\treturn Enums.DiceOutcome.BEST'
const MOVE_BASE_PICK : String = 'func pick(character : Character) -> void:\n\tpass'
const MOVE_BASE_EXECUTE : String = 'func execute(character : Character) -> void:\n\tpass'

const FACT_BASE : String = 'func execute(executor : Character, suspects : Array) -> Array:\n\treturn CharacterQuery.findByHighestHp(suspects)'

