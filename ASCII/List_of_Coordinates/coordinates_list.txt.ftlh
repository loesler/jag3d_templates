<#ftl output_format="plainText" encoding="utf-8">

<#-- Decimal format w.r.t. user preferences -->
<#assign df_length             = "${digits_length???then(digits_length, 0.00000)};;                      roundingMode=halfEven decimalSeparator='.' infinity='∞' nan='NaN'">
<#assign df_length_uncertainty = "${digits_length_uncertainty???then(digits_length_uncertainty, 0.00)};; roundingMode=halfEven decimalSeparator='.' infinity='∞' nan='NaN'">

<#macro printFormattedNumber value format>
	<#t>${value?string[format]?left_pad(15, " ")}<#t>
	<#return>
</#macro>

<#-- Define the table header names -->
<#assign header_id          = "Name">
<#assign header_east        = "East">
<#assign header_north       = "North">
<#assign header_up          = "Up">
<#assign header_sigma_east  = "σy">
<#assign header_sigma_north = "σx">
<#assign header_sigma_up    = "σz">
<#assign header_type        = "Type">
<#-- Define a placeholder for empty values -->
<#assign empty_value        = "-">

<#-- Create list of points -->
<#if point_groups??>
	${header_id?left_pad(15, " ")}<#t>
	${header_type?right_pad(15, " ")}<#t>
	${header_east?left_pad(15, " ")}<#t>
	${header_north?left_pad(15, " ")}<#t>
	${header_up?left_pad(15, " ")}<#t>
	${header_sigma_east?left_pad(15, " ")}<#t>
	${header_sigma_north?left_pad(15, " ")}<#t>
	${header_sigma_up?left_pad(15, " ")}<#t>

	<#list point_groups as group>
		<#assign point_type = "">
		<#if group.type == "REFERENCE_POINT">
			<#assign point_type = "Reference">
		<#elseif group.type == "STOCHASTIC_POINT">
			<#assign point_type = "Stochastic">
		<#elseif group.type == "DATUM_POINT">
			<#assign point_type = "Datum">
		<#elseif group.type == "NEW_POINT">
			<#assign point_type = "Unknown">
		</#if>
		<#list group.points as point>
				${point.name?left_pad(15, " ")}<#t>
				${point_type?right_pad(15, " ")}<#t>
				<#if group.dimension != 1>
					<@printFormattedNumber value=point.y format=df_length/>
					<@printFormattedNumber value=point.x format=df_length/>
				<#else>
					${empty_value?left_pad(15, " ")}<#t>
					${empty_value?left_pad(15, " ")}<#t>
				</#if>
				<#if group.dimension != 2>
					<@printFormattedNumber value=point.z format=df_length/>
				<#else>
					${empty_value?left_pad(15, " ")}<#t>
				</#if>
				<#if group.type != "REFERENCE_POINT" && group.dimension != 1>
					<@printFormattedNumber value=point.sigma_y format=df_length_uncertainty/>
					<@printFormattedNumber value=point.sigma_x format=df_length_uncertainty/>
				<#else>
					${empty_value?left_pad(15, " ")}<#t>
					${empty_value?left_pad(15, " ")}<#t>
				</#if>
				<#if group.type != "REFERENCE_POINT" && group.dimension != 2>
					<@printFormattedNumber value=point.sigma_z format=df_length_uncertainty/>
				<#else>
					${empty_value?left_pad(15, " ")}<#t>
				</#if>
		</#list>
	</#list>
</#if>