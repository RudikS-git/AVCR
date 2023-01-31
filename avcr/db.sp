public void ConnectCallBack (Database hDB, const char[] szError, any data)
{
    if (hDB == null || szError[0])
    {
        SetFailState("Database failure: %s", szError);
        return;
    }

    g_hDatabase = hDB;
    CreateTables();
}

void CreateTables()
{
    SQL_LockDatabase(g_hDatabase);

    g_hDatabase.Query(SQL_Callback_CheckError,	"CREATE TABLE IF NOT EXISTS `custom_round_set` (\
                                                            `id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,\
                                                            `auth` INTEGER(11) NOT NULL,\
                                                            `name_set` VARCHAR(64) NOT NULL default '',\
                                                            `type_custom_game` INTEGER UNSIGNED NOT NULL default '0',\
                                                            `is_tooled` INTEGER UNSIGNED NOT NULL default '0',\
                                                            `is_props` INTEGER UNSIGNED NOT NULL,\
                                                            `current_weapon` VARCHAR(64) NOT NULL default '',\
                                                            `name_weapon` VARCHAR(64) NOT NULL default '',\
                                                            `speed` INTEGER UNSIGNED NOT NULL default '0',\
                                                            `armor` INTEGER UNSIGNED NOT NULL default '0', \
                                                            `is_hs_mode` INTEGER UNSIGNED NOT NULL default '0',\
                                                            `is_gravity` INTEGER UNSIGNED NOT NULL default '0',\
                                                            `is_knife` INTEGER UNSIGNED NOT NULL default '0',\
                                                            `is_mod_queue` INTEGER UNSIGNED NOT NULL default '0',\
                                                            `is_knife_damage` INTEGER UNSIGNED NOT NULL default '0');");
                                                            //FOREIGN KEY (`auth`) REFERENCES `vip_users` (`id`) ON DELETE CASCADE
    SQL_UnlockDatabase(g_hDatabase);

    g_hDatabase.SetCharset("utf8");
}

public void SQL_Callback_CheckError(Database hDatabase, DBResultSet results, const char[] szError, any data)
{
    if(szError[0])
    {
        LogError("SQL_Callback_CheckError: %s", szError);
    }
}

public void Db_OnClientPostAdminCheck(int iClient)
{
    if(!IsFakeClient(iClient))
    {
        /*char szQuery[256];
        int accountId = GetSteamAccountID(iClient);

        FormatEx(szQuery, sizeof(szQuery), "SELECT * FROM `custom_round_set` AS CRS \
                                            JOIN `vip_users` AS VU \
                                            ON CRS.auth = VU.id \
                                            WHERE VU.account_id = '%d';", accountId);

        g_hDatabase.Query(SQL_Callback_SelectClient, szQuery, GetClientUserId(iClient));*/
    }
}

public void SQL_Callback_SelectClient(Database hDatabase, DBResultSet hResults, const char[] sError, any iUserID)
{
    if(sError[0])
    {
        LogError("SQL_Callback_SelectClient: %s", sError);
        return;
    }

    int iClient = GetClientOfUserId(iUserID);
    if(iClient)
    {
        char szQuery[256];

        //g_hDatabase.Escape(szQuery, szName, sizeof(szName)); // Экранируем запрещенные символы в имени

        if(hResults.FetchRow())	// Игрок есть в базе
        {
            CustomRound customRound;

            char name[64];
            hResults.FetchString(2, name, sizeof(name));

            customRound.typeCustomGame =  hResults.FetchInt(3);
            customRound.IsTooled =  !!hResults.FetchInt(4);
            customRound.g_bProps =  !!hResults.FetchInt(5);

            hResults.FetchString(6, customRound.sCurrentWeapon, 64);
            hResults.FetchString(7, customRound.sNameCurWeapon, 64);

            customRound.g_iSetSpeed = hResults.FetchInt(8);
            customRound.g_iSetArmor = hResults.FetchInt(9);

            customRound.g_bSetHsMode =  !!hResults.FetchInt(10);
            customRound.g_bGravity =  !!hResults.FetchInt(11);
            customRound.g_bKnife =  !!hResults.FetchInt(12);
            customRound.g_bModQueue =  !!hResults.FetchInt(13);
            customRound.g_bKnifeDamage =  !!hResults.FetchInt(14);


        }
    }
}

public void GetCustomRound(int id, int iClient)
{
    char szQuery[256];
    int accountId = GetSteamAccountID(iClient);

    FormatEx(szQuery, sizeof(szQuery), "SELECT * FROM `custom_round_set` \
                                        WHERE `id` = '%d';", id);


    g_hDatabase.Query(SQL_Callback_GetCustomRound, szQuery, GetClientUserId(iClient));
}

public void SQL_Callback_GetCustomRound(Database hDatabase, DBResultSet hResults, const char[] sError, any userId)
{
    if(sError[0])
    {
        LogError("SQL_Callback_SelectClient: %s", sError);
        return;
    }
    
    int iClient = GetClientOfUserId(userId);
    if(iClient)
    {
        char szQuery[256];

        //g_hDatabase.Escape(szQuery, szName, sizeof(szName)); // Экранируем запрещенные символы в имени

        if(hResults.FetchRow())	// Игрок есть в базе
        {
            CustomRound customRound;

            char name[64];
            hResults.FetchString(2, name, sizeof(name));

            customRound.typeCustomGame =  hResults.FetchInt(3);
            customRound.IsTooled =  !!hResults.FetchInt(4);
            customRound.g_bProps =  !!hResults.FetchInt(5);

            hResults.FetchString(6, customRound.sCurrentWeapon, 64);
            hResults.FetchString(7, customRound.sNameCurWeapon, 64);

            customRound.g_iSetSpeed = hResults.FetchInt(8);
            customRound.g_iSetArmor = hResults.FetchInt(9);

            customRound.g_bSetHsMode =  !!hResults.FetchInt(10);
            customRound.g_bGravity =  !!hResults.FetchInt(11);
            customRound.g_bKnife =  !!hResults.FetchInt(12);
            customRound.g_bModQueue =  !!hResults.FetchInt(13);
            customRound.g_bKnifeDamage =  !!hResults.FetchInt(14);


            for(int i = 0; i < COUNT_ROUNDS; i++)
            {
                Copy(pCustomRound[iClient][i], customRound);
            }

            CreateSetRoundMenu(Handler_MenuAvcr_ChoiceNumRounds_Set).Display(iClient, 15);
        }
    }    
}

public void SaveSetsDb(int iClient, CustomRound customRound, char [] name)
{
    char szQuery[512];
    int accountId = GetSteamAccountID(iClient);

    char szEscapedName [256];
    g_hDatabase.Escape(name, szEscapedName, sizeof(szEscapedName));

    FormatEx(szQuery, sizeof(szQuery), "INSERT `custom_round_set`(auth, name_set, type_custom_game, is_tooled, is_props, current_weapon, name_weapon, speed, armor, is_hs_mode, is_gravity, is_knife, is_mod_queue, is_knife_damage) \
                                        VALUES(%d, '%s', %d, %d, %d, '%s', '%s', %d, %d, %d, %d, %d, %d, %d);", 
                                        accountId,
                                        szEscapedName,
                                        customRound.typeCustomGame,
                                        customRound.IsTooled,
                                        customRound.g_bProps,
                                        customRound.sCurrentWeapon,
                                        customRound.sNameCurWeapon,
                                        customRound.g_iSetSpeed,
                                        customRound.g_iSetArmor,
                                        customRound.g_bSetHsMode,
                                        customRound.g_bGravity,
                                        customRound.g_bKnife,
                                        customRound.g_bModQueue,
                                        customRound.g_bKnifeDamage);           

    name[0] = '\0';

    g_hDatabase.Query(SQL_Callback_SaveSetClient, szQuery, GetClientUserId(iClient));
}

public void SQL_Callback_SaveSetClient(Database hDatabase, DBResultSet hResults, const char[] sError, any iUserID)
{
    if(sError[0])
    {
        LogError("SQL_Callback_SelectClient: %s", sError);
        return;
    }

    int iClient = GetClientOfUserId(iUserID);
    if(iClient)
    {
        PrintToChat(iClient, "Set был успешно добавлен");
    }
}

public void CreateDisplaySetsMenuDb(int iClient)
{
    char szQuery[256];
    int accountId = GetSteamAccountID(iClient);

    FormatEx(szQuery, sizeof(szQuery), "SELECT `name_set`, `id` FROM `custom_round_set` \
                                        WHERE `auth` = '%d';", accountId);

                                        // JOIN `vip_users` AS VU
                                        // ON CRS.auth = VU.id

    g_hDatabase.Query(SQL_Callback_SetNamesClient, szQuery, GetClientUserId(iClient));
}

public void SQL_Callback_SetNamesClient(Database hDatabase, DBResultSet hResults, const char[] sError, any iUserID)
{
    if(sError[0])
    {
        LogError("SQL_Callback_SelectClient: %s", sError);
        return;
    }

    int iClient = GetClientOfUserId(iUserID);
    if(iClient)
    {
        char szQuery[256];
        char name[MAX_SETS][64];
        int id[MAX_SETS];

        for(int i = 0; i < MAX_SETS; i++)
        {
            if(hResults.FetchRow())
            {
                hResults.FetchString(0, name[i], 64);
                id[i] = hResults.FetchInt(1);
            }

        }

        CreateSetsMenu(iClient, name, id, hResults.RowCount).Display(iClient, 15);
    }
}

public void DeleteSet(int id, int iClient)
{
    char szQuery[256];
    int accountId = GetSteamAccountID(iClient);
    FormatEx(szQuery, sizeof(szQuery), "DELETE FROM `custom_round_set` \
                                        WHERE `id` = '%d';", id);

    g_hDatabase.Query(SQL_Callback_SetId, szQuery, GetClientUserId(iClient));
}

public void SQL_Callback_SetId(Database hDatabase, DBResultSet hResults, const char[] sError, any iUserID)
{
    int iClient = GetClientOfUserId(iUserID);
    if(iClient)
    {
        PrintToChat(iClient, "Set успешно удален");
    }
}