extends TileMap

@export var player: Node2D
@export var width: int = 50
@export var height: int = 50

@export var source_id: int = 0
@export var grass_tiles: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0)
]

var previous_player_tile := Vector2i(999999, 999999)


func _ready() -> void:
	generate_grass_around_player()


func _process(_delta: float) -> void:
	var player_tile: Vector2i = local_to_map(
		to_local(player.global_position)
	)

	if player_tile != previous_player_tile:
		previous_player_tile = player_tile
		generate_grass(player_tile)


func generate_grass_around_player() -> void:
	var player_tile: Vector2i = local_to_map(
		to_local(player.global_position)
	)

	previous_player_tile = player_tile
	generate_grass(player_tile)


func generate_grass(center: Vector2i) -> void:
	if grass_tiles.is_empty():
		return

	for x in range(-width / 2, width / 2):
		for y in range(-height / 2, height / 2):
			var tile_position := center + Vector2i(x, y)

			# Skip tiles that were already generated.
			if get_cell_source_id(0, tile_position) != -1:
				continue

			var grass_tile: Vector2i = grass_tiles[
				randi_range(0, grass_tiles.size() - 1)
			]

			set_cell(
				0,
				tile_position,
				source_id,
				grass_tile
			)
