@icon ("./icon.svg")
@tool
class_name POM extends MultiMeshInstance3D

@export var use_parent_mesh:bool=false
var current_shadows:bool
@export var shadows:bool
var current_POM_layers:int
@export_range(1,1000) var POM_layers:int=20
var current_layer_gap:float
@export var layer_gap:float=0.2
var current_adjust_alpha:float
@export_range(-1.0,1.0)var adjust_alpha:float=0.05
var current_mesh:Mesh
@export var mesh:Mesh=BoxMesh.new()

func _process(delta):
	
	if mesh==null&&use_parent_mesh :
		mesh=get_parent().mesh
		
	
	if material_override==null:
		material_override= load("res://addons/POM/POM_material.tres").duplicate()
	
	if(
	current_shadows!=shadows||
	current_POM_layers!=POM_layers||
	current_layer_gap!=layer_gap||
	current_adjust_alpha!=adjust_alpha||
	current_mesh!=mesh):
		do_POM()
		current_shadows=shadows
		current_POM_layers=POM_layers
		current_mesh=mesh

func do_POM():
	material_override.set_shader_parameter("layer_gap",layer_gap)
	material_override.set_shader_parameter("adjust_alpha",adjust_alpha)
	
	if mesh==null:mesh=PlaneMesh.new()
	
	cast_shadow=0
	multimesh=MultiMesh.new()
	multimesh.transform_format=MultiMesh.TRANSFORM_3D
	multimesh.use_colors=true
	multimesh.mesh=mesh
	multimesh.instance_count=POM_layers
	cast_shadow=int(shadows)
	
	for i in POM_layers:
		multimesh.set_instance_transform(i,Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3.ZERO))
		var instance_alpha=(float(i)/float(POM_layers))
		multimesh.set_instance_color(i,Color(Color(instance_alpha,instance_alpha,instance_alpha),instance_alpha))
