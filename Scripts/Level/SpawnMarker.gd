class_name SpawnMarker
extends Marker2D

class SpawnInfo:
	var enemy_type: Constants.EnemyType
	var position : Vector2
	func _init(type: Constants.EnemyType, position: Vector2):
		self.enemy_type = type
		self.position = position

@export var shape: Shape2D
@export_flags("Goblin", "Wizard") var spawnable_enemies: int
@export var probability: float = 0.05
@export var entities_to_spawn: int = 20
@onready var levels = $"../../Levels"
@export var level: int = 1
var spawning = false

func _check_spawning(current_level: int):
	spawning = current_level == level
	print(self, " spawning: ", spawning)

func _ready():
	levels.on_level_advance.connect(_check_spawning)

func get_spawnable_enemies() -> Array[Constants.EnemyType]:
	var res: Array[Constants.EnemyType] = []
	for i in range(30):
		if spawnable_enemies & (1 << i) != 0:
			res.append((1 << i) as Constants.EnemyType)
	return res

func try_spawn() -> SpawnInfo:
	print(Game.afterTutorial)
	if not spawning or randf_range(0, 1) > probability or entities_to_spawn <= 0\
		or len(G.getNodes("enemy_")) > min(5*level,15) or !Game.afterTutorial:
		return SpawnInfo.new(Constants.EnemyType.NONE, Vector2.ZERO)
	var enemy_types = get_spawnable_enemies()
	var enemy_type = enemy_types[randi_range(0, len(enemy_types) - 1)]
	var rect : Rect2 = shape.get_rect()
	var x = randi_range(rect.position.x, rect.position.x+rect.size.x)
	var y = randi_range(rect.position.y, rect.position.y+rect.size.y)
	var rand_point = global_position + Vector2(x,y)
	entities_to_spawn -= 1
	if entities_to_spawn <= 0:
		print(self, "stops spawning")
		spawning = false
	return SpawnInfo.new(enemy_type, rand_point)
