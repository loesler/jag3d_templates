<#function to_string>
	<#assign str = "0
SECTION
2
ENTITIES
0
">
<#list layers as layer, layer_properties>
	<#if layer_properties.visible?? && layer_properties.visible>
		<#if point_groups?? && ["NEW_POINT_APOSTERIORI", "DATUM_POINT_APOSTERIORI", "STOCHASTIC_POINT_APOSTERIORI", "REFERENCE_POINT_APOSTERIORI"]?seq_contains(layer)>
			<#list point_groups as group>
				<#if group.visible>
					<#list group.points as point>
						<#assign str += utils.add_point(point.y, point.x, point.z, "Coordinates") + "\r\n">
						<#assign str += utils.add_text(point.y, point.x, point.z, point.name, "Names", 10.0) + "\r\n">
						<#if group.type != "REFERENCE_POINT">
							<#assign confidence_ellipse_major_axis = vector_scale * point.confidence_ellipse_major_axis * unit_conversion_length_uncertainty / unit_conversion_length>
							<#assign confidence_ellipse_minor_axis = vector_scale * point.confidence_ellipse_minor_axis * unit_conversion_length_uncertainty / unit_conversion_length>
							<#assign confidence_ellipse_angle      = 1.5*Math.PI - point.confidence_ellipse_angle * unit_conversion_angle>
							<#if group.dimension != 1 && confidence_ellipse_minor_axis gt 0>
								<#assign str += utils.add_ellipse(point.y, point.x, point.z, confidence_ellipse_major_axis, confidence_ellipse_minor_axis, confidence_ellipse_angle, "Confidences") + "\r\n">
							<#elseif group.dimension == 1 || confidence_ellipse_minor_axis == 0>
								<#assign str += utils.add_line(point.y,  (point.x - 0.5*confidence_ellipse_major_axis),  point.z,  point.y,  (point.x + 0.5*confidence_ellipse_major_axis), point.z, "Confidences") + "\r\n">
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
					<#assign str += utils.add_line(line.point1.y, line.point1.x line.point1.z,  line.point2.y line.point2.x, line.point2.z, "Observations") + "\r\n">
				</#list>
			</#if>
		</#if>
	</#if>
</#list>
<#assign str += "ENDSEC">
	<#return str>
</#function>
