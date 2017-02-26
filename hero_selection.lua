

----------------------------------------------------------------------------------------------------

function Think()

if (GetTeam() == TEAM_RADIANT )
    then
       print( "Selecting Radiant Team");
       isBot( 0, "npc_dota_hero_sven");
       isBot( 1, "npc_dota_hero_dazzle");
       isBot( 2, "npc_dota_hero_death_prophet");
       isBot( 3, "npc_dota_hero_axe");
       isBot( 4, "npc_dota_hero_ogre_magi");
    
    elseif( GetTeam() == TEAM_DIRE)
    then
       print( "Selecting Dire Team")
       isBot( 5, "npc_dota_hero_phantom_assassin");
       isBot( 6, "npc_dota_hero_jakiro");
       isBot( 7, "npc_dota_hero_zuus");
       isBot( 8, "npc_dota_hero_pudge");
       isBot( 9, "npc_dota_hero_ancient_apparition");
    end
    
end


function isBot (id, hero)
  
    if (IsPlayerBot(id) and IsPlayerInHeroSelectionControl(id))
    then
        SelectHero(id, hero)
    end
end

----------------------------------------------------------------------------------------------------