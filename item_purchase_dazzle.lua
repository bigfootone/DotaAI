
local itemsToBuy = 
{
  "item_flying_courier",
  "item_magic_stick",
  "item_boots",
  "item_branches",
  "item_circlet",
  --"item_energy_booster",
  "item_cloak",
  "item_shadow_amulet",
  "item_branches",
  --"item_energy_booster",
  "item_ring_of_health",
  "item_recipe_aether_lens",
  "item_staff_of_wizardry",
  "item_ring_of_regen",
  "item_recipe_force_staff",
  "item_ghost",
};

local startingItems = 
{
  "item_courier",
  "item_tango",
  "item_clarity",
  "item_flask",
  "item_branches",
};

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

  local bot = GetBot();
  local numberOfWards = GetItemStockCount("item_ward_observer");
  local nextItem = itemsToBuy[1];
  local nextStartingItem = startingItems[1];
  local team = GetTeam();
  local enemyTeam = {}
    
  -- Check for 2 Observer Wards in stock
  if( GetItemStockCount("item_ward_observer") >= 2)
   then
    for i=numberOfWards,1,-1
     do
       if(bot :GetGold() >= GetItemCost("item_ward_observer"))
        then
          bot:ActionImmediate_PurchaseItem("item_ward_observer");
        end
     end   
  end
   
  
  -- Check and buy tp scrolls 
  if(DotaTime() >= 181)
    then
     buyTPScroll(bot);
  end
   

  -- Purchase item if bot has enough gold
  if( bot :GetGold() >= GetItemCost (nextItem) and DotaTime() >= 211)
    then
       bot:ActionImmediate_PurchaseItem(nextItem);
       print( "item purchased:" .. nextItem);
       table.remove(itemsToBuy, 1);
    end
  
  
  -- Purchase starting items
  if(#startingItems >= 1)
    then
      bot:ActionImmediate_PurchaseItem(nextStartingItem);
      table.remove(startingItems, 1);
    end
    
    
  -- Identify enemy heroes
  if(team == 2)
    then
      for i=6,10,1
        do
         enemyTeam[i-5] = GetSelectedHeroName(i);
      end
  else if (team == 3)
    then
      for i=1,5,1
        do
          enemyTeam[i] = GetSelectedHeroName(i);
      end
  end
  end
  
  
  -- Check for true sight heroes and remove invis items
  for i, v in pairs(enemyTeam)
    do
      if (v == "npc_dota_hero_zuus" or v == "npc_dota_hero_bounty_hunter")
        then
          for i=1,#itemsToBuy, 1
            do
              if(itemsToBuy[i] == "item_cloak" or itemsToBuy[i] == "item_shadow_amulet")
                then
                  table.remove(itemsToBuy, i);
                  print("removed");
              end
          end
      end
  end

end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function buyTPScroll(npcBot)

  local noOfTPs = 0;
  local botTP = GetBot();
 
 
  for i=0,16,1
    do
      local curItem = botTP:GetItemInSlot(i);
      if(curItem ~= nil)
        then  
          local itemName = curItem:GetName();
          if(itemName == "item_tpscroll")
            then
              noOfTPs = noOfTPs + 1;
          end
      end
  end
  
  
  -- Check for tp scrolls
  if( noOfTPs == 0 and DotaTime() >= 180)
    then
      botTP:ActionImmediate_PurchaseItem("item_tpscroll");
      botTP:ActionImmediate_PurchaseItem("item_tpscroll");
  end
  
end

----------------------------------------------------------------------------------------------------