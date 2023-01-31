public void createGlows() 
{
    sv_force_transmit_players.SetString("1", true, false);
    
    char model[PLATFORM_MAX_PATH];
    int skin = -1;
    int team;

    for(int i = 1; i <= MaxClients; i++) 
    {
        if(!IsClientInGame(i) || !IsPlayerAlive(i)) 
        {
            continue;
        }

        team = GetClientTeam(i);

        GetClientModel(i, model, sizeof(model));
        skin = CreatePlayerModelProp(i, model);
        
        if(skin > MaxClients) 
        {
            SetupGlow(skin, team);
        }
    }
}

public void SetupGlow(int entity, int team) 
{
    static offset;
    if (!offset && (offset = GetEntSendPropOffs(entity, "m_clrGlow")) == -1)  // Get sendprop offset for prop_dynamic_override
    {
        LogError("Unable to find property offset: \"m_clrGlow\"!");
        return;
    }

    // Enable glow for custom skin
    SetEntProp(entity, Prop_Send, "m_bShouldGlow", true, true);
    SetEntProp(entity, Prop_Send, "m_nGlowStyle", 0);
    SetEntPropFloat(entity, Prop_Send, "m_flGlowMaxDist", 10000.0);

    if(team == 2)
    {
        for(int i = 0; i < 3; i++) 
        {
            SetEntData(entity, offset + i, TColor[i], _, true); 
        }
    }
    else if(team == 3)
    {
        for(int i = 0; i < 3; i++) 
        {
            SetEntData(entity, offset + i, CtColor[i], _, true); 
        }
    }
}

public int CreatePlayerModelProp(int client, char[] sModel) 
{
    int skin = CreateEntityByName("prop_dynamic_glow");
    DispatchKeyValue(skin, "model", sModel);
    //DispatchKeyValue(skin, "disablereceiveshadows", "1");
    //DispatchKeyValue(skin, "disableshadows", "1");
    DispatchKeyValue(skin, "solid", "0");
    DispatchKeyValue(skin, "fademindist", "0.0");
    DispatchKeyValue(skin, "fademaxdist", "1.0");
    //DispatchKeyValue(skin, "spawnflags", "256");
    SetEntProp(skin, Prop_Send, "m_CollisionGroup", 0);
    DispatchSpawn(skin);
    SetEntityRenderMode(skin, RENDER_GLOW);
    SetEntityRenderColor(skin, 0, 0, 0, 0);
    SetEntProp(skin, Prop_Send, "m_fEffects", 1);
    SetVariantString("!activator");
    AcceptEntityInput(skin, "SetParent", client, skin);
    SetVariantString("primary");
    AcceptEntityInput(skin, "SetParentAttachment", skin, skin, 0);

    return skin;
}

public void ShowNotificationWallHack()
{
    char sBuf[128];
    Format(sBuf, sizeof (sBuf), "Начался WallHack раунд! \nОсталось раундов: %d", iCountRound);
    CGOPrintToChatAll("{DEFAULT}[{LIGHTBLUE}CR{DEFAULT}] Начался {RED}WallHack{DEFAULT} раунд! {PURPLE}Осталось раундов: {RED}%d", iCountRound);

    for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			SetHudTextParams(-0.4, -0.6, 4.5, 26, 107, 184, 255, 0, 0.0, 0.1, 0.1);
			ShowHudText(i, 2, sBuf);
		}
	}
}