public ResetSettings()
{
	mp_ignore_round_win_conditions.IntValue = 0;

	ResetCR(customRound);

	hs_mode.IntValue = iHSMODE;
	mp_ignore_round_win_conditions.IntValue = 0;
}

public ResetCR(CustomRound [] cr)
{
	for(int i = 0; i < COUNT_ROUNDS; i++)
	{
		cr[i].g_bSetHsMode = false;
		cr[i].g_iSetArmor = 0;
		cr[i].g_iSetSpeed = 0;
		cr[i].g_bKnife = false;
		cr[i].g_bGravity = false;
		cr[i].g_bModQueue = false;
		cr[i].IsTooled = false;
		cr[i].typeCustomGame = Default;
		cr[i].g_bKnifeDamage = false;
		cr[i].g_bProps = false;

		g_iAdminChoses = 0;
		numCurrentRound = 0;			
	}
}

public void PlayerCrToCommonCr(int iClient)
{
	for(int i = 0; i < COUNT_ROUNDS; i++)
	{
		customRound[i].IsTooled = pCustomRound[iClient][i].IsTooled;
		customRound[i].g_iSetSpeed = pCustomRound[iClient][i].g_iSetSpeed;
		customRound[i].g_iSetArmor = pCustomRound[iClient][i].g_iSetArmor;
		customRound[i].g_bSetHsMode = pCustomRound[iClient][i].g_bSetHsMode;
		customRound[i].g_bGravity = pCustomRound[iClient][i].g_bGravity;
		customRound[i].g_bKnife = pCustomRound[iClient][i].g_bKnife;
		customRound[i].g_bModQueue = pCustomRound[iClient][i].g_bModQueue;
		customRound[i].g_bKnifeDamage = pCustomRound[iClient][i].g_bKnifeDamage;
		customRound[i].g_bProps = pCustomRound[iClient][i].g_bProps;
		customRound[i].typeCustomGame = pCustomRound[iClient][i].typeCustomGame;

		strcopy(customRound[i].sCurrentWeapon, LENGTH_WEAPON, pCustomRound[iClient][i].sCurrentWeapon);
		strcopy(customRound[i].sNameCurWeapon, LENGTH_WEAPON, pCustomRound[iClient][i].sNameCurWeapon);
	}

	iCountRound = piCountRound[iClient];
}

public void Copy(CustomRound cr, CustomRound sourceCr)
{
	cr.IsTooled = sourceCr.IsTooled;
	cr.g_iSetSpeed = sourceCr.g_iSetSpeed;
	cr.g_iSetArmor = sourceCr.g_iSetArmor;
	cr.g_bSetHsMode = sourceCr.g_bSetHsMode;
	cr.g_bGravity = sourceCr.g_bGravity;
	cr.g_bKnife = sourceCr.g_bKnife;
	cr.g_bModQueue = sourceCr.g_bModQueue;
	cr.g_bKnifeDamage = sourceCr.g_bKnifeDamage;
	cr.g_bProps = sourceCr.g_bProps;
	cr.typeCustomGame = sourceCr.typeCustomGame;

	strcopy(cr.sCurrentWeapon, LENGTH_WEAPON, sourceCr.sCurrentWeapon);
	strcopy(cr.sNameCurWeapon, LENGTH_WEAPON, sourceCr.sNameCurWeapon);
}

public void SetRandomWeapons(CustomRound [] cr, int i) {
	int typeWeapon = GetRandomInt(0, 1);

	char dsBUF [2][64];
	
	if(typeWeapon)
	{
		int weapon = GetRandomInt(0, sizeof(sWeapon) - 1);
		ExplodeString(sWeapon[weapon], "_", dsBUF, 2, 64, false)
		strcopy(cr[i].sCurrentWeapon, LENGTH_WEAPON, sWeapon[weapon]);
		strcopy(cr[i].sNameCurWeapon, LENGTH_WEAPON, dsBUF[1]);
	}
	else
	{
		int weapon = GetRandomInt(0, sizeof(sPistol) - 1);
		ExplodeString(sPistol[weapon], "_", dsBUF, 2, 64, false)
		strcopy(cr[i].sCurrentWeapon, LENGTH_WEAPON, sPistol[weapon]);
		strcopy(cr[i].sNameCurWeapon, LENGTH_WEAPON, dsBUF[1]);
	}
}

public void GetRandomModes(CustomRound [] cr, int iCountRound)
{
	g_bIsSameRounds = false;

	for(int i = 0; i < iCountRound; i++)
	{
		int randomInt = GetRandomInt(1, 15); // специально число больше, чтобы увеличить вероятность обычных оружейных раундов

		switch(randomInt)
		{
			case OtherWeapons:
			{
				RandomOtherWeapons(cr, i);
			}

			case NoScope:
			{
				SetNoScopeMode(cr, i);
			}

			case OnlyKnife:
			{
				SetOnlyKnifeMode(cr, i);
			}

			case ChickenWar:
			{
				cr[i].IsTooled = true;
				cr[i].g_iSetSpeed = 0;//GetRandomInt(0, 2);
				cr[i].g_iSetArmor = GetRandomInt(0, 2);
				cr[i].g_bSetHsMode = false;//view_as<bool>(GetRandomInt(0, 1));
				cr[i].g_bGravity = false;//view_as<bool>(GetRandomInt(0, 1));
				cr[i].g_bKnife = view_as<bool>(GetRandomInt(0, 1));
				cr[i].g_bModQueue = false;//view_as<bool>(GetRandomInt(0, 1));
				cr[i].g_bKnifeDamage = view_as<bool>(GetRandomInt(0, 1));
		
				SetRandomWeapons(cr, i);

				SetChickenWarMode(cr, i);
			}

			case GrenadeWar:
			{
				int typeWeapon = GetRandomInt(0, sizeof(sGrenades) - 1);

				SetGrenadeWarMode(cr, i, sGrenades[typeWeapon]);
			}

			case WallFists:
			{
				int typeWeapon = GetRandomInt(0, sizeof(sSpecialWeapons) - 1);

				SetWallFistsMode(cr, i, sSpecialWeapons[typeWeapon]);
			}

			// case Poeben:
			// {
			// 	SetPoebenMode(cr, i);
			// }

			case LongJump:
			{
				SetLongJumpMode(cr, i);
			}

			case WallHack:
			{
				SetWallHackMode(cr, i);
			}

			case CatchUp:
			{
				SetCatchUpMode(cr, i);
			}

			case Arena:
			{
				cr[i].g_iSetArmor = GetRandomInt(0, 2);
				cr[i].g_bSetHsMode = view_as<bool>(GetRandomInt(0, 1));
				cr[i].g_bKnife = view_as<bool>(GetRandomInt(0, 1));
				cr[i].g_bModQueue = view_as<bool>(GetRandomInt(0, 1));
				cr[i].g_bKnifeDamage = view_as<bool>(GetRandomInt(0, 1));
				
				SetRandomWeapons(cr, i);

				SetArenaMode(cr, i);
			}

			case BombMan:
			{
				SetBombManMode(cr, i);
			}

			default:
			{
				RandomOtherWeapons(cr, i);
			}
		}
	}
}

public void RandomOtherWeapons(CustomRound [] cr, int i) 
{
	cr[i].typeCustomGame = OtherWeapons;
	cr[i].IsTooled = true;
	cr[i].g_iSetSpeed = 0; // GetRandomInt(0, 1);
	cr[i].g_iSetArmor = GetRandomInt(0, 2);
	cr[i].g_bSetHsMode = view_as<bool>(GetRandomInt(0, 1));

	cr[i].g_bGravity = false; //view_as<bool>(GetRandomInt(0, 1));
	cr[i].g_bKnife = view_as<bool>(GetRandomInt(0, 1));
	cr[i].g_bModQueue = false; // view_as<bool>(GetRandomInt(0, 1));
	cr[i].g_bKnifeDamage = view_as<bool>(GetRandomInt(0, 1));

	int typeWeapon = GetRandomInt(0, 1);

	char dsBUF [2][64];
	
	if(typeWeapon)
	{
		int weapon = GetRandomInt(0, sizeof(sWeapon) - 1);
		ExplodeString(sWeapon[weapon], "_", dsBUF, 2, 64, false)
		strcopy(cr[i].sCurrentWeapon, LENGTH_WEAPON, sWeapon[weapon]);
		strcopy(cr[i].sNameCurWeapon, LENGTH_WEAPON, dsBUF[1]);
	}
	else
	{
		int weapon = GetRandomInt(0, sizeof(sPistol) - 1);
		ExplodeString(sPistol[weapon], "_", dsBUF, 2, 64, false)
		strcopy(cr[i].sCurrentWeapon, LENGTH_WEAPON, sPistol[weapon]);
		strcopy(cr[i].sNameCurWeapon, LENGTH_WEAPON, dsBUF[1]);
	}
}

public CancelAllClientMenu()
{
	for(int i = 1; i<MaxClients; i++)
	{
		CancelClientMenu(i, false);
	}
}

public void KillAllWeapons()
{	
	int maxent = GetMaxEntities();
	char weapon[64];
	for (int i = 1; i < maxent; ++i) 
	{ 	
		if (IsValidEdict(i) && IsValidEntity(i)) 
		{
			GetEdictClassname(i, weapon, sizeof(weapon));

			if (customRound[numCurrentRound].g_bKnife && (StrContains(weapon, "knife", false) > -1 || StrContains(weapon, "bayonet", false) > -1))
			{
				continue;
			}

			if (StrContains(weapon, "weapon", false) != -1 || StrContains(weapon, "bayonet", false) != -1) 
			{
				RemoveEdict(i);
			}
		} 
	}
}

public Action DeleteDeagleTimerHandler(Handle hTimer, any userId)
{
	int iClient = GetClientOfUserId(userId);

	if(iClient > 0 && IsClientInGame(iClient))
	{
		DeleteDeagle(iClient);
	}

	return Plugin_Continue;
}

public void DeleteDeagle(int iClient)
{
	int ind;
	if (IsClientInGame(iClient) && (ind = GetPlayerWeaponSlot(iClient, 1)) >= 0)
	{
		RemovePlayerItem(iClient, ind);
	}
}

public void DeleteWeapons(int iClient)
{
	int index;
	char weapon[64];
	char knife[64];
	for (int slot = 0; slot < 5; ++slot)
	{
		while ((index = GetPlayerWeaponSlot(iClient, slot)) != -1)
		{
			if(customRound[numCurrentRound].g_bKnife && CS_SLOT_KNIFE == slot)
			{
				GetEdictClassname(index, weapon, sizeof(weapon));
				if (StrContains(weapon, "knife", false) > -1 || StrContains(weapon, "bayonet", false) > -1)
				{
					strcopy(knife, sizeof(knife), weapon);
				}
			}
			
			RemovePlayerItem(iClient, index);
			AcceptEntityInput(index, "Kill");
		}
	}

	if (customRound[numCurrentRound].g_bKnife)
	{
		GivePlayerItem(iClient, knife);
	}
}

public Action DeleteWeaponsTimer(Handle hTimer, any userId)
{
	int iClient = GetClientOfUserId(userId);

	if(iClient > 0 && IsClientInGame(iClient))
	{
		DeleteWeapons(iClient);
	}

	return Plugin_Stop;
}

public bool IsAwpRound(TypeCustomGame typeCustomGame)
{
	switch(typeCustomGame)
	{
		case NoScope:
			return true;
		case Poeben:
			return true;
		case LongJump:
			return true;
		case WallHack:
			return true;
		case Deagle:
			return true;
		case Teleporters:
			return true;
	}

	return false;
}

public bool IsClientValid(int iClient)
{
    return iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient);
}

public void SetAmmo(int iClient)
{
	int iWeapon = GetEntPropEnt(iClient, Prop_Data, "m_hActiveWeapon");
	if(iWeapon != -1)
	{
		SetEntProp(iWeapon, Prop_Send, "m_iPrimaryReserveAmmoCount", 1); // патроны в запасе
		SetEntProp(iWeapon, Prop_Send, "m_iClip1", 0); // патроны в обойме
	}
}

public void ShowHudTextAll(char [] sBuf)
{
	SetHudTextParams(-0.4, -0.6, 4.5, GetRandomInt(0, 255), GetRandomInt(0, 255), GetRandomInt(0, 255), 255, 0, 0.0, 0.1, 0.1);

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			ShowHudText(i, 2, sBuf);
		}
	}
}

public void ShowRoundsQueue()
{
	if(numCurrentRound != COUNT_ROUNDS - 1 && customRound[numCurrentRound + 1].typeCustomGame != Default)
	{
		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Следующие раунды:\n");

		char sType[64];
		
		for(int i = numCurrentRound + 1, j = 1; i < iCountRound; i++, j++)
		{
			if(!customRound[i].IsTooled)
			{
				break;
			}

			GetTypeCustomGame(sType, sizeof(sType), i);
			CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] {PURPLE}%d) {PURPLE}%s", j, sType);
		}
	}
}

public void GetTypeCustomGame(char [] sType, int length, int round)
{
	switch(customRound[round].typeCustomGame)
	{
		case OtherWeapons:
		{
			if(customRound[round].g_bSetHsMode)
			{
				if((!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage))
				{
					Format(sType, length, "Оружейный на {PURPLE}%s {DEFAULT}(Только в голову, Нож выкл)", customRound[round].sNameCurWeapon);
				}
				else
				{
					Format(sType, length, "Оружейный на {PURPLE}%s {DEFAULT}(Только в голову, Нож вкл)", customRound[round].sNameCurWeapon);
				}
			}
			else
			{
				if((!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage))
				{
					Format(sType, length, "Оружейный на {PURPLE}%s {DEFAULT}(Нож выкл)", customRound[round].sNameCurWeapon);
				}
				else
				{
					Format(sType, length, "Оружейный на {PURPLE}%s {DEFAULT}(Нож вкл)", customRound[round].sNameCurWeapon);
				}
			}

			
		}
		case OnlyKnife:
		{
			strcopy(sType, length, "На ножах");
		}
		case NoScope:
		{
			if(!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage)
			{
				strcopy(sType, length, "Без прицелов (Нож выкл)");
			}
			else
			{
				strcopy(sType, length, "Без прицелов (Нож вкл)");
			}
		}
		case ChickenWar:
		{
			Format(sType, length, "Куриная битва (%s)", customRound[round].sNameCurWeapon);
		}
		case GrenadeWar:
		{
			if(!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage)
			{
				Format(sType, length, "Война на гранатах ({PURPLE}%s{DEFAULT}, Нож выкл)", customRound[round].sCurrentWeapon);
			}
			else
			{
				Format(sType, length, "Война на гранатах ({PURPLE}%s{DEFAULT}, Нож вкл)", customRound[round].sCurrentWeapon);
			}
			
		}
		case WallFists:
		{
			Format(sType, length, "Стенка на стенку (%s)", customRound[round].sCurrentWeapon);
		}
		case Poeben:
		{
			if(!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage)
			{
				strcopy(sType, length, "Поебень (Нож выкл)");
			}
			else
			{
				strcopy(sType, length, "Поебень (Нож вкл)");
			}

		}
		case LongJump:
		{
			if(!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage)
			{
				strcopy(sType, length, "Длинные прыжки (Нож выкл)");
			}
			else
			{
				strcopy(sType, length, "Длинные прыжки (Нож вкл)");
			}
			
		}
		case WallHack:
		{
			if(!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage)
			{
				strcopy(sType, length, "WallHack (Нож выкл)");
			}
			else
			{
				strcopy(sType, length, "WallHack (Нож вкл)");
			}

		}

		case CatchUp:
		{
			strcopy(sType, length, "CatchUp");
		}

		case Arena:
		{
			if(customRound[round].g_bSetHsMode)
			{
				if((!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage))
				{
					Format(sType, length, "Арена на {PURPLE}%s {DEFAULT}(Только в голову, Нож выкл)", customRound[round].sNameCurWeapon);
				}
				else
				{
					Format(sType, length, "Арена на {PURPLE}%s {DEFAULT}(Только в голову, Нож вкл)", customRound[round].sNameCurWeapon);
				}
			}
			else
			{
				if((!customRound[round].g_bKnife || !customRound[round].g_bKnifeDamage))
				{
					Format(sType, length, "Арена на {PURPLE}%s {DEFAULT}(Нож выкл)", customRound[round].sNameCurWeapon);
				}
				else
				{
					Format(sType, length, "Арена на {PURPLE}%s {DEFAULT}(Нож вкл)", customRound[round].sNameCurWeapon);
				}
			}
		}
		

	}
}

stock void RemoveNades(int client)
{
	while (RemoveWeaponBySlot(client, 3))
	{
		for (int i = 0; i < 6; i++)
			SetEntProp(client, Prop_Send, "m_iAmmo", 0, _, g_iGrenadeOffsets[i]);
	}
}

void GetMiddleOfABox(const float vec1[3], const float vec2[3], float buffer[3])
{
	// Just make vector from points and half-divide it
	float mid[3];
	MakeVectorFromPoints(vec1, vec2, mid);
	mid[0] = mid[0] / 2.0;
	mid[1] = mid[1] / 2.0;
	mid[2] = mid[2] / 2.0;
	AddVectors(vec1, mid, buffer);
}

public void TE_SendBeamBoxToClient(int client, const float upc[3], const float btc[3], int ModelIndex, int HaloIndex, int StartFrame, int FrameRate, const float Life, const float Width, const float EndWidth, int FadeLength, const float Amplitude, const int Color[4], int Speed)
{
	// Create the additional corners of the box
	float tc1[] = {0.0, 0.0, 0.0};
	float tc2[] = {0.0, 0.0, 0.0};
	float tc3[] = {0.0, 0.0, 0.0};
	float tc4[] = {0.0, 0.0, 0.0};
	float tc5[] = {0.0, 0.0, 0.0};
	float tc6[] = {0.0, 0.0, 0.0};

	AddVectors(tc1, upc, tc1);
	AddVectors(tc2, upc, tc2);
	AddVectors(tc3, upc, tc3);
	AddVectors(tc4, btc, tc4);
	AddVectors(tc5, btc, tc5);
	AddVectors(tc6, btc, tc6);

	tc1[0] = btc[0];
	tc2[1] = btc[1];
	tc3[2] = btc[2];
	tc4[0] = upc[0];
	tc5[1] = upc[1];
	tc6[2] = upc[2];

	// Draw all the edges
	TE_SetupBeamPoints(upc, tc1, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(upc, tc2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(upc, tc3, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc6, tc1, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc6, tc2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc6, btc, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc4, btc, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc5, btc, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc5, tc1, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc5, tc3, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc4, tc3, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
	TE_SetupBeamPoints(tc4, tc2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
	TE_SendToClient(client);
}

/*public void DeleteEquip(int i)
{
	if(IsClientInGame(i) && IsPlayerAlive(i))
	{
		int iEnt;

		while ((iEnt = GetPlayerWeaponSlot(i, 2)) != -1)
		{
			RemovePlayerItem(i, iEnt);
		}
	}
}*/

void ShowAlertTextAll(const char[] sMessage, int iDuration = 5)
{
	Event hEvent = CreateEvent("show_survival_respawn_status", true);
	
	hEvent.SetString("loc_token", sMessage);
	hEvent.SetInt("duration", iDuration);
	hEvent.SetInt("userid", -1);
	
	for (int i = 1; i <= MaxClients; i++) if(IsClientInGame(i) && !IsFakeClient(i))
	{
		hEvent.FireToClient(i);
	}
	
	hEvent.Cancel();
}

public Menu CloneMenuSettings(Menu &inputMenu)
{
	Menu menu = new Menu(MenuSetRounds);

	char title[64];
	
	inputMenu.GetTitle(title, sizeof(title));

	menu.SetTitle(title);
	menu.ExitButton = inputMenu.ExitButton;
	menu.ExitBackButton = inputMenu.ExitBackButton;

	char infoBuf[64];
	char dispBuf[64];
	int style;

	for(int i = 0; i < inputMenu.ItemCount; i++)
	{
		inputMenu.GetItem(i, infoBuf, sizeof(infoBuf), style, dispBuf, sizeof(dispBuf));
		menu.AddItem(infoBuf, dispBuf);
	}

	return menu;
}

public void CreateVoteWithMessage(iClient)
{
	char sBuf[256];

	if(g_bIsSameRounds)
	{
		switch(pCustomRound[iClient][numCurrentRound].typeCustomGame)
		{
			case OtherWeapons, OnlyKnife:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил игру на %s\nКол-во раундов - %d\nРежим - %s\n", iClient, pCustomRound[iClient][numRound].sNameCurWeapon, piCountRound[iClient], pCustomRound[iClient][numRound].g_bSetHsMode? "ONLY HS":"Стандарт");
			}
			case NoScope:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил игру без прицелов (NoScope)\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case ChickenWar:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил куриную бойню на %s\nКол-во раундов - %d\n", iClient, pCustomRound[iClient][numRound].sNameCurWeapon, piCountRound[iClient]);
			}
			case GrenadeWar:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил битву на гранатах(%s)\nКол-во раундов - %d\n", iClient, pCustomRound[iClient][numRound].sCurrentWeapon, piCountRound[iClient]);
			}
			case WallFists:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил стенку на стенку\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case Poeben:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил поебень\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case LongJump:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил LongJump + BHOP\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case WallHack:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил WallHack\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case CatchUp:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил Догонялки\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case Deagle:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил AWP+DEAGLE\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case Arena:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил ARENA на %s\nКол-во раундов - %d\n", iClient, pCustomRound[iClient][numRound].sNameCurWeapon, piCountRound[iClient]);
			}
			case KingOfTheHill:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил Царь горы\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
			case Teleporters:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил Телепорташки\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}

			case BombMan:
			{
				Format(sBuf, sizeof(sBuf), "\n\n\n\nАдмин %N предложил BombMan\nКол-во раундов - %d\n", iClient, piCountRound[iClient]);
			}
		}
	}
	else
	{
		Format(sBuf, sizeof(sBuf), "\n\n\nАдмин %N предложил смесь режимов кастомной игры\nКол-во раундов - %d \n", iClient, piCountRound[iClient]);
	}

	yes = GetRandomInt(1, 7);
	no = yes + 1;
	
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) != 1)
		{
			CreateVotePanel(i, sBuf);
			maxCurPlayer++;
		}
	}
}