
static const float vTspawnOrigin[][] =
{
	{-235.5, -817.508789, -312.468750},
    {-235.5, -896.226623, -312.468750},
    {-235.5, -971.950378, -312.468750},
    {-235.5, -1049.181640, -312.468750},
    {-235.5, -1125.820922, -312.468750},
    //======================================
    {-116.0, -817.508789, -312.468750},
    {-116.0, -896.226623, -312.468750},
    {-116.0, -971.950378, -312.468750},
    {-116.0, -1049.181640, -312.468750},
    {-116.0, -1125.820922, -312.468750}
};

static const float vCTspawnOrigin[][] =
{
	{330.431457, -817.508789, -312.468750},
    {330.431457, -896.226623, -312.468750},
    {330.431457, -971.950378, -312.468750},
    {330.431457, -1049.181640, -312.468750},
    {330.431457, -1125.820922, -312.468750},
    //======================================
    {210.0, -817.508789, -312.468750},
    {210.0, -896.226623, -312.468750},
    {210.0, -971.950378, -312.468750},
    {210.0, -1049.181640, -312.468750},
    {210.0, -1125.820922, -312.468750}
};

static const float vTAngles [] = {0.17, -0.27, 0.0};
static const float vCTAngles [] = {0.16, 179.77, 0.0};

static const float poeben_vTspawnOrigin [] = {19.40, 1177.99, -244.37}; 
static const float poeben_vCTspawnOrigin [] = {18.63, -1153.71, -244.37}; 

static const float poeben_vTspawnAng [] = {-9.57, -90.45, 0.00}; 
static const float poeben_vCTspawnAng [] = {-14.85, 90.28, 0.00}; 

int ctSpawnCount = 0;
int tSpawnCount = 0;

public void TeleportToPoebenClient(int iClient)
{
    int team = GetClientTeam(iClient);

    if(team == 2)
    {
        TeleportEntity(iClient, poeben_vTspawnOrigin, poeben_vTspawnAng, NULL_VECTOR);
    }
    else if(team == 3)
    {
        TeleportEntity(iClient, poeben_vCTspawnOrigin, poeben_vCTspawnAng, NULL_VECTOR);
    }
}

public void TeleportClient(int iClient)
{
    int team = GetClientTeam(iClient);

    if(team == 2)
    {
        TeleportEntity(iClient, vTspawnOrigin[tSpawnCount], vTAngles, NULL_VECTOR);
        tSpawnCount++;
    }
    else if(team == 3)
    {
        TeleportEntity(iClient, vCTspawnOrigin[ctSpawnCount], vCTAngles, NULL_VECTOR);
        ctSpawnCount++;
    }
    
    if(ctSpawnCount > 9) ctSpawnCount = 0;
    if(tSpawnCount > 9) tSpawnCount = 0;
}

public void ShowNotificationWallFists()
{
    char sBuf[128];
    Format(sBuf, sizeof (sBuf), "Началась стенка на стенку! \nОсталось раундов: %d", iCountRound);
    CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Началась {PURPLE}стенка на стенку{DEFAULT} раунд! {PURPLE}Осталось раундов: {PURPLE}%d", iCountRound);

    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i))
        {
			SetHudTextParams(-0.4, -0.6, 4.5, 26, 107, 184, 255, 0, 0.0, 0.1, 0.1);
			ShowHudText(i, 2, sBuf);
		}
	}
}