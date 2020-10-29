#BUNNY
extends KinematicBody2D

enum BunnyState {IDLE,HOP} # possible actions or behaviors
var currentBunnyState = BunnyState.IDLE # current state

var bunny_color = Color.white # default color
var facingRight = false # a bool to hold the direction the bunny is facing

const MOTION_SPEED = 1000 # Pixels/second
const GRAVITY = 6 

var timer = 0.0 # to control states
var hop_time = 2.0 # length of time to stay in the hop state
var idle_time = 1.0 # length of time to stay in the idle state

onready var anim = get_node("AnimationPlayer") 
onready var sprite = get_node("Sprite")

func _ready():
	InitializeBunny()

# give the bunny some starting values
func InitializeBunny():
	idle_time += rand_range(1,2)
	hop_time += rand_range(-0.4,1)
	
	RandomizeColor()
	
	if rand_range(0,10) < 5:
		Flip()
		
# when the bunny spawns we'll give it a random color
func RandomizeColor():
	var r = rand_range(1,10)
	if r < 4:
		bunny_color = Color.black
	elif r < 7:
		bunny_color = Color.brown
	
	sprite.modulate = bunny_color

# the idle state will handle animation and movement
# because the bunny is in idle, only gravity is applied to the force
func Idle(delta):
	anim.play("idle")
	timer += delta
	
	if timer > idle_time:
		ChangeState(BunnyState.HOP)
		Flip()
	
	# this is the velocity we'll send to the kinematic body 
	var force = Vector2(0,GRAVITY) * MOTION_SPEED * delta
	move_and_slide(force)
	
# a convient function for flipping the bunny around
func Flip():
	facingRight = not facingRight
	scale.x *= -1
	
# the hop function will move the bunny horizontally depending on the bunny's direction
func Hop(delta):
	anim.play("hop")
	timer += delta
	
	if timer > hop_time:
		ChangeState(BunnyState.IDLE)
		
	else:
		var force = Vector2.RIGHT
		if not facingRight:
			force = Vector2.LEFT
		#apply gravity to the directional force and multiply by speed and deltatime
		force = (force + Vector2(0,GRAVITY)) * MOTION_SPEED * delta
		move_and_slide(force)
		
# a convient function for changing the bunny's state
func ChangeState(new_state):
	currentBunnyState = new_state
	timer = 0

# this functin is updated on each tick of the physics engine
# we'll use it to handle the bunnies state
func _physics_process(_delta):
	match(currentBunnyState):
		BunnyState.IDLE:
			Idle(_delta)
		BunnyState.HOP:
			Hop(_delta)
		
