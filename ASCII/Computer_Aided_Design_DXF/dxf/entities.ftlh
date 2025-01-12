<#macro add_point x y z layer='0' line_type='Solid' line_width=-1 color=0>
POINT
5
${to_hex(handle())}
100
AcDbEntity
8
<#lt>${layer}
6
<#lt>${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
<#if color gte 0 && color lte 256>
${color?floor}
<#else>
256
</#if>
100
AcDbPoint
10
<@printFormattedNumber value=x format=resolution/>
20
<@printFormattedNumber value=y format=resolution/>
30
<@printFormattedNumber value=z format=resolution/>
0
<#return>
</#macro>
<#macro add_line x1 y1 z1 x2 y2 z2 layer='0' line_type='Solid' line_width=-1 color=0>
LINE
5
${to_hex(handle())}
100
AcDbEntity
8
<#lt>${layer}
6
<#lt>${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
<#if color gte 0 && color lte 256>
${color?floor}
<#else>
256
</#if>
100
AcDbLine
10
<@printFormattedNumber value=x1 format=resolution/>
20
<@printFormattedNumber value=y1 format=resolution/>
30
<@printFormattedNumber value=z1 format=resolution/>
11
<@printFormattedNumber value=x2 format=resolution/>
21
<@printFormattedNumber value=y2 format=resolution/>
31
<@printFormattedNumber value=z2 format=resolution/>
0
<#return>
</#macro>
<#macro add_text x y z label layer='0' capital_height=10.0 line_type='Solid' line_width=-1 color=0>
TEXT
5
${to_hex(handle())}
100
AcDbEntity
8
<#lt>${layer}
6
<#lt>${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
<#if color gte 0 && color lte 256>
${color?floor}
<#else>
256
</#if>
100
AcDbText
1
<#lt>${label}
7
STANDARD
10
<@printFormattedNumber value=x format=resolution/>
20
<@printFormattedNumber value=y format=resolution/>
30
<@printFormattedNumber value=z format=resolution/>
11
<@printFormattedNumber value=x format=resolution/>
21
<@printFormattedNumber value=y format=resolution/>
31
<@printFormattedNumber value=z format=resolution/>
40
<@printFormattedNumber value=capital_height format=resolution/>
50
0.0
51
0.0
100
AcDbText
0
<#return>
</#macro>
<#macro add_ellipse x y z a b alpha layer='0' line_type='Solid' line_width=-1 color=0>
ELLIPSE
5
${to_hex(handle())}
100
AcDbEntity
8
<#lt>${layer}
6
<#lt>${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
<#if color gte 0 && color lte 256>
${color?floor}
<#else>
256
</#if>
100
AcDbEllipse
10
<@printFormattedNumber value=x format=resolution/>
20
<@printFormattedNumber value=y format=resolution/>
30
<@printFormattedNumber value=z format=resolution/>
11
<@printFormattedNumber value=(Math.cos(alpha) * a) format=resolution/>
21
<@printFormattedNumber value=(Math.sin(alpha) * a) format=resolution/>
31
<@printFormattedNumber value=z format=resolution/>
40
<@printFormattedNumber value=(b / a) format=resolution/>
41
0.0
42
360.0
0
<#return>
</#macro>
0
SECTION
2
ENTITIES
0
<#list layers as layer, layer_properties>
	<#if layer_properties.visible?? && layer_properties.visible>
		<#if point_groups?? && ["NEW_POINT_APOSTERIORI", "DATUM_POINT_APOSTERIORI", "STOCHASTIC_POINT_APOSTERIORI", "REFERENCE_POINT_APOSTERIORI"]?seq_contains(layer)>
			<#list point_groups as group>
				<#if group.visible>
					<#list group.points as point>
						<@add_point  x=point.y  y=point.x  z=point.z layer='Coordinates' />
						<@add_text x=point.y  y=point.x  z=point.z  label=point.name  layer='Point_names' capital_height=10.0  />
						<#if group.type != "REFERENCE_POINT">
							<#assign helmert_major_axis = vector_scale * point.helmert_major_axis * unit_conversion_length_uncertainty / unit_conversion_length>
							<#assign helmert_minor_axis = vector_scale * point.helmert_minor_axis * unit_conversion_length_uncertainty / unit_conversion_length>
							<#assign helmert_alpha      = 1.5*Math.PI - point.helmert_alpha * unit_conversion_angle>
							<#if group.dimension != 1 && helmert_minor_axis gt 0>
								<@add_ellipse x=point.y  y=point.x  z=point.z  a=helmert_major_axis  b=helmert_minor_axis alpha=helmert_alpha layer='Confidences' />
							<#elseif group.dimension == 1 || helmert_minor_axis == 0>
								<@add_line x1=point.y  y1=(point.x - 0.5*helmert_major_axis)  z1=point.z   x2=point.y  y2=(point.x + 0.5*helmert_major_axis)  z2=point.z layer='Confidences' />
							</#if>
						</#if>
					</#list>
				</#if>
			</#list>
		</#if>
		<#if observation_groups?? && layer == "OBSERVATION_APOSTERIORI">
			<#assign observation_lines = {}>
			<#list observation_groups as group>
				<#list group.observations as observation>
					<#if points[observation.start_point_name]?? && points[observation.end_point_name]??>
						<#assign point_pair1 = [observation.start_point_name, observation.end_point_name]?join("-")>
						<#assign point_pair2 = [observation.end_point_name, observation.start_point_name]?join("-")>
						<#if observation_lines[point_pair1]?? || observation_lines[point_pair2]??>
							<#continue>
						<#else>
							<#assign observation_lines = {point_pair1 : {
									'point1': points[observation.start_point_name], 
									'point2': points[observation.end_point_name]
							}  } + observation_lines>
						</#if>
					</#if>
				</#list>
			</#list>
			<#if observation_lines??>
				<#list observation_lines as key, line>
					<@add_line x1=line.point1.y  y1=line.point1.x  z1=line.point1.z   x2=line.point2.y  y2=line.point2.x  z2=line.point2.z layer='Observations' />
				</#list>
			</#if>
		</#if>
	</#if>
</#list>
ENDSEC
