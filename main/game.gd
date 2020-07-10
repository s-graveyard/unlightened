extends Node

const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY = 1000

const MAX_SPEED = 60
const ACCELERATION = 250
const DECELERATION = 250

const JUMP_FORCE = 240
const MAX_FALL_SPEED = 300

# Sound
var enable_ambience = true
var enable_sound = true

# Graphics
var enable_shader = false

var inventory = {}

const inventory_dialogue = {
	"empty": "Nothing here.",
	"basement_key": "Found a key"
}

# Dialogue
const door_dialogue_locked = [
	"I can’t open that! Find a key will ya...",
	"Not Possible, I need a key",
	"Need a key",
	"Key !!"
]

const cat_dialogue = [
	"She doesn’t look happy to see me.",
	"I don’t want to do that.",
	"Not right now.",
	"Why?"
]

const stuffs_dialogue = [
	"I don't have time for this!",
	"May be next time",
	"Why?",
	"Not right now"
	
]
