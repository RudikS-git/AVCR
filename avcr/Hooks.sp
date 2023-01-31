public Action OnWeaponUse(int wpnClient, int wpnId)
{
	if(bCustomRound && !api_IsWeaponBlock)
	{
		char wName[22];
		
		GetEntityClassname(wpnId, wName, 22);

		switch (GetEntProp(wpnId, Prop_Send, "m_iItemDefinitionIndex"))
		{
			case 23: strcopy(wName, sizeof(wName), "weapon_mp5sd");
			case 60: strcopy(wName, sizeof(wName), "weapon_m4a1_silencer");
			case 61: strcopy(wName, sizeof(wName), "weapon_usp_silencer");
			case 63: strcopy(wName, sizeof(wName), "weapon_cz75a");
			case 64: strcopy(wName, sizeof(wName), "weapon_revolver");
		}

		if (customRound[numCurrentRound].g_bKnife && (StrContains(wName, "knife", false) > -1 || StrContains(wName, "bayonet", false) > -1))
		{
			return Plugin_Continue;
		}

		if(customRound[numCurrentRound].typeCustomGame == Deagle)
		{
			if(StrContains(wName, "deagle", false) == -1 && StrContains(wName, "awp", false) == -1)
			{
				//PrintToChatAll("Удаление %s", wName);
				return Plugin_Handled;
			}

			return Plugin_Continue;
		}

		if(customRound[numCurrentRound].typeCustomGame == CatchUp)
		{
			if (!StrEqual(wName, "weapon_taser") && !StrEqual(wName, "weapon_hegrenade") && !StrEqual(wName, "weapon_healthshot"))
			{
				return Plugin_Handled;
			}

			return Plugin_Continue;
		}

		if(customRound[numCurrentRound].typeCustomGame != OnlyKnife)
		{
			if (!StrEqual(wName, customRound[numCurrentRound].sCurrentWeapon))
			{
				return Plugin_Handled;
			}
		}
		else
		{
			if (StrContains(wName, "knife", false) == -1 && StrContains(wName, "bayonet", false) == -1)
			{
				return Plugin_Handled;
			}
		}
	}
	/*else if(bAwpMap)
	{
		char wName[22];
		GetEntityClassname(wpnId, wName, 22);
		
		if (StrEqual(wName, "weapon_deagle"))
		{
			RequestFrame(DeleteDeagle, wpnClient);
		}
	}*/
	return Plugin_Continue;
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{
	//PrintToChatAll("%N attack %N with %d", attacker, victim, weapon);
	if(bCustomRound)
	{
		if(customRound[numCurrentRound].typeCustomGame == CatchUp)
		{
			damage = 0.0;

			if (damagetype & DMG_FALL) // убираем урон от падения
			{
				return Plugin_Handled;
			}

			if(!IsClientValid(attacker) || !IsClientValid(victim))
			{
				//PrintToChatAll("шо то не то | attacker - %d, victim - %d", attacker, victim);
				return Plugin_Continue;
			}

			int teamVictim = GetClientTeam(victim);
			int teamAtacker = GetClientTeam(attacker);
			static char wName[32];
			

			if(teamVictim != teamAtacker)
			{
				if(teamVictim == CS_TEAM_CT && GetEntityMoveType(victim) != MOVETYPE_NONE)
				{
					i_CountUseFulness[attacker]++;

					SetEntityMoveType(victim, MOVETYPE_NONE); // морозим игрока
					RequestFrame(CatchUpFreezePlayer, victim);
					PrintHintText(victim,"Вы были заморожены %N.\nДождитесь помощи тиммейтов:)", attacker);

					RequestFrame(CreateAntiCamp, victim);
					
				}
				else if(teamVictim == CS_TEAM_T) // weapon id 40 - taser
				{
					if(weapon != -1)
					{
						GetEntityClassname(weapon, wName, sizeof(wName));
						if(StrContains(wName, "taser", false) != -1)
						{
							PerformBlind(victim, 255, 10);

							SetEntDataFloat(victim, m_flLaggedMovementValue, 0.5, true);
							CreateTimer(2.5, Timer_CatchUpStopRunHandler, GetClientUserId(victim), TIMER_FLAG_NO_MAPCHANGE);
						}
					}

					return Plugin_Handled;
				}
			}
			else
			{
				if(GetEntityMoveType(victim) == MOVETYPE_NONE)
				{
					if(weapon != -1)
					{
						GetEntityClassname(weapon, wName, sizeof(wName));
					}

					if(GetEntityMoveType(attacker) == MOVETYPE_WALK || damagetype & DMG_BLAST || (StrContains(wName, "knife", false) == -1 && StrContains(wName, "bayonet", false) == -1))
					{
						i_CountUseFulness[attacker]++;

						CatchUpUnFreezePlayer(victim);
						DeleteAntiCamp(victim);
					}

					return Plugin_Changed;
				}
			}

			if(!b_gCatchUpRoundEnd && (CheckPlayersOnTeam() || CheckAlivePlayers())) // problem 0players != end game
			{
				EndOfTheRound();
				b_gCatchUpRoundEnd = true;	
			}

			return Plugin_Handled;
		}
		else if(customRound[numCurrentRound].typeCustomGame == BombMan)
		{
			if(attacker == victim && damagetype == 64)
			{
				return Plugin_Handled;
			}

			if (damagetype & DMG_FALL) // убираем урон от падения
			{
				return Plugin_Handled;
			}
		}
		else if(customRound[numCurrentRound].typeCustomGame == KingOfTheHill)
		{
			if(IsClientValid(attacker) && IsClientValid(victim))
			{
				if(GetClientTeam(attacker) != GetClientTeam(victim))
				{
					PushCommonInfected(attacker, victim, 800.0, 380.0);
					iLastPushed[victim] = attacker;
					return Plugin_Handled;
				}
			}

			// if(damagetype & DMG_FALL)
			// {
			// 	PrintToChatAll("%N упал(damage %f(уронил %N))", victim, damage, iLastPushed[victim]);
			// 	if(GetClientHealth(victim) <= damage)
			// 	{
			// 		PrintToChatAll("%N сейчас сдохнет(damage %f)", victim, damage);

			// 		attacker = iLastPushed[victim];
			// 		inflictor = iLastPushed[victim];
			// 		damagetype = DMG_SLASH;
			// 		weapon = GetEntPropEnt(iLastPushed[victim], Prop_Send, "m_hActiveWeapon");
			// 	}

			// 	return Plugin_Continue;
			// }
		}
		else if((customRound[numCurrentRound].typeCustomGame == GrenadeWar || !customRound[numCurrentRound].g_bKnifeDamage) && damagetype & DMG_SLASH && IsClientValid(attacker) && IsClientValid(victim))
    	{
        	static char wpn[32];
        	GetClientWeapon(attacker, wpn, sizeof(wpn));
        	if(StrContains(wpn, "knife", false) != -1 || StrContains(wpn, "bayonet", false) != -1)
        	{
            	damage = 0.0;
            	return Plugin_Changed;
        	}
    	}
		else if(customRound[numCurrentRound].typeCustomGame == Arena)
		{
			if(ArenaClients[attacker] != ArenaClients[victim]) // in one arena
			{
				return Plugin_Handled;
			}

		}
	}


	return Plugin_Continue;
}

public Action OnPreThink(int client)
{
	if(bCustomRound)
	{
		if(customRound[numCurrentRound].typeCustomGame == NoScope)
		{
			SetNoScope(GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"));
		}
		else if(customRound[numCurrentRound].typeCustomGame == BombMan)
		{
			BombMan_OnPreThink(client);
		}
	}
	
	return Plugin_Continue;
}

public Action SetTransmit(int entity, int iClient) 
{
	if(bCustomRound && customRound[numCurrentRound].typeCustomGame == Arena)
	{
		if (IsClientInGame(iClient))
		{
			if (iClient != entity && 0 < entity <= MaxClients)
			{
				int team = GetClientTeam(iClient);
				if (ArenaClients[iClient] != ArenaClients[entity] && team != CS_TEAM_SPECTATOR && team != CS_TEAM_NONE && IsPlayerAlive(iClient))
				{
					return Plugin_Handled;
				}
			}		
		}
	}

	return Plugin_Continue; 
}

public Action StartTouch (int entity, int other)
{
	if(bCustomRound && customRound[numCurrentRound].typeCustomGame == KingOfTheHill)
	{
		if(entity > 0 && entity <= MaxClients && other > 0 && other <= MaxClients)
		{
		//	PrintToChatAll("%N and %N were touched", entity, other);
			iLastPushed[entity] = other;
			PushCommonInfected(entity, other, 850.0, 380.0);	
		}
	}

	return Plugin_Continue;
}

stock void PushCommonInfected(int client, int target, float distance, float jump_power = 251.0)
{
    static float angle[3], dir[3], current[3], resulting[3];
    
    GetClientEyeAngles(client, angle);
 //   PrintToChat(client, "EyeAng: %f %f %f", angle[0], angle[1], angle[2]);
    GetAngleVectors(angle, dir, NULL_VECTOR, NULL_VECTOR);
  //  PrintToChat(client, "AngVect: %f %f %f", dir[0], dir[1], dir[2]);
    NormalizeVector(dir, dir);
//    PrintToChat(client, "NormalizeVect: %f %f %f", dir[0], dir[1], dir[2]);
    ScaleVector(dir, distance);
  //  PrintToChat(client, "ScaleVector: %f %f %f", dir[0], dir[1], dir[2]);

    
    GetEntDataVector(target, VelocityOffset_0, current);
   // PrintToChat(client, "GetEntDataVector: %f %f %f", current[0], current[1], current[2]);
    resulting[0] = current[0] + dir[0];
    resulting[1] = current[1] + dir[1];
    resulting[2] = jump_power; // min. 251
    
    TeleportEntity(target, NULL_VECTOR, NULL_VECTOR, resulting);
}