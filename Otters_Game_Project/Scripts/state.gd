extends Node

var pos1Char : String = "Peepo"
var pos2Char : String = "empty"
var pos3Char : String = "empty"

const Max_Health = 10000

var P1_current_health = 180
var P1_max_health = 180
var P1_damage = 20

var P2_current_health = 50
var P2_max_health = 50
var P2_damage = 20

var P3_current_health = 50
var P3_max_health = 50
var P3_damage = 20

var Peepo_health = 180
var Peepo_max_health = 180
var Peepo_damage = 20

var Starlorn_health = 50
var Starlorn_max_health = 50
var Starlorn_damage = 15

var Ana_health = 100
var Ana_max_health = 100
var Ana_damage = 10

var Cyrus_health = 30
var Cyrus_max_health = 30
var Cyrus_damage = 30

var enemy_type1 = null
var enemy_type2 = null


var enemy1:Resource
var enemy2:Resource

var defeated_enemy
var defeated_enemies = []

var playerx = null
var playery = null

func save_position(x, y):
	playerx = x
	playery = y


func remove_enemy():
	defeated_enemies.insert(0, defeated_enemy)

func load_enemy():
	enemy1 = load("res://Characters/"+enemy_type1+".tres")
	
	if  enemy_type2 != "null":
		enemy2 = load("res://Characters/"+enemy_type2+".tres")

func set_stats():
	match pos1Char:
		"Peepo":
			P1_current_health = Peepo_health
			P1_max_health = Peepo_max_health
			P1_damage = Peepo_damage
		"Starlorn":
			P1_current_health = Starlorn_health
			P1_max_health = Starlorn_max_health
			P1_damage = Starlorn_damage
		"Ana":
			P1_current_health = Ana_health
			P1_max_health = Ana_max_health
			P1_damage = Ana_damage
		"Cyrus":
			P1_current_health = Cyrus_health
			P1_max_health = Cyrus_max_health
			P1_damage = Cyrus_damage
	match pos2Char:
		"Peepo":
			P2_current_health = Peepo_health
			P2_max_health = Peepo_max_health
			P2_damage = Peepo_damage
		"Starlorn":
			P2_current_health = Starlorn_health
			P2_max_health = Starlorn_max_health
			P2_damage = Starlorn_damage
		"Ana":
			P2_current_health = Ana_health
			P2_max_health = Ana_max_health
			P2_damage = Ana_damage
		"Cyrus":
			P2_current_health = Cyrus_health
			P2_max_health = Cyrus_max_health
			P2_damage = Cyrus_damage
	match pos3Char:
		"Peepo":
			P3_current_health = Peepo_health
			P3_max_health = Peepo_max_health
			P3_damage = Peepo_damage
		"Starlorn":
			P3_current_health = Starlorn_health
			P3_max_health = Starlorn_max_health
			P3_damage = Starlorn_damage
		"Ana":
			P3_current_health = Ana_health
			P3_max_health = Ana_max_health
			P3_damage = Ana_damage
		"Cyrus":
			P3_current_health = Cyrus_health
			P3_max_health = Cyrus_max_health
			P3_damage = Cyrus_damage
