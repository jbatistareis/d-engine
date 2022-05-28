class_name CharacterDTO
extends DTO

var name : String = 'Base Character'
var shortName : String = 'BSECHA'

var type : int = Enums.CharacterType.NPC
var model : String = 'BSECHA'

var baseHp : int = 9
var currentHp : int = 10
var extraHp : int = 2

var baseDamage : int = 1

var currentLevel : int = 1
var experiencePoints : int = 0
var sparePoints : int = 0

var strength : int = 1
var dexterity : int = 1
var constitution : int = 1
var intelligence : int = 1
var wisdom : int = 1
var charisma : int = 1

var inventoryShortName : String = 'BSEINV'

var verdictShortName : String = 'BSEVRD'
var verdictActive : bool = true

var currentLocation : String = 'BSELOC'
var currentRoom : int = 0

