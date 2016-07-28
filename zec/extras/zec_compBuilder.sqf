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
			
	Example:
	_nul = [this,25,1,"My Export"] execVM "zec_compBuilder.sqf";
*/
params [["_keyObj",nil],["_radius",25,[0]],["_delay",1,[0]],["_className","Unknown"],["_ignoreClass","Land_Garbage_line_F"]];

if (isNil "_keyObj") exitWith {};

if (isNil "var_compCount") then {var_compCount = 0};

sleep _delay;

_nearObjects = _keyObj nearObjects _radius;

diag_log text format["class Export%1 {",var_compCount];
diag_log text format["    name = ""%1""; // Credit: %2",_className,profileName];

for "_i" from 0 to (count _nearObjects) -1 do {
	_tmpObj = _nearObjects select _i;
	if (typeOf _tmpObj != _ignoreClass) then {
		_relPos = _keyObj worldToModel (position _tmpObj);	
		diag_log text format["    class Object%1 {side = 8; vehicle = ""%2""; rank = """"; position[] = {%3,%4,0}; dir = %6;};%5",
		_i,
		typeOf _tmpObj,
		_relPos select 0,
		_relPos select 1,
		if (getPosATL _tmpObj select 2 > 0.06) then {format[" // Z: %1",(getPosATL _tmpObj select 2)]} else {""},
		(getDir _tmpObj) - (getDir _keyObj)];
	};
}; 

diag_log text format["};",var_compCount];

var_compCount = var_compCount + 1;