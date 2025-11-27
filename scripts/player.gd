extends CharacterBody2D

@export var speed = 200.0
@export var jump_velocity = -300.0

enum State { IDLE, RUN, JUMP, FALL }

var state: State = State.IDLE

var score: int = 0
signal score_changed(new_score)

@onready var sprite: Sprite2D = $Sprite
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	process_gravity(delta)
	process_state(delta)
	move_and_slide()

# ---------------------------------------------------------
# FSM MAIN LOGIC
# ---------------------------------------------------------
func process_state(delta: float) -> void:
	match state:

		State.IDLE:
			state_idle()

		State.RUN:
			state_run()

		State.JUMP:
			state_jump()

		State.FALL:
			state_fall()


# ---------------------------------------------------------
# STATES
# ---------------------------------------------------------

func state_idle():
	animationPlayer.play("idle")
	velocity.x = move_toward(velocity.x, 0, speed)

	var dir := Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("jump"):
		start_jump()
	elif dir != 0:
		set_state(State.RUN)
	elif not is_on_floor():
		set_state(State.FALL)


func state_run():
	animationPlayer.play("run")

	var dir := Input.get_axis("move_left", "move_right")
	if dir == 0:
		set_state(State.IDLE)
	else:
		velocity.x = dir * speed
		sprite.flip_h = dir < 0

	if Input.is_action_just_pressed("jump"):
		start_jump()
	elif not is_on_floor():
		set_state(State.FALL)


func state_jump():
	animationPlayer.play("jump")

	var dir := Input.get_axis("move_left", "move_right")

	if dir:
		velocity.x = dir * speed
		sprite.flip_h = dir < 0

	if velocity.y > 0:
		set_state(State.FALL)


func state_fall():
	animationPlayer.play("fall")

	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * speed

	if is_on_floor():
		if dir == 0:
			set_state(State.IDLE)
		else:
			set_state(State.RUN)


# ---------------------------------------------------------
# UTILS
# ---------------------------------------------------------
func process_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func start_jump():
	velocity.y = jump_velocity
	set_state(State.JUMP)


func set_state(new_state: State):
	state = new_state

func add_score(amount: int):
	score += amount
	emit_signal("score_changed", score)

# ---------------------------------------------------------
# SIGNALS
# ---------------------------------------------------------

func _on_hitbox_area_entered(area: Area2D) -> void:
	start_jump()
	area.get_parent().queue_free()

func _on_death_zone_area_entered(area: Area2D) -> void:
	get_tree().reload_current_scene()
