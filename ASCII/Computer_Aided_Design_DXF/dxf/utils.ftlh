<#-- Decimal resolution -->
<#assign resolution = "0.0000000;; roundingMode=halfEven decimalSeparator='.' infinity='∞' nan='NaN'">

<#-- Line width: -1 (by layer), -2 (by block), -3 (default) -->
<#assign line_widths = [0, 5, 9, 13, 15, 18, 20, 25, 30, 35, 40, 50, 53, 60, 70, 80, 90, 100, 106, 120, 140, 158, 200, 211, -1, -2, -3]>

<#-- DXF object handle id -->
<#assign object_handle_counter = 0>

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

<#function print_formatted_number value format=resolution>
	<#return value?string[format]>
</#function>




<#function add_layer name line_type='Solid' line_width=-3 color=0>
	<#if color?floor lt 0 || color?floor gt 256>
		<#assign color = 0>
	</#if>
	
	<#assign str = "LAYER
5
${to_hex(handle())}
100
AcDbSymbolTableRecord
100
AcDbLayerTableRecord
2
${name}
6
${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -3)}
62
${color?floor}
70
0
390
0
0">
	<#return str>
</#function>


<#function add_point x y z layer='0' line_type='Solid' line_width=-1 color=1>
	<#if color?floor lt 0 || color?floor gt 256>
		<#assign color = 256>
	</#if>
	
	<#assign str = "POINT
5
${to_hex(handle())}
100
AcDbEntity
8
${layer}
6
${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
${color?floor}
100
AcDbPoint
10
${print_formatted_number(x)}
20
${print_formatted_number(y)}
30
${print_formatted_number(z)}
0">
	<#return str>
</#function>


<#function add_line x1 y1 z1 x2 y2 z2 layer='0' line_type='Solid' line_width=-1 color=256>
	<#if color?floor lt 0 || color?floor gt 256>
		<#assign color = 256>
	</#if>
	
	<#assign str = "LINE
5
${to_hex(handle())}
100
AcDbEntity
8
${layer}
6
${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
${color?floor}
100
AcDbLine
10
${print_formatted_number(x1)}
20
${print_formatted_number(y1)}
30
${print_formatted_number(z1)}
11
${print_formatted_number(x2)}
21
${print_formatted_number(y2)}
31
${print_formatted_number(z2)}
0">
	<#return str>
</#function>


<#function add_text x y z text layer='0' capital_height=10.0 line_type='Solid' line_width=-1 color=256>
	<#if color?floor lt 0 || color?floor gt 256>
		<#assign color = 256>
	</#if>
	
	<#assign str = "TEXT
5
${to_hex(handle())}
100
AcDbEntity
8
${layer}
6
${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
${color?floor}
100
AcDbText
1
${text}
7
STANDARD
10
${print_formatted_number(x)}
20
${print_formatted_number(y)}
30
${print_formatted_number(z)}
11
${print_formatted_number(x)}
21
${print_formatted_number(y)}
31
${print_formatted_number(z)}
40
${print_formatted_number(capital_height)}
50
0.0
51
0.0
100
AcDbText
0">
	<#return str>
</#function>



<#function add_ellipse x y z a b alpha layer='0' line_type='Solid' line_width=-1 color=256>
	<#if color?floor lt 0 || color?floor gt 256>
		<#assign color = 256>
	</#if>
	
	<#assign str = "ELLIPSE
5
${to_hex(handle())}
100
AcDbEntity
8
${layer}
6
${line_type}
370
${line_widths?seq_contains(line_width)?string(line_width, -1)}
62
${color?floor}
100
AcDbEllipse
10
${print_formatted_number(x)}
20
${print_formatted_number(y)}
30
${print_formatted_number(z)}
11
${print_formatted_number(Math.cos(alpha) * a)}
21
${print_formatted_number(Math.sin(alpha) * a)}
31
${print_formatted_number(0)}
40
${print_formatted_number(b / a)}
41
0.0
42
6.28318530718
0">
	<#return str>
</#function>
