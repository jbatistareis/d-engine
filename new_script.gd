extends Node

var characterSpawnId : int

var playback : AudioStreamPlayback
var sample_hz : float = 44100.0
var amp : float = 0

var pulse_hz1 : float = 440.0
var phase1 : float = 0.0
var increment1 = pulse_hz1 / sample_hz
var sample1 : float

var pulse_hz2 : float = 440.0
var phase2 : float = 0.0
var increment2 = pulse_hz2 / sample_hz
var sample2 : float

func _ready():
	print('TEST START')
	
	var location = LocationsDatabase.spawnEntity(1, true)
	
	Signals.connect("characterArrivedLocation", self, 'printEntering')
	Signals.connect("characterTravelledLocation", self, 'printTraveling')
	
	location.enter(1, 1)
	
	location.travel(characterSpawnId, Enums.RoomDirection.NORTH)
	location.travel(characterSpawnId, Enums.RoomDirection.SOUTH)
	location.travel(characterSpawnId, Enums.RoomDirection.WEST)
	
	playback = $Player.get_stream_playback()

func _process(delta):
	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		sample2 = sin(phase2 * TAU) * amp
		sample1 = sin(phase1 * TAU + sample2) * amp
		
		playback.push_frame(Vector2(sample1, sample1)) # Audio frames are stereo.
		
		phase1 = fmod(phase1 + increment1, 1.0)
		phase2 = fmod(phase2 + increment2, 1.0)
		
		to_fill -= 1
	
	if (amp < 1): amp += delta / 100

func printEntering(characterSpawnId, locationId) -> void:
	self.characterSpawnId = characterSpawnId
	
	var location = LocationsDatabase.getEntitySpawn(locationId)
	var character = CharactersDatabase.getEntitySpawn(characterSpawnId)
	
	print('Character \'' + character.getName() + '\' entering location \'' + location.getName() + '\'')

func printTraveling(characterSpawnId, direction, currentRoomId, newRoomId) -> void:
	var directionStr
	var character = CharactersDatabase.getEntitySpawn(characterSpawnId)
	
	match direction:
		0:
			directionStr = 'north'
		1:
			directionStr = 'south'
		2:
			directionStr = 'east'
		3:
			directionStr = 'west'
		_:
			directionStr = ''
	
	print('Character \'' + character.getName() + '\' moving to the ' + directionStr + ' of room ' + str(currentRoomId) + ', into room ' + str(newRoomId))

