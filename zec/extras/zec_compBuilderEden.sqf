/*
	Author: 2600K [Zeus] - http://zeus-community.net

	Description:
	Writes a collection of objects in a defined area to allow import into addon, use in debug editor after selecting the central object.
*/

_keyObj = get3DENSelected "Object"#0; 
_radius = 15; 
 
if (isNil "_keyObj") exitWith {}; 
 
if (isNil "var_compCount") then {var_compCount = 0}; 
 
_nearObjects = _keyObj nearObjects _radius; 
 
diag_log text format["class Export%1 {",var_compCount]; 
diag_log text format["    name = ""Unknown""; // Credit: %2",_className,profileName]; 
diag_log text "    icon = ""\a3\Ui_f\data\Map\Markers\Military\unknown_ca.paa"";"; 
diag_log text "    side = 8;"; 
 
{ 
 _relPos = _keyObj worldToModel (position _x);  
  
 diag_log text format["    class Object%1 {side = 8; vehicle = ""%2""; rank = """"; position[] = {%3,%4,%5}; dir = %6;};", 
  _forEachIndex, 
  typeOf _x, 
  _relPos select 0, 
  _relPos select 1, 
  if (_relPos select 2 > 0.1) then { _relPos select 2 } else { 0 }, 
  round (getDir _x) - (getDir _keyObj) 
 ]; 
} forEach (_keyObj nearObjects _radius); 
 
diag_log text format["};",var_compCount]; 
 
var_compCount = var_compCount + 1;