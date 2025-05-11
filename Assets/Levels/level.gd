extends Node3D

# Ноды сцены
@onready var player = $Player
@onready var score_label: Label = $UI/Control/CoinContainer/CoinsLabel
@onready var platform_generator: PlatformGenerator = $PlatformGenerator
@onready var plane = $Plane

# Характеристики генерации
var layer_count = Global.get_current_layer()
var chaos = 0.9

func _ready() -> void:
	# Инициализация размеров плоскости для генерации платформ
	platform_generator.initialize_plane(plane)
	
	# Создание базовой сетки платформ
	await platform_generator.spawn_base_grid({
		"spacing": 8.0,
		"offset": 10.0,
	})
	
	await platform_generator.spawn_clustered_path({
		"turns_count": layer_count,         # Заменяет layer_count
		"platforms_per_turn": 10,          # Новое значение
		"spiral_step": 1.01,               # Новый параметр
		"cluster_radius": 16.0,             # Новый параметр
		"vertical_step": 1.01,              # Заменяет vertical_spacing
		"difficulty": 1.0,
})
	
	# Создание платформы победы
	platform_generator.spawn_win_platform(_on_win_platform_activated)

func _input(event: InputEvent) -> void:
	# Перезапуск уровня при нажатии клавиши рестарта
	if event.is_action_pressed("restart"):
		_restart_level()

func _on_coin_collected() -> void:
	# Увеличение счета игрока и обновление текста
	player.add_score()
	score_label.text = "Coins: %d" %  player._score
	print("Монета собрана")

func _on_win_platform_activated() -> void:
	# Отображение диалога победы
	print("Победа! Игрок достиг платформы победы.")
	# player._dance_play()
	layer_count += 5
	Global.set_layer(layer_count)
	_restart_level()
	
#	var dialog := ConfirmationDialog.new()
	#dialog.title = "Win"
#	dialog.dialog_text = "Good job!"
#	add_child(dialog)
#	dialog.popup_centered()

func _on_teleport_body_entered(body: Node3D) -> void:
	# Телепортация игрока при входе в зону телепорта
	if body.name == "Player":
		_teleport_player()

func _on_teleport_zone_body_entered(body: Node3D) -> void:
	# Телепортация игрока при входе в зону телепорта
	if body.name == "Player":
		_teleport_player()

func _teleport_player() -> void:
	# Телепортация игрока в случайную точку спавна
	var spawn_points := [$Plane/Spawn_1, $Plane/Spawn_2, $Plane/Spawn_3 ]
	if spawn_points.size() > 0:
		var random_spawn: Node3D = spawn_points[randi() % spawn_points.size()]
		player.global_transform.origin = random_spawn.global_transform.origin + Vector3(0, 0.5, 0)

func _restart_level() -> void:
	# Отложенный перезапуск текущей сцены
	get_tree().call_deferred("reload_current_scene")

func player_fell() -> void:
	# Перезапуск уровня при падении игрока
	_restart_level()
