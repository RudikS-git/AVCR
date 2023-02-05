public Menu CreateCrAdminMenu()
{
    Menu g_CrAdminMenu = new Menu(Handler_CrAdminMenu);

    g_CrAdminMenu.SetTitle("Управление оружейными раундами:\n");
    g_CrAdminMenu.AddItem("", "Начать оружейный раунд");
    g_CrAdminMenu.AddItem("", "Начать оружейный раунд(без голосования)");
    g_CrAdminMenu.AddItem("", "Информация");
    g_CrAdminMenu.AddItem("", "Сброс КД");
    g_CrAdminMenu.AddItem("", "Сеты");

    g_CrAdminMenu.ExitButton = true;

    return g_CrAdminMenu;
}

public Menu ChoiceTypeGameMenu()
{
    Menu g_ChoiceTypeGame = new Menu(Handler_MenuChoiceTypeGame);

    g_ChoiceTypeGame.SetTitle("Выберите режим игры:\n");
    g_ChoiceTypeGame.AddItem("", "На оружиях");
    g_ChoiceTypeGame.AddItem("", "NoScope");
    g_ChoiceTypeGame.AddItem("", "WallHack");
    g_ChoiceTypeGame.AddItem("", "BombMan(NEW)");
    g_ChoiceTypeGame.AddItem("", "Телепорташки");
    g_ChoiceTypeGame.AddItem("", "Царь горы");
    g_ChoiceTypeGame.AddItem("", "Арена");
    g_ChoiceTypeGame.AddItem("", "AWP+DEAGLE (неиграбельно)", ITEMDRAW_DISABLED); // g_bDeagleRestrict? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED
    g_ChoiceTypeGame.AddItem("", "Догонялки");
    g_ChoiceTypeGame.AddItem("", "LongJump + BHOP");
    g_ChoiceTypeGame.AddItem("", "На ножах");
    g_ChoiceTypeGame.AddItem("", "Куриная бойня");
    g_ChoiceTypeGame.AddItem("", "Битва на гранатах");
    g_ChoiceTypeGame.AddItem("", "Стенка на стенку");
    g_ChoiceTypeGame.AddItem("", "Поебень (неиграбельно)", ITEMDRAW_DISABLED);
    g_ChoiceTypeGame.ExitBackButton = true;
    g_ChoiceTypeGame.ExitButton = false;

    return g_ChoiceTypeGame; 
}

public Menu CreateRoundSettingsMenu(iClient)
{
    Menu g_SettingsRound = new Menu(Handler_MenuRoundSettings);

    g_SettingsRound.SetTitle("Настройка раунда:\n");

    if(!SettingSet_Name[iClient][0])
    {
        g_SettingsRound.AddItem("", "Выбрать рандомно");
        g_SettingsRound.AddItem("", "Поставить на все раунды");
    }

    char sBuf[128];

    for(int i = 0; i < piCountRound[iClient]; i++)
    {
        if(pCustomRound[iClient][i].IsTooled)
        {
            FormatEx(sBuf, sizeof(sBuf), "Настройка %d раунда [✓]", i + 1);
        }
        else
        {
            FormatEx(sBuf, sizeof(sBuf), "Настройка %d раунда [ ]", i + 1);
        }

        g_SettingsRound.AddItem("", sBuf);
    }

    if(!SettingSet_Name[iClient][0])
    {
        if(CheckTooled(iClient))
        {
            g_SettingsRound.AddItem("", "Начать голосование", ITEMDRAW_CONTROL);
        }
        else
        {
            g_SettingsRound.AddItem("", "Начать голосование", ITEMDRAW_DISABLED);
        }
    }
    else
    {
        g_SettingsRound.AddItem("", "Ваш сет будет сохранен даже после перезахода", ITEMDRAW_DISABLED);
        g_SettingsRound.AddItem("", "Сеты будут доступны на всех серверах проекта", ITEMDRAW_DISABLED);
        g_SettingsRound.AddItem("", "Сохранить сет", ITEMDRAW_CONTROL);
    }

    g_SettingsRound.ExitBackButton = true;
    g_SettingsRound.ExitButton = false;

    return g_SettingsRound;
}

bool CheckTooled(int iClient)
{
    for(int i = 0; i < piCountRound[iClient]; i++)
    {
        if(pCustomRound[iClient][i].IsTooled == false)
        {
            return false;
        }
    }

    return true;
}

public void CreateVotePanel(int iClient, char [] sBuf)
{
	Panel panel = new Panel();
	panel.CurrentKey = yes;
	panel.DrawItem("Да");

	panel.CurrentKey = no;
	panel.DrawItem("Нет");

	panel.SetTitle(sBuf);
	panel.Send(iClient, MS_VotePanel, 8);

	delete panel;
}

public void CreatePanelInfo(int iClient)
{
    Panel panel = new Panel();
    panel.SetTitle("Информация:\n");
    panel.DrawText("Автор плагина: RudikS");
    
    char sbuf[32];
    panel.DrawText(sbuf);
    panel.DrawText("Задержка между включениями раундов составляет 10 минут");
    panel.DrawText("P.S Не забывайте, что в меню есть кнопка перейти на следующую страницу!\n");
    panel.DrawItem("Закрыть");
    panel.CurrentKey = 9;
    panel.Send(iClient, PanelEmpty, 0);
}

public void CreatePanelSetInfo(int iClient)
{
    Panel panel = new Panel();
    panel.SetTitle("Создание сета:\n");

    panel.DrawText("Введите в чат название сета (не более 32 символов), \nнапример: 'ak47 only hs'\n\n\n ");
    //panel.DrawItem("Закрыть");
    //panel.CurrentKey = 9;
    panel.Send(iClient, PanelEmpty, 0);
}

public Menu CreateTypeWeaponMenu()
{
    Menu g_STWeaponMenu = new Menu(MenuHandler_SetTypeWeapon);
    g_STWeaponMenu.SetTitle("Выберите оружие на котором хотите провести раунд:\n");
    g_STWeaponMenu.AddItem("", "Основное");
    g_STWeaponMenu.AddItem("", "Пистолеты");
    g_STWeaponMenu.ExitBackButton = true;
    g_STWeaponMenu.ExitButton = false;

    return g_STWeaponMenu;
}

public Menu CreateWeaponMenu()
{
    Menu g_PrimaryMenu = new Menu(MenuHandler_SettingsSet);
    g_PrimaryMenu.SetTitle("Выберите оружие:\n");
    g_PrimaryMenu.ExitBackButton = true;
    g_PrimaryMenu.ExitButton = false;
	
    for(int j = 0; j < sizeof(sWeapon); j++)
    {
        g_PrimaryMenu.AddItem(sWeapon[j], sNameWeapon[j]);
    }

    return g_PrimaryMenu;
}

public Menu CreatePistolMenu()
{
    Menu g_PistolMenu = new Menu(MenuHandler_SettingsSet);
    g_PistolMenu.SetTitle("Выберите пистолет:\n");
    g_PistolMenu.ExitBackButton = true;
    g_PistolMenu.ExitButton = false;
	
    for(int i = 0; i< sizeof(sPistol); i++)
    {
        g_PistolMenu.AddItem(sPistol[i], sNamePistol[i]);
    }

    return g_PistolMenu;
}

public Menu CreateSetSettings()
{
    Menu g_SetSettings = new Menu(MenuSetRounds);
    g_SetSettings.ExitBackButton = true;
    g_SetSettings.ExitButton = false;

    return g_SetSettings;
}

public Menu CreateSetRoundMenu(const MenuHandler menuHandler)
{//Handler_MenuAvcr_ChoiceNumRounds
    Menu g_NumRoundMenu = new Menu(menuHandler);
    g_NumRoundMenu.SetTitle("Выберите кол-во раундов:\n");
    g_NumRoundMenu.AddItem("", "1 раунд");
    g_NumRoundMenu.AddItem("", "2 раунда");
    g_NumRoundMenu.AddItem("", "3 раунда");
    g_NumRoundMenu.ExitBackButton = true;
    g_NumRoundMenu.ExitButton = false;

    return g_NumRoundMenu;
}

public Menu CreateNewWeaponsMenu()
{
    Menu g_NewWeaponsMenu = new Menu(Handler_MenuAVCR_WallFists);
    g_NewWeaponsMenu.SetTitle("Выберите оружие:\n");

    for(int i = 0; i< sizeof(sSpecialWeapons); i++)
    {
        g_NewWeaponsMenu.AddItem(sSpecialWeapons[i], sSpecialWeapons[i]);
    }
    
    g_NewWeaponsMenu.ExitBackButton = true;
    g_NewWeaponsMenu.ExitButton = false;

    return g_NewWeaponsMenu;
}

public Menu CreateChoiceGrenadeMenu()
{
    Menu g_ChoiseGrenade = new Menu(Handler_MenuAVCR_GrenadeChoice);
    g_ChoiseGrenade.SetTitle("Выберите тип гранаты:\n");

    for(int i = 0; i< sizeof(sGrenades); i++)
    {
        g_ChoiseGrenade.AddItem(sGrenades[i], sGrenades[i]);
    }
    
    g_ChoiseGrenade.ExitBackButton = true;
    g_ChoiseGrenade.ExitButton = false;

    return g_ChoiseGrenade;
}

public Menu CreateSetsMenu(int iClient, char [][] name, int[] id, int count)
{
    Menu setsMenu = new Menu(Handler_MenuAvcr_Sets);
    setsMenu.SetTitle("Сеты кастомных раундов:\n");

    if(count == MAX_SETS)
    {
        setsMenu.AddItem("", "Добавить (превышен лимит сетов)\n ", ITEMDRAW_DISABLED);
    }
    else
    {
        setsMenu.AddItem("", "Добавить\n ");
    }
    
    for(int i = 0; i < count; i++)
    {
        char ident[11];
        IntToString(id[i], ident, sizeof(ident));
        setsMenu.AddItem(ident, name[i]);
    }

    setsMenu.ExitBackButton = true;
    setsMenu.ExitButton = true;

    return setsMenu;
}

public Menu CreateManageSet(int id)
{
    char infoBuf[64];
    IntToString(id, infoBuf, sizeof(infoBuf));

    Menu menu = new Menu(Handler_Set_Manage);
    menu.SetTitle("Управление сетом:\n");
    menu.AddItem(infoBuf, "Поставить \n ");
    menu.AddItem(infoBuf, "Удалить");
    
    menu.ExitBackButton = true;
    menu.ExitButton = false;

    return menu;
}
