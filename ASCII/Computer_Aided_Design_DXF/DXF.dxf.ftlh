<#ftl output_format="plainText" encoding="utf-8">
<#setting locale="en">
<#-- Unit and conversion settings -->
<#global unit_type_length                   = unit_type_length???then(unit_type_length, "METER")>
<#global unit_conversion_angle              = unit_conversion_angle???then(unit_conversion_angle, 1.0)>
<#global unit_conversion_length             = unit_conversion_length???then(unit_conversion_length, 1.0)>
<#global unit_conversion_length_uncertainty = unit_conversion_length_uncertainty???then(unit_conversion_length_uncertainty, 1.0)>
<#-- Scale of confidences -->
<#global vector_scale = vector_scale???then(vector_scale, 250.0)>
<#import "dxf/utils.ftlh"    as utils>
<#import "dxf/header.ftlh"   as header>
<#import "dxf/classes.ftlh"  as classes>
<#import "dxf/tables.ftlh"   as tables>
<#import "dxf/blocks.ftlh"   as blocks>
<#import "dxf/objects.ftlh"  as objects>
<#import "dxf/entities.ftlh" as entities>
<#-- Create list of points -->
<#global points = {}>
<#assign number_of_points  = 0>
<#assign viewport_center_x = 0 in tables>
<#assign viewport_center_y = 0 in tables>
<#assign viewport_center_scale = 1000.0 in tables>
<#if point_groups??>
	<#list point_groups as group>
		<#if group.visible>
			<#list group.points as point>
				<#global points = {point.name : point} + points>
				<#assign viewport_center_x += point.y in tables>
				<#assign viewport_center_y += point.x in tables>
				<#assign number_of_points++>
			</#list>
		</#if>
	</#list>
	<#assign viewport_center_x /= number_of_points in tables>
	<#assign viewport_center_y /= number_of_points in tables>
</#if>
<#if unit_type_length??>
	<#if unit_type_length?lower_case == 'inch'>
		<#assign unit=1 in header>
	<#elseif unit_type_length?lower_case == 'foot'>
		<#assign unit=2 in header>
	<#elseif unit_type_length?lower_case == 'millimeter'>
		<#assign unit=4 in header>
	<#elseif unit_type_length?lower_case == 'meter'>
		<#assign unit=6 in header>
	<#elseif unit_type_length?lower_case == 'nanometer'>
		<#assign unit=12 in header>
	<#elseif unit_type_length?lower_case == 'micrometer'>
		<#assign unit=13 in header>
	<#else>
		<#assign unit=0 in header>
	</#if>
</#if>
<#assign classes_str  = classes.to_string()>
<#assign tables_str   = tables.to_string()>
<#assign blocks_str   = blocks.to_string()>
<#assign entities_str = entities.to_string()>
<#assign objects_str  = objects.to_string()>
<#assign header_str   = header.to_string()>
${header_str}
${classes_str}
${tables_str}
${blocks_str}
${entities_str}
${objects_str}
0
EOF
