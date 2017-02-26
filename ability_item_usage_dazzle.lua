
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
function CanCastPoisonTouch (npcTarget)

  return not target: IsMagicImmune() and target: CanBeSeen(); 
  
end


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function ConsiderShadowWave()

  -- Make sure spell is castable, i.e not stunned or casting anything else
  if( abilityHeal: IsFullyCastable() == nil)
    then
      return BOT_ACTION_DESIRE_NONE, 0;
  end
  --[[
  if( castGravePriority > 0 )
    then 
      return BOT_ACTION_DESIRE_NONE, 0;
  end
--]]
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function ConsiderPoisonTouch()

end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function ConsiderShallowGrave()

  -- Make sure spell is castable, i.e not stunned or casting anything else
  if( abilityGrave: IsFullyCastable() == nil)
    then
      return BOT_ACTION_DESIRE_NONE, 0;
  end
  
  local graveRange = abilityGrave: GetCastRange();
  local nearbyAlliedHeroes = bot: GetNearbyHeroes(graveRange + 700, false, BOT_MODE_NONE);
  local nearbyAlliesPower = {};
  
  for i, v in pairs(nearbyAlliedHeroes)
    do
      --nearbyAlliedHeroes[i] = nearbyAlliedHeroes[i]: GetOffensivePower();
      nearbyAlliesPower[v] = nearbyAlliedHeroes[i]: GetOffensivePower();
  end

print(nearbyAlliesPower[nearbyAlliedHeroes[2]]);
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
  
 function ConsiderWeave()
 
 end 
 
----------------------------------------------------------------------------------------------------