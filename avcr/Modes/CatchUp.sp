static const float CatchUp_Origin[][3] = 
{
	{695.89, -1033.14, -62.37},
	{381.73, -1045.06, -69.91},
	{32.6, -1045.48, -80.75},
	{-284.99, -1047.85, -82.59},
	{-639.57, -1046.75, -87.03},
	{-660.98, 1104.42, -74.53},
	{-345.08, 1105.82, -68.84},
	{24.87, 1105.46, -63.09},
	{360.68, 1105.69, -61.66},
	{682.79, 1107.32, -70.06},
	{594.26, 505.04, -26.03},
	{594.37, 305.45, -24.03},
	{593.88, 88.15, -25.31},
	{594.98, -159.37, -27.97},
	{595.14, -444.19, -29.94},
	{-560.82, 512.64, -29.28},
	{-559.16, 287.11, -26.09},
	{-559.25, 38.5, -26.12},
	{-560.12, -164.28, -27.03},
	{-559.05, -425.14, -27.47}
};

static const float CatchUp_Ang[][3] = 
{
	{-8.85, 122.45, 0.00},
	{-9.73, 107.76, 0.00},
	{-10.77, 90.99, 0.00},
	{-10.39, 76.03, 0.00},
	{-9.56, 59.75, 0.00},
	{-8.63, -59.05, 0.00},
	{-9.34, -73.85, 0.00},
	{-10.17, -90.95, 0.00},
	{-9.67, -106.41, 0.00},
	{-8.68, -121.39, 0.00},
	{-12.69, -142.24, 0.00},
	{-13.30, -157.64, 0.00},
	{-15.39, -174.08, 0.00},
	{-14.07, 165.73, 0.00},
	{-12.48, 142.03, 0.00},
	{-12.42, -39.31, 0.00},
	{-14.34, -22.42, 0.00},
	{-15.56, -0.97, 0.00},
	{-14.57, 16.3, 0.00},
	{-11.87, 37.64, 0.00},
};

static const float catchingOrigin[3] = {12.25, 33.72, 191.0};
static const float catchingAng[3] = {21.18, 91.05, 0.00}; // t spawn sight

public void PrepareCatchUp(int reason)
{
	ServerCommand("AA_TIME 120");
	ServerCommand("sm_bp_enable 0");
	infinite_ammo_mode.IntValue = 0;

	PrintToChatAll("[AVCR] reason - %d", reason)
	PrintToChatAll("[AVCR] floatRoundEndDelay - %f", floatRoundEndDelay)
	PrintToChatAll("[AVCR] WithVoting - %d", WithVoting)
	PrintToChatAll("[AVCR] (reason != 10) - %f", (reason != 10)? floatRoundEndDelay:0.1);
	// (reason != 10)? floatRoundEndDelay:
	CreateTimer(0.1, CatchUpFormTeams_TimerCB, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action CatchUpInfo(Handle hTimer)
{
	static bool IsMomentDrop = false;

	if(!bCustomRound || customRound[numCurrentRound].typeCustomGame != CatchUp)
	{
		return Plugin_Stop;
	}

	--i_gCatchUpTime;
	int count = GetUnFreezePlayers();
	SetHudTextParams(-0.4, -0.1, 1.0, 216, 4, 146, 255, 0, 1.0, 1.0, 1.0);

	if(i_gCatchUpTime == 0)
	{
		i_gCatchUpTime = 120;
		CatchUpSetRandomTypeWeapons();
		IsMomentDrop = true;
		
	}

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(GetClientTeam(i) == CS_TEAM_CT)
			{
				ShowHudText(i, -1, "Осталось незамороженных: %d чел.\nВы спасли: %d раз\nПовторная выдача предметов через %d сек.", count, i_CountUseFulness[i], i_gCatchUpTime);
			}
			else
			{
				ShowHudText(i, -1, "Осталось незамороженных: %d чел.\nВы поймали: %d раз\nПовторная выдача предметов через %d сек.", count, i_CountUseFulness[i], i_gCatchUpTime);
			}

			if(IsMomentDrop)
			{
				CatchUpGiveItem(i);
			}
		}
	}

	if(i_gCatchUpTime == 120)
	{
		IsMomentDrop = false;
	}

	return Plugin_Continue;
}

public void CatchUpGiveItem(int iClient)
{
	if(GetClientTeam(iClient) == CS_TEAM_CT)
	{
		switch(catchUptypeWeapon[iClient])
		{
			case Taser:
			{
				GivePlayerItem(iClient, "weapon_taser");
			}

			case Grenade:
			{
				GivePlayerItem(iClient, "weapon_hegrenade");
				//PrintToChatAll("[DEBUG] %N получил гранату!", iClient);
			}

			case Healthshot:
			{
				GivePlayerItem(iClient, "weapon_healthshot");
				//PrintToChatAll("[DEBUG] %N получил шприц!", iClient);
			}
		}

	}
}

public Action CatchUpRoundEnd_TimerCallBack(Handle hTimer)
{
	CS_TerminateRound(6.0, CSRoundEnd_CTWin);
	CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] {PURPLE}Террористы {DEFAULT}проиграли. Победа за {PURPLE}CT");

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{			
			if(catchUp_TimerAntiCamp[i] != null)
			{
				delete catchUp_TimerAntiCamp[i];
			}
		}
	}

	h_CatchUpEndTimer = null;

	return Plugin_Stop;
}

public void ZeroingCatchUp()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		i_CountUseFulness[i] = 0;
	}
}

public Action CatchUpFormTeams_TimerCB(Handle hTimer)
{
	PrintToChatAll("[AVCR] Начало формирования команды");
	catchUpDataPack = FormTeams();
	PrintToChatAll("[AVCR] Конец формирования команды");

	CatchUpSetRandomTypeWeapons();

	return Plugin_Stop;
}

public void CatchUpSetRandomTypeWeapons()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		float sampleValue = GetRandomFloat(0.0, 1.0);

		if(sampleValue >= 0.0 && sampleValue < 0.2)
		{
			catchUptypeWeapon[i] = Grenade;
		}
		else if(sampleValue >= 0.2 && sampleValue < 0.4)
		{
			catchUptypeWeapon[i] = Healthshot;
		}
		else if(sampleValue >= 0.4 && sampleValue <= 1.0)
		{
			catchUptypeWeapon[i] = Taser;
		}
	}
}

public DataPack FormTeams()
{
	DataPack dataPack = new DataPack();

	int count = GetCountPlayersOnServer();
	int tCount = count / 3;
	CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Всего террористов на {PURPLE}%d {DEFAULT}игроков будет {PURPLE}%d {DEFAULT}штук", count, tCount);
	dataPack.WriteCell(tCount);

	int clients[MAXPLAYERS + 1];
	for(int i = 1, j = 0; i <= MaxClients; i++) 
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			int team = GetClientTeam(i);
			if(team != CS_TEAM_SPECTATOR && team != CS_TEAM_NONE)
			{
				CS_SwitchTeam(i, CS_TEAM_CT);
				clients[j] = i;
				PrintToChatAll("[AVCR] %N (%i) - %d", i, i, clients[j]);
				j++;
				continue;
			}
		}
	}

	SortIntegers(clients, MAXPLAYERS + 1, Sort_Random);

	PrintToChatAll("[AVCR] After sort:");
	for(int i = 0, j = 0; i <= MaxClients; i++) {
		int index = clients[i];
		if(index != 0 && IsClientInGame(index) && !IsFakeClient(index)) {
			PrintToChatAll("[AVCR] %N (%i) will be T player", index, index);
			CS_SwitchTeam(index, CS_TEAM_T);
			dataPack.WriteCell(GetClientUserId(index));
			j++;
		}
		
		if(j == tCount) {
			break;
		}
	}
	
	return dataPack;
}

public GetCountPlayersOnServer()
{
	int count = 0;

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(GetClientTeam(i) != CS_TEAM_SPECTATOR && GetClientTeam(i) != CS_TEAM_NONE)
			{
				count++;
			}
		}
	}

	return count;
}

public Action CatchUp_TimerCallBack(Handle hTimer)
{
	if(catchUpDataPack != null)
	{
		catchUpDataPack.Reset();
		int count = catchUpDataPack.ReadCell();

		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Ловящими выбраны:");
		for(int i = 0; i < count; i ++)
		{
			int tClient = GetClientOfUserId(catchUpDataPack.ReadCell());

			if(tClient != 0 && IsClientInGame(tClient))
			{
				CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}]      {PURPLE}%N", tClient);
			}
		}

		// TurnOnSound();

		delete catchUpDataPack;
	}

	return Plugin_Stop;
}

public void TeleportToCatchUpSpawn(int iClient)
{
	static int j = sizeof(CatchUp_Origin) - 1;
	int team = GetClientTeam(iClient);

	PrintToChatAll("%N team - %s", iClient, GetClientTeam(iClient) == CS_TEAM_CT? "ct":"t")

	if(team == CS_TEAM_CT)
	{
		if(j == 0)
		{
			j = sizeof(CatchUp_Origin) - 1;
		}

		TeleportEntity(iClient, CatchUp_Origin[j], CatchUp_Ang[j], NULL_VECTOR);
		j--;
	}
	else
	{
		TeleportEntity(iClient, catchingOrigin, catchingAng, NULL_VECTOR);
		SetEntityRenderColor(iClient, TColor[0], TColor[1], TColor[2], TColor[3]); // устанавливаем ему красный цвет
	}
}

public void TurnOnSound()
{
	int[] clients = new int[MaxClients];
	int total = 0;

	for (int i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && g_bCatchUpMusic[i])
		{
			clients[total++] = i;
		}
	}

	if (total)
	{
		EmitSound(clients, total, g_sSoundCatchUp, SOUND_FROM_WORLD, SNDCHAN_STATIC,
			SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,
			NULL_VECTOR, NULL_VECTOR, true, 0.0);
	}

}

public bool CheckPlayersOnTeam()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			int team = GetClientTeam(i);
		
			if(team == CS_TEAM_CT && IsPlayerAlive(i))
			{
				if(GetEntityMoveType(i) == MOVETYPE_WALK)
				{
					return false;
				}
			}
		}
	}

	return true;
}

public bool CheckAlivePlayers()
{
	int ct = 0;
	int t = 0;

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			int team = GetClientTeam(i);
		
			if(team == CS_TEAM_CT && IsPlayerAlive(i))
			{
				ct++;
			}
			else if(team == CS_TEAM_T && IsPlayerAlive(i))
			{
				t++
			}

		}
	}

	if(ct == 0 || t == 0)
	{
		return true;
	}

	return false;
}

public int GetUnFreezePlayers()
{
	int count = 0;

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && GetClientTeam(i) == CS_TEAM_CT && IsPlayerAlive(i))
		{
			if(GetEntityMoveType(i) == MOVETYPE_WALK)
			{
				count++;
			}
		}
	}

	return count;
}

public void EndOfTheRound()
{
	if(h_CatchUpEndTimer != null)
	{
		delete h_CatchUpEndTimer;
	}

	CS_TerminateRound(6.0, CSRoundEnd_TerroristWin);

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			StopSound(i, SNDCHAN_STATIC, g_sSoundCatchUp);
			
			if(catchUp_TimerAntiCamp[i] != null)
			{
				delete catchUp_TimerAntiCamp[i];
			}
		}
	}

	CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] {PURPLE}CT {DEFAULT}проиграли. Победа за {PURPLE}T");
}

public int CatchUp_GetMaxUsefulness(int team)
{
	int iClient;
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && GetClientTeam(i) == team)
		{
			iClient = i;
			break;
		}
	}

	for(int i = 1; i < MaxClients; i++)
	{
		if(iClient != 0 && IsClientInGame(iClient))
		{
			if(IsClientInGame(i) && !IsFakeClient(i))
			{
				if(GetClientTeam(i) == team)
				{
					if(i_CountUseFulness[i] > i_CountUseFulness[iClient])
					{
						iClient = i;
					}
				}
				

			}
		}
		
	}

	return iClient;
}

void PerformBlind(int target, int amount, int duration)
{
	duration = duration * 1000;
	int g_iColor[4];
	g_iColor[0] = amount;
	g_iColor[1] = amount;
	g_iColor[2] = amount;
	g_iColor[3] = amount;

	Handle hMessage;
	int iClients[1];
	iClients[0] = target;
	hMessage = StartMessage("Fade", iClients, 1); 

	if(GetUserMessageType() == UM_Protobuf) 
	{
		PbSetInt(hMessage, "duration", duration);
		PbSetInt(hMessage, "hold_time", 0);
		PbSetInt(hMessage, "flags", 0x0001);
		PbSetColor(hMessage, "clr", g_iColor);
	}
	else
	{
		BfWriteShort(hMessage, duration);
		BfWriteShort(hMessage, 0);
		BfWriteShort(hMessage, (0x0001));
		BfWriteByte(hMessage, g_iColor[0]);
		BfWriteByte(hMessage, g_iColor[1]);
		BfWriteByte(hMessage, g_iColor[2]);
		BfWriteByte(hMessage, g_iColor[3]);
	}
	EndMessage(); 
}

public Action Timer_CatchUpStopRunHandler(Handle hTimer, any userId)
{
	int iClient = GetClientOfUserId(userId);

	if(iClient != 0 && IsClientInGame(iClient))
	{
		SetEntDataFloat(iClient, m_flLaggedMovementValue, 1.0, true);
	}	

	return Plugin_Stop;
}

public Action CatchUpUnBlind_TimerCB(Handle hTimer, any userId)
{
	int iClient = GetClientOfUserId(userId);

	if(iClient != 0 && IsClientInGame(iClient))
	{
		PerformBlind(iClient, 0, 0);
	}

	return Plugin_Stop;
}

public void ShowNotificationCatchUp()
{
	CreateTimer(1.0, CatchUp_NotifyRoundStart, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);

	
}

public Action CatchUp_NotifyRoundStart(Handle hTimer)
{
	static int time = 8;
	static char sBuf[128];

	if(time == 0)
	{
		time = 8;
		return Plugin_Stop;
	}


	if(time == 8)
	{
		Format(sBuf, sizeof (sBuf), "Беги!!! \nОсталось раундов: %d", iCountRound);

		CGOPrintToChatAll("{DEFAULT}[{PURPLE}XCP{DEFAULT}] Начались {PURPLE}догонялки{DEFAULT} раунд! {PURPLE}Осталось раундов: {PURPLE}%d", iCountRound);
	}

	static char sSecondBuf[MAXPLAYERS + 1][256];

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			SetHudTextParams(-0.4, -0.8, 4.5, 26, 107, 184, 255, 0, 0.0, 0.1, 0.1);
			
			ShowHudText(i, -1, sBuf);

			SetHudTextParams(-0.4, -0.6, 4.5, 26, 107, 184, 255, 0, 0.0, 0.1, 0.1);

			if(time == 8)
			{
				SetMessageClient(sSecondBuf[i], sizeof(sSecondBuf[]));
			}

			ShowHudText(i, -1, sSecondBuf[i]);
		}
	}

	time--;

	return Plugin_Continue;
}

public Action SetMessageClient(char [] sBuf, int len)
{
	int num = GetRandomInt(0, 4);

	switch(num)
	{
		case 0:
		{
			Format(sBuf, len, "Подсказка: Zeus не только слепит врагов,\nно и помогает спасти союзника");
		}

		case 1:
		{
			Format(sBuf, len, "Подсказка: Шприц поможет тебе спастись.\n Не забывай про него!");
		}

		case 2:
		{
			Format(sBuf, len, "Подсказка: Граната способна полностью перевернуть исход игры,\nесли кинуть её в замороженных союзников");
		}

		case 3:
		{
			Format(sBuf, len, "Подсказка: Шанс получения шприца или гранаты 20%");
		}

		case 4:
		{
			Format(sBuf, len, "Подсказка: При заморозке вокруг вас создается защитное поле.\nОно поможет вашим тиммейтам спасти вас");
		}
	}
}

public Action CatchUpDeleteFloor_TimerCallBack(Handle hTimer)
{
	CatchUpDeleteTowerFloor();
	CGOPrintToChatAll("{DEFAULT}[{PURPLE}XCP{DEFAULT}] Пол на {PURPLE}башне {DEFAULT}был разрушен!");

	return Plugin_Stop;
}

public void CatchUpDeleteTowerFloor()
{
	DeleteProp(CatchUpEntObjectsTower[0]);
	DeleteProp(CatchUpEntObjectsTower[1]);
}

public void ShowBetterPlayers()
{
	int usefulnessCT = CatchUp_GetMaxUsefulness(CS_TEAM_CT);
	int usefulnessT = CatchUp_GetMaxUsefulness(CS_TEAM_T);

	if(usefulnessCT != - 1 && i_CountUseFulness[usefulnessCT] != 0)
	{
		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Больше всего спас союзников - {PURPLE}%N{DEFAULT}({PURPLE}%d{DEFAULT})", usefulnessCT, i_CountUseFulness[usefulnessCT]);
	}

	if(usefulnessT != -1  && i_CountUseFulness[usefulnessT] != 0)
	{
		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Больше всего заморозил - {PURPLE}%N{DEFAULT}({PURPLE}%d{DEFAULT})", usefulnessT, i_CountUseFulness[usefulnessT]);
	}
}

public void CatchUpOffVipFeatures()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(VIP_IsClientFeatureUse(i, "VIP_PLAYERCOLOR"))
			{
				VIPFM_ToggleFeature(i, false, "VIP_PLAYERCOLOR");
			}
		}
	}
}

public void CatchUpDeleteStoreEntities()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		int entity = EntRefToEntIndex(catchUpStoreEntities[i]);
		if(entity != 0 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
}

public void CatchUpFreezePlayer(int victim)
{
	SetEntityRenderColor(victim, CtColor[0], CtColor[1], CtColor[2], CtColor[3]);

	float clientPos[3];
	GetClientAbsOrigin(victim, clientPos);
	int iEnt = CreateEntityByName("prop_dynamic_override");
	if (iEnt != -1 && IsValidEntity(iEnt))
	{
		SetEntityModel(iEnt, "models/weapons/eminem/ice_cube/ice_cube.mdl");
		DispatchSpawn(iEnt);
		ActivateEntity(iEnt);
		TeleportEntity(iEnt, clientPos, NULL_VECTOR, NULL_VECTOR); 
	}

	GetClientEyePosition(victim, clientPos);
	EmitAmbientSound(g_sFreezeSound, clientPos, victim, SNDLEVEL_RAIDSIREN);
	catchUpStoreEntities[victim] = EntIndexToEntRef(iEnt);
}

public void CatchUpUnFreezePlayer(int victim)
{
	float clientPos[3];
	SetEntityMoveType(victim, MOVETYPE_WALK); // размораживаем игрока
	SetEntityRenderColor(victim, defaultColor[0], defaultColor[1], defaultColor[2], defaultColor[3]);

	GetClientEyePosition(victim, clientPos);
	EmitAmbientSound(g_sFreezeSound, clientPos, victim, SNDLEVEL_RAIDSIREN);

	int entity = EntRefToEntIndex(catchUpStoreEntities[victim]);
	if(entity != 0 && IsValidEntity(entity))
	{
		AcceptEntityInput(entity, "Kill");
	}
}

public void DeleteAntiCamp(int iClient)
{
	AcceptEntityInput(catchUp_EntAntiCamp[iClient], "Kill");
}

public void CreateAntiCamp(int iClient)
{
	int zone = CreateEntityByName("trigger_multiple");
	catchUp_EntAntiCamp[iClient] = zone;

	if(zone == -1)
	{
		PrintToChat(iClient, "[DEBUG] Не удалось создать entity");
		return;
	}

	// int filter = CreateEntityByName("filter_activator_team");

	// if(filter == -1)
	// {
	// 	PrintToChat(iClient, "[DEBUG] Не удалось создать entity");
	// 	return Plugin_Handled;
	// }

	// PrintToChatAll("[DEBUG] filter activator team has been created(%d)", filter);

	// DispatchKeyValue(filter, "filterteam", "3");

	float fOrigin[3];
	
	GetClientEyePosition(iClient, fOrigin);

	

	float m_vecMins[3];
	m_vecMins[0] = fOrigin[0] - 65.0;
	m_vecMins[1] = fOrigin[1] + 65.0;
	m_vecMins[2] = fOrigin[2] + 50.0;
	
	float m_vecMaxs[3];
	m_vecMaxs[0] = fOrigin[0] + 65.0;
	m_vecMaxs[1] = fOrigin[1] - 65.0;
	m_vecMaxs[2] = fOrigin[2] - 50.0;

	float middle[3];
	char ZoneName[64];

	// Set name
	Format(ZoneName, sizeof(ZoneName), "anticamp");
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
	// SetEntityModel(zone, "models/error.mdl");

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			TE_SendBeamBoxToClient(i, m_vecMins, m_vecMaxs, LaserMaterial, HaloMaterial, 0, 30, 3.0, 5.0, 5.0, 2, 1.0, TColor, 0);
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
	HookSingleEntityOutput(zone, "OnStartTouch", StartOnTouch);
	HookSingleEntityOutput(zone, "OnEndTouch",   EndTouch);

	// PrintToChatAll("vecMax - %f, %f, %f", m_vecMaxs[0], m_vecMaxs[1], m_vecMaxs[2]);
	// PrintToChatAll("vecMin - %f, %f, %f", m_vecMins[0], m_vecMins[1], m_vecMins[2]);

	GetEntPropVector(zone, Prop_Send, "m_vecMins", m_vecMins);
	GetEntPropVector(zone, Prop_Send, "m_vecMaxs", m_vecMaxs);

	// PrintToChatAll("[Ent] vecMax - %f, %f, %f", m_vecMaxs[0], m_vecMaxs[1], m_vecMaxs[2]);
	// PrintToChatAll("[Ent] vecMin - %f, %f, %f", m_vecMins[0], m_vecMins[1], m_vecMins[2]);
}

public void StartOnTouch(const char[] output, int caller, int activator, float delay)
{
	if(IsClientValid(activator) && GetClientTeam(activator) == CS_TEAM_T && catchUp_TimerAntiCamp[activator] == null)
	{
		DataPack dataPack = new DataPack();

		dataPack.WriteCell(caller);
		dataPack.WriteCell(GetClientUserId(activator));

		catchUp_TimerAntiCamp[activator] = CreateTimer(5.0, CatchUp_AntiCampStartTimerCallBack, dataPack, TIMER_FLAG_NO_MAPCHANGE);
		// *  PrintToChatAll("[DEBUG] %N зашел в зону!(catchUp_TimerAntiCamp - %d)", activator, catchUp_TimerAntiCamp);
	}
}

public void EndTouch(const char[] output, int caller, int activator, float delay)
{
	//PrintToChatAll("[DEBUG] valid - %d, %N вышел из зоны!(catchUp_TimerAntiCamp - %d)", IsClientValid(activator), activator, catchUp_TimerAntiCamp[activator]);
	//PrintToChatAll("[DEBUG] GetClientTeam(activator) - %d == %d", GetClientTeam(activator), CS_TEAM_T);

	if(IsClientValid(activator) && GetClientTeam(activator) == CS_TEAM_T && catchUp_TimerAntiCamp[activator] != null)
	{
		// *  PrintToChatAll("[DEBUG] %N вышел из зоны!(catchUp_TimerAntiCamp - %d)", activator, catchUp_TimerAntiCamp[activator]);
		delete catchUp_TimerAntiCamp[activator];
	}

}

public Action CatchUp_AntiCampStartTimerCallBack(Handle hTimer, Handle dataPack)
{
	DataPack dp = view_as<DataPack>(dataPack);
	//PrintToChatAll("CatchUp_AntiCampStartTimerCallBack:: dataPack - %d", dp);
	dp.Reset(false);

	if(dp.IsReadable())
	{
		int ent = dp.ReadCell();
		int iClient = GetClientOfUserId(dp.ReadCell());

		// *       PrintToChatAll("[DEBUG] %N был больше 5 сек в зоне кемперства!(catchUp_TimerAntiCamp - %d)", iClient, catchUp_TimerAntiCamp);

		// int valident = IsValidEntity(ent);
		// PrintToChatAll("flag isValidEntity - %d", valident);

		if(IsValidEntity(ent))
		{
			DataPack secondDataPack = new DataPack();
			
		//	PrintToChatAll("Создаем secondDataPack");
			secondDataPack.WriteCell(ent);
			secondDataPack.WriteCell(GetClientUserId(iClient));

			catchUp_TimerAntiCamp[iClient] = CreateTimer(1.0, CatchUp_AntiCampTimerCallBack, secondDataPack, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
		//	PrintToChatAll("Создаем таймер на секундный damage, (catchUp_TimerAntiCamp[iClient] - %d)", catchUp_TimerAntiCamp[iClient]);
		}
		else
		{
			catchUp_TimerAntiCamp[iClient] = null;
			// *   PrintToChatAll("[DEBUG] %N невалидное поле, удаляем!(catchUp_TimerAntiCamp - %d)", iClient, catchUp_TimerAntiCamp);
		}

	}

	if(dp != null)
	{
		delete dp;
	}
	
	return Plugin_Stop;
}

public Action CatchUp_AntiCampTimerCallBack(Handle hTimer, Handle hDataPack)
{
	DataPack dp = view_as<DataPack>(hDataPack);
	dp.Reset(false);

	int ent = dp.ReadCell();
	int iClient = GetClientOfUserId(dp.ReadCell());

	// *    PrintToChatAll("Таймер на дамаг %N (hDataPack - %d)", iClient, hDataPack);
	// *    PrintToChatAll("ent - %d, iClient - %d", ent, iClient);

	if(IsValidEntity(ent))
	{
		if(iClient != 0 && IsClientInGame(iClient))
		{
			PrintHintText(iClient, "Вы зашли в личную зону замороженного игрока!\nВыйдите из неё, иначе последует урон...");
			SDKHooks_TakeDamage(iClient, iClient, -1, 10.0, DMG_BURN, -1, NULL_VECTOR, NULL_VECTOR);

			return Plugin_Continue;
		}
	}

	// *   PrintToChatAll("[DEBUG] проход на удаление");

	catchUp_TimerAntiCamp[iClient] = null;

	if(dp != null)
	{
		delete dp;
	}

	return Plugin_Stop;
}
