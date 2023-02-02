// public void Handler_MenuAVCR(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
// {
//     switch (action)
//     {
//         // Когда категория отображается пунктом на главной странице админ-меню
//     	case TopMenuAction_DisplayOption:
//         {
//             FormatEx(sBuffer, maxlength, "Управление оружейными раундами");
//         }
//         // Когда категория отображается заглавием меню
//     	case TopMenuAction_DisplayTitle:
//         {
//             FormatEx(sBuffer, maxlength, "Раунд(ы) на оружиях");
//         }
//     }
// }



// public void Handler_MenuAVCR_Start(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char [] sBuffer, int maxlength)
// {
// 	switch(action)
// 	{
// 		case TopMenuAction_DisplayOption:
// 		{
// 			FormatEx(sBuffer, maxlength, "Начать создание оружейного раунда");
// 		}
// 		case TopMenuAction_SelectOption:
// 		{
// 			if(!bNewVote && !g_iAdminChoses)
// 			{
// 				g_NumRoundMenu.Display(iClient, 15);
// 				g_iAdminChoses = iClient;
// 			}
// 			else if(g_iAdminChoses) 
// 			{
// 				CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] На данный момент другой {PURPLE}администратор {DEFAULT}проводит создание {PURPLE}Custom Rounds");
// 			}
// 			else if(bNewVote) 
// 			{
// 				//int timeLeft;
// 				//GetMapTimeLeft(timeLeft);

// 				//if(timeLeft <= 60)
// 				//{
// 				//	CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] До окончания игры осталось {PURPLE}%d {DEFAULT}секунд. Дождитесь обнуления и повторите попытку!", timeLeft);
// 				//	return;
// 				//}

// 				int curTime = GetTime();

// 				if(curTime > timeCD)
// 				{
// 					CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Кастомный раунд уже поставлен! Дождитесь окончания для того чтобы узнать время до нового.");
// 				}
// 				else
// 				{
// 					int _timeCD = timeCD - curTime;
// 					CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Следующее голосование возможно через {PURPLE}%d мин. %02d сек.", _timeCD / 60, _timeCD % 60);
// 				}
// 			}
// 		}
// 	}
// }


// public void Handler_MenuAVCR_Info(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char [] sBuffer, int maxlength)
// {
// 	switch(action)
// 	{
// 		case TopMenuAction_DisplayOption:
// 		{
// 			FormatEx(sBuffer, maxlength, "Информация");
// 		}
// 		case TopMenuAction_SelectOption:
// 		{
// 			CreatePanelInfo(iClient);
		
// 		}
// 	}
// }

// public void Handler_MenuAVCR_RefreshCoolDown(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char [] sBuffer, int maxlength)
// {
// 	switch(action)
// 	{
// 		case TopMenuAction_DisplayOption:
// 		{
// 			FormatEx(sBuffer, maxlength, "Сброс КД");
// 		}
// 		case TopMenuAction_SelectOption:
// 		{
// 			if(g_hTimer != null)
// 			{
// 				delete g_hTimer;
// 				g_hTimer = null;
// 				bNewVote = false;
// 				CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] КД сбросилось, можно начинать новый кастомный раунд!");
// 			}
// 			else CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Ошибка! Не удалось найти ограничение для установки кастомного раунда");
		
// 		}
// 	}
// }


public int Handler_CrAdminMenu(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(Item)
			{
				case 0:
				{
					if(!bNewVote && !g_iAdminChoses)
					{
						CreateSetRoundMenu(Handler_MenuAvcr_ChoiceNumRounds).Display(iClient, 15);
						g_iAdminChoses = iClient;
					}
					else if(g_iAdminChoses) 
					{
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] На данный момент другой {PURPLE}администратор {DEFAULT}проводит создание {PURPLE}Custom Rounds");
					}
					else if(bNewVote) 
					{
						//int timeLeft;
						//GetMapTimeLeft(timeLeft);

						//if(timeLeft <= 60)
						//{
						//	CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] До окончания игры осталось {PURPLE}%d {DEFAULT}секунд. Дождитесь обнуления и повторите попытку!", timeLeft);
						//	return;
						//}
						WithVoting = true;
						int curTime = GetTime();

						if(curTime > timeCD)
						{
							CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Кастомный раунд уже поставлен! Дождитесь окончания для того чтобы узнать время до нового.");
						}
						else
						{
							int _timeCD = timeCD - curTime;
							CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Следующее голосование возможно через {PURPLE}%d мин. %02d сек.", _timeCD / 60, _timeCD % 60);
						}
					}
				}

				case 1:
				{
					AdminId admin = GetUserAdmin(iClient);
					if(admin == INVALID_ADMIN_ID || !GetAdminFlag(admin, Admin_Root))
					{
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Нету доступа");
						return;
					}

					if(!bNewVote && !g_iAdminChoses)
					{
						WithVoting = false;

						CreateSetRoundMenu(Handler_MenuAvcr_ChoiceNumRounds).Display(iClient, 15);
						g_iAdminChoses = iClient;
					}
					else if(g_iAdminChoses) 
					{
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] На данный момент другой {PURPLE}администратор {DEFAULT}проводит создание {PURPLE}Custom Rounds");
					}
					else if(bNewVote)
					{
						int curTime = GetTime();

						if(curTime > timeCD)
						{
							CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Кастомный раунд уже поставлен! Дождитесь окончания для того чтобы узнать время до нового.");
						}
						else
						{
							int _timeCD = timeCD - curTime;
							CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Следующий кастомный раунд возможен через {PURPLE}%d мин. %02d сек.", _timeCD / 60, _timeCD % 60);
						}
					}
				}

				case 2:
				{
					CreatePanelInfo(iClient);
				}

				case 3:
				{
					AdminId admin = GetUserAdmin(iClient);
					if(admin != INVALID_ADMIN_ID && GetAdminFlag(admin, Admin_Root) || GetAdminFlag(admin, Admin_Custom1))
					{
						int currentTime = GetTime();
						int dtime = currentTime - lastDischargeTime;
					//	PrintToChatAll("currentTime - %d", currentTime);
					//	PrintToChatAll("lastDischargeTime - %d", lastDischargeTime);
					//	PrintToChatAll("dtime =  %d", dtime);
					//	PrintToChatAll("dischargeCount =  %d", dtime);

						if(dtime > 3600 && dischargeCount == 0)
						{
							dischargeCount = DISCHARGE_COUNT;
						}

						if(dischargeCount != 0)
						{
							if(g_hTimer != null)
							{
								if(dischargeCount == 1)
								{
									lastDischargeTime = currentTime;
								}

								delete g_hTimer;
								bNewVote = false;
								dischargeCount--;
								CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] КД сброшен! Осталось %d раз(а)", dischargeCount);
								CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] %N сбросил КД кастомных раундов!", iClient);
							}
							else CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Ошибка! Не удалось найти ограничение для установки кастомного раунда");
						}
						else CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Кол-во попыток исчерпано за час. Осталось %d сек", 3600 - dtime);
					}
					else
					{
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Нету доступа");
					}
				}

				case 4:
				{
					CreateDisplaySetsMenuDb(iClient);
				}
			}
			
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int PanelEmpty(Menu panel, MenuAction action, int iClient, int item) 
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(item == 9)
			{
				panel.Cancel();
			
			}
		}

		case MenuAction_End:
		{
			delete panel;
		}
	}
}

public int Handler_MenuAvcr_ChoiceNumRounds(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{	
			piCountRound[iClient] = Item + 1;
			
			CreateRoundSettingsMenu(iClient).Display(iClient, 0)
		}

		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				CreateCrAdminMenu().Display(iClient, 0);
			}

			ResetCR(pCustomRound[iClient]);
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int Handler_MenuRoundSettings(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(Item == 0)
			{
				GetRandomModes(pCustomRound[iClient], piCountRound[iClient]);
				CreateRoundSettingsMenu(iClient).Display(iClient, 0);
			}
			else if(Item == 1)
			{
				numRound = 0;
				g_bIsSameRounds = true;

				ChoiceTypeGameMenu().Display(iClient, 15);
			}
			else if(Item == piCountRound[iClient] + 2)
			{
				if(SettingSet_Name[iClient][0]) // УСТАНОВКА СЕТА, А НЕ КАСТОМНОГО РАУНДА!
				{
					SaveSetsDb(iClient, pCustomRound[iClient][0], SettingSet_Name[iClient]);

					return;
				}



				if(!IsNewVoteAllowed())
				{
					CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] На данный момент голосование {PURPLE}запрещено{DEFAULT}!");
					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				PlayerCrToCommonCr(iClient);

				if(!WithVoting)
				{
					CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Администратор запустил Custom Rounds {PURPLE}без {DEFAULT}голосования!");
					WithVoting = true;
					g_iAdminChoses = 0;
					preVote = true;		
					bNewVote = true;		
					iHSMODE = hs_mode.IntValue;
					iFreezeTime = mp_freezetime.IntValue;
					GetMapTimeLeft(g_iRemainderTimeLeft);
					// ExtendMapTimeLimit(50000);
					CS_TerminateRound(0.1, CSRoundEnd_Draw);

					ResetCR(pCustomRound[iClient]);

					return;
				}

				CreateVoteWithMessage(iClient);

				ResetCR(pCustomRound[iClient]);

				hVoteTimer = CreateTimer(10.0, VoteEnd, _, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				numRound = Item - 2;
				g_bIsSameRounds = false;

				ChoiceTypeGameMenu().Display(iClient, 15);
			}
		}
		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				CreateSetRoundMenu(Handler_MenuAvcr_ChoiceNumRounds).Display(iClient, 15);
			}

			ResetCR(pCustomRound[iClient])
		}
		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int Handler_MenuChoiceTypeGame(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(Item)
			{
				case 0:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							pCustomRound[iClient][i].typeCustomGame = OtherWeapons;
						}
					}
					else
					{
						pCustomRound[iClient][numRound].typeCustomGame = OtherWeapons;
					}

					CreateTypeWeaponMenu().Display(iClient, 15);
				}

				case 1:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetNoScopeMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetNoScopeMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 2:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetWallHackMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetWallHackMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 3:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetBombManMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetBombManMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 4:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetTeleportersMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetTeleportersMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 5:
				{
					if(GetClientCount(true) < 3)
					{
						ChoiceTypeGameMenu().Display(iClient, 15);
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] На сервере должно находится более {PURPLE}2 {DEFAULT}человек, чтобы включить данный режим!");
						return;
					}

					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetKingOfTheHill(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetKingOfTheHill(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 6:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetArenaMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetArenaMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateTypeWeaponMenu().Display(iClient, 15);
				}

				case 7:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetDeagleMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetDeagleMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 8:
				{
					if(GetClientCount(true) < 3)
					{
						ChoiceTypeGameMenu().Display(iClient, 15);
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] На сервере должно находится более {PURPLE}2 {DEFAULT}человек, чтобы включить данный режим!");
						return;
					}

					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetCatchUpMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetCatchUpMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 9:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetLongJumpMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetLongJumpMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 10:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetOnlyKnifeMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetOnlyKnifeMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					
					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}

				case 11:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetChickenWarMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetChickenWarMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateTypeWeaponMenu().Display(iClient, 15);
				}

				case 12:
				{
					CreateChoiceGrenadeMenu().Display(iClient, 15);
				}

				case 13:
				{
					CreateNewWeaponsMenu().Display(iClient, 15);
				}

				case 14:
				{
					if(g_bIsSameRounds)
					{
						for(int i = 0; i < piCountRound[iClient]; i++)
						{
							SetPoebenMode(pCustomRound[iClient], i);
							pCustomRound[iClient][i].IsTooled = true;
						}
					}
					else
					{
						SetPoebenMode(pCustomRound[iClient], numRound);
						pCustomRound[iClient][numRound].IsTooled = true;
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}
			}
		}
		case MenuAction_Cancel:
		{
			ResetCR(pCustomRound[iClient])

			if(MenuCancel_ExitBack == Item)
			{
				CreateRoundSettingsMenu(iClient).Display(iClient, 15);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int Handler_MenuAVCR_WallFists(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sBuf [64];
			hMenu.GetItem(Item, sBuf, sizeof(sBuf));
			
			if(g_bIsSameRounds)
			{
				for(int i = 0; i < piCountRound[iClient]; i++)
				{
					SetWallFistsMode(pCustomRound[iClient], i, sBuf);
					pCustomRound[iClient][i].IsTooled = true;
				}
			}
			else
			{
				SetWallFistsMode(pCustomRound[iClient], numRound, sBuf);
				pCustomRound[iClient][numRound].IsTooled = true;
			}

			CreateRoundSettingsMenu(iClient).Display(iClient, 15);

		}
		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				CreateRoundSettingsMenu(iClient).Display(iClient, 15);
			}

			ResetCR(pCustomRound[iClient])
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int Handler_MenuAVCR_GrenadeChoice(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sBuf [64];
			hMenu.GetItem(Item, sBuf, sizeof(sBuf));

			if(g_bIsSameRounds)
			{
				for(int i = 0; i < piCountRound[iClient]; i++)
				{
					SetGrenadeWarMode(pCustomRound[iClient], i, sBuf);
					pCustomRound[iClient][i].IsTooled = true;
				}
			}
			else
			{
				SetGrenadeWarMode(pCustomRound[iClient], numRound, sBuf);
				pCustomRound[iClient][numRound].IsTooled = true;
			}

			CreateRoundSettingsMenu(iClient).Display(iClient, 15);

		}
		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				CreateRoundSettingsMenu(iClient).Display(iClient, 15);
			}

			ResetCR(pCustomRound[iClient])
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int MenuHandler_SetTypeWeapon(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(Item)
			{
				case 0:
				{
					CreateWeaponMenu().Display(iClient, 15);
				}
				case 1:
				{
					CreatePistolMenu().Display(iClient, 15);
				}
			}
		}
		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				ChoiceTypeGameMenu().Display(iClient, 15);
			}

			ResetCR(pCustomRound[iClient])
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int MenuHandler_SettingsSet(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sBuf [64];
			char dsBUF [2][64];
			hMenu.GetItem(Item, sBuf, sizeof(sBuf));
			ExplodeString(sBuf, "_", dsBUF, 2, 64, false)

			strcopy(pCustomRound[iClient][numRound].sCurrentWeapon, LENGTH_WEAPON, sBuf);
			strcopy(pCustomRound[iClient][numRound].sNameCurWeapon, LENGTH_WEAPON, dsBUF[1]);
				
			//g_SetSettings.RemoveAllItems();

			Menu setSettings = CreateSetSettings();
			setSettings.SetTitle("Выберите настройки:\n");
			setSettings.AddItem("n", "Включить Только в голову []", pCustomRound[iClient][numRound].typeCustomGame == ChickenWar? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
			setSettings.AddItem("n", "Броня [Нету]");
			setSettings.AddItem("n", "Скорость [Стандарт]", pCustomRound[iClient][numRound].typeCustomGame == Arena? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
			setSettings.AddItem("n", "Прыжки [Стандарт]", pCustomRound[iClient][numRound].typeCustomGame == Arena? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
			setSettings.AddItem("n", "Нож [Нету]\n \n");
			setSettings.AddItem("", "Далее", ITEMDRAW_CONTROL);
	
			setSettings.Display(iClient, 15);
		}
		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				CreateTypeWeaponMenu().Display(iClient, 15);
			}
			else
			{
				ResetCR(pCustomRound[iClient])
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int MenuSetRounds(Menu hMenu, MenuAction action, int iClient, int Item)
{
	char sBuf[32];

	switch(action)
	{
		case MenuAction_Select:
		{
			Menu menu;
			if(Item != 8) // BAD :(
			{
				menu = CloneMenuSettings(hMenu);
				menu.GetItem(Item, sBuf, sizeof(sBuf));
				menu.RemoveItem(Item);
			}

			switch(Item)
			{
				case 0:
				{
					if(sBuf[0] == 'n')
					{
						menu.InsertItem(Item, "y", "Включить Только в голову [✓]")
						pCustomRound[iClient][numRound].g_bSetHsMode = true;
					}
					else
					{
						menu.InsertItem(Item, "n", "Включить Только в голову []")
						pCustomRound[iClient][numRound].g_bSetHsMode = false;
					}
				
					menu.Display(iClient, 15);
				}
				case 1:
				{
					if(sBuf[0] == 'n')
					{
						menu.InsertItem(Item, "k", "Броня [Без шлема]")
						pCustomRound[iClient][numRound].g_iSetArmor = 1;
					}
					else if(sBuf[0] == 'k')
					{
						menu.InsertItem(Item, "h", "Броня [Полная]")
						pCustomRound[iClient][numRound].g_iSetArmor = 2;
					}
					else
					{
						menu.InsertItem(Item, "n", "Броня [Нету]")
						pCustomRound[iClient][numRound].g_iSetArmor = 0;
					}

					menu.Display(iClient, 15);
				}
				case 2:
				{
					if(sBuf[0] == 'n')
					{
						menu.InsertItem(Item, "h", "Скорость [Спидхак]")
						pCustomRound[iClient][numRound].g_iSetSpeed = 1;
					}
					else if(sBuf[0] == 'h')
					{
						menu.InsertItem(Item, "с", "Скорость [Черепаха]")
						pCustomRound[iClient][numRound].g_iSetSpeed = 2;
					}
					else
					{
						menu.InsertItem(Item, "n", "Скорость [Стандарт]")
						pCustomRound[iClient][numRound].g_iSetSpeed = 0;
					}

					menu.Display(iClient, 15);
				}
				case 3:
				{
					if(sBuf[0] == 'n')
					{
						menu.InsertItem(Item, "h", "Прыжки [Очень высоко]")
						pCustomRound[iClient][numRound].g_bGravity = true;
					}
					else
					{
						menu.InsertItem(Item, "n", "Прыжки [Стандарт]")
						pCustomRound[iClient][numRound].g_bGravity = false;
					}

					menu.Display(iClient, 15);
				}
				case 4:
				{
					if(sBuf[0] == 'n')
					{
						menu.InsertItem(Item, "h", "Нож [Есть]")
						pCustomRound[iClient][numRound].g_bKnife = true;
					}
					else
					{
						menu.InsertItem(Item, "n", "Нож [Нету]")
						pCustomRound[iClient][numRound].g_bKnife = false;
					}
					
					menu.Display(iClient, 15);
				}
				case 5:
				{
					pCustomRound[iClient][numRound].IsTooled = true;
					if(g_bIsSameRounds)
					{
						for(int i = 1; i < COUNT_ROUNDS; i++)
						{
							Copy(pCustomRound[iClient][i], pCustomRound[iClient][0]);
						}
					}

					CreateRoundSettingsMenu(iClient).Display(iClient, 15);
				}
			}
		}
		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				if(pCustomRound[iClient][numRound].typeCustomGame != GrenadeWar) 
				{
					CreateTypeWeaponMenu().Display(iClient, 15);
				}
				else
				{
					CreateChoiceGrenadeMenu().Display(iClient, 15);
				}
			}
			else
			{
				ResetCR(pCustomRound[iClient])
			}
			
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int MS_VotePanel(Menu panel, MenuAction action, int iClient, int item)
{
	if(IsClientInGame(iClient))
	{
		bool flag = item == yes;
		g_bVoteClient[iClient] = flag;
		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] %N нажал %s", iClient, flag == true? "{PURPLE}+":"{PURPLE}-");
	}
	
	playerCount++;

	if(maxCurPlayer == playerCount)
	{
		KillTimer(hVoteTimer);
		VoteResult();
	}
}

public void VoteResult()
{
	int total;
	int y;

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			if(g_bVoteClient[i])
			{
				y++;
			}

			total++;
		}
	}

	if(total == 0)
	{
		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Голосование провалилось. {PURPLE}Никто не проголосовал!");
		return;
	}

	float limit = 0.50;
	float percent = float(y) / float(total); 

	if (FloatCompare(percent,limit) < 0)
	{

		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Голосование провалилось. Необходимо %d %s голосов. {PURPLE}(Получено %d %s голосов из %d)", RoundToNearest(100.0*limit), "%", RoundToNearest(100.0*percent), "%%", total);
		ResetSettings();
	}
	else
	{
		CGOPrintToChatAll("[{PURPLE}XCP{DEFAULT}] Голосование состоялось. {PURPLE}(Получено %d %s голосов из %d)", RoundToNearest(100.0*percent), "%", total);
	
		//iRound = CS_GetTeamScore(2) + CS_GetTeamScore(3) + 1;

		preVote = true;
		bNewVote = true;
		iHSMODE = hs_mode.IntValue;
		iFreezeTime = mp_freezetime.IntValue;

		GetMapTimeLeft(g_iRemainderTimeLeft);
		// PrintToChatAll("[DEBUG] Оставалось до конца карты %d(%d min %d sec)", g_iRemainderTimeLeft, g_iRemainderTimeLeft / 60, g_iRemainderTimeLeft % 60);
		// ExtendMapTimeLimit(50000); // полный идиотизм, чтобы увеличить тайм нужно подать отрицательное значение xD

		// int test;
		// GetMapTimeLeft(test);
		// PrintToChatAll("[DEBUG] Продлено до конца карты %d(%d min %d sec)", test, test / 60, test % 60);
	}
	
	g_iAdminChoses = 0;
}

public Action VoteEnd(Handle hTimer)
{
	VoteResult();
	g_iAdminChoses = 0;

	return Plugin_Stop;
}

public Action TimerNewVote(Handle hTimer)
{
	bNewVote = false;
	g_hTimer = null;
}

public Action TimerDeleteAllWeapons(Handle hTimer)
{
	KillAllWeapons();
	
	return Plugin_Stop;
}

public Action TimerCallBack(Handle hTimer, any iUserID)
{
	int iClient = GetClientOfUserId(iUserID);
	if(iClient > 0 && IsClientInGame(iClient))
	{
		if(customRound[numCurrentRound].g_bGravity)
		{
			SetEntPropFloat(iClient, Prop_Data, "m_flGravity", 0.25);
		}

		if(!customRound[numCurrentRound].g_iSetArmor)
		{
			SetEntData(iClient, m_ArmorValue, 0);
			SetEntData(iClient, m_bHasHelmet, 0);
		}
		else if (customRound[numCurrentRound].g_iSetArmor == 1)
		{
			SetEntData(iClient, m_ArmorValue, 100);
			SetEntData(iClient, m_bHasHelmet, 0);
		}
		else if (customRound[numCurrentRound].g_iSetArmor == 2)
		{
			SetEntData(iClient, m_ArmorValue, 100);
			SetEntData(iClient, m_bHasHelmet, 1);
		}
		
		if(customRound[numCurrentRound].g_iSetSpeed == 1)
		{
			SetEntDataFloat(iClient, m_flLaggedMovementValue, 2.5, true);
		}
		else if(customRound[numCurrentRound].g_iSetSpeed == 2)
		{
			SetEntDataFloat(iClient, m_flLaggedMovementValue, 0.5, true);
		}
		
		if(customRound[numCurrentRound].g_bModQueue)
		{
			int iWeapon = GetEntPropEnt(iClient, Prop_Data, "m_hActiveWeapon");
			
			if(iWeapon != -1)
			{
				SetEntProp(iWeapon, Prop_Send, "m_iPrimaryReserveAmmoCount", 1); // патроны в запасе
				SetEntProp(iWeapon, Prop_Send, "m_iClip1", 0); // патроны в обойме
			}
		}

		switch(customRound[numCurrentRound].typeCustomGame)
		{
			case OtherWeapons:
			{
			//	DeleteWeapons(iClient);
			}
			case ChickenWar:
			{
				SetChicken(iClient);
			}
			case GrenadeWar:
			{
				SetEntityHealth(iClient, 1);
				SetEntProp(iClient, Prop_Data, "m_iMaxHealth", 1);
				GivePlayerItem(iClient, customRound[numCurrentRound].sCurrentWeapon);

				return Plugin_Stop;
			}
			case WallFists:
			{
				TeleportClient(iClient);
			}
			case Poeben:
			{
				TeleportToPoebenClient(iClient);
			}
			case CatchUp:
			{
				CatchUpGiveItem(iClient);
				TeleportToCatchUpSpawn(iClient);

				return Plugin_Stop;	
			}

			case Arena:
			{
			//	TeleportToArenaSpawn(iClient);
				return Plugin_Stop;
			}

			case KingOfTheHill:
			{
				SetEntityHealth(iClient, 20);
				SetEntProp(iClient, Prop_Data, "m_iMaxHealth", 20);

				if(!KOTH_TimerAntiCamp[iClient])
				{
					timerSec[iClient] = 10;
					KOTH_TimerAntiCamp[iClient] = CreateTimer(1.0, KOTH_AntiCampStartTimerCallBack, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
//					PrintToChatAll("[DEBUG] %N ставим таймер!(KOTH_TimerAntiCamp[activator] - %d)", iClient, KOTH_TimerAntiCamp[iClient]);
				}				

				return Plugin_Stop;
			}
		}
		
		
		if(bAwpMap)
		{
			if(!StrEqual(customRound[numCurrentRound].sCurrentWeapon, "weapon_awp") && !StrEqual(customRound[numCurrentRound].sCurrentWeapon, ""))
			{
				EquipPlayerWeapon(iClient, GivePlayerItem(iClient, customRound[numCurrentRound].sCurrentWeapon));
				FakeClientCommand(iClient, "use %s", customRound[numCurrentRound].sCurrentWeapon);
			}
			
		}
		else
		{
			EquipPlayerWeapon(iClient, GivePlayerItem(iClient, customRound[numCurrentRound].sCurrentWeapon));
			FakeClientCommand(iClient, "use %s", customRound[numCurrentRound].sCurrentWeapon);
		}
	}
	return Plugin_Stop;
}

public Action TimerDeleteWeaponsOnTheGround(Handle hTimer)
{
	static char wName[64];

	for(int entity = GetEntityCount(); MaxClients < entity; entity--) 
	{
		if(IsValidEdict(entity)) 
		{
			if(GetEdictClassname(entity, wName, sizeof(wName))) 
			{
				if(strncmp(wName, "weapon_", 7) == 0) 
				{
					if(GetEntDataEnt2(entity, m_hOwnerEntity) == -1) 
					{
						RemoveEdict(entity);
					}
				}
			}
		}

	}

	return Plugin_Stop;
}

public Action:OnKnifeArenaSpawn(&Levels, &Float:Radius, &Float:Length, Float:Origin[3]) //Action OnKnifeArenaSpawn(int &Levels, &float Radius, &float Length, float Origin[3])
{
	if(customRound[numCurrentRound].typeCustomGame == CatchUp || customRound[numCurrentRound].typeCustomGame == Arena || customRound[numCurrentRound].typeCustomGame == KingOfTheHill)
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public int Handler_MenuAvcr_Sets(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(Item == 0) // добавить
			{
				bIsSettingSet[iClient] = true;
				piCountRound[iClient] = 1;
				PrintToChat(iClient, "Введите название сета:\n\n ");
				CreatePanelSetInfo(iClient);
			}
			else if(Item < 8)
			{
				char infoBuf[64];
				hMenu.GetItem(Item, infoBuf, sizeof(infoBuf));
				int id = StringToInt(infoBuf);
				CreateManageSet(id).Display(iClient, 0);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int Handler_MenuAvcr_ChoiceNumRounds_Set(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{	
			piCountRound[iClient] = Item + 1;
			
			CreateRoundSettingsMenu(iClient).Display(iClient, 0);
		}

		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				CreateCrAdminMenu().Display(iClient, 0);
			}

			ResetCR(pCustomRound[iClient]);
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}

public int Handler_Set_Manage(Menu hMenu, MenuAction action, int iClient, int Item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char infoBuf[64];
			hMenu.GetItem(Item, infoBuf, sizeof(infoBuf));
			int id = StringToInt(infoBuf);

			if(Item == 0)
			{
				if(bNewVote) 
				{
					WithVoting = true;
					int curTime = GetTime();

					if(curTime > timeCD)
					{
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Кастомный раунд уже поставлен! Дождитесь окончания для того чтобы узнать время до нового.");
					}
					else
					{
						int _timeCD = timeCD - curTime;
						CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] Следующее голосование возможно через {PURPLE}%d мин. %02d сек.", _timeCD / 60, _timeCD % 60);
					}

					return;
				}
				else if(g_iAdminChoses) 
				{
					CGOPrintToChat(iClient, "[{PURPLE}XCP{DEFAULT}] На данный момент другой {PURPLE}администратор {DEFAULT}проводит создание {PURPLE}Custom Rounds");
					return;
				}
				
				GetCustomRound(id, iClient);
			}
			else if(Item == 1)
			{
				DeleteSet(id, iClient)
			}
		}

		case MenuAction_Cancel:
		{
			if(MenuCancel_ExitBack == Item)
			{
				CreateCrAdminMenu().Display(iClient, 0);
			}

			ResetCR(pCustomRound[iClient]);
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
}