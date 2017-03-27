	-- Ward location
local radiantWardingLocations =
{
	-2927, 780,		-- radiant start	radiant top ward highground
	-457, 340,		-- radiant start	dire mid lane t1
	1767, -2820,	-- radiant start	radiant bot ward highground
	5918, -3125,	-- radiant early	dire bot lane t1	
	-1272, 2726		-- radiant early	dire top ward highground
	-3023, 3916 	-- radiant midgame	dire top bounty rune
	5056, -773		-- radiant midgame 	dire bot t1 highground
	110, 2463		-- radiant midgame	dire top shrine
	5063, 767		-- radiant endgame winning	dire bot t2 highground
	1013, 4643		-- radiant endgame winning	dire top t2 highground
	1017, 2327		-- radiant endgame winning	dire shrine towards t2 mid
	4951, 1833		-- radiant endgame 	location to stand at for mid ward in radiant base
	5105, 2123		-- radiant endgame	mid ward in dire base
	-4368, -1277	-- radiant endgame losing	below radiant top bounty rune - highground
	1965, -4064		-- radiant endgame losing 	radiant jungle
	-1043, 4614		-- radiant endgame losing 	radiant bot highground
	-5139, 2103		-- radiant endgame losing	above radiant top bounty rune - highground
	3540, 161		-- radiant endgame	dire top bounty rune at camps
	-1542, 1989		-- dire start 	mid t1 covers top rune
	-6007, 3519		-- dire start 	top t1 at radiant tower
	-708, -922		-- dire early	radiant mid lane t1
	5264, -4884		-- dire early radiant bot lane - jungle above t1
	473, -2620		-- dire endgame	radiant bot shrine
	-2356, -3541	-- dire endgame	radiant t2 mid behind trees below tower
	-3832, 3144		-- dire jungle small highground below bounty rune
}



function  OnStart()
end

function OnEnd()
end

function GetDesire()
  return 0.0;
end

function Think()
end
