public void SetChicken(int iClient)
{
	PrecacheModel("models/chicken/chicken.mdl", true);
	SetEntityModel(iClient, "models/chicken/chicken.mdl");
	SetEntData(iClient, g_iOffsCollisionGroup, g_iCollisionGroup, 4, true);
	SetEntProp(iClient, Prop_Send, "m_nBody", GetChickenHat()); //0=normal 1=BdayHat 2=ghost 3=XmasSweater 4=bunnyEars 5=pumpkinHead

	//Shop_DeEquipments(iClient);
	if(g_hTimerChicken[iClient] == null)
			g_hTimerChicken[iClient] = CreateTimer(10.0, TimerChickenSound, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action TimerChickenSound(Handle timer, any iClient)
{
	if (g_hTimerChicken[iClient] != null && IsClientInGame(iClient) && IsPlayerAlive(iClient)) 
	{	
		float fVec[3];
		GetClientEyePosition(iClient, fVec);

		EmitSoundToAll(g_sSoundPath, iClient, 0, 75, 0, 1.0, 100, -1, fVec, NULL_VECTOR, true, 0.0);
		return Plugin_Continue; 
	}
	else
	{
		g_hTimerChicken[iClient] = null;
		return Plugin_Stop;
	}
}

public void RemoveSound()
{
	for(int i = 1; i < MaxClients; i++)
	{
		if(g_hTimerChicken[i] != null)
		{
			KillTimer(g_hTimerChicken[i]);
			g_hTimerChicken[i] = null;
		}
	}
}

public void SpawnChickens()
{
	//Reset the number of chickens in the map (stop server crash)
	RemoveChickens();
	
	static bool spawnOrigin = true;
	int entitySpawnCounter = 0;
	float worldOrigin[3];
	
	int chickenNumber = CHICKEN_MAX_COUNT - GetClientCount(true);

	//Creates some chickens around the world origin
	if (spawnOrigin)
	{
		while (entitySpawnCounter < chickenNumber)
		{
			entitySpawnCounter += CreateChickenRandom(worldOrigin); //If entity has been created, add 1 to the chicken counter
		}
	}
	//Creates some chickens both sides around spawn
	else
	{
		float fOrigin[3];
		int spawn = FindEntityByClassname(MAXPLAYERS, "info_player_terrorist");
		GetEntPropVector(spawn, Prop_Send, "m_vecOrigin", fOrigin);
		while (entitySpawnCounter < (chickenNumber / 2))
		{
			entitySpawnCounter += CreateChickenRandom(fOrigin); //If entity has been created, add 1 to the chicken counter
		}
		spawn = FindEntityByClassname(MAXPLAYERS, "info_player_counterterrorist");
		GetEntPropVector(spawn, Prop_Send, "m_vecOrigin", fOrigin);
		while (entitySpawnCounter < chickenNumber)
		{
			entitySpawnCounter += CreateChickenRandom(fOrigin);
		}
	}
	
	
//	PrintToChatAll("chickens : %i", entitySpawnCounter);
}

public int CreateChickenRandom(float origin[3])
{
	//Approximate chicken hull size
	float boxMin[3] =  { -16.0, -16.0, -16.0 };
	float boxMax[3] =  { 16.0, 16.0, 16.0 };
	//PrintToChatAll("Trying to create chicken%i", entitySpawnCounter);
	
	int entity = CreateEntityByName("chicken");
	if (IsValidEntity(entity))
	{
		SetChickenStyle(entity); //Set the hat/skin
		//Random pos around the origin (if too big, can crash)
		float newPos[3];
		newPos[0] = origin[0] + GetRandomFloat(-2500.0, 2500.0);
		newPos[1] = origin[1] + GetRandomFloat(-2500.0, 2500.0);
		newPos[2] = origin[2] + GetRandomFloat(-1000.0, 1000.0);
		
		float rot[3];
		rot[1] = GetRandomFloat(0.0, 360.0);
		
		TeleportEntity(entity, newPos, rot, NULL_VECTOR);
		DispatchSpawn(entity);
		ActivateEntity(entity);
		
		//Check if entity is stuck
		TR_TraceHullFilter(newPos, newPos, boxMin, boxMax, MASK_SOLID, TRDontHitSelf, entity);
		if (TR_DidHit())
		{
			RemoveEdict(entity);
			return 0;
		}
		else
			return 1;
	}
	else
		return 0;
}

public void RemoveChickens()
{
	char className[64];
	for (int i = MaxClients; i < GetMaxEntities(); i++)
	{
		if (IsValidEntity(i) && IsValidEdict(i))
		{
			GetEdictClassname(i, className, sizeof(className));
			if (StrEqual(className, "chicken") && GetEntPropEnt(i, Prop_Send, "m_hOwnerEntity") == -1)
				RemoveEdict(i);
		}
	}
}

public void SetChickenStyle(int chicken)
{
	SetEntProp(chicken, Prop_Send, "m_nSkin", GetRandomInt(0, 1)); //0=normal 1=brown chicken
	SetEntProp(chicken, Prop_Send, "m_nBody", GetChickenHat()); //0=normal 1=BdayHat 2=ghost 3=XmasSweater 4=bunnyEars 5=pumpkinHead
}

public int GetChickenHat()
{
	static int chickenHats[6] = {1, 1, 1, 1, 1, 1};

	int enabled[sizeof(chickenHats)];
	int total = 0;
	for (int i = 0; i < sizeof(chickenHats); i++)
	{
		if (chickenHats[i] == 1)
		{
			enabled[total] = i;
			total++;
		}
	}
	if (total == 0) //Set chicken to no hat if every cvar is at 0
	{
		return 0;
	}
	else //Select a random hat between the enabled ones
	{
		return enabled[GetRandomInt(0, (total - 1))];
	}
}

public bool TRDontHitSelf(int entity, int mask, any data) //Trace hull filter
{
	if (entity == data)return false;
	return true;
}