extends Node

@onready var tilemap : TileMapLayer = $".."
@onready var goblin_template : PackedScene = preload("res://goblin.tscn")
@onready var wizard_template : PackedScene = preload("res://wizard.tscn")
@onready var enemy_container = $"../Enemies"
@onready var levels = $"../Levels"
var active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var data = tilemap.get_used_cells()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _physics_process(delta):
	if not active:
		return
	var spawning = false
	for child in get_children():
		if child is not SpawnMarker:
			continue
		spawning = spawning or child.spawning
		var info: SpawnMarker.SpawnInfo = child.try_spawn()
		if info.enemy_type == Constants.EnemyType.NONE: 
			continue
		var enemy: Enemy
		match info.enemy_type:
			Constants.EnemyType.GOBLIN:
				enemy = goblin_template.instantiate()
			Constants.EnemyType.WIZARD:
				enemy = wizard_template.instantiate()
			_:
				continue
		enemy_container.add_child(enemy)
		enemy.position = info.position
	if not spawning and enemy_container.get_child_count() == 0:
		active = false
		levels.show_upgrade_popup()

func _on_levels_on_level_advance(level):
	print("Level advanced to", level)
	active = true
