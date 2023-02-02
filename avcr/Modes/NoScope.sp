public void SetNoScope(int weapon)
{
	if (IsValidEdict(weapon))
	{
		char classname[32];
		GetEdictClassname(weapon, classname, sizeof(classname));
		
		if (!StrEqual(classname[7], "knife") && !StrEqual(classname[7], "revolver") && !StrEqual(classname[7], "hegrenade") && !StrEqual(classname[7], "incgrenade") && !StrEqual(classname[7], "molotov") && !StrEqual(classname[7], "smokegrenade") && !StrEqual(classname[7], "tagrenade") && !StrEqual(classname[7], "flashbang") && !StrEqual(classname[7], "decoy"))
		{
			SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 2.0);
		}
	}
}

public void ShowNotificationNoScope()
{
	char sBuf[128];
	Format(sBuf, sizeof (sBuf), "Начался раунд без прицелов!\nОсталось раундов: %d", iCountRound);
	CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Начался {PURPLE}без прицелов {DEFAULT}раунд! Осталось раундов: {PURPLE}%d", iCountRound);

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			SetHudTextParams(-0.4, -0.6, 4.5, 26, 107, 184, 255, 0, 0.0, 0.1, 0.1);
			ShowHudText(i, 2, sBuf);
		}
	}
}