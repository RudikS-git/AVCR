public void CreateKOTHZone()
{
	int zone = CreateEntityByName("trigger_multiple");
	KOTH_entZone = zone;

	float m_vecMins[3] = { 273.88, 265.56, 130.00 };
	float m_vecMaxs[3] = { -247.88, -195.56, 400.00};

	float middle[3];
	char ZoneName[64];

	// Set name
	Format(ZoneName, sizeof(ZoneName), "kingofthehill");
	DispatchKeyValue(zone, "targetname", ZoneName);
	DispatchKeyValue(zone, "spawnflags", "64");
	DispatchKeyValue(zone, "wait",       "0");

	DispatchKeyValue(zone, "damagetype", "8");
	DispatchKeyValue(zone, "damagecap", "1");
	DispatchKeyValue(zone, "damage", "5");

	// char sBuf[128];
	// IntToString(EntIndexToEntRef(filter), sBuf, sizeof(sBuf));
	// DispatchKeyValue(zone, "filtername", sBuf);

	// Spawn an entity
	DispatchSpawn(zone);

	// Since its brush entity, use ActivateEntity as well
	ActivateEntity(zone);

	// Set datamap spawnflags (value means copy origin and angles)
	SetEntProp(zone, Prop_Data, "m_spawnflags", 64);

	// Get the middle of zone
	GetMiddleOfABox(m_vecMins, m_vecMaxs, middle);

	// Move zone entity in middle of a box
	TeleportEntity(zone, middle, NULL_VECTOR, NULL_VECTOR);

	// Set the model (yea, its also required for brush model)
	SetEntityModel(zone, "models/weapons/eminem/ice_cube/ice_cube.mdl");

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			TE_SendBeamBoxToClient(i, m_vecMins, m_vecMaxs, LaserMaterial, HaloMaterial, 0, 30, 30.0, 5.0, 5.0, 2, 1.0, kingofthehillZone, 0);
		}
	}

	// Have the m_vecMins always be negative
	m_vecMins[0] = m_vecMins[0] - middle[0];
	if (m_vecMins[0] > 0.0)
		m_vecMins[0] *= -1.0;
	m_vecMins[1] = m_vecMins[1] - middle[1];
	if (m_vecMins[1] > 0.0)
		m_vecMins[1] *= -1.0;
	m_vecMins[2] = m_vecMins[2] - middle[2];
	if (m_vecMins[2] > 0.0)
		m_vecMins[2] *= -1.0;

	// And the m_vecMaxs always be positive
	m_vecMaxs[0] = m_vecMaxs[0] - middle[0];
	if (m_vecMaxs[0] < 0.0)
		m_vecMaxs[0] *= -1.0;
	m_vecMaxs[1] = m_vecMaxs[1] - middle[1];
	if (m_vecMaxs[1] < 0.0)
		m_vecMaxs[1] *= -1.0;
	m_vecMaxs[2] = m_vecMaxs[2] - middle[2];
	if (m_vecMaxs[2] < 0.0)
		m_vecMaxs[2] *= -1.0;

	// Set mins and maxs for entity
	SetEntPropVector(zone, Prop_Send, "m_vecMins", m_vecMins);
	SetEntPropVector(zone, Prop_Send, "m_vecMaxs", m_vecMaxs);

	// Enable touch functions and set it as non-solid for everything
	SetEntProp(zone, Prop_Send, "m_usSolidFlags",  152);
	SetEntProp(zone, Prop_Send, "m_CollisionGroup", 11);

	// Make the zone visible by removing EF_NODRAW flag
	new m_fEffects = GetEntProp(zone, Prop_Send, "m_fEffects");
	m_fEffects |= 0x020;
	SetEntProp(zone, Prop_Send, "m_fEffects", m_fEffects);

	// Hook touch entity outputs
	HookSingleEntityOutput(zone, "OnStartTouch", StartOnTouchKOTHZone);
	HookSingleEntityOutput(zone, "OnEndTouch",   EndTouchKOTHZone);

	// PrintToChatAll("vecMax - %f, %f, %f", m_vecMaxs[0], m_vecMaxs[1], m_vecMaxs[2]);
	// PrintToChatAll("vecMin - %f, %f, %f", m_vecMins[0], m_vecMins[1], m_vecMins[2]);

	GetEntPropVector(zone, Prop_Send, "m_vecMins", m_vecMins);
	GetEntPropVector(zone, Prop_Send, "m_vecMaxs", m_vecMaxs);

	// PrintToChatAll("[Ent] vecMax - %f, %f, %f", m_vecMaxs[0], m_vecMaxs[1], m_vecMaxs[2]);
	// PrintToChatAll("[Ent] vecMin - %f, %f, %f", m_vecMins[0], m_vecMins[1], m_vecMins[2]);
}

public void StartOnTouchKOTHZone(const char[] output, int caller, int activator, float delay)
{
    // caller - zone
    // activator - player

    if(IsClientValid(activator) && KOTH_TimerAntiCamp[activator])
    {
		//delete KOTH_TimerAntiCamp[activator];
		KillTimer(KOTH_TimerAntiCamp[activator]);
		KOTH_TimerAntiCamp[activator] = null;
//		PrintToChatAll("[DEBUG] %N зашел в зону!(KOTH_TimerAntiCamp[activator] - %d)", activator, KOTH_TimerAntiCamp[activator]);
    }
}

public void EndTouchKOTHZone(const char[] output, int caller, int activator, float delay)
{
	//PrintToChatAll("[DEBUG] valid - %d, %N вышел из зоны!(catchUp_TimerAntiCamp - %d)", IsClientValid(activator), activator, catchUp_TimerAntiCamp[activator]);
	//PrintToChatAll("[DEBUG] GetClientTeam(activator) - %d == %d", GetClientTeam(activator), CS_TEAM_T);
	if(IsClientValid(activator) && !KOTH_TimerAntiCamp[activator])
	{
        KOTH_TimerAntiCamp[activator] = CreateTimer(1.0, KOTH_AntiCampStartTimerCallBack, GetClientUserId(activator), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
        timerSec[activator] = 5;
//		PrintToChatAll("[DEBUG] %N вышел из зоны!(KOTH_TimerAntiCamp[activator] - %d)", activator, KOTH_TimerAntiCamp[activator]);
	}

}

public Action KOTH_AntiCampStartTimerCallBack(Handle hTimer, any userId)
{
	int iClient = GetClientOfUserId(userId);

	if(iClient != 0 && IsClientInGame(iClient))
	{
     //   PrintToChatAll("Таймер у %N (time - %d)", iClient, timerSec[iClient]);
		if(timerSec[iClient] >= 0)
		{
			SetHudTextParams(-0.4, -0.1, 1.0, 216, 4, 146, 255, 0, 1.0, 1.0, 1.0);
			ShowHudText(iClient, -1, "Заберитесь на гору, у вас %d секунд", timerSec[iClient]);

			timerSec[iClient]--;

	//		PrintToChatAll("%N - handle - %d", iClient, hTimer);
			return Plugin_Continue;
		}
        
		ForcePlayerSuicide(iClient);
		KOTH_TimerAntiCamp[iClient] = null;
	}
	
	return Plugin_Stop;
}

void ShowNotificationKingOfTheHill()
{
 	char sBuf[128];
    Format(sBuf, sizeof (sBuf), "Начался Царь горы раунд! \nОсталось раундов: %d", iCountRound);
    CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался раунд {PURPLE}Царь горы {DEFAULT}(Осталось раундов: {PURPLE}%d{DEFAULT})\n", iCountRound);

    for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			ShowHudText(i, 2, sBuf);
		}
	}
}