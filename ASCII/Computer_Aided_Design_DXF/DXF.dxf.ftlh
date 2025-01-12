<#ftl output_format="plainText" encoding="utf-8">
<#setting locale="en">
<#-- DXF object handle id -->
<#assign object_handle_counter = 0>
<#-- Decimal resolution -->
<#assign resolution = "0.0000000;; roundingMode=halfEven decimalSeparator='.' infinity='∞' nan='NaN'">
<#-- Line width: -1 (by layer), -2 (by block), -3 (default) -->
<#assign line_widths = [0, 5, 9, 13, 15, 18, 20, 25, 30, 35, 40, 50, 53, 60, 70, 80, 90, 100, 106, 120, 140, 158, 200, 211, -1, -2, -3]>
<#-- Unit and conversion settings -->
<#assign unit_type_length                   = unit_type_length???then(unit_type_length, "METER")>
<#assign unit_conversion_angle              = unit_conversion_angle???then(unit_conversion_angle, 1.0)>
<#assign unit_conversion_length             = unit_conversion_length???then(unit_conversion_length, 1.0)>
<#assign unit_conversion_length_uncertainty = unit_conversion_length_uncertainty???then(unit_conversion_length_uncertainty, 1.0)>
<#-- Scale of confidences -->
<#assign vector_scale = vector_scale???then(vector_scale, 250.0)>
<#-- Create list of points -->
<#assign points = {}>
<#assign number_of_points  = 0>
<#assign viewport_center_x = 0>
<#assign viewport_center_y = 0>
<#assign viewport_center_scale = 1000.0>
<#if point_groups??>
	<#list point_groups as group>
		<#if group.visible>
			<#list group.points as point>
				<#assign points = {point.name : point} + points>
				<#assign viewport_center_x += point.y>
				<#assign viewport_center_y += point.x>
				<#assign number_of_points++>
			</#list>
		</#if>
	</#list>
	<#assign viewport_center_x = viewport_center_x / number_of_points>
	<#assign viewport_center_y = viewport_center_y / number_of_points>
</#if>
<#function handle>
	<#assign object_handle_counter = object_handle_counter + 1>
	<#return object_handle_counter>
</#function>
<#function to_hex value hex_string=''>
	<#assign hexadecimal = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']>

	<#assign rem = value?floor % 16>

	<#if value?floor  / 16 gt 0>
		<#return to_hex(value?floor / 16, hexadecimal[rem] + hex_string)>
	<#else>
		<#return hex_string>
	</#if>
</#function>
<#macro printFormattedNumber value format>
	<#lt>${value?string[format]}
	<#return>
</#macro>
999
Java-Applied-Geodesy-3D
<#include "dxf/header.ftlh"    parse=true>
<#include "dxf/classes.ftlh"   parse=false>
<#include "dxf/tables.ftlh"    parse=true>
<#include "dxf/blocks.ftlh"    parse=true>
<#include "dxf/entities.ftlh"  parse=true>
<#include "dxf/objects.ftlh"   parse=true>
0
EOF
