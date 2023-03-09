extends Node2D
class_name Game

var value : = 2
var value2 : int = 2
var val := "String"
var arr := [0, 1, 2]
var dict = {"key": 12, "other_key": "value"} # dict.key or dict["key"]
var none = null
var another_array: Array setget set_array, get_array
var vector : Vector2

const Answer = 42

enum ItemTypes {Sword = 12, Axe, Key} # ItemTypes.Sword

export var exported_name = "Name"

onready var _child = get_node("Child")

signal item_acquired(which_item)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("a")
	yield(get_tree().create_timer(1.0), "timeout")
	print("b")
	
	
func _init() -> void:
	# MyClass.new()
	var my_vector := Vector2(2, 5)
	
	#connect("item_acquired", self, "on_item_acquired")
	
	# Game.get_answer()


func on_item_acquired(item) -> void:
	pass

	
func set_array(value : Array) -> void:
	another_array = value
	# Some side-effects
	
func get_array() -> Array:
	.get_array()
	return another_array


static func get_answer() -> int:
	return Answer


func check_answer(my_answer : int = 42) -> int:
	if my_answer == Answer:
		print("correct")
	elif my_answer < Answer:
		print("lesser")
	else:
		print("out of bounds")
		
	while my_answer < Answer:
		my_answer += 1
		
	for x in [5, 7, 11]:
		print(x) # 5, 7, 11
		
	var dict = {"a": 0, "b": 1, "c": 2}
	for i in dict:
		print(i) # a, b, c
		print(dict[i]) # 0, 1, 2
		
	for i in 10: # range(10)
		print(i)
		
	# match
	match my_answer:
		1:
			print("One?")
		Answer:
			print("true answer?")
		45:
			print("Mix and match types")
		_:
			print("No match")
			
	match my_answer:
		42, 43, 44, Answer:
			print("It's close enough")
		53, 1:
			print("It's one of those")
			
	return my_answer


func _on_Button_pressed() -> void:
	pass # Replace with function body.


func _on_Button_mouse_entered() -> void:
	pass # Replace with function body.
