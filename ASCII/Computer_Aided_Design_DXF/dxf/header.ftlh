<#-- 
 0 = Unitless
 1 = Inches
 2 = Feet
 3 = Miles
 4 = Millimeter
 5 = Centimeters
 6 = Meters
 7 = Kilometers
 8 = Microinche
 9 = Mils
10 = Yards
11 = Angstroms
12 = Nanometer
13 = Microns
14 = Decimeters
15 = Decameter
16 = Hectometers
17 = Gigameters
18 = Astronomical units
19 = Light years
20 = Parsecs  (no kidding)
-->
0
SECTION
2
HEADER
9
$ACADVER
1
AC1021
<#-- 
9
$HANDSEED
5
2e
-->
9
<#if unit_type_length??>
$INSUNITS
70
	<#if unit_type_length?lower_case == 'inch'>
1
	<#elseif unit_type_length?lower_case == 'foot'>
2
	<#elseif unit_type_length?lower_case == 'millimeter'>
4
	<#elseif unit_type_length?lower_case == 'meter'>
6
	<#elseif unit_type_length?lower_case == 'nanometer'>
12
	<#elseif unit_type_length?lower_case == 'micrometer'>
13
	<#else>
0
	</#if>
</#if>
0
ENDSEC
