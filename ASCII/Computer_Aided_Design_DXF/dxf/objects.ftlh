<#assign parent_handle_id = utils.handle()>
<#assign child_handle_id  = utils.handle()>

<#function to_string>
	<#assign str = "0
SECTION
2
OBJECTS
0
DICTIONARY
5
${utils.to_hex(parent_handle_id)}
330
0
100
AcDbDictionary
281
1
3
ACAD_GROUP
350
${utils.to_hex(child_handle_id)}
0
DICTIONARY
5
${utils.to_hex(child_handle_id)}
330
${utils.to_hex(parent_handle_id)}
100
AcDbDictionary
281
1
0
ENDSEC">
	<#return str>
</#function>