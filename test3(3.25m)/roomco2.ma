
[top]
components : room

[room]
type : cell

% Each cell is 25cm x 25cm x 25cm = 15.626 Liters of air each
dim : (30,20)
%dim : (44, 40)

delay : transport
defaultDelayTime : 1000
border : nonwrapped

neighbors :           room(0,-1)
neighbors : room(-1,0)  room(0,0)  room(1,0) 
neighbors :           room(0,1)

%  Background indoor CO2 levels assumed to be 500 ppm
initialvalue : 500
localtransition : rules 

% 3 State Variables corresponding to CO2 concentraion in ppm (conc) and the kind of cell (type)
% Default CO2 concentration inside a building (conc) is 0.05% or 500ppm in normal air
StateVariables: conc type counter
NeighborPorts: c ty co s
StateValues: 500 -100 -1
InitialVariablesValue: roomco2.3.val

% STATE VARIABLE LEGEND :
%   conc = double : represents the CO2 concentration (units of ppm) in a given cell, can be any positive numbe, default value is 500ppm
%
%   type = -100 : normal cell representing air with some CO2 concentration
%   type = -200 : CO2 source, constantly emits a specific CO2 output
%   type = -300 : impermeable structure (ie: walls, chairs, tables, solid objects)
%   type = -400 : doors, fixed at normal indoor background co2 level (500 ppm)
%   type = -500 : window, fixed at lower co2 levels found outside (400 ppm)
%   type = -600 : ventillation, actively removing CO2 (300 ppm)
%   type = -700 : CO2 sensor(500pm)
%   type = -800 : ducts
%   type = -900 : movelable people
%   type = -1000 : destination

[rules]
% No diffusion / CO2 concentration for impermeable structures
rule : { ~c := $conc; ~ty := $type; } { $conc := -10; } 1000 { $type = -300 }

% Doors represent fixed co2 levels of the rest of the building (large volume compared to small room)
rule : { ~c := $conc; ~ty := $type; } { $conc := 500; } 1000 { $type = -400 }

% Windows to the outside have a lower CO2 concentration (anywhere from 300 to 400 ppm)
rule : { ~c := $conc; ~ty := $type; } { $conc := 400; } 1000 { $type = -500 }

% Ventilation actively removes CO2 at a rate greater than doors or windows. (assumed equivalent to 300 ppm)
rule : { ~c := $conc; ~ty := $type; } { $conc := 300; } 1000 { $type = -600 }



% Diffusion between normal air cells 
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/4); } 1000 { $type = -100 AND (-1,0)~c < 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,0)~c + (0,1)~c + (1,0)~c)/4); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (1,0)~c)/4); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c)/4); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c < 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,0)~c + (0,1)~c + (1,0)~c)/3); } 1000 { $type = -100 AND (-1,0)~c < 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c)/3); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c < 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,-1)~c + (0,0)~c + (1,0)~c)/3); } 1000 { $type = -100 AND (-1,0)~c < 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,0)~c + (0,1)~c)/3); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c < 0}

% Diffusion between ducts air cells 
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5); } 1000 { $type = -800 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/4); } 1000 { $type = -800 AND (-1,0)~c < 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,0)~c + (0,1)~c + (1,0)~c)/4); } 1000 { $type = -800 AND (-1,0)~c > 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (1,0)~c)/4); } 1000 { $type = -800 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c)/4); } 1000 { $type = -800 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c < 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,0)~c + (0,1)~c + (1,0)~c)/3); } 1000 { $type = -800 AND (-1,0)~c < 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c)/3); } 1000 { $type = -800 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c < 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,-1)~c + (0,0)~c + (1,0)~c)/3); } 1000 { $type = -800 AND (-1,0)~c < 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,0)~c + (0,1)~c)/3); } 1000 { $type = -800 AND (-1,0)~c > 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c < 0}

rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5); $counter:= $counter + 1; } 1000 { $type = -1000 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0 AND $counter < 125 }
rule : { ~c := $conc; ~ty := $type; } { $conc := ((121.6*2) + (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5)); $counter:= $counter + 1; $type:=-200; } 5000 { $type = -1000 AND $counter = 125 }
% CO2 sources have their concentration continually increased by 12.16 ppm every 5 seconds. Normal diffusion rule applies.
rule : { ~c := $conc; ~ty := $type; } { $conc := ((121.6*2) + (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5)); $counter:= $counter + 1; } 5000 { $type = -200 }
rule : { ~c := $conc; ~ty := $type; } { $conc := ((121.6*2) + (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5)); $counter:= $counter + 1; } 5000 { $type = -900 AND $counter < 125 }

rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5); $counter:= $counter + 1; $type:=-100; } 5000 { $type = -900 AND $counter = 125 }

rule : { ~s := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5); } 60000 { $type = -700 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0}

% Default rule: keep concentration the same if all other rules untrue (should never happen)
rule : { ~c := $conc; ~ty := $type; } 1000 { t }
