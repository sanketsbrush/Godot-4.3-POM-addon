@icon ("./icon.svg")
@tool
class_name POM extends MultiMeshInstance3D
##Parent needs to be "MeshInstace3D" , otherwise it won't work.
@export var use_parent_mesh:bool=true
var current_shadows:bool
##Shadows will reduce performance , so use it only when needed the most.
@export var shadows:bool=false
var current_POM_layers:int
##This handles instance count of mesh. Keep it on lower count for better performance.
@export_range(1,100) var POM_layers:int=10
var current_layer_gap:float
##You can change height with this one.
@export var layer_gap:float=.11
var current_adjust_alpha:float
##You can shift height up or down with this one.
@export_range(-1.0,1.0)var adjust_alpha:float=.11
var current_mesh:Mesh
##Keep it low poly for better performance.
@export var mesh:Mesh=BoxMesh.new()

func _process(delta) : if Engine.is_editor_hint() :
	if get_parent()is not MeshInstance3D || get_parent().mesh==null: use_parent_mesh=false
	if use_parent_mesh && mesh!=get_parent().mesh:
		mesh=get_parent().mesh
		transform=Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3.ZERO)
	
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
