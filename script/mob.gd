extends Node2D

const SPEED = 60
var direction = 1 # 1 = Kanan, -1 = Kiri

# Atur jangkauan pergerakan 
@export var movement_range_x: float = 100.0 

var start_x: float = 0.0 # Posisi X awal mob

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	# Simpan posisi X awal
	start_x = position.x


func _process(delta):
	# Hitung batas minimum dan maksimum
	var min_x = start_x - movement_range_x
	var max_x = start_x + movement_range_x
	
	# Logika Pembalikan Arah
	if direction == 1: # Bergerak ke Kanan
		if position.x >= max_x:
			direction = -1 # Balik ke Kiri
			animated_sprite.flip_h = true
	
	elif direction == -1: # Bergerak ke Kiri
		if position.x <= min_x:
			direction = 1 # Balik ke Kanan
			animated_sprite.flip_h = false
			
	# Gerakkan Mob
	position.x += direction * SPEED * delta
