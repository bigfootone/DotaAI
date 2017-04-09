	-- Ward location
	
local wardingLocations =
{
	Vector(-2927, 780),		-- radiant start	radiant top ward highground
	Vector(-457, 340),		-- radiant start	dire mid lane t1
	Vector(1767, -2820),	-- radiant start	radiant bot ward highground
	Vector(5918, -3125),	-- radiant early	dire bot lane t1	
	Vector(-1272, 2726),		-- radiant early	dire top ward highground
	Vector(-3023, 3916), 	-- radiant midgame	dire top bounty rune
	Vector(5056, -773),		-- radiant midgame 	dire bot t1 highground
	Vector(110, 2463),		-- radiant midgame	dire top shrine
	Vector(5063, 767),		-- radiant endgame winning	dire bot t2 highground
	Vector(1013, 4643),		-- radiant endgame winning	dire top t2 highground
	Vector(1017, 2327), 	-- radiant endgame winning	dire shrine towards t2 mid
	Vector(4951, 1833),		-- radiant endgame 	location to stand at for mid ward in radiant base
	Vector(5105, 2123),		-- radiant endgame	mid ward in dire base
	Vector(-4368, -1277),	-- radiant endgame losing	below radiant top bounty rune - highground
	Vector(1965, -4064),		-- radiant endgame losing 	radiant jungle
	Vector(-1043, 4614),		-- radiant endgame losing 	radiant bot highground
	Vector(-5139, 2103),		-- radiant endgame losing	above radiant top bounty rune - highground
	Vector(3540, 161),		-- radiant endgame	dire top bounty rune at camps
	Vector(-1542, 1989),		-- dire start 	mid t1 covers top rune
	Vector(-6007, 3519),		-- dire start 	top t1 at radiant tower
	Vector(-708, -922),		-- dire early	radiant mid lane t1
	Vector(5264, -4884),		-- dire early radiant bot lane - jungle above t1
	Vector(473, -2620),		-- dire endgame	radiant bot shrine
	Vector(-2356, -3541),	-- dire endgame	radiant t2 mid behind trees below tower
	Vector(-3832, 3144)		-- dire jungle small highground below bounty rune
}

bot = GetBot();
numberOfWards = 0;
wardLocation = Vector(0, 0);	
observerWard = "item_ward_observer";
wardCastRange = 500;
team = bot:GetTeam(); -- radiant = 2, dire = 3
t1Top = GetTower(team, TOWER_TOP_1);
t2Top = GetTower(team, TOWER_TOP_2);
t3Top = GetTower(team, TOWER_TOP_3);
t1Mid = GetTower(team, TOWER_MID_1);
t2Mid = GetTower(team, TOWER_MID_2);
t3Mid = GetTower(team, TOWER_MID_3);
t1Bot = GetTower(team, TOWER_BOT_1);
t2Bot = GetTower(team, TOWER_BOT_2);
t3Bot = GetTower(team, TOWER_BOT_3);

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------


function  OnStart()

end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function OnEnd()
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function GetDesire()
  	
	local numberOfWards = GetUnitList(UNIT_LIST_ALLIED_WARDS);
	local inventoryWards = checkHoldingWards();
	
	local nearbyEnemyHeroes = bot:GetNearbyHeroes(1500, true, BOT_MODE_NONE);
	local nearbyEnemyTowers = bot:GetNearbyTowers(1500, true);
	
  if(#nearbyEnemyHeroes > 0 and #nearbyEnemyTowers > 0)
   then
     return BOT_MODE_DESIRE_NONE;
  end

  if(inventoryWards > 0)  -- check to see if we have wards
    then
    	if(#numberOfWards < 2) -- check to see if there are less than 2 wards on the map
    		then	
    			return BOT_MODE_DESIRE_HIGH;
    	elseif(bot:GetActiveMode() == BOT_MODE_WARD and inventoryWards > 0) -- if we are warding, keep warding 
    		then	
    			return BOT_MODE_DESIRE_MODERATE;
			elseif(inventoryWards >= 2) -- if we have 2 or wards, we want to ward
			 then
			   return BOT_MODE_DESIRE_HIGH;
		  end
	else
    return BOT_MODE_DESIRE_NONE;
  end
	

 	
end


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
function Think()
  
  -- if all t1 towers are alive
  if(t1Top and t1Mid and t1Bot and DotaTime() < 180)
    then
      local wardSpot = 2;
      local canWard = checkForWards(wardingLocations[wardSpot]);
      if(canWard == true)
        then
          wardLocation = wardingLocations[wardSpot];    
      else
          wardSpot = 3;
          canWard = checkForWards(wardingLocations[wardSpot]);
          if(canWard == true)
            then
              wardLocation = wardingLocations[wardSpot];
          end
      end
  end
      
      
  -- if all t1 towers are alive and its past the start ofthe game 
  if(t1Top and t1Mid and t1Bot and DotaTime() > 180)
    then
    
      local wardSpot = 4;
      canWard = checkForWards(wardingLocations[wardSpot]);
      
      if(canWard == true)
        then
          wardLocation = wardingLocations[wardSpot];   
          
      elseif(canWard == false)
        then
          wardSpot = 2;
          canWard = checkForWards(wardingLocations[wardSpot]);
          
          if(canWard == true)
            then
              wardLocation = wardingLocations[wardSpot];
          end
          
      elseif(canWard == false)
        then
          wardSpot = 5;
          canWard = checkForWards(wardingLocations[wardSpot]);
          
          if(canWard == true)
            then
              wardLocation = wardingLocations[wardSpot];
          end     
      else
        print("welp");
      end
  end

		
		-- Place the ward
		if(wardLocation ~= nil)
		 then	  
		   local slotNumber = bot:FindItemSlot("item_ward_observer");  
       local wardHandle = bot:GetItemInSlot(slotNumber);    
		   local distanceToWard = GetUnitToLocationDistance(bot, wardLocation);
		   if(distanceToWard < wardCastRange and slotNumber <= 5) -- are we close enough to place the ward
  	     then 	     		        
		        bot:Action_UseAbilityOnLocation(wardHandle, wardLocation);		                        
       else
          bot:Action_MoveToLocation(wardLocation);
          if(slotNumber > 5)        
            then                
              for i=0,5,1 -- find swappable item
                do                
                  local curItem = bot:GetItemInSlot(i);                  
                  if(curItem == nil or curItem:GetName() == "item_tango" or curItem:GetName() == "item_clarity")
                    then                     
                      bot:ActionImmediate_SwapItems(slotNumber, i);                
                  end
              end         
           end
        end
    end
	
end


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function checkForWards(location)


    local currentWards = GetUnitList(UNIT_LIST_ALLIED_WARDS);
    local safeToWard = true;
    for k, v in pairs(currentWards)
      do
        if(GetUnitToLocationDistance(v, location) < 2000)
          then  
            safeToWard = false;
        end
    end
    return safeToWard;
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function checkHoldingWards()

  local numberOfWardsHolding = 0;
  for i=0,8,1
    do
      local curItem = bot:GetItemInSlot(i);
      if(curItem ~= nil)
        then  
          local itemName = curItem:GetName();
          if(itemName == observerWard)
            then
              numberOfWardsHolding = curItem:GetCurrentCharges();
          end
      end
  end
  
  return numberOfWardsHolding;
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------