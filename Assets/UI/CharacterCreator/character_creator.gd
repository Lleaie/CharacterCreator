extends Control

@export var eyearray: Array[CompressedTexture2D]
var eye_index: int = 0
const max_eye_index: int = 2

@export var moutharray: Array[CompressedTexture2D]
var mouth_index: int = 0
const max_mouth_index: int = 19

@onready var thigh_size_value: Label = $Customisation/BodyContent/ThighSizeSlider/HBoxContainer/ThighSizeValue
@onready var booty_size_value: Label = $Customisation/BodyContent/BootySizeSlider/HBoxContainer/BootySizeValue
@onready var arm_size_value: Label = $Customisation/BodyContent/ArmSizeSlider/HBoxContainer/ArmSizeValue
@onready var breasts_size_value: Label = $Customisation/BodyContent/FemaleSliders/BreastsSizeSlider/HBoxContainer/BreastsSizeValue
@onready var female_chest_size_value: Label = $Customisation/BodyContent/FemaleSliders/FemaleChestSizeSlider/HBoxContainer/FemaleChestSizeValue
@onready var male_sliders: VBoxContainer = $Customisation/BodyContent/MaleSliders
@onready var female_sliders: VBoxContainer = $Customisation/BodyContent/FemaleSliders
@onready var male_chest_size_value: Label = $Customisation/BodyContent/MaleSliders/ChestSizeSlider/HBoxContainer/MaleChestSizeValue
@onready var trivallen_skin_tone_slider: VBoxContainer = $Customisation/BodyContent/TrivallenSkinTone
@onready var erylir_skin_tone_slider: VBoxContainer = $Customisation/BodyContent/ErylirSkinTone
@onready var ciar_skin_tone_slider: VBoxContainer = $Customisation/BodyContent/CiarSkinTone
@onready var feil_skin_tone_slider: VBoxContainer = $Customisation/BodyContent/FeilSkinTone
@onready var fuar_skin_tone_slider: VBoxContainer = $Customisation/BodyContent/FuarSkinTone
@onready var trivallen_skin_value: Label = $Customisation/BodyContent/TrivallenSkinTone/HBoxContainer/TrivallenSkinValue
@onready var erylir_skin_value: Label = $Customisation/BodyContent/ErylirSkinTone/HBoxContainer/ErylirSkinValue
@onready var ciar_skin_value: Label = $Customisation/BodyContent/CiarSkinTone/HBoxContainer/CiarSkinValue
@onready var feil_skin_value: Label = $Customisation/BodyContent/FeilSkinTone/HBoxContainer/FeilSkinValue
@onready var fuar_skin_value: Label = $Customisation/BodyContent/FuarSkinTone/HBoxContainer/FuarSkinValue
@onready var body_content: VBoxContainer = $Customisation/BodyContent
@onready var head_content: VBoxContainer = $Customisation/HeadContent
@onready var eye_3_list: ItemList = $Customisation/HeadContent/Eyes/Eye3List
@onready var eyes_label: Label = $Customisation/HeadContent/Eyes/HBoxContainer/EyesLabel
@onready var mouth_label: Label = $Customisation/HeadContent/Mouth/HBoxContainer/MouthLabel
@onready var confirm_box: Panel = $ConfirmBox

@onready var body: MeshInstance3D = $"../Player_Creator/Rig/PlayerModel/PlayerModel/Skeleton3D/Body"
@onready var outfit: MeshInstance3D = $"../Player_Creator/Rig/PlayerModel/PlayerModel/Skeleton3D/EldwykPrisonRag"

# Variables used to make the real time changes work in the character creator
var player_eyes_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerEyes.tres")
var player_mouth_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerMouth.tres")
var player_body_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerBody.tres")
var player_hair_mat: BaseMaterial3D = preload("res://Assets/Character/Player/Materials/Player/PlayerHair.tres")
var erylir_tone: int
var trivallen_tone: int = 1
var ciar_tone: int
var feil_tone: int
var fuar_tone: int
var player_name: String
var player_race: String
var breasts_value: float = 0.0
var is_female: bool = false

# Eye 3 Colours
const E3BLACK = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Black.png")
const E3BLIND = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Blind.png")
const E3BLUE = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Blue.png")
const E3BROWN = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Brown.png")
const E3GREEN = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Green.png")
const E3GREY = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Grey.png")
const E3ICY = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Icy.png")
const E3ORANGE = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Orange.png")
const E3RED = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Red.png")
const E3VIOLET = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Violet.png")
const E3VOID = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Void.png")
const E3WHITE = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/White.png")
const E3YELLOW = preload("res://Assets/Character/Player/Textures/Face/Eye/Eye 3/Yellow.png")

# Feil Sìth Skin Tones
const FFS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Feil Sìth/Skin Tone 1/FF_S1.png")
const FMS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Feil Sìth/Skin Tone 1/FM_S1.png")
const FFS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Feil Sìth/Skin Tone 2/FF_S2.png")
const FMS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Feil Sìth/Skin Tone 2/FM_S2.png")
const FFS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Feil Sìth/Skin Tone 3/FF_S3.png")
const FMS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Feil Sìth/Skin Tone 3/FM_S3.png")

# Ciar Sìth Skin Tones
const CFS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 1/CF_S1.png")
const CMS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 1/CM_S1.png")
const CFS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 2/CF_S2.png")
const CMS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 2/CM_S2.png")
const CFS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 3/CF_S3.png")
const CMS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 3/CM_S3.png")
const CFS_4: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 4/CF_S4.png")
const CMS_4: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 4/CM_S4.png")
const CFS_5: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 5/CF_S5.png")
const CMS_5: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Ciar Sìth/Skin Tone 5/CM_S5.png")

# Fuar Sìth Skin Tones
const FUFS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Fuar Sìth/Skin Tone 1/FUF_S1.png")
const FUMS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Fuar Sìth/Skin Tone 1/FuM_S1.png")
const FUFS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Fuar Sìth/Skin Tone 2/FuF_S2.png")
const FUMS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Fuar Sìth/Skin Tone 2/FuM_S2.png")
const FUFS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Fuar Sìth/Skin Tone 3/FuF_S3.png")
const FUMS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Fuar Sìth/Skin Tone 3/FuM_S3.png")

# Erylir Skin Tones
const EFS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Erylir/Skin Tone 1/EF_S1.png")
const EMS_1: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Erylir/Skin Tone 1/EM_S1.png")
const EFS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Erylir/Skin Tone 2/EF_S2.png")
const EMS_2: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Erylir/Skin Tone 2/EM_S2.png")
const EMS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Erylir/Skin Tone 3/EM_S3.png")
const EFS_3: CompressedTexture2D = preload("res://Assets/Character/Player/Textures/Races/Erylir/Skin Tone 3/EF_S3.png")

# Trivallen Skin Tones
const TFS_1 = preload("res://Assets/Character/Player/Textures/Races/Trivallen/Skin Tone 1/TF_S1.png")
const TMS_1 = preload("res://Assets/Character/Player/Textures/Races/Trivallen/Skin Tone 1/TM_S1.png")
const TFS_2 = preload("res://Assets/Character/Player/Textures/Races/Trivallen/Skin Tone 2/TF_S2.png")
const TMS_2 = preload("res://Assets/Character/Player/Textures/Races/Trivallen/Skin Tone 2/TM_S2.png")
const TFS_3 = preload("res://Assets/Character/Player/Textures/Races/Trivallen/Skin Tone 3/TF_S3.png")
const TMS_3 = preload("res://Assets/Character/Player/Textures/Races/Trivallen/Skin Tone 3/TM_S3.png")

func _ready() -> void:
	eyes_label.text = str(eye_index + 1)
	mouth_label.text = str(mouth_index + 1)
	
	if CharacterDataAutoload.is_female:
		female_sliders.visible = true
		male_sliders.visible = false
	else:
		male_sliders.visible = true
		female_sliders.visible = false
	
	body_content.visible = false
	head_content.visible = true

func _on_name_select_text_changed(new_text: String) -> void:
	player_name = new_text

func _on_male_chest_size_slider_value_changed(value: float) -> void:
	male_chest_size_value.text = str(value)
	body.set_blend_shape_value(5, value)
	outfit.set_blend_shape_value(5, value)
	CharacterDataAutoload.chest_size_male = value

func _on_thigh_size_slider_value_changed(value: float) -> void:
	thigh_size_value.text = str(value)
	body.set_blend_shape_value(7, value)
	outfit.set_blend_shape_value(7, value)
	CharacterDataAutoload.thigh_size = value

func _on_booty_size_slider_value_changed(value: float) -> void:
	booty_size_value.text = str(value)
	body.set_blend_shape_value(8, value)
	outfit.set_blend_shape_value(8, value)
	CharacterDataAutoload.booty_size = value

func _on_arm_size_slider_value_changed(value: float) -> void:
	arm_size_value.text = str(value)
	body.set_blend_shape_value(9, value)
	outfit.set_blend_shape_value(9, value)
	CharacterDataAutoload.arm_size = value

func _on_breasts_size_slider_value_changed(value: float) -> void:
	breasts_size_value.text = str(value)
	breasts_value = value
	_set_female_texture()
	body.set_blend_shape_value(3, value)
	outfit.set_blend_shape_value(3, value)

func _set_female_texture():
	if breasts_value > 0.0:
		if player_race == "Erylir":
			if erylir_tone == 1:
				player_body_mat.albedo_texture = EFS_1
			elif erylir_tone == 2:
				player_body_mat.albedo_texture = EFS_2
			elif erylir_tone == 3:
				player_body_mat.albedo_texture = EFS_3
		elif player_race == "Trivallen":
			if trivallen_tone == 1:
				player_body_mat.albedo_texture = TFS_1
			elif trivallen_tone == 2:
				player_body_mat.albedo_texture = TFS_2
			elif trivallen_tone == 3:
				player_body_mat.albedo_texture = TFS_3
		elif player_race == "Feil Sìth":
			if feil_tone == 1:
				player_body_mat.albedo_texture = FFS_1
			elif feil_tone == 2:
				player_body_mat.albedo_texture = FFS_2
			elif feil_tone == 3:
				player_body_mat.albedo_texture = FFS_3
		elif player_race == "Ciar Sìth":
			if ciar_tone == 1:
				player_body_mat.albedo_texture = CFS_1
			elif ciar_tone == 2:
				player_body_mat.albedo_texture = CFS_2
			elif ciar_tone == 3:
				player_body_mat.albedo_texture = CFS_3
			elif ciar_tone == 4:
				player_body_mat.albedo_texture = CFS_4
			elif ciar_tone == 5:
				player_body_mat.albedo_texture = CFS_5
		elif player_race == "Fuar Sìth":
			if fuar_tone == 1:
				player_body_mat.albedo_texture = FUFS_1
			elif fuar_tone == 2:
				player_body_mat.albedo_texture = FUFS_2
			elif fuar_tone == 3:
				player_body_mat.albedo_texture = FUFS_3
	if breasts_value == 0.0:
		if player_race == "Erylir":
			if erylir_tone == 1:
				player_body_mat.albedo_texture = EMS_1
			elif erylir_tone == 2:
				player_body_mat.albedo_texture = EMS_2
			elif erylir_tone == 3:
				player_body_mat.albedo_texture = EMS_3
		elif player_race == "Trivallen":
			if trivallen_tone == 1:
				player_body_mat.albedo_texture = TMS_1
			elif trivallen_tone == 2:
				player_body_mat.albedo_texture = TMS_2
			elif trivallen_tone == 3:
				player_body_mat.albedo_texture = TMS_3
		elif player_race == "Feil Sìth":
			if feil_tone == 1:
				player_body_mat.albedo_texture = FMS_1
			elif feil_tone == 2:
				player_body_mat.albedo_texture = FMS_2
			elif feil_tone == 3:
				player_body_mat.albedo_texture = FMS_3
		elif player_race == "Ciar Sìth":
			if ciar_tone == 1:
				player_body_mat.albedo_texture = CMS_1
			elif ciar_tone == 2:
				player_body_mat.albedo_texture = CMS_2
			elif ciar_tone == 3:
				player_body_mat.albedo_texture = CMS_3
			elif ciar_tone == 4:
				player_body_mat.albedo_texture = CMS_4
			elif ciar_tone == 5:
				player_body_mat.albedo_texture = CMS_5
		elif player_race == "Fuar Sìth":
			if fuar_tone == 1:
				player_body_mat.albedo_texture = FUMS_1
			elif fuar_tone == 2:
				player_body_mat.albedo_texture = FUMS_2
			elif fuar_tone == 3:
				player_body_mat.albedo_texture = FUMS_3

func _on_female_chest_size_slider_value_changed(value: float) -> void:
	female_chest_size_value.text = str(value)
	body.set_blend_shape_value(2, value)
	outfit.set_blend_shape_value(2, value)
	CharacterDataAutoload.chest_size_female = value

func _on_female_button_pressed() -> void:
	is_female = true
	male_sliders.visible = false
	female_sliders.visible = true
	body.set_blend_shape_value(1, 1)
	outfit.set_blend_shape_value(1, 1)

func _on_male_button_pressed() -> void:
	is_female = false
	male_sliders.visible = true
	female_sliders.visible = false
	body.set_blend_shape_value(1, 0)
	outfit.set_blend_shape_value(1, 0)

func _on_toggle_clothing_button_toggled(toggled_on: bool) -> void:
	outfit.visible = toggled_on

func _on_feil_race_pressed() -> void:
	body.set_blend_shape_value(10, 1)
	feil_tone = 1
	player_body_mat.albedo_texture = FMS_1
	feil_skin_tone_slider.visible = true
	fuar_skin_tone_slider.visible = false
	trivallen_skin_tone_slider.visible = false
	ciar_skin_tone_slider.visible = false
	erylir_skin_tone_slider.visible = false
	player_race = "Feil Sìth"
	if breasts_value > 0.0:
		player_body_mat.albedo_texture = FFS_1

func _on_ciar_race_pressed() -> void:
	body.set_blend_shape_value(10, 1)
	ciar_tone = 1
	player_body_mat.albedo_texture = CMS_1
	feil_skin_tone_slider.visible = false
	fuar_skin_tone_slider.visible = false
	trivallen_skin_tone_slider.visible = false
	ciar_skin_tone_slider.visible = true
	erylir_skin_tone_slider.visible = false
	player_race = "Ciar Sìth"
	if breasts_value > 0.0:
		player_body_mat.albedo_texture = CFS_1

func _on_fuar_race_pressed() -> void:
	body.set_blend_shape_value(10, 1)
	fuar_tone = 1
	player_body_mat.albedo_texture = FUMS_1
	feil_skin_tone_slider.visible = false
	fuar_skin_tone_slider.visible = true
	trivallen_skin_tone_slider.visible = false
	ciar_skin_tone_slider.visible = false
	erylir_skin_tone_slider.visible = false
	player_race = "Fuar Sìth"
	if breasts_value > 0.0:
		player_body_mat.albedo_texture = FUFS_1

func _on_trivallen_race_pressed() -> void:
	body.set_blend_shape_value(10, 0)
	trivallen_tone = 1
	player_body_mat.albedo_texture = TMS_1
	feil_skin_tone_slider.visible = false
	fuar_skin_tone_slider.visible = false
	trivallen_skin_tone_slider.visible = true
	ciar_skin_tone_slider.visible = false
	erylir_skin_tone_slider.visible = false
	player_race = "Trivallen"
	if breasts_value > 0.0:
		player_body_mat.albedo_texture = TFS_1

func _on_erylir_race_pressed() -> void:
	body.set_blend_shape_value(10, 0)
	erylir_tone = 1
	player_body_mat.albedo_texture = EMS_1
	feil_skin_tone_slider.visible = false
	fuar_skin_tone_slider.visible = false
	trivallen_skin_tone_slider.visible = false
	ciar_skin_tone_slider.visible = false
	erylir_skin_tone_slider.visible = true
	player_race = "Erylir"
	if breasts_value > 0.0:
		player_body_mat.albedo_texture = EFS_1

# Skin Tones

func _on_trivallen_skin_slider_value_changed(value: float) -> void:
	trivallen_skin_value.text = str(value)
	if value == 1:
		trivallen_tone = 1
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = TFS_1
		else:
			player_body_mat.albedo_texture = TMS_1
	elif value == 2:
		trivallen_tone = 2
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = TFS_2
		else:
			player_body_mat.albedo_texture = TMS_2
	elif value == 3:
		trivallen_tone = 3
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = TFS_3
		else:
			player_body_mat.albedo_texture = TMS_3

func _on_erylir_skin_slider_value_changed(value: float) -> void:
	erylir_skin_value.text = str(value)
	if value == 1:
		erylir_tone = 1
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = EFS_1
		else:
			player_body_mat.albedo_texture = EMS_1
	elif value == 2:
		erylir_tone = 2
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = EFS_2
		else:
			player_body_mat.albedo_texture = EMS_2
	elif value == 3:
		erylir_tone = 3
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = EFS_3
		else:
			player_body_mat.albedo_texture = EMS_3

func _on_ciar_skin_slider_value_changed(value: float) -> void:
	ciar_skin_value.text = str(value)
	if value == 1:
		ciar_tone = 1
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = CFS_1
		else:
			player_body_mat.albedo_texture = CMS_1
	elif value == 2:
		ciar_tone = 2
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = CFS_2
		else:
			player_body_mat.albedo_texture = CMS_2
	elif value == 3:
		ciar_tone = 3
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = CFS_3
		else:
			player_body_mat.albedo_texture = CMS_3
	elif value == 4:
		ciar_tone = 4
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = CFS_4
		else:
			player_body_mat.albedo_texture = CMS_4
	elif value == 5:
		ciar_tone = 5
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = CFS_5
		else:
			player_body_mat.albedo_texture = CMS_5

func _on_feil_skin_slider_value_changed(value: float) -> void:
	feil_skin_value.text = str(value)
	if value == 1:
		feil_tone = 1
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = FFS_1
		else:
			player_body_mat.albedo_texture = FMS_1
	elif value == 2:
		feil_tone = 2
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = FFS_2
		else:
			player_body_mat.albedo_texture = FMS_2
	elif value == 3:
		feil_tone = 3
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = FFS_3
		else:
			player_body_mat.albedo_texture = FMS_3

func _on_fuar_skin_slider_value_changed(value: float) -> void:
	fuar_skin_value.text = str(value)
	if value == 1:
		fuar_tone = 1
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = FUFS_1
		else:
			player_body_mat.albedo_texture = FUMS_1
	elif value == 2:
		fuar_tone = 2
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = FUFS_2
		else:
			player_body_mat.albedo_texture = FUMS_2
	elif value == 3:
		fuar_tone = 3
		if CharacterDataAutoload.breasts > 0.0:
			player_body_mat.albedo_texture = FUFS_3
		else:
			player_body_mat.albedo_texture = FUMS_3

func _on_body_tab_pressed() -> void:
	body_content.visible = true
	head_content.visible = false

func _on_head_tab_pressed() -> void:
	head_content.visible = true
	body_content.visible = false

# Eyes

func _on_eye_3_list_item_selected(index: int) -> void:
	if index == 0:
		player_eyes_mat.albedo_texture = E3VIOLET
	elif index == 1:
		player_eyes_mat.albedo_texture = E3BROWN
	elif index == 2:
		player_eyes_mat.albedo_texture = E3ORANGE
	elif index == 3:
		player_eyes_mat.albedo_texture = E3YELLOW
	elif index == 4:
		player_eyes_mat.albedo_texture = E3RED
	elif index == 5:
		player_eyes_mat.albedo_texture = E3ICY
	elif index == 6:
		player_eyes_mat.albedo_texture = E3BLUE
	elif index == 7:
		player_eyes_mat.albedo_texture = E3GREEN
	elif index == 8:
		player_eyes_mat.albedo_texture = E3VOID
	elif index == 9:
		player_eyes_mat.albedo_texture = E3BLACK
	elif index == 10:
		player_eyes_mat.albedo_texture = E3GREY
	elif index == 11:
		player_eyes_mat.albedo_texture = E3WHITE
	elif index == 12:
		player_eyes_mat.albedo_texture = E3BLIND

func _on_eyes_button_left_pressed() -> void:
	eye_index = (eye_index - 1 + max_eye_index + 1) % (max_eye_index + 1)
	update_eye()

func _on_eyes_button_right_pressed() -> void:
	eye_index = (eye_index + 1) % (max_eye_index + 1)
	update_eye()

func update_eye():
	player_eyes_mat.albedo_texture = eyearray[eye_index]
	eyes_label.text = str(eye_index + 1)
	eye_3_list.visible = eye_index == 2

# Mouths

func _on_mouth_button_left_pressed() -> void:
	mouth_index = (mouth_index - 1 + max_mouth_index + 1) % (max_mouth_index + 1)
	update_mouth()

func _on_mouth_button_right_pressed() -> void:
	mouth_index = (mouth_index + 1) % (max_mouth_index + 1)
	update_mouth()

func update_mouth():
	player_mouth_mat.albedo_texture = moutharray[mouth_index]
	mouth_label.text = str(mouth_index + 1)

# Hair

func _on_hair_colour_picker_color_changed(color: Color) -> void:
	player_hair_mat.albedo_color = color 

# Save and Continue

func _on_save_continue_button_pressed() -> void:
	confirm_box.visible = true


func _on_yes_confirm_pressed() -> void:
	set_character_data()
	get_tree().change_scene_to_file("res://Levels/DevLevels/DevDungeon/DevDungeon.tscn")

func set_character_data():
	CharacterDataAutoload.breasts = body.get_blend_shape_value(3)
	CharacterDataAutoload.chest_size_female = body.get_blend_shape_value(2)
	CharacterDataAutoload.chest_size_male = body.get_blend_shape_value(5)
	CharacterDataAutoload.thigh_size = body.get_blend_shape_value(7)
	CharacterDataAutoload.booty_size = body.get_blend_shape_value(8)
	CharacterDataAutoload.arm_size = body.get_blend_shape_value(9)
	
	CharacterDataAutoload.is_female = is_female
	CharacterDataAutoload.player_hair = player_hair_mat.albedo_color
	CharacterDataAutoload.player_skin = player_body_mat.albedo_texture
	CharacterDataAutoload.player_eyes = player_eyes_mat.albedo_texture
	CharacterDataAutoload.player_mouth = player_mouth_mat.albedo_texture
	CharacterDataAutoload.player_name = player_name
	CharacterDataAutoload.player_race = player_race
	if player_race in ["Feil Sìth", "Fuar Sìth", "Ciar Sìth"]:
		CharacterDataAutoload.is_elf = true
	else:
		return

func _on_no_confirm_pressed() -> void:
	confirm_box.visible = false
