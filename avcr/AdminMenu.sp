// public void OnLibraryAdded(const char[] szLibraryName)
// {
// 	if (strcmp(szLibraryName, "adminmenu") == 0)
// 	{
// 		TopMenu hTopMenu = GetAdminTopMenu();
// 		if (hTopMenu != null)
// 		{
// 			OnAdminMenuReady(hTopMenu);
// 		}
// 	}
// }

// public void OnLibraryRemoved(const char[] sName)
// {
// 	if (StrEqual(sName, "adminmenu"))
// 	{
// 		g_hTopMenu = null;
// 		AdminMenuObject = INVALID_TOPMENUOBJECT;
// 	}
// }

// public void OnAdminMenuReady(Handle aTopMenu)
// {
// 	TopMenu hTopMenu = TopMenu.FromHandle(aTopMenu);

// 	if (hTopMenu == g_hTopMenu) 
//     {
//         return;
//     }

// 	g_hTopMenu = hTopMenu;

	

// 	AddItemsToTopMenu();

// 	CreateTypeWeaponMenu();
// 	CreateWeaponMenu();
// 	CreatePistolMenu();
// 	CreateSetSettings();
// 	CreateNewWeaponsMenu();
// 	CreateChoiceGrenadeMenu();

// 	ChoiceTypeGameMenu();
// 	CreateSetRoundMenu();
// }

// void AddItemsToTopMenu()
// {
// 	if (AdminMenuObject == INVALID_TOPMENUOBJECT)
// 	{
// 		AdminMenuObject = g_hTopMenu.AddCategory("avcr_category", Handler_MenuAVCR, "avcr", ADMFLAG_UNBAN, "Управление оружейными раундами");
// 	}

// 	g_hTopMenu.AddItem("avcr_start", Handler_MenuAVCR_Start, AdminMenuObject, "avcr", ADMFLAG_UNBAN, "Начать оружейный раунд");
// 	g_hTopMenu.AddItem("avcr_info", Handler_MenuAVCR_Info, AdminMenuObject, "avcr", ADMFLAG_UNBAN, "Информация");
// 	g_hTopMenu.AddItem("avcr_refreshcd", Handler_MenuAVCR_RefreshCoolDown, AdminMenuObject, "avcr", ADMFLAG_ROOT, "Сброс КД");
// }
