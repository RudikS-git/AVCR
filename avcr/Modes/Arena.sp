static const float ArenaOriginTFirst[][3] =
{
    // t spawn 
	{ 665.94, 914.0, -75.06 }, // 2floor|right|firstSpawn|T
	{ 656.10, 914.0, -248.41 }, // 1floor|right|firstSpawn|T
	{ -42.85, 914.0, -248.41 }, // 1floor|left|firstSpawn|T
	{ -46.78, 914.0, -75.06 }, //2floor|left|firstSpawn|T

    // ct spawn offset 1161 | -859 = (-2020)
	{ 656.10, -1106.0, -248.41 },
    { 665.94, -1106.0, -75.06 },
	{ -51.21, -1107.72, -248.41 },
    { -51.21, -1107.72, -75.06 },

    // t side second
    { 662.28, 287.0, 65.09 }, // 1floor|right|1spawn|T
	{ 662.56, 287.0, 236.94 }, // 2floor|right|1spawn|T
	{ -60.42, 288.51, 65.09 },
    { -60.42, 288.51, 236.94 },

    // ct side second 539 | - 297 = offset -836
    { 662.28, -549.0, 65.09 },
	{ 662.56, -549.0, 236.94 },
	{ -46.45, -544.28, 65.09 },
	{ -46.45, -544.28, 236.94 }
    
};

static const float ArenaOriginTSecond[][3] =
{
    // t spawn 
	{ 660.08, 1162.0, -75.06 }, // 2floor|right|secondSpawn|T
	{ 652.62, 1162.0, -248.41 }, // 1floor|right|secondSpawn|T
	{ -52.20, 1162.0, -248.41 }, // 1floor|left|secondSpawn|T
	{ -52.80, 1162.0, -75.06 }, // 2floor|left|secondSpawn|T

    // ct spawn
	{ 652.62, -858.0, -248.41 },
    { 660.08, -858.0, -75.06 },
	{ -52.20, -858.0, -248.41 },
	{ -52.80, -858.0, -75.06 },

    // t side second
    { 660.42, 536.0, 65.09 }, // 1floor|right|2spawn|T
	{ 667.55, 536.0, 236.94 }, // 2floor|right|2spawn|T
	{ -55.4, 537.96, 65.09 }, // 1floor|left|2spawn|T
	{ -55.99, 538.51, 236.94 }, // 2floor|left|2spawn|T

    // ct side second
    { 660.42, -300.0, 65.09 },
	{ 667.55, -300.0, 236.94},
    { -52.54, -298.33, 65.09 },
	{ -55.05, -299.63, 236.94 }
};

static const float ArenaOriginCTFirst[][3] =
{
    // t spawn 
    { 85.13, 914.0, -75.06 }, // 2floor|right|firstSpawn|СT
	{ 98.74, 914.0, -248.41 }, // 1floor|right|firstSpawn|СT
	{ -598.42, 914.0, -248.41 }, // 1floor|left|firstSpawn|СT
	{ -598.92, 914.0, -75.06 }, //2floor|left|firstSpawn|СT

    // ct spawn offset 1161 | -859 = (-2020)
	{ 98.74, -1106.0, -248.41 },
	{ 85.13, -1106.0, -75.06 },
    { -582.81, -1107.72, -248.41 }, // замена -42.85, -1106.0, -248.41
	{ -582.81, -1107.72, -75.06 }, // замена -46.78, -1106.0, -75.06

    // t side second
    { 85.25, 287.0, 65.09 }, // 1floor|right|1spawn|CT
	{ 85.25, 287.0, 236.94 }, // 2floor|right|1spawn|CT
    { -592.53, 288.51, 65.09 },
    { -592.53, 288.51, 236.94 },


    // ct side second 539 | - 297 = offset -836
    { 85.25, -549.0, 65.09 },
	{ 85.25, -549.0, 236.94 },
    { -601.12, -549.0, 65.09 },
	{ -588.43, -549.0, 236.94 }
};

static const float ArenaOriginCTSecond[][3] = 
{
    // t spawn
    { 83.90, 1162.0, -75.06 }, // 2floor|right|secondSpawn|СT
	{ 91.26, 1162.0, -248.41 }, // 1floor|right|secondSpawn|СT
	{ -601.61, 1162.0, -248.41 }, // 1floor|left|secondSpawn|СT
	{ -598.78, 1162.0, -75.06 }, // 2floor|left|secondSpawn|СT

    // ct spawn
	{ 91.26, -858.0, -248.41 },
	{ 83.90, -858.0, -75.06 },
	{ -601.61, -858.0, -248.41 },
	{ -598.78, -858.0, -75.06 },

    // t side second
    { 76.67, 536.0, 65.09 }, // 1floor|right|2spawn|CT
	{ 74.35, 536.0, 236.94 }, // 2floor|right|2spawn|CT
	{ -608.48, 536.0, 65.09 }, // 1floor|left|2spawn|СT
	{ -595.36, 536.0, 236.94 }, // 2floor|left|2spawn|СT

    // ct side second
    { 88.66, -299.15, 65.09 },
	{ 88.01, -299.39, 236.94 },
	{ -608.48, -300.0, 65.09 },
	{ -595.36, -300.0, 236.94 }
};

static const float Arena_AlphaT[3] = { 3.25, 178.2, 0.00 };
static const float Arena_AlphaCT[3] = { 7.47, 1.59, 0.0 };

public Action Command_bidat(int iClient, int argc)
{
    //CreateAntiCamp(iClient);

    char buffer[128]
    GetCmdArg(1, buffer, sizeof(buffer));
    int num = StringToInt(buffer);
    GetCmdArg(2, buffer, sizeof(buffer));
    int second = StringToInt(buffer);

    if(num < 16 && num >= 0)
    {
        TeleportEntity(iClient, ArenaOriginTFirst[num], Arena_AlphaT, NULL_VECTOR);
        PrintToChatAll("%N %f %f %f", iClient, ArenaOriginTFirst[num][0], ArenaOriginTFirst[num][1], ArenaOriginTFirst[num][2]);

        PrintToChatAll("%f %f %f", ArenaOriginCTFirst[num][0], ArenaOriginCTFirst[num][1], ArenaOriginCTFirst[num][2]);
        TeleportEntity(second, ArenaOriginCTFirst[num], Arena_AlphaCT, NULL_VECTOR);
        
    }
    else
    {
        PrintToChat(iClient, "Некорректное число от 0 до 15");
    }

    return Plugin_Handled;
}

public Action Command_Secbidat(int iClient, int argc)
{
    char buffer[128]
    GetCmdArg(1, buffer, sizeof(buffer));
    int num = StringToInt(buffer);
    GetCmdArg(2, buffer, sizeof(buffer));
    int second = StringToInt(buffer);

    if(num < 16 && num >= 0)
    {
        TeleportEntity(iClient, ArenaOriginTSecond[num], Arena_AlphaT, NULL_VECTOR);
        TeleportEntity(second, ArenaOriginCTSecond[num], Arena_AlphaCT, NULL_VECTOR);
    }
    else
    {
        PrintToChat(iClient, "Некорректное число от 0 до 15");
    }

    return Plugin_Handled;
}

public void PrepareArena()
{
    mp_teammates_are_enemies.IntValue = 1;
    mp_ignore_round_win_conditions.IntValue = 1;
    mp_death_drop_gun.IntValue = 0;

    ServerCommand("sm_bp_enable 0");
}

public void PreparePairs()
{
    int lastClient = -1;

    for(int i = 1, arenaNumber = 1, c = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i) && !IsFakeClient(i) && !IsClientSourceTV(i))
        {
            int team = GetClientTeam(i);
            if(team != CS_TEAM_SPECTATOR && team != CS_TEAM_NONE)
            {
                ArenaClients[i] = arenaNumber;

                if(c % 2 == 0)
                {
                    arenaNumber++;
                }
                
                c++;

                lastClient = i;
            }
        }
    }

    MixPairs(lastClient);

    if(lastClient != -1)
    {
        int rival = FindRival(lastClient);

        if(rival == -1)
        {
            Queue.Push(lastClient);
//            PrintToChatAll("%N добавлен в очередь(Всего %d length)", lastClient, Queue.Length);
        }
    }

    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i) && !IsFakeClient(i) && !IsClientSourceTV(i))
        {
            int team = GetClientTeam(i);
            if(team != CS_TEAM_SPECTATOR && team != CS_TEAM_NONE)
            {
//                PrintToChatAll("MIX | %N arena - %d", i, ArenaClients[i]);
            }
        }
    }
}

public void MixPairs(int &lastClient)
{
    if(GetClientCount(true) < 3)
    {
        return;
    }

    for(int i = 1; i <= MaxClients / 2; i++)
    {
        int firstClient;
        int secondClient;

        do
        {
            firstClient = GetRandomInt(1, MaxClients);
        }
        while(ArenaClients[firstClient] <= 0)

        do
        {
            secondClient = GetRandomInt(1, MaxClients);
        }
        while(ArenaClients[secondClient] <= 0 || ArenaClients[secondClient] == ArenaClients[firstClient])

        if(lastClient == firstClient)
        {
            lastClient = secondClient;
        }
        else if(lastClient == secondClient)
        {
            lastClient = firstClient;
        }

        int buffer = ArenaClients[firstClient];
        ArenaClients[firstClient] = ArenaClients[secondClient];
        ArenaClients[secondClient] = buffer;
    }
}

public void TeleportAllToArenaSpawn()
{
    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i) && !IsFakeClient(i))
        {
            TeleportToArenaSpawn(i);
            CreateArenaFreezeTime(i);
        }
    }
}

public void ArenaClear()
{
    for(int i = 0; i <= MaxClients / 2; i++) // может быть проблема тут (охвачены не все арены)
    {
        IsArenaBusy[i] = false;
    }

    for(int i = 1; i <= MaxClients; i++) // может быть проблема тут (охвачены не все арены)
    {
        ArenaClients[i] = -1;
    }
}

public void TeleportToArenaSpawn(int iClient)
{
    int typeSpawn = GetRandomInt(0, 1);
    int arena = ArenaClients[iClient] - 1;

    if(arena >= 0)
    {
        if(!IsArenaBusy[arena])
        {
    //        PrintToChatAll("[DEBUG] Arena %d | %N телепортирован в зону T (IsArenaBusy[arena] - %d)", arena, iClient, IsArenaBusy[arena]);
            if(typeSpawn)
            {
                TeleportEntity(iClient, ArenaOriginTFirst[arena], Arena_AlphaT, NULL_VECTOR);
            }
            else
            {
                TeleportEntity(iClient, ArenaOriginTSecond[arena], Arena_AlphaT, NULL_VECTOR);
            }

            IsArenaBusy[arena] = true;
        }
        else
        {
    //        PrintToChatAll("[DEBUG] Arena %d | %N телепортирован в зону CT (IsArenaBusy[arena] - %d)", arena, iClient, IsArenaBusy[arena]);

            if(typeSpawn)
            {
                TeleportEntity(iClient, ArenaOriginCTFirst[arena], Arena_AlphaCT, NULL_VECTOR);
            }
            else
            {
                TeleportEntity(iClient, ArenaOriginCTSecond[arena], Arena_AlphaCT, NULL_VECTOR);
            }

            IsArenaBusy[arena] = false;
        }
    }
    
}

public CreateArenaGame(Handle hdataPack)
{
    DataPack dataPack = view_as<DataPack>(hdataPack);
    dataPack.Reset();
    int iFirstPlayer = dataPack.ReadCell();
    int iSecondPlayer = dataPack.ReadCell();
    delete dataPack;

    TeleportToArenaSpawn(iFirstPlayer);
    TeleportToArenaSpawn(iSecondPlayer);

    CreateArenaFreezeTime(iFirstPlayer);
    CreateArenaFreezeTime(iSecondPlayer);

    PrintHintText(iFirstPlayer, "Ваш соперник: %N", iSecondPlayer);
    PrintHintText(iSecondPlayer,  "Ваш соперник: %N", iFirstPlayer);

  //  PrintToChatAll("Были телепортнуты в 1 арену %N и %N", iFirstPlayer, iSecondPlayer);
}

public void GiveArenaDrop(int iClient)
{
    GivePlayerItem(iClient, customRound[numCurrentRound].sCurrentWeapon);

  //  PrintToChatAll("[DEBUG] Выдача дропа %s", customRound[numCurrentRound].sCurrentWeapon);
}

public CreateArenaFreezeTime(int iClient)
{
    int secondPlayer = FindRival(iClient);

    

    if(secondPlayer != -1)
    {
        PrintHintText(iClient, "Ваш соперник: %N", secondPlayer);
    //    PrintToChatAll("%N -> %N", iClient, secondPlayer);
    }
    else
    {
        PrintHintText(iClient, "У вас отсутствует противник :(");
    //    PrintToChatAll("%N нету соперника", iClient);
    }

    DeleteWeapons(iClient);
    SetEntityHealth(iClient, 100);
    SetEntityMoveType(iClient, MOVETYPE_NONE);

    CreateTimer(3.0, ArenaFreezeTimeCallBack, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
}

public Action ArenaFreezeTimeCallBack(Handle hTimer, any userId)
{
    int iFirstPlayer = GetClientOfUserId(userId);

    if(iFirstPlayer > 0 && IsClientInGame(iFirstPlayer))
    {
        SetEntityMoveType(iFirstPlayer, MOVETYPE_WALK);
        GiveArenaDrop(iFirstPlayer);
        PrintHintText(iFirstPlayer, "Начали !!!");
    }

    return Plugin_Stop;
}

public int FindRival(int iClient)
{
    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i))
        {
            if(ArenaClients[i] == ArenaClients[iClient] && i != iClient)
            {
                return i;
            }
        }
    }

    return -1;
}

public void SendToArena()
{
    for(int i = 0; i < (Queue.Length - 1); i+=2)
    {
        int firstClient = Queue.Get(0);
        int secondClient = Queue.Get(1);
        
        ArenaClients[firstClient] = ArenaClients[secondClient];
        IsArenaBusy[ArenaClients[firstClient]] = false;

        //PrintToChatAll("Зануляем IsArenaBusy, arena %d (%N & %N", ArenaClients[firstClient], firstClient, secondClient);
        //PrintToChatAll("IsArenaBusy[ArenaClients[firstClient]] - %d", IsArenaBusy[ArenaClients[firstClient]]);

        DataPack dataPack = new DataPack();
        dataPack.WriteCell(firstClient);
        dataPack.WriteCell(secondClient);
        RequestFrame(CreateArenaGame, dataPack);

        Queue.Erase(0);
        Queue.Erase(0);
    }

}

public int CountAlivePlayers()
{
    int alivePlayers = 0;

    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i) && IsPlayerAlive(i))
        {
            alivePlayers++;
        }
    }

    return alivePlayers;
}

public void ShowNotificationArena()
{
    char sBuf[128];
    Format(sBuf, sizeof (sBuf), "Начался Arena 1x1 раунд! \nОсталось раундов: %d", iCountRound);
    CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался {PURPLE}Arena 1x1{DEFAULT} раунд! {PURPLE}Осталось раундов: {PURPLE}%d", iCountRound);

    for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			ShowHudText(i, 2, sBuf);
		}
	}
}