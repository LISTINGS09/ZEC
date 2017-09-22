/*
	Author: 2600K [Zeus] - http://zeus-community.net

	Description:
	Writes a collection of objects in a defined area to allow import into addon.

	Parameter(s):
		0 (Required):
			OBJECT - Ideally should be close to the central point of your collection.
		1 (Optional):
			NUMBER - Search Radius, in meters from given object. (Default: 25 (Random))
		2 (Optional): 
			NUMBER - Sleep timer, seconds to wait if calling multiple times. (Default: 1)
		3 (Optional): 
			STRING - The name of your creation. (Default: "Unknown")
		4 (Optional): 
			STRING - The name of a class you wish to ignore (I use 'Land_Garbage_line_F' as I put this script in that item);
			
	Example Object Init:
	_nul = [this, 25, 1, "My Export"] execVM "zec_compBuilder.sqf";
	
	Example Trigger Init:
	_nul = [thisTrigger,(triggerArea thisTrigger select 0), 1, "Aid Station (Water)"] execVM "extras\zec_compBuilder.sqf";
*/
params [["_keyObj",nil],["_radius",25,[0]],["_delay",1,[0]],["_className","Unknown"],["_ignoreClass",typeOf (_this select 0)]];

if (isNil "_keyObj") exitWith {};

if (isNil "var_compCount") then {var_compCount = 0};

sleep _delay;

_nearObjects = _keyObj nearObjects _radius;

diag_log text format["class Export%1 {",var_compCount];
diag_log text format["    name = ""%1""; // Credit: %2",_className,profileName];
diag_log text "    icon = ""\a3\Ui_f\data\Map\Markers\Military\unknown_ca.paa"";";
diag_log text "    side = 8;";

for "_i" from 0 to (count _nearObjects) -1 do {
	_tmpObj = _nearObjects select _i;
	if (typeOf _tmpObj != _ignoreClass) then {
		_relPos = _keyObj worldToModel (position _tmpObj);	
		diag_log text format["    class Object%1 {side = 8; vehicle = ""%2""; rank = """"; position[] = {%3,%4,0}; dir = %5;};",
		_i,
		typeOf _tmpObj,
		_relPos select 0,
		_relPos select 1,
		round (getDir _tmpObj) - (getDir _keyObj)
		];
	};
}; 

diag_log text format["};",var_compCount];

var_compCount = var_compCount + 1;