@icon ("./icon.svg")
@tool

class_name POM extends MultiMeshInstance3D

##Parent needs to be "MeshInstace3D" , otherwise it won't work.
@export var use_parent_mesh:=false

##Shadows will reduce performance , so use it only when needed the most.
@export var shadows:=false

##This handles instance count of mesh. Keep it on lower count for better performance.
@export_range(1,100) var POM_layers:=10
var current_POM_layers:int

##You can change height with this one.
@export var layer_gap:=.11

##You can shift height up or down with this one.
@export_range(-1.0,1.0)var adjust_alpha:=.11

##Keep it low poly for better performance.
@export var mesh:Mesh=BoxMesh.new()
var current_mesh:Mesh


func _process(delta) : if Engine.is_editor_hint() :
	
	cast_shadow=int(shadows)
	if material_override==null:material_override= load("res://addons/POM/POM_material.tres").duplicate()
	material_override.set_shader_parameter("layer_gap",layer_gap)
	material_override.set_shader_parameter("adjust_alpha",adjust_alpha)
	
	if mesh==null:
		mesh=PlaneMesh.new()
	
	if get_parent() is not MeshInstance3D or get_parent().mesh==null:
		use_parent_mesh=false
	
	if use_parent_mesh :
		mesh=get_parent().mesh
		transform=Transform3D(Basis(),Vector3())
	
	if current_POM_layers!=POM_layers or current_mesh!=mesh:
		do_POM()
		current_POM_layers=POM_layers
		current_mesh=mesh


func do_POM():
	
	multimesh=MultiMesh.new()
	multimesh.transform_format=MultiMesh.TRANSFORM_3D
	multimesh.use_colors=true
	multimesh.mesh=mesh
	multimesh.instance_count=POM_layers
	
	for i in POM_layers:
		multimesh.set_instance_transform(i,Transform3D(Basis(),Vector3()))
		var instance_alpha=float(i)/float(POM_layers)
		multimesh.set_instance_color( i,Color(instance_alpha,instance_alpha,instance_alpha,instance_alpha))
