public void EventRoundPreStart(Event hEvent, const char[] sEvName, bool bDontBroadcast)
{
	//PrintToChatAll("iRound - %d, CS_GetTeamScore(2) + CS_GetTeamScore(3) - %d", iRound, CS_GetTeamScore(2) + CS_GetTeamScore(3));
//	if(iRound == CS_GetTeamScore(2) + CS_GetTeamScore(3)) // Действия в самом начале кастом раунда

	if(preVote)
	{
		bCustomRound = true;
		preVote = false;

		InitSettings();
		return;
	}

	// if(g_bIsMatchEnd)
	// {
	// 	g_bIsMatchEnd = false;
	// 	CS_TerminateRound(10.0, CSRoundEnd_Draw);
	// 	PrintToChatAll("[DEBUG] Зашли в блок g_bIsMatchEnd");

	// 	return;
	// }

	if(bCustomRound)
	{
		InitSettings();
	}
}

public void Event_WeaponFire(Event hEvent, const char[] sEvName, bool bDontBroadcast)
{
	static char sBuf[128];

	if(bCustomRound && customRound[numCurrentRound].typeCustomGame == CatchUp)
	{
		hEvent.GetString("weapon", sBuf, sizeof(sBuf));

		if(StrEqual("weapon_healthshot", sBuf))
		{
			int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
			if(GetClientTeam(iClient) == CS_TEAM_CT && GetEntityMoveType(iClient) == MOVETYPE_NONE)
			{
				CatchUpUnFreezePlayer(iClient);
			}

			int entity = GetPlayerWeaponSlot(iClient, 11);

			if(entity == -1)
			{
				return;
			}

			RemoveEntity(entity);
		}
	}

	
}

void InitSettings()
{
	if(customRound[numCurrentRound].typeCustomGame == GrenadeWar)
	{
		infinite_ammo_mode.IntValue = 1;
	}

	if(!customRound[numCurrentRound].g_bModQueue && customRound[numCurrentRound].typeCustomGame != CatchUp) 
	{
		infinite_ammo_mode.IntValue = 2;
	}
	else
	{
		HookEvent("weapon_fire", WeaponFire);
	}

	CancelAllClientMenu();
	
	switch(customRound[numCurrentRound].typeCustomGame)
	{
		case GrenadeWar:
		{
			HookEvent("grenade_thrown", GrenadeThrown);
		}
		
		case LongJump:
		{
		//	HookEvent("player_jump", Event_PlayerJump);
		}
		case CatchUp:
		{
			HookEvent("weapon_fire", Event_WeaponFire);
			mp_ignore_round_win_conditions.IntValue = 1;
		}
		case Arena:
		{
			mp_death_drop_gun.IntValue = 0;
		}

		case KingOfTheHill:
		{
			ServerCommand("sm_bp_enable 0");
		}
	}

	if(customRound[numCurrentRound].typeCustomGame == WallFists)
	{
		mp_freezetime.IntValue = 5;
	}

	if(customRound[numCurrentRound].typeCustomGame == CatchUp)
	{
		mp_freezetime.IntValue = 10;
		mp_roundtime.IntValue = 5;
		ServerCommand("mp_autoteambalance 0");
	}

	if(customRound[numCurrentRound].g_bSetHsMode) 
	{
		hs_mode.IntValue = 1;
	}
	else
	{
		hs_mode.IntValue = 0;
	}

}

// на быструю руку
public void OffVipFeatures() {
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(VIP_IsClientFeatureUse(i, "BoostLadder"))
			{
				VIPFM_ToggleFeature(i, false, "BoostLadder");
			}

			if(VIP_IsClientFeatureUse(i, "BHOP"))
			{
				VIPFM_ToggleFeature(i, false, "BHOP");
			}

			if(VIP_IsClientFeatureUse(i, "Parachute"))
			{
				VIPFM_ToggleFeature(i, false, "Parachute");
			}

			if(VIP_IsClientFeatureUse(i, "Healthshot") || VIP_IsClientFeatureUse(i, "Healthshot_Pro"))
			{
				VIPFM_ToggleFeature(i, false, "Healthshot");
				VIPFM_ToggleFeature(i, false, "Healthshot_Pro");
			}

			if(VIP_IsClientFeatureUse(i, "AutoBuy"))
			{
				VIPFM_ToggleFeature(i, false, "AutoBuy");
			}		

			if(VIP_IsClientFeatureUse(i, "Respawn"))
			{
				VIPFM_ToggleFeature(i, false, "Respawn");
			}

			if(VIP_IsClientFeatureUse(i, "HP"))
			{
				VIPFM_ToggleFeature(i, false, "HP");
			}		

			if(VIP_IsClientFeatureUse(i, "Armor"))
			{
				VIPFM_ToggleFeature(i, false, "Armor");
			}

			if(VIP_IsClientFeatureUse(i, "Skins"))
			{
				VIPFM_ToggleFeature(i, false, "Skins");
			}
		}
	}
}

// на быструю руку
public void OnVipFeatures() {
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && VIP_IsClientVIP(i))
		{
				VIPFM_ToggleFeature(i, true, "BoostLadder");

				VIPFM_ToggleFeature(i, true, "BHOP");

				VIPFM_ToggleFeature(i, true, "Parachute");
			

				VIPFM_ToggleFeature(i, true, "Healthshot");
				VIPFM_ToggleFeature(i, true, "Healthshot_Pro");

	
				VIPFM_ToggleFeature(i, true, "AutoBuy");

				VIPFM_ToggleFeature(i, true, "Respawn");

				VIPFM_ToggleFeature(i, true, "HP");
				VIPFM_ToggleFeature(i, true, "Armor");

				VIPFM_ToggleFeature(i, true, "Skins");
		}
	}
}

public void EventRS_PS(Event hEvent, const char[] sEvName, bool bDontBroadcast)
{			
	if(bCustomRound)
	{
		if(sEvName[0] == 'p' && customRound[numCurrentRound].typeCustomGame != NoScope && customRound[numCurrentRound].typeCustomGame != OnlyKnife) // player_spawn
		{
			if(!IsAwpRound(customRound[numCurrentRound].typeCustomGame))
			{
				CreateTimer(0.01, DeleteWeaponsTimer, hEvent.GetInt("userid"), TIMER_FLAG_NO_MAPCHANGE);
			}

			CreateTimer(0.3, TimerCallBack, hEvent.GetInt("userid"), TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (sEvName[6] == 'e') // round_end
		{
			if(iCountRound == 0)
			{
				int tl;
				GetMapTimeLeft(tl);

				// ExtendMapTimeLimit(g_iRemainderTimeLeft - tl);
			//	PrintToChatAll("Уменьшаем timelimit на %d", g_iRemainderTimeLeft - tl);
			}

			if(!g_bIsSameRounds || !iCountRound)
			{
				switch(customRound[numCurrentRound].typeCustomGame)
				{
					case OtherWeapons:
					{
						hs_mode.IntValue = iHSMODE; // iHSMODE ставим тот режим, который стоял на сервере по умолчанию!
						mp_freezetime.IntValue = iFreezeTime;
						infinite_ammo_mode.IntValue = 0;
					}
					case GrenadeWar:
					{
						infinite_ammo_mode.IntValue = 0;
						UnhookEvent("grenade_thrown", GrenadeThrown);
					}
					case ChickenWar:
					{
						RemoveChickens();
						RemoveSound();
					}
					case WallFists:
					{
						mp_freezetime.IntValue = iFreezeTime;
						//delete props;
					}
					case WallHack:
					{
						sv_force_transmit_players.SetString("0", true, false);
					}
					case CatchUp:
					{
						mp_freezetime.IntValue = iFreezeTime;
						mp_roundtime.IntValue = 2;
						mp_ignore_round_win_conditions.IntValue = 0;
						infinite_ammo_mode.IntValue = 0;
						
						ServerCommand("AA_TIME 30");
						ServerCommand("sm_bp_enable 1");
						ServerCommand("mp_autoteambalance 1");

						UnhookEvent("weapon_fire", Event_WeaponFire);

						ShowBetterPlayers();
						ZeroingCatchUp();
						
						for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i))
							{
								if(!IsFakeClient(i) && VIP_IsClientVIP(i))
								{
									VIPFM_ToggleFeature(i, true, "VIP_PLAYERCOLOR");
								}

								if(catchUp_TimerAntiCamp[i] != null)
								{
									delete catchUp_TimerAntiCamp[i];
								}
							}
						}

						if(h_CatchUpInfoTimer != null)
						{
							delete h_CatchUpInfoTimer;
						}

						if(h_CatchUpEndTimer != null)
						{
							delete h_CatchUpEndTimer;
						}

						i_gCatchUpTime = 120;

						CatchUpDeleteStoreEntities();
					}

					case Deagle:
					{
					}

					case Arena:
					{
						mp_teammates_are_enemies.IntValue = 0;
						mp_ignore_round_win_conditions.IntValue = 0;
						mp_death_drop_gun.IntValue = 1;
						
						ServerCommand("sm_bp_enable 1");

						for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i))
							{
								if(!IsFakeClient(i) && VIP_IsClientVIP(i))
								{
									VIPFM_ToggleFeature(i, true, "Respawn");
								}
							}
						}

						hs_mode.IntValue = iHSMODE
						mp_freezetime.IntValue = iFreezeTime;

						Queue.Clear();
					}

					case KingOfTheHill:
					{
						mp_freezetime.IntValue = iFreezeTime;

						if(IsValidEntity(KOTH_entZone))
						{
							UnhookSingleEntityOutput(KOTH_entZone, "OnStartTouch", StartOnTouchKOTHZone);
							UnhookSingleEntityOutput(KOTH_entZone, "OnEndTouch",   EndTouchKOTHZone);
						}

						for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i))
							{
								if(KOTH_TimerAntiCamp[i])
								{
									KillTimer(KOTH_TimerAntiCamp[i]);
									KOTH_TimerAntiCamp[i] = null;
								}
							}
						}

						ServerCommand("sm_bp_enable 1");
					}
				}

				OnVipFeatures();

				if(customRound[numCurrentRound].g_bModQueue) 
				{
					UnhookEvent("weapon_fire", WeaponFire);
				}

				if(customRound[numCurrentRound].g_bGravity)
				{
					for(int i = 1; i <= MaxClients; i++)
					{
						if(IsClientInGame(i))
						{
							if(!IsFakeClient(i) && VIP_IsClientVIP(i))
							{
								VIPFM_ToggleFeature(i, true, "Parachute");
							}
						}
					}
				}
			}

			if(numCurrentRound != COUNT_ROUNDS - 1)
			{
				ServerCommand("sm plugins unload Duel.smx");
				ServerCommand("sm plugins unload Duel/Duel.smx");

				if(customRound[numCurrentRound + 1].typeCustomGame == CatchUp)
				{
					ServerCommand("mp_autoteambalance 0");
					PrepareCatchUp(GetEventInt(hEvent, "reason"));

					ShowBetterPlayers();
					ZeroingCatchUp();
					CatchUpOffVipFeatures();
					OffVipFeatures();
					CatchUpDeleteStoreEntities();

					i_gCatchUpTime = 120;

					if(customRound[numCurrentRound].typeCustomGame == CatchUp)
					{
						if(h_CatchUpInfoTimer != null)
						{
							delete h_CatchUpInfoTimer;
						}

						if(h_CatchUpEndTimer != null)
						{
							delete h_CatchUpEndTimer;
						}

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
					}

				}
				else if(customRound[numCurrentRound + 1].typeCustomGame == KingOfTheHill)
				{
					if(IsValidEntity(KOTH_entZone))
					{
						UnhookSingleEntityOutput(KOTH_entZone, "OnStartTouch", StartOnTouchKOTHZone);
						UnhookSingleEntityOutput(KOTH_entZone, "OnEndTouch",   EndTouchKOTHZone);
					}
					
					

					for(int i = 1; i <= MaxClients; i++)
					{
						if(IsClientInGame(i))
						{
							if(KOTH_TimerAntiCamp[i])
							{
								KillTimer(KOTH_TimerAntiCamp[i]);
								KOTH_TimerAntiCamp[i] = null;
							}
						}
					}
					
				}
			}


			KillAllWeapons();
			numCurrentRound++; // обязательно внизу, т.к сначала нужно убрать проделки прошлого раунда

			if(!iCountRound)
			{
				bCustomRound = false;
				ServerCommand("sm plugins load Duel.smx");
				ServerCommand("sm plugins load Duel/Duel.smx");
				//iRound = 1337;

				//int timeLeft;
				//GetMapTimeLeft(timeLeft);
				//PrintToChatAll("[DEBUG] Оставалось до конца карты %d(%d min %d sec)", timeLeft, timeLeft / 60, timeLeft % 60);
 
				//ExtendMapTimeLimit(timeLeft - g_iRemainderTimeLeft);  // полный идиотизм, чтобы увеличить тайм нужно подать отрицательное значение xD. Наоборот положительное соответственно
				//GetMapTimeLeft(timeLeft);
				//PrintToChatAll("[DEBUG] Поставлен дефолт, теперь до конца карты %d(%d min %d sec)", timeLeft, timeLeft / 60, timeLeft % 60);

				ResetSettings();

				g_hTimer = CreateTimer(CD, TimerNewVote, _, TIMER_FLAG_NO_MAPCHANGE);
				timeCD = GetTime() + 600;
			}

		}
		else if (sEvName[6] == 's') // round start
		{	
			iCountRound--;
			
			char sBuf[128];

			switch(customRound[numCurrentRound].typeCustomGame)
			{
				case OtherWeapons:
				{
					CreateTimer(0.1, TimerDeleteAllWeapons);

					Format(sBuf, sizeof (sBuf), "Начался раунд на %s!\nОсталось раундов: %d", customRound[numCurrentRound].sNameCurWeapon, iCountRound, customRound[numCurrentRound].g_bSetHsMode? "Только в голову":"Стандарт");
					ShowHudTextAll(sBuf);
					
					if(customRound[numCurrentRound].g_bSetHsMode)
					{
						ShowAlertTextAll("<font color='#ff00ff'>Только в голову</font>", 7)
					}

					if(customRound[numCurrentRound].g_bProps)
					{
						SpawnBlocks(kvWeaponRoundsObjects);
					}

					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался раунд на {PURPLE}%s {DEFAULT}(Осталось раундов: {PURPLE}%d{DEFAULT})\n", customRound[numCurrentRound].sNameCurWeapon, iCountRound);
					
				}
				case OnlyKnife:
				{
					Format(sBuf, sizeof (sBuf), "Начался раунд на %s!\nОсталось раундов: %d", customRound[numCurrentRound].sNameCurWeapon, iCountRound);
					
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался раунд на {PURPLE}%s {DEFAULT}(Осталось раундов: {PURPLE}%d{DEFAULT})", customRound[numCurrentRound].sNameCurWeapon, iCountRound);
					ShowHudTextAll(sBuf);
					
				}
				case NoScope:
				{
					ShowNotificationNoScope();
				}
				case ChickenWar:
				{
					Format(sBuf, sizeof (sBuf), "Началась куриная бойня! \nОружие: %s\nОсталось раундов: %d", customRound[numCurrentRound].sNameCurWeapon, iCountRound);
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Началась {PURPLE}куриная бойня {DEFAULT}раунд! \nОружие: {PURPLE}%s\nОсталось раундов: {PURPLE}%d", customRound[numCurrentRound].sNameCurWeapon, iCountRound);
					SpawnChickens();
					ShowHudTextAll(sBuf);
				}
				case GrenadeWar:
				{
					Format(sBuf, sizeof (sBuf), "Началась битва на гранатах(%s)! \nОсталось раундов: %d", customRound[numCurrentRound].sCurrentWeapon, iCountRound);
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Началась {PURPLE}битва на гранатах(%s) {DEFAULT}раунд! {PURPLE}Осталось раундов: {PURPLE}%d", customRound[numCurrentRound].sCurrentWeapon, iCountRound);
					ShowHudTextAll(sBuf);
				}
				case WallFists:
				{
					CreateTimer(0.1, TimerDeleteAllWeapons);

					SpawnBlocks(kvWallFistsObjects);

					ShowNotificationWallFists();
				}
				case Poeben:
				{
					Format(sBuf, sizeof (sBuf), "Началась поебень! \nОсталось раундов: %d", iCountRound);
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Началась {PURPLE}поебень{DEFAULT} раунд! {PURPLE}Осталось раундов: {PURPLE}%d", iCountRound);

					SpawnBlocks(kvPoebenObjects);

					ShowHudTextAll(sBuf);
				}
				case LongJump:
				{
					Format(sBuf, sizeof (sBuf), "Начался LongJump раунд! \nОсталось раундов: %d", iCountRound);
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался {PURPLE}LongJump{DEFAULT} раунд! {PURPLE}Осталось раундов: {PURPLE}%d", iCountRound);

					ShowHudTextAll(sBuf);
				}
				case WallHack:
				{
					createGlows();

					ShowNotificationWallHack();
				}

				case CatchUp:
				{
					SpawnBlocks(kvCatchUpObjects);
					h_CatchUpInfoTimer = CreateTimer(1.0, CatchUpInfo, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(0.3, CatchUp_TimerCallBack, _, TIMER_FLAG_NO_MAPCHANGE);
					h_CatchUpEndTimer = CreateTimer(mp_roundtime.IntValue * 60.0 + mp_freezetime.IntValue, CatchUpRoundEnd_TimerCallBack, _, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(20.0, CatchUpDeleteFloor_TimerCallBack, _, TIMER_FLAG_NO_MAPCHANGE);
					b_gCatchUpRoundEnd = false;

					ShowNotificationCatchUp();

				}

				case Deagle:
				{
					Format(sBuf, sizeof (sBuf), "Начался AWP + DEAGLE раунд! \nОсталось раундов: %d", iCountRound);
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался раунд {PURPLE}AWP + DEAGLE {DEFAULT}(Осталось раундов: {PURPLE}%d{DEFAULT})\n", iCountRound);
					ShowHudTextAll(sBuf);
				}

				case Arena:
				{
					CreateTimer(0.1, TimerDeleteAllWeapons);
					ArenaClear();

					PrepareArena();
					PreparePairs();
					TeleportAllToArenaSpawn();
					SpawnBlocks(kvArenaObjects);

					ShowNotificationArena();

					for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i))
							{
								if(!IsFakeClient(i) && VIP_IsClientVIP(i))
								{
									VIPFM_ToggleFeature(i, false, "Respawn");
								}
							}
						}
				}

				case KingOfTheHill:
				{
					CreateTimer(0.1, TimerDeleteAllWeapons);
					SpawnBlocks(kvKingOfTheHillObjects);
					CreateKOTHZone();

					ServerCommand("sm_bp_enable 0");
					ShowNotificationKingOfTheHill();
				}

				case Teleporters:
				{
					Format(sBuf, sizeof (sBuf), "Начались Телепорташки! \nОсталось раундов: %d", iCountRound);
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начались {PURPLE}Телепорташки{DEFAULT} раунд! {PURPLE}Осталось раундов: {PURPLE}%d", iCountRound);

					ShowHudTextAll(sBuf);
				}

				case BombMan:
				{
					Format(sBuf, sizeof (sBuf), "Начался BombMan раунд! \nОсталось раундов: %d", iCountRound);
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался {PURPLE}BombMan{DEFAULT} раунд! {PURPLE}Осталось раундов: {PURPLE}%d", iCountRound);

					ShowHudTextAll(sBuf);
				}
			}

			OffVipFeatures();

			CreateTimer(2.5, TimerDeleteWeaponsOnTheGround, _, TIMER_FLAG_NO_MAPCHANGE);

			Call_StartForward(g_hGFwd_CustomRoundStart); // Передаем Handle форварда
			Call_PushCell(customRound[numCurrentRound].typeCustomGame);
			Call_Finish();// Завершаем вызов форварда 
			
			if(!g_bIsSameRounds)
			{
				ShowRoundsQueue();
			}
		}
	}
	else if (sEvName[6] == 'e') // round_end
	{
		if(preVote)
		{
			if(customRound[numCurrentRound].typeCustomGame == CatchUp)
			{
				ServerCommand("mp_autoteambalance 0");
				PrepareCatchUp(GetEventInt(hEvent, "reason"));
				CatchUpOffVipFeatures();
			}
			else if(customRound[numCurrentRound].typeCustomGame == KingOfTheHill)
			{
				ServerCommand("sm_bp_enable 0");
			}
		}
	}
	else if(sEvName[0] == 'p' && g_bDeagleRestrict)
	{
		if(bAwpMap)
		{
			CreateTimer(0.1, DeleteDeagleTimerHandler, hEvent.GetInt("userid"), TIMER_FLAG_NO_MAPCHANGE);
		}
		
	}
}

public void EventCSWIN_Panel(Event event, const char[] name, bool dontBroadcast)
{
	if(bCustomRound && customRound[numCurrentRound].typeCustomGame == CatchUp)
	{
		//iCountRound++;
		//numCurrentRound--;
		// g_bIsMatchEnd = true;

		//mp_respawn_on_death_t.IntValue = 1;
		//mp_respawn_on_death_ct.IntValue = 1;
		//mp_roundtime.IntValue = 20;
		

		//CreateTimer(18.0, WinPanelNewRound_TimerCallBack, _, TIMER_FLAG_NO_MAPCHANGE);

		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Была завершена игра. Перенастраиваем {PURPLE}кастомные раунды");
	}
}

public void WeaponFire(Event hEvent, const char[] sName, bool bDbc)
{
	if(bCustomRound && customRound[numCurrentRound].g_bModQueue)
	{
        int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
        RequestFrame(SetAmmo, iClient);
	}
}

public void GrenadeThrown(Event hEvent, const char[] sName, bool bDbc)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));

	if(IsPlayerAlive(iClient))
	{
		if ((GetPlayerWeaponSlot(iClient, 2)) == -1)
		{
			GivePlayerItem(iClient, "weapon_knife_css");
		}

	}
}

public void Event_PlayerJump(Handle event, const char[] name, bool dontBroadcast)
{ 
	if(!bCustomRound || customRound[numCurrentRound].typeCustomGame != LongJump)
	{
		return;
	}

	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	float finalvec[3];
	finalvec[0] = GetEntDataFloat(iClient, VelocityOffset_0) * (1.2/2.0);
	finalvec[1] = GetEntDataFloat(iClient, VelocityOffset_1) * (1.2/2.0);
	finalvec[2] = 0.0;
	SetEntDataVector(iClient, BaseVelocityOffset, finalvec, true);
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	if(bCustomRound)
	{
		int iClient = GetClientOfUserId(event.GetInt("userid"));

		if(customRound[numCurrentRound].typeCustomGame == CatchUp)
		{
			if(CheckAlivePlayers())
			{
				EndOfTheRound();
			}

			if(iClient != 0 && catchUp_TimerAntiCamp[iClient] != null)
			{
				delete catchUp_TimerAntiCamp[iClient];
			}
							
		}
		else if(customRound[numCurrentRound].typeCustomGame == KingOfTheHill)
		{
			int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

			if(attacker == 0 && IsClientValid(iLastPushed[iClient]))
			{
				event.BroadcastDisabled = true;
				
				Event event_fake = CreateEvent("player_death", true);
				
				char sbuf[64];
				GetClientWeapon(iLastPushed[iClient], sbuf, sizeof(sbuf));

				event_fake.SetString("weapon", sbuf);
				event_fake.SetInt("userid", event.GetInt("userid"));
				event_fake.SetInt("attacker", GetClientUserId(iLastPushed[iClient]));
				
				for(int i = 1; i <= MaxClients; i++) if(IsClientInGame(i) && !IsFakeClient(i))
				{
					event_fake.FireToClient(i);
				}
				
				event_fake.Cancel();

				SetEntProp(iLastPushed[iClient], Prop_Data, "m_iFrags", GetEntProp(iLastPushed[iClient], Prop_Data, "m_iFrags") + 1);

				SetEntProp(iClient, Prop_Data, "m_iFrags", GetEntProp(iClient, Prop_Data, "m_iFrags") + 1);
				CS_SetClientContributionScore(iLastPushed[iClient], CS_GetClientContributionScore(iLastPushed[iClient]) + 2);
			}

			if(KOTH_TimerAntiCamp[iClient])
			{
				KillTimer(KOTH_TimerAntiCamp[iClient]);
				KOTH_TimerAntiCamp[iClient] = null;
			}
		}
		else if(customRound[numCurrentRound].typeCustomGame == Arena)
		{
			int players = CountAlivePlayers();
			if(players < 2)
			{
				CS_TerminateRound(6.0, CSRoundEnd_Draw);

				int winner = FindRival(iClient);

				if(winner != -1)
				{
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Победителем оказался {PURPLE}%N", winner);
				}
				else
				{
					CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Победитель не найден!");
				}

				Queue.Clear();
				ArenaClear();

				return;
			}

			// iClient - кто сдох, узнаем его арену
			// ArenaClients[iClient] - его арена

			int indexRival = FindRival(iClient); // Поиск его киллера
			ArenaClients[iClient] = -1;

			if(indexRival != -1)
			{
				if(IsPlayerAlive(indexRival))
				{
					Queue.Push(indexRival);
//					PrintToChatAll("Сейчас в очереди %d игроков", Queue.Length);
//					PrintToChatAll("%N добавлен в очередь", indexRival);
				}
				
			}


			// Проверяем есть ли свободные игроки для начала новый игры на арене 
			// Если есть, то выбираем для них арену(изменить переменные), телепортируем и запускаем
			if(Queue.Length > 1) 
			{
				SendToArena();

				return;
			}
		}
		else if(customRound[numCurrentRound].typeCustomGame == Teleporters)
		{
			int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

			float vec[3];
			float ang[3];
			GetClientAbsOrigin(iClient, vec);
			GetClientAbsAngles(attacker, ang);
			TeleportEntity(attacker, vec, ang, NULL_VECTOR);
		}
	}
}

public void Event_WF(Event event, const char[] name, bool dontBroadcast)
{
	if(customRound[numCurrentRound].typeCustomGame == BombMan)
	{
		BombMan_WeaponFire(event);
	}
}