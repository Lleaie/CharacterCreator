extends Node

var player_name: String = ""
var player_race: String = "Trivallen"
var player_skin: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Trivallen/Skin Tone 1/TM_S1.png")
var player_hair: Color = Color("#FFFFFF")
var player_eyes: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye1.png")
var player_mouth: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Face/Mouth/Mouth1.png")
var is_female: bool = false
var is_elf: bool = false
var breasts: float = 0.0
var chest_size_female: float = 0.0
var chest_size_male: float = 0.0
var thigh_size: float = 0.0
var booty_size: float = 0.0
var arm_size: float = 0.0

# Not Implemented Yet
#var equipped_helmet: String = ""
#var equipped_armour: String = ""
#var equipped_gauntlets: String = ""
#var equipped_boots: String = ""
#var equipped_weapon: String = ""

func _ready() -> void:
	clamp_blendshape_values()

func clamp_blendshape_values():
	breasts = clamp(breasts, 0.0, 1.0)
	chest_size_female = clamp(chest_size_female, 0.0, 1.0)
	chest_size_male = clamp(chest_size_male, 0.0, 1.0)
	thigh_size = clamp(thigh_size, 0.0, 1.0)
	booty_size = clamp(booty_size, 0.0, 1.0)
	arm_size = clamp(arm_size, 0.0, 1.0)
