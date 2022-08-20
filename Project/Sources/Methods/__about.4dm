//%attributes = {}
/* Purpose: 

The idea here is to have two objects that provide mapping between the listbox 
constants (*1), which are available through various commands and  LISTBOX Get property,
and the corresponding JSON properties on a form definition. 

The reason to have such a list is to make it easier to reference data between
the two formats. 

For example, you might adopt a strategy of saving user preferences for various
listbox properties using the same format as the listbox JSON, e.g.
  a listbox column definition is
{
  "header": {
    "text": "Date",
    "name": "Header4"  
  },
  "name": "Column4",
  "footer": {
    "name": "Footer4"
  },
  "dataSource": "This:C1470.Invoice_Date",
  "enterable": false,
  "width": 70,
  "dataSourceTypeHint": "date",
  "styledText": 1
}

Width, enterable and even dataSourceTypeHint are pretty easy. However, styledText
corresponds with the `lb multi style` constant. We need a way to easily translate
the information from one modality to another.  
 ------------------
*1)  see:  https://doc.4d.com/4Dv19R5/4D/19-R5/List-Box.302-5831593.en.html


 Created by: Kirk as Designer, Created: 08/20/22, 14:56:44
 */


/*
I like using objects as associative arrays for these chores. 
*/

$JSONmap:=New object(\
"wordwrap"; lk allow wordwrap; \
"rowHeightAuto"; lk auto row height; \
"rowFillSource"; lk background color expression; \
"maxWidth"; lk column max width; \
"minWidth"; lk column min width; \
"resizable"; lk column resizable; \
"controlType"; lk display type; \
"hideExtraBlankRows"; lk extra rows; \
"rowStrokeSource"; lk font color expression; \
"rowStyleSource"; lk font style expression; \
"hideSystemHighlight"; lk hide selection highlight; \
"styledText"; lk multi style; \
"resizingMode"; lk resizing mode; \
"selectionMode"; lk selection mode; \
"singleClickEdit"; lk single click edit; \
"sortable"; lk sortable; \
"truncateMode"; lk truncate)

/*  With this object available I could set appropriate properties on a 
listbox already displayed based on values in the JSON definition: 

*/

$prefsObj:=New object("singleClickEdit"; 1; "hideExtraBlankRows"; 1)

For each ($property; $prefsObj)  //  loop through the properties of the prefs
	
	If ($JSONmap[$property]#Null)  // if the property is defined
		//  set it to the pref value
		LISTBOX SET PROPERTY(*; "listboxName"; $JSONmap[$property]; $prefsObj[$property])
		
	End if 
	
End for each 

// --------------------------------------------------------
/*  We can use the same strategy to collect data from a displayed listbox. 

Here I'm using a trick. Numbers are not valid JSON property names but
you can use them. The limitation is you can't use dot notation. But you
can use the square brackets. So I can make an object where each 'key'
is the stringified value of the 4D constant and the value is the JSON 
property. 

With this I could update a preference object. 
*/
$constantMap:=New object(\
String(lk allow wordwrap); "wordwrap"; \
String(lk auto row height); "rowHeightAuto"; \
String(lk background color expression); "rowFillSource"; \
String(lk column max width); "maxWidth"; \
String(lk column min width); "minWidth"; \
String(lk column resizable); "resizable"; \
String(lk display type); "controlType"; \
String(lk extra rows); "hideExtraBlankRows"; \
String(lk font color expression); "rowStrokeSource"; \
String(lk font style expression); "rowStyleSource"; \
String(lk hide selection highlight); "hideSystemHighlight"; \
String(lk multi style); "styledText"; \
String(lk resizing mode); "resizingMode"; \
String(lk selection mode); "selectionMode"; \
String(lk single click edit); "singleClickEdit"; \
String(lk sortable); "sortable"; \
String(lk truncate); "truncateMode")

$prefsObj:=New object()  //  I'm going to collect them all

For each ($constantStr; $constantMap)
	$constant_value:=Num($constantStr)
	
	$prefsObj[$constantMap[$constantStr]]:=LISTBOX Get property(*; "listboxName"; $constant_value)
	
End for each 

/* Preferences is just one use case. 

*/
