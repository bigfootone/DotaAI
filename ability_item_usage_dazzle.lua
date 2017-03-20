
  --Levelling order
local abilityLevelling =
{
  "dazzle_poison_touch",  --1
  "dazzle_shadow_wave",   --2
  "dazzle_shadow_wave",   --3
  "dazzle_shallow_grave", --4
  "dazzle_shadow_wave",   --5
  "dazzle_weave",         --6
  "dazzle_shadow_wave",   --7
  "dazzle_shallow_grave", --8 
  "dazzle_shallow_grave", --9   
  "special_bonus_hp_125", --10
  "dazzle_shallow_grave", --11
  "dazzle_weave",         --12
  "dazzle_poison_touch",  --13
  "dazzle_poison_touch",  --14
  "special_bonus_cast_range_100", --15
  "dazzle_poison_touch",  --16
  "dazzle_weave",         --18
  "special_bonus_movement_speed_25", --20
  "special_bonus_unique_dazzle_1",   --25
};


  -- Variables
  bot = GetBot();
  team = bot:GetTeam();
  abilityHeal = bot:GetAbilityByName("dazzle_shadow_wave");
  abilitySlow = bot:GetAbilityByName("dazzle_poison_touch");
  abilityGrave = bot:GetAbilityByName("dazzle_shallow_grave");
  abilityUlt = bot:GetAbilityByName("dazzle_weave");
  castHealPriority = 0;
  castSlowPriority = 0;
  castGravePriority = 0;
  castUltPriority = 0;
  
----------------------------------------------------------------------------------------------------

function AbilityLevelUpThink()

  --if can level up, level up the next spell
  local nextAbilityToLevel = bot:GetAbilityByName(abilityLevelling[1]);
  
  if(bot: GetAbilityPoints() == 1 and nextAbilityToLevel ~= nil and nextAbilityToLevel:CanAbilityBeUpgraded() and nextAbilityToLevel:GetLevel() < nextAbilityToLevel:GetMaxLevel())
    then
      bot: ActionImmediate_LevelAbility(abilityLevelling[1]);
      table.remove(abilityLevelling, 1);
  end
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

  -- Adapted from in-game example
function AbilityUsageThink()

  --If using an ability, dont cast another
  if(bot: IsUsingAbility() )
    then
      return
  end
  
  castSlowPriority, castSlowTarget = ConsiderPoisonTouch();
  castHealPriority, castHealTarget = ConsiderShadowWave();
  castGravePriority, castGraveTarget = ConsiderShallowGrave();
  castUltPriority, castUltLocation = ConsiderWeave();
  
  if(castGravePriority ~= nil and castGravePriority > 0)
    then
      bot: Action_UseAbilityOnEntity(abilityGrave, castGraveTarget);
      return;
  end
  
  if(castHealPriority ~= nil and castHealPriority > 0)
    then
      bot: Action_UseAbilityOnEntity(abilityHeal, castHealTarget);
      return;
  end
  
  if(castUltPriority ~= nil and castUltPriority > 0)
    then
      bot: Action_UseAbilityOnLocation(abilityUlt, castUltLocation);
      return;
  end
  
  if(castSlowPriority ~= nil and castSlowPriority > 0)
    then
      bot: Action_UseAbilityOnEntity(abilitySlow, castSlowTarget);
      return;
  end
  --[[
  if(castGravePriority > castHealPriority and castGravePriority > castSlowPriority and castGravePriority > castUltPriority)
    then
      bot: Action_UseAbilityOnEntity(abilityGrave, castGraveTarget);
      return;
  end
  
  if(castHealPriority > 0 and castHealPriority > castSlowPriority and castHealPriority > castUltPriority)
    then
      bot: Action_UseAbilityOnEntity(abilityHeal, castHealTarget);
  end
  
  if(castSlowPriority > 0 and castSlowPriority > castHealPriority and castSlowPriority > castUltPriority)
    then
      bot: Action_UseAbilityOnEntity(abilitySlow, castSlowTarget);
  end
  
  if(castUltPriority > 0 and castUltPriority > castHealPriority and castUltPriority > castSlowPriority)
    then
      bot: Action_UseAbilityOnLocation(abilityUlt, castUltLocation);
  end--]]
  
end    

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

  --Make sure we can cast the spell
function CanCastPoisonTouch (target)

  return target: CanBeSeen() and not target: IsMagicImmune();
  
end


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function ConsiderShadowWave()

  -- Make sure spell is castable, i.e not stunned or casting anything else
  if( abilityHeal: IsFullyCastable() == nil)
    then
      return BOT_ACTION_DESIRE_NONE, 0;
  end
  
  if(castGravePriority ~= ni and castGravePriority > 0 )
    then 
      return BOT_ACTION_DESIRE_NONE, 0;
  end
  
  local healRange = abilityHeal: GetCastRange();
  
  -- Farming with heal-bomb  
  if (bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
      bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
      bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT)
    then
    
      -- Check for nearby allies so we dont steal farm
      local nearbyAlliedHeroes = bot: GetNearbyHeroes(800, false, BOT_MODE_NONE);
      local localHeroesCount = 0;
      
      for i in pairs(nearbyAlliedHeroes)
        do
          localHeroesCount = localHeroesCount + 1;
      end
      
      -- Find our current lane
      local currentLane = LANE_NONE;
      
      if(bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP)
        then
          currentLane = LANE_TOP;
      elseif(bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID)
        then
          currentLane = LANE_MID;
      elseif(bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT)
        then
         currentLane = LANE_BOT;
      end
      
      -- If there's noone here and we have lots of mana
      if(localHeroesCount == 1 and bot:GetMana()/bot:GetMaxMana() > 0.7)
        then
        
          local nearbyAlliedCreeps = bot:GetNearbyLaneCreeps(800, false);
          local nearbyEnemyCreeps =  bot:GetNearbyLaneCreeps(1000,true);        
                    
          local nearbyAlliesCreepCount = 0;

          for i in pairs (nearbyAlliedCreeps)
            do
              nearbyAlliesCreepCount = nearbyAlliesCreepCount + 1;
          end
          
          
          local nearbyEnemyCreepCount = 0;
          
          for i in pairs(nearbyEnemyCreeps)
            do
              nearbyEnemyCreepCount = nearbyEnemyCreepCount + 1;
          end
          
          local radiantTeamLaneFront = GetLaneFrontLocation(2, currentLane, 0);
          
          local direTeamLaneFront = GetLaneFrontLocation(3, currentLane, 0);
                    
          
          if(nearbyAlliesCreepCount > 3 and nearbyEnemyCreepCount > 2 and radiantTeamLaneFront.x - direTeamLaneFront.x <110 and radiantTeamLaneFront.y - direTeamLaneFront.y < 110)
            then
              return BOT_ACTION_DESIRE_MODERATE, nearbyAlliedCreeps[1];
          end           

      elseif (localHeroesCount > 1)
        then
          print("Too many heroes");  
      elseif (bot:GetMana()/bot:GetMaxMana() > 0.7)
        then
          print("not enough mana");
      end
  end
  
  -- Heal allies who have recently been damaged
  if(bot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
     bot:GetActiveMode() == BOT_MODE_RETREAT or
     bot:GetActiveMode() == BOT_MODE_ATTACK or
     bot:GetActiveMode() == PUSH_TOWER_TOP or
     bot:GetActiveMode() == PUSH_TOWER_MID or
     bot:GetActiveMode() == PUSH_TOWER_BOT)
   then
   
    local allies = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE);
     
    for k, v in pairs(allies)
      do    
        local healthLost = v:GetMaxHealth() - v:GetHealth();
        
        if(v:WasRecentlyDamagedByAnyHero(2) == true and healthLost > abilityHeal:GetAbilityDamage())
          then
            return BOT_ACTION_DESIRE_HIGH, v;
        end
    end
  end 
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function ConsiderPoisonTouch()

  -- Make sure spell is castable, i.e not stunned or casting anything else
  if( abilitySlow: IsFullyCastable() == nil)
    then
      return BOT_ACTION_DESIRE_NONE, 0;
  end
  
  -- Gather variables
  local slowRange = abilitySlow: GetCastRange();
  
  --If we're on the offense, slow a target
  if(bot:GetActiveMode() == BOT_MODE_ATTACK)
    then
      
      local target = bot:GetTarget();
      
      if(target ~= nil)
        then
          if(CanCastPoisonTouch(target))
            then
              return BOT_ACTION_DESIRE_HIGH, target;
          end
      end
  end
  
  --If we're running away, try and slow a target
  if(bot:GetActiveMode() == BOT_MODE_RETREAT and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
    then    
      local nearbyHeroes = bot:GetNearbyHeroes(slowRange + 100, true, BOT_MODE_NONE);      
      for k, v in pairs(nearbyHeroes)
        do
          if(bot:WasRecentlyDamagedByHero(v, 1))
            then
              if(CanCastPoisonTouch(v))
                then
                  return BOT_ACTION_DESIRE_HIGH, v;
              end
          end
      end
  end
  
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function ConsiderShallowGrave()

  -- Make sure spell is castable, i.e not stunned or casting anything else
  if( abilityGrave: IsFullyCastable() == nil)
    then
      return BOT_ACTION_DESIRE_NONE, 0;
  end
  
  -- Gather variables
  local graveRange = abilityGrave: GetCastRange();
  local nearbyAlliedHeroes = bot: GetNearbyHeroes(graveRange + 500, false, BOT_MODE_NONE);
  local nearbyAlliesPower = {};
  
  -- Local neaby allies and calculate their Hero Power
  for i, v in pairs(nearbyAlliedHeroes)
    do
      nearbyAlliesPower[nearbyAlliedHeroes[i]] = nearbyAlliedHeroes[i]: GetOffensivePower();
  end
      
  -- Sort nearby allies by Hero Power  This needs to be updated to grave high priority targets
  for k, v in sortTable(nearbyAlliesPower, function(t,a,b) return t[b] < t[a] end)
    do
      local health = k:GetHealth();
      local maxHealth = k:GetMaxHealth();
      local healthPercentage = health/maxHealth;
      if(healthPercentage < 0.2 and k:WasRecentlyDamagedByAnyHero(1))
        then
          return BOT_ACTION_DESIRE_HIGH, k;
      end
  end
  
  
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
  
 function ConsiderWeave()
  
   -- Make sure spell is castable, i.e not stunned or casting anything else
  if( abilityUlt: IsFullyCastable() == nil)
    then
      return BOT_ACTION_DESIRE_NONE, 0;
  end
  
  local weaveCastRange = abilityUlt:GetCastRange();
  local weaveRadius = 575  -- Work out actual range instead of hard coding
  
  if(bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
     bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
     bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
     bot:GetActiveMode() == BOT_MODE_ROSHAN or
     bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
     bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
     bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
     bot:GetActiveMode() == BOT_MODE_TEAM_ROAM)
   then
    

    local optimalAOE = bot:FindAoELocation(false, true, bot:GetLocation(), weaveCastRange, weaveRadius, 0, 0)
    
    print(optimalAOE.count);
    
    if(optimalAOE.count > 1)
      then
        return BOT_ACTION_DESIRE_HIGH, optimalAOE.targetloc;
    end
      
  end 
  
 end 
 
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

  -- http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
function sortTable(t, order)

  local keys = {}
  for k in pairs(t) 
    do 
      keys[#keys+1] = k
  end

  if order 
    then 
      table.sort(keys, function(a,b) return order (t,a,b) end)
    else
      table.sort(keys)
    end
    
  local i =0;
  return function()
    i= i+1
    if keys[i]
      then
        return keys[i], t[keys[i]]
      end
    end
  end


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function ItemUsageThink()

  local arcaneBoots = CanUseItem("item_arcane_boots")
  
  -- Use arcane boots if we need them
  if(arcaneBoots ~= nil) 
    then
      if(bot:GetMaxMana() - bot:GetMana() > 135)
        then  
          bot:Action_UseAbility(arcaneBoots);
      end
  end
  
  -- Use arcane boots if allies need them  
  if(arcaneBoots ~= nil)
    then
      local nearbyAllies = GetNearbyHeroes(900, false, BOT_MODE_NONE);
      for k, v in pairs(nearbyAllies)
        do
          if(v:GetMaxMana() - v:GetMana() > 135)
            then
              bot:Action_UseAbility(arcaneBoots);
          end
      end
  end
  
  -- Activate courier if we have one
  local courier = CanUseItem("item_courier")
  if(courier ~= nil)
    then
      if(GetNumCouriers() == 0)
        then
          bot:Action_UseAbility(courier);
      end
  end

  -- If ally is stunned, glimmer them
  local glamourCape = CanUseItem("item_glimmer_cape");
  if(glamourCape ~= nil )
    then
      local nearbyAllies = GetNearbyHeroes(1200, false, BOT_MODE_NONE);
      for k, v in pairs(nearbyAllies)
        do
          if(v:IsStunned() == true)
            then
              bot:Action_UseAbilityOnEntity(glamourCape, v)
          end
      end
  end
  
  if(glamourCape ~= nil and (bot:GetActiveMode() == BOT_MODE_RETREAT or bot:GetActiveMode() == BOT_MODE_DEFEND_ALLY))
    then
      local nearbyAllies = GetNearbyHeroes(1200, false, BOT_MODE_NONE);
      for k, v in pairs(nearbyAllies)
        do
          if (v:WasRecentlyDamagedByAnyHero(1))
            then
              bot:Action_UseAbilityOnEntity(glamourCape, v)
          end
      end
  end
end


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

  --Check if item is available, similar to item_purchase
function CanUseItem(itemName)

  for i = 0, 5, 1
    do
      local curItem = bot:GetItemInSlot(i);
      if(curItem ~= nil)
        then
          if(curItem:GetName() == itemName and curItem:IsFullyCastable())
            then
              return curItem;
          end
      end
  end
end
      

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
      
  -- Courier Use   --update to only use courier if we have space
function CourierUsageThink()

  local courier = GetCourier(0);
  local totalStashValue = 0;
     
  -- Value of items in stash      
  for i = 9, 14, 1
    do 
      local curItem = bot:GetItemInSlot(i);
      if(curItem ~= nil)
        then
          totalStashValue = totalStashValue + GetItemCost(curItem:GetName());
      end
  end
  
  -- Courier logic
  if(GetCourierState(courier) == 1)
    then
      if(totalStashValue >= 400)
        then      
          bot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS);  
                 
      elseif(bot:GetCourierValue() > 0)
        then
          bot:ActionImmediate_Courier(courier, COURIER_ACTION_TRANSFER_ITEMS);
      end
      
  elseif (GetCourierState(courier) == 2 or
          GetCourierState(courier) == 4)
        then
          if(bot:GetCourierValue() > 0 and IsCourierAvailable())
            then
              bot:ActionImmediate_Courier(courier, COURIER_ACTION_TRANSFER_ITEMS);
          end
  elseif (GetCourierState(courier) == 0 )
    then
      if(totalStashValue >= 400)
        then
          bot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS);
      
      elseif (bot:GetCourierValue() > 0)
        then
          bot:ActionImmediate_Courier(courier, COURIER_ACTION_TRANSFER_ITEMS);
      end    
  end
  
  print("State is ", GetCourierState(courier))
          
   
end
     