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

<#assign unit = 0>

<#function to_string>
	<#assign str = "999
Java-Applied-Geodesy-3D
0
SECTION
2
HEADER
9
$ACADVER
1
AC1021
9
$HANDSEED
5
${utils.to_hex(utils.handle())}
9
$INSUNITS
70
${unit}
0
ENDSEC">
	<#return str>
</#function>
