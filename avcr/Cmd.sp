

public Action Command_Cr(int iClient, int argc)
{
	CreateCrAdminMenu().Display(iClient, 0);

	return Plugin_Handled;
}

public Action StopSoundHandler(int iClient, int argc)
{
	g_bCatchUpMusic[iClient] = !g_bCatchUpMusic[iClient];
	char sbuf[16];

	if(g_bCatchUpMusic[iClient])
	{
		CGOPrintToChat(iClient, "[{LIGHTBLUE}CR{DEFAULT}] Вы успешно {GREEN}включили {DEFAULT}музыку.");
	}
	else
	{
		CGOPrintToChat(iClient, "[{LIGHTBLUE}CR{DEFAULT}] Вы успешно {RED}выключили {DEFAULT}музыку.");
	}

	IntToString(g_bCatchUpMusic[iClient], sbuf, sizeof(sbuf));
	SetClientCookie(iClient, g_hCookie, sbuf)

	return Plugin_Handled;
}

public Action Command_Kek(int iClient, int argc)
{
	EquipPlayerWeapon(iClient,GivePlayerItem(iClient, "weapon_fists"));
	// int zone = CreateEntityByName("trigger_hurt");

	// float fOrigin[3];
	
	// GetClientEyePosition(iClient, fOrigin);

	// float m_vecMins[3];
	// m_vecMins[0] = fOrigin[0] - 200.0;
	// m_vecMins[1] = fOrigin[1] + 200.0;
	// m_vecMins[2] = fOrigin[2] + 200.0;
	
	// float m_vecMaxs[3];
	// m_vecMaxs[0] = fOrigin[0] + 200.0;
	// m_vecMaxs[1] = fOrigin[1] - 200.0;
	// m_vecMaxs[2] = fOrigin[2] - 200.0;

	// DispatchKeyValue(zone, "targetname", "tree");
	// DispatchKeyValue(zone, "spawnflags", "64");
	// DispatchKeyValue(zone, "damagetype", "1024");
	// DispatchKeyValue(zone, "damagecap", "5");
	// DispatchKeyValue(zone, "damage", "-5");
	// DispatchSpawn(zone);
	// ActivateEntity(zone);
	// SetEntProp(zone, Prop_Data, "m_spawnflags", 64);
	// TeleportEntity(zone, fOrigin, NULL_VECTOR, NULL_VECTOR);
	// SetEntityModel(zone, "models/error.mdl");

	// // Have the m_vecMins always be negative
	// m_vecMins[0] = m_vecMins[0] - fOrigin[0];
	// if (m_vecMins[0] > 0.0)
	// 	m_vecMins[0] *= -1.0;
	// m_vecMins[1] = m_vecMins[1] - fOrigin[1];
	// if (m_vecMins[1] > 0.0)
	// 	m_vecMins[1] *= -1.0;
	// m_vecMins[2] = m_vecMins[2] - fOrigin[2];
	// if (m_vecMins[2] > 0.0)
	// 	m_vecMins[2] *= -1.0;

	// // And the m_vecMaxs always be positive
	// m_vecMaxs[0] = m_vecMaxs[0] - fOrigin[0];
	// if (m_vecMaxs[0] < 0.0)
	// 	m_vecMaxs[0] *= -1.0;
	// m_vecMaxs[1] = m_vecMaxs[1] - fOrigin[1];
	// if (m_vecMaxs[1] < 0.0)
	// 	m_vecMaxs[1] *= -1.0;
	// m_vecMaxs[2] = m_vecMaxs[2] - fOrigin[2];
	// if (m_vecMaxs[2] < 0.0)
	// 	m_vecMaxs[2] *= -1.0;

	// SetEntPropVector(zone, Prop_Send, "m_vecMins", m_vecMins);
	// SetEntPropVector(zone, Prop_Send, "m_vecMaxs", m_vecMaxs);

	// SetEntProp(zone, Prop_Send, "m_usSolidFlags",  152);

	// int filter = CreateEntityByName("filter_activator_team");
	// PrintToChatAll("IsValidEntity(filter) - %d filter_activator_team - %d", IsValidEntity(filter), filter);

	return Plugin_Handled;
}