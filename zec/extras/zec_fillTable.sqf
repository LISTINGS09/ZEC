/*
	Author: 2600K [Zeus] - http://zeus-community.net

	Description:
	Fills a table object with assorted items. Place in core objects INIT field.

	Parameter(s):
		0 (Required):
			OBJECT - The object you want to decorate.
		1 (Optional):
			NUMBER - Fill item type: 0=Random, 1=Office, 2=Food, 3=Medical, 4=Tools. (Default: 0 (Random))
			ARRAY - Fill with ONLY objects from this array.
		2 (Optional): 
			NUMBER - % of space to fill between 0 (no items!) and 100 (full). (Default: 40)
	
	Returns:
	BOOL
			
	Example:
	_nul = [MYTABLE1] execVM "scripts\zec\scripts\zec_fillTable.sqf";
	_nul = [MYTABLE1,["Land_RiceBox_F","Land_BottlePlastic_V2_F"],20] execVM "scripts\zec\scripts\zec_fillTable.sqf";
*/

private ["_itemArray","_fromEdge","_offSet","_objBB"];
params [["_obj",nil,[objNull]],["_fillType",0,[[],0]],["_fillPercent",40,[0]]];

if (!isServer || isNil "_obj") exitWith {diag_log text "[ERROR] (z_fillItems.sqf): Invalid or missing object passed to script."; false};

if (typeName _fillType == "ARRAY") then {
	_itemArray = [];
	{
		if (!isClass (configFile >> "CfgWeapons" >> _x)) then {
			_itemArray pushBack _x;
		} else {
			diag_log text format["[ERROR] (z_fillItems.sqf): Invalid item passed '%1'.",_x];
		};
	} forEach _fillType;
	
	_itemArray = _fillType;
} else {
	private ["_itemIntel","_itemFood","_itemMedical","_itemTools"];
	_itemIntel = getArray (configFile >> "CfgPatches" >> "A3_Structures_F_Items_Documents" >> "Units") 
					+ getArray (configFile >> "CfgPatches" >> "A3_Structures_F_Items_Stationery" >> "Units");
					
	_itemFood = getArray (configFile >> "CfgPatches" >> "A3_Structures_F_EPA_Items_Food" >> "Units") 
					+ getArray (configFile >> "CfgPatches" >> "A3_Structures_F_Items_Cans" >> "Units");
					
	_itemMedical = getArray (configFile >> "CfgPatches" >> "A3_Structures_F_EPA_Items_Medical" >> "Units");
	
	_itemTools =  getArray (configFile >> "CfgPatches" >> "A3_Structures_F_Items_Tools" >> "Units") 
					+ getArray (configFile >> "CfgPatches" >> "A3_Structures_F_EPA_Items_Tools" >> "Units");
					
	_itemTools = _itemTools - ["Land_FireExtinguisher_F","Land_Axe_F","Land_Axe_fire_F","Land_DrillAku_F","Land_Shovel_F","Land_MetalWire_F"];  // Remove large items.

	switch (_fillType) do {
		case 1: { // Office
			_itemArray = _itemIntel + ["Land_FMradio_F","Land_HandyCam_F","Land_MobilePhone_old_F","Land_MobilePhone_smart_F","Land_PortableLongRangeRadio_F"];
		};
		case 2: { // Food
			_itemArray = _itemFood + ["Land_TinContainer_F"] + (_itemFood - ["Land_Canteen_F","Land_CerealsBox_F"]);
		};
		case 3: { // Medical
			_itemArray = _itemMedical + (_itemMedical - ["Land_Defibrillator_F"]);
		};
		case 4: { // Tools
			_itemArray =  _itemTools + (_itemTools - ["Land_Grinder_F"]);
		};
		default { // Random
			_itemArray = _itemIntel + _itemFood + _itemMedical;
		};
	};
};

if (isNil "_itemArray") exitWith {false};

fnc_attachItem = {
	params ["_objAtt","_item","_itemToPos",["_forceDir",random 360]];
	private ["_objT"];

	//diag_log text format["[DEBUG] (z_fillItems.sqf): Creating item '%1' on '%2' at %3.",_item,_objAtt,_itemToPos];
	
	_objT = _item createVehicle [0,0,0];
	_objT allowDamage false;
	_objT enableSimulation false;
	_objT attachTo [_objAtt,[(_itemToPos select 0),(_itemToPos select 1),(_itemToPos select 2) + ((boundingBox _objT select 1) select 2)]];
	_objT setDir _forceDir;
};

_fromEdge = [0.1,0.05,0.1,0.05]; // Indent from XX & YY boundingBox.
_itemSpacing = [0.2,0.2]; // Space between items.
_offSet = [0]; // Z for each layer of items (shelves etc).

// Overrides to overcome bounding/model issues.
switch (typeOf _obj) do {
	case "Land_CashDesk_F": {_fromEdge = [0.2,0.2,0.3,0.05]; _offSet = [-0.26,-0.75,-1.26]};
	case "Land_CratesWooden_F": {_fromEdge = [1.88,0.2,0.3,0.3]; _offSet = [-0.78]};
	case "Fridge_01_open_F": {_fromEdge = [0.7,0.7,0.8,0.7]; _offSet = [-0.78,-1.33,-1.51]};
	case "Fridge_01_closed_F": {_fromEdge = [0.6,0.6,0.6,0.6]; _offSet = [-0.78]};
	case "Land_Metal_rack_F": {_fromEdge = [0.1,0.05,0.15,0.05]; _offSet = [-0.35,-0.8,-1.25,-1.7]};
	case "Land_Metal_rack_Tall_F": {_fromEdge = [0.1,0.1,0.15,0.05]; _offSet = [-0.075,-0.46,-0.84,-1.22,-1.6]};
	case "Land_Metal_wooden_rack_F": {_offSet = [0,-0.42,-0.92,-1.42,-1.92]};
	case "Land_MobileScafolding_01_F": {_offSet = [-1.125]};
	case "Land_Rack_F": {_fromEdge = [0.2,0.2,0.2,0.2]; _offSet = [-0.15,-0.53,-0.84,-1.2,-1.52]};
	case "Land_ShelvesWooden_F"; case "Land_ShelvesWooden_blue_F"; case "Land_ShelvesWooden_khaki_F": {_fromEdge = [0.1,0.1,0.2,0.2]; _offSet = [-0.04,-0.39,-0.7]};
	case "Land_ShelvesMetal_F": {_fromEdge = [0.2,0.2,0.1,0.1];_offSet = [-0.24,-0.595,-0.945,-1.3]};
	case "Land_TablePlastic_01_F": {_fromEdge = [0.3,0.3,0.1,0.1]; _offSet = [-0.005]};
	case "Land_ToolTrolley_01_F": {_fromEdge = [0.15,0.15,0.25,0.25]; _offSet = [-0.13,-0.48,-0.83]};
	case "Land_RattanTable_01_F"; case "Land_WoodenTable_large_F"; case "Land_WoodenTable_small_F": {_offSet = [-0.005]}; 
	case "Land_Workbench_01_F": {_fromEdge = [0.1,0.1,0.35,0.1]; _offSet = [-0.175]};
	case "OfficeTable_01_new_F"; case "OfficeTable_01_old_F": {_fromEdge = [1.1,1,0.65,0.6]; _offSet = [-0.65]};
};

_objBB = boundingBox _obj;

{
	for [{_i = ((_objBB select 0) select 0)+(_fromEdge select 0)},{_i < ((_objBB select 1) select 0)-(_fromEdge select 1)},{_i =  _i + (_itemSpacing select 0) + random 0.1}] do {
		for [{_j = ((_objBB select 0) select 1)+(_fromEdge select 2)},{_j < ((_objBB select 1) select 1)-(_fromEdge select 3)},{_j = _j + (_itemSpacing select 1) + random 0.1}] do {
			if (random 100 < _fillPercent) then {
				[_obj,_itemArray call BIS_fnc_selectRandom,[_i,_j,((_objBB select 1) select 2) + _x]] spawn fnc_attachItem;
			};
		};
	};
} forEach _offSet;

true