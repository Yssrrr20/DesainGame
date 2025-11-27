class_name Enemy

extends CharacterBody2D

@export var health := 100
@export var speed := 60.0
@export var detection_range := 50.0
@export var attack_range := 5.0

# States
enum EnemyState {
	IDLE,
	PATROLLING,
	CHASING,
	ATTACKING,
	DEAD
}

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var state : EnemyState = EnemyState.IDLE
var player : Node = null
var direction : int = -1 

# Can be overridden by child classes for special behavior
var attack_damage := 10
var attack_cooldown := 1.0  # Time in seconds between attacks
var last_attack_time := 0.0  # Keeps track of the time of the last attack

# Called when the enemy is ready (e.g., after scene is loaded)
func _ready():
	player = get_node_or_null("/root/Player")
	set_state(EnemyState.PATROLLING)

# Called every physics frame
func _physics_process(delta):
	# Handle state-specific behavior
	match state:
		EnemyState.IDLE:
			idle_state(delta)
		EnemyState.PATROLLING:
			patrol_state(delta)
		EnemyState.CHASING:
			chase_state(delta)
		EnemyState.ATTACKING:
			attack_state(delta)
		EnemyState.DEAD:
			dead_state(delta)

	# Always apply gravity
	process_gravity(delta)
	move_and_slide()

# ---------------------------------------------------
# IDLE STATE
# ---------------------------------------------------

func idle_state(delta):
	velocity.x = 0
	animationPlayer.play("idle")
	# Transition to patrolling or chasing based on the player's proximity
	if is_player_near():
		set_state(EnemyState.CHASING)

# ---------------------------------------------------
# PATROLLING STATE
# ---------------------------------------------------

func patrol_state(delta):
	velocity.x = direction * speed

	animationPlayer.play("run")

# ---------------------------------------------------
# CHASING STATE
# ---------------------------------------------------

func chase_state(delta):
	if player != null:
		var player_position = player.position
		if player_position.x > position.x:
			direction = 1
		else:
			direction = -1

		velocity.x = direction * speed

		animationPlayer.play("run")

		# Transition back to patrolling if the player is out of range
		if is_player_out_of_range():
			set_state(EnemyState.PATROLLING)

# ---------------------------------------------------
# ATTACKING STATE
# ---------------------------------------------------

func attack_state(delta):
	set_state(EnemyState.IDLE)

# ---------------------------------------------------
# DEAD STATE
# ---------------------------------------------------

func dead_state(delta):
	queue_free()

# ---------------------------------------------------
# UTILS
# ---------------------------------------------------

# Check if the player is within detection range
func is_player_near() -> bool:
	if player != null:
		return position.distance_to(player.position) < detection_range
	return false

# Check if the player is out of detection range
func is_player_out_of_range() -> bool:
	if player != null:
		return position.distance_to(player.position) > detection_range
	return true

# Can the enemy attack the player based on cooldown?
func can_attack() -> bool:
	return false

func attack_player():
	if player != null and player.has_method("take_damage"):
		player.take_damage(attack_damage)

# Change the state of the enemy
func set_state(new_state : EnemyState):
	state = new_state


func flip_direction():
	direction *= -1
	sprite.flip_h = direction == 1

func process_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
