#include <sourcemod>
#include <adminmenu>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <csgo_colors>
#include <clientprefs>

#undef REQUIRE_PLUGIN
#include <shop_equip>
#include <vip_core>
#include <vip_fm>
#include <ws_knife_arena>

#include "avcr/vars.sp"
#include "avcr/Hooks.sp"
#include "avcr/Menu.sp"
#include "avcr/Modes/SettingsMode.sp"
#include "avcr/Handlers.sp"
#include "avcr/Functions.sp"

#include "avcr/Modes/ChickenFake.sp"
#include "avcr/Modes/WallFists.sp"
#include "avcr/Modes/NoScope.sp"
#include "avcr/Modes/WH.sp"
#include "avcr/Modes/CatchUp.sp"
#include "avcr/Modes/Arena.sp"
#include "avcr/Modes/KingOfTheHill.sp"
#include "avcr/Modes/BombMan.sp"

#include "avcr/Cmd.sp"
#include "avcr/Props.sp"
#include "avcr/Events.sp"
#include "avcr/API.sp"
#include "avcr/AdminMenu.sp"
#include "avcr/db.sp"
#include "avcr/Random-custom-rounds.sp"

/*695.89 -1033.14 -62.37 | -8.85 122.45 0.00
381.73 -1045.06 -69.91 | -9.73 107.76 0.00
32.6 -1045.48 -80.75| -10.77 90.99 0.00
-284.99 -1047.85 -82.59 | -10.39 76.03 0.00
-639.57 -1046.75 -87.03 | -9.56 59.75 0.00
t
-660.98 1104.42 -74.53 | -8.63 -59.05 0.00
-345.08 1105.82 -68.84 | -9.34 -73.85 0.00
24.87 1105.46 -63.09 | -10.17 -90.95 0.00
360.68 1105.69 -61.66 | -9.67 -106.41 0.00
682.79 1107.32 -70.06 | -8.68 -121.39 0.00
left for t
594.26 505.04 -26.03 | -12.69 -142.24 0.00
594.37 305.45 -24.03 | -13.30 -157.64 0.00
593.88 88.15 -25.31 | -15.39 -174.08 0.00
594.98 -159.37 -27.97 | -14.07 165.73 0.00
595.14 -444.19 -29.94 | -12.48 142.03 0.00
right for t
-560.82 512.64 -29.28 | -12.42 -39.31 0.00
-559.16 287.11 -26.09 | -14.34 -22.42 0.00
-559.25 38.5 -26.12 | -15.56 -0.97 0.00
-560.12 -164.28 -27.03 | -14.57 16.3 0.00
-559.05 -425.14 -27.47 | -11.87 37.64 0.00

catching
12.25 33.72 191.0
t ang: 21.18 91.05 0.00
left for t ang: 21.18 0.63 0.00
right for t ang: 21.18 -179.03 0.00
ct ang: 21.18 -88.77 0.0
*/

public Plugin myinfo =
{
	name        = 	"Admin Vote Custom Rounds",
	author      = 	"RudikS",
	version     = 	PLUGIN_VERSION,
};

public void OnConfigsExecuted()
{
	AddCommandListener(CB_Block, "sm_shop");
	AddCommandListener(CB_Block, "sm_store");
	AddCommandListener(CB_Block, "sm_arena");

	BombMan_OnConfigsExecuted();
}

public void OnPluginStart()
{
	RegAdminCmd("sm_cr", Command_Cr, ADMFLAG_BAN);
	RegConsoleCmd("sm_crmus", StopSoundHandler);
	

	// Events
	HookEvent("round_start", EventRS_PS);
	HookEvent("round_prestart", EventRoundPreStart);
	HookEvent("player_spawn", EventRS_PS);
	HookEvent("round_end", EventRS_PS);
	HookEvent("cs_win_panel_match", EventCSWIN_Panel); // пока что хлам
	HookEvent("player_jump", Event_PlayerJump);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("weapon_fire", Event_WF);

	AddCommandListener(Say_Callback, "say");
	AddCommandListener(Say_Callback, "say_team");

	// Convars
	infinite_ammo_mode = FindConVar("sv_infinite_ammo");
	mp_freezetime = FindConVar("mp_freezetime");
	hs_mode = FindConVar("mp_damage_headshot_only");
	sv_force_transmit_players = FindConVar("sv_force_transmit_players");
	mp_roundtime = FindConVar("mp_roundtime");
	mp_ignore_round_win_conditions = FindConVar("mp_ignore_round_win_conditions");
	mp_teammates_are_enemies = FindConVar("mp_teammates_are_enemies");
	mp_death_drop_gun = FindConVar("mp_death_drop_gun");

	mp_respawn_on_death_t = FindConVar("mp_respawn_on_death_t");								
	mp_respawn_on_death_ct = FindConVar("mp_respawn_on_death_ct");						

	ConVar conVar;

	(conVar = CreateConVar("sm_cr_weapon_deagle", "0", "1|0 Запретить/Разрешить deagle", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_DeagleRestrict);
	g_bDeagleRestrict = conVar.BoolValue;
	//PrintToChatAll("conVar.BoolValue - %d, g_bDeagleRestrict - %d", conVar.BoolValue, g_bDeagleRestrict);

	HookConVarChange(conVar = FindConVar("mp_round_restart_delay"), RoundEndDelayConvarChange);
	floatRoundEndDelay= GetConVarFloat(conVar) - 0.2;
	delete conVar;

	AutoExecConfig(true, "custom-rounds");
	
	// Offsets
	m_ArmorValue = FindSendPropInfo("CCSPlayer", "m_ArmorValue");
	m_bHasHelmet = FindSendPropInfo("CCSPlayer", "m_bHasHelmet");
	m_flLaggedMovementValue = FindSendPropInfo("CCSPlayer", "m_flLaggedMovementValue");
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
	g_iOffsCollisionGroup = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	m_hOwnerEntity = FindSendPropInfo("CBaseCombatWeapon", "m_hOwnerEntity");
	VelocityOffset_0 = FindSendPropInfo("CBasePlayer", "m_vecVelocity[0]");
	VelocityOffset_1 = FindSendPropInfo("CBasePlayer", "m_vecVelocity[1]");
	BaseVelocityOffset = FindSendPropInfo("CBasePlayer", "m_vecBaseVelocity");

	// xren
	// if (LibraryExists("adminmenu"))
	// {
	// 	TopMenu hTopMenu;
	// 	if ((hTopMenu = GetAdminTopMenu()) != null)
	// 	{
	// 		OnAdminMenuReady(hTopMenu);
	// 	}
	// }

	PreloadConfigs();

	g_hCookie = RegClientCookie("CatchUpMusic", "Музыка во время догонялок", CookieAccess_Private);
	SetCookiePrefabMenu(g_hCookie, CookieMenu_OnOff_Int, "CatchUpMusic", CatchUpCookieHandler);

	Queue = new ArrayList();

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			OnClientPutInServer(i)
		}
	}

	Database.Connect(ConnectCallBack, "avcr");
	
}

public void CatchUpCookieHandler(int iClient, CookieMenuAction action, any info, char[] buffer, int maxlen)
{
    if (action == CookieMenuAction_SelectOption)
    {
        OnClientCookiesCached(iClient);
    }
}

public void OnClientCookiesCached(int iClient)
{
    char szValue[4];
    GetClientCookie(iClient, g_hCookie, szValue, sizeof(szValue));
    if(szValue[0]) // Если в куках что-то записано
    {
        // Получаем это
        g_bCatchUpMusic[iClient] = view_as<bool>(StringToInt(szValue));
    }
    else // Иначе
    {
        // По умолчанию сделаем опцию включенной
        g_bCatchUpMusic[iClient] = true;
    }
}

public void RoundEndDelayConvarChange(Handle convar, char [] O, char [] N) 
{
    floatRoundEndDelay = GetConVarFloat(convar) - 0.2;
}

public void ChangeCvar_DeagleRestrict(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bDeagleRestrict = convar.BoolValue;
	//PrintToChatAll("conVar.BoolValue - %d, g_bDeagleRestrict - %d", convar.BoolValue, g_bDeagleRestrict);
}

void PreloadConfigs()
{
	kvWallFistsObjects = new KeyValues("WallFistsObjects");
	if(!kvWallFistsObjects.ImportFromFile(pathWallFistsObjects))
	{
		SetFailState("Не загружен список объектов для WallFistsObjects");
	}

	kvPoebenObjects = new KeyValues("PoebenObjects");
	if(!kvPoebenObjects.ImportFromFile(pathPoebenObjects))
	{
		SetFailState("Не загружен список объектов для PoebenObjects");
	}

	kvCatchUpObjects = new KeyValues("CatchUpObjects");
	if(!kvCatchUpObjects.ImportFromFile(pathCatchUpObjects))
	{
		SetFailState("Не загружен список объектов для CatchUpObjects");
	}

	kvArenaObjects = new KeyValues("Arena")
	if(!kvArenaObjects.ImportFromFile(pathArenaObjects))
	{
		SetFailState("Не загружен список объектов для Arena");
	}

	kvKingOfTheHillObjects = new KeyValues("KingOfTheHill")
	if(!kvKingOfTheHillObjects.ImportFromFile(pathKingOfTheHillObjects))
	{
		SetFailState("Не загружен список объектов для KingOfTheHill");
	}

	kvWeaponRoundsObjects = new KeyValues("WeaponRoundsObjects");
	if(!kvWeaponRoundsObjects.ImportFromFile(pathWeaponRoundsObjects))
	{
		SetFailState("Не загружен список объектов для WeaponRoundsObjects");
	}
	
}

public void OnClientPutInServer(int iClient)
{
	SDKHook(iClient, SDKHook_PreThink, OnPreThink);
	SDKHook(iClient, SDKHook_WeaponCanUse, OnWeaponUse);
	SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
	SDKHook(iClient, SDKHook_SetTransmit, SetTransmit);
//	SDKHook(iClient, SDKHook_StartTouch, StartTouch);
}

public void OnClientPostAdminCheck(int iClient)
{
	Db_OnClientPostAdminCheck(iClient);
}

public void OnMapStart()
{
	bCustomRound = false,
	bNewVote = false,
	iCountRound = 0;
	preVote = false;
//	iRound = 1337;

	ResetSettings();

	char sBuf [128];
	GetCurrentMap(sBuf, sizeof(sBuf));
	if(StrContains(sBuf, "awp") != -1)
	{
		bAwpMap = true;
	}
	else bAwpMap = false;

	// PrecacheSound("avcr/ds_avcr_mus_catchup.mp3");
	// AddFileToDownloadsTable("sound/avcr/ds_avcr_mus_catchup.mp3");

	PrecacheModel("models/weapons/eminem/ice_cube/ice_cube.mdl");

	LaserMaterial = PrecacheModel("materials/sprites/laserbeam.vmt");
	HaloMaterial  = PrecacheModel("materials/sprites/glow01.vmt");

	AddFileToDownloadsTable("models/weapons/eminem/ice_cube/ice_cube.phy");
	AddFileToDownloadsTable("models/weapons/eminem/ice_cube/ice_cube.vvd");
	AddFileToDownloadsTable("models/weapons/eminem/ice_cube/ice_cube.dx90.vtx");
	AddFileToDownloadsTable("models/weapons/eminem/ice_cube/ice_cube.mdl");

	AddFileToDownloadsTable("materials/models/weapons/eminem/ice_cube/ice_cube.vtf");
	AddFileToDownloadsTable("materials/models/weapons/eminem/ice_cube/ice_cube_normal.vtf");
	AddFileToDownloadsTable("materials/models/weapons/eminem/ice_cube/ice_cube.vmt");
	
	//PreloadConfigs();
	CreateTimer(1500.0, CreateRandomCustomRoundsHandler, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

public void OnMapEnd()
{
	hs_mode.IntValue = iHSMODE; // iHSMODE ставим тот режим, который стоял на сервере по умолчанию!
}

public void OnClientDisconnect(int iClient)
{
	if(g_iAdminChoses == iClient)
	{
		g_iAdminChoses = 0;
	}

	//IsClientValid(iClient)

	if(bCustomRound)
	{
		if(customRound[numCurrentRound].typeCustomGame == Arena && Queue.Length != 0)
		{
			int index = Queue.FindValue(iClient);

			if(index != -1)
			{
				Queue.Erase(index);

				int rival = FindRival(iClient);

				if(rival != -1)
				{
					Queue.Push(rival);

					if(Queue.Length > 1)
					{
						SendToArena();
					}
				}
			}
		}
		
		if(customRound[numCurrentRound].typeCustomGame == CatchUp)
		{
			i_CountUseFulness[iClient] = 0;

			int entity = EntRefToEntIndex(catchUpStoreEntities[iClient]);
			if(entity != 0 && IsValidEntity(entity))
			{
				AcceptEntityInput(entity, "Kill");
			}
		}

		if(customRound[numCurrentRound].typeCustomGame == KingOfTheHill)
		{
			if(KOTH_TimerAntiCamp[iClient])
			{
				KillTimer(KOTH_TimerAntiCamp[iClient]);
				KOTH_TimerAntiCamp[iClient] = null;
			}
		}
	}
}

public void OnPluginEnd()
{
	if(kvWallFistsObjects != null)
	{
		delete kvWallFistsObjects;
	}

	if(kvPoebenObjects != null)
	{
		delete kvPoebenObjects;
	}

	if(kvCatchUpObjects != null)
	{
		delete kvCatchUpObjects;
	}


	ServerCommand("exec \"gamemode_casual_server.cfg\"");
	mp_ignore_round_win_conditions.IntValue = 0;
	mp_respawn_on_death_t.IntValue = 0;
	mp_respawn_on_death_ct.IntValue = 0;
	hs_mode.IntValue = 0;
	mp_death_drop_gun.IntValue = 1;
	
	CGOPrintToChatAll("{DEFAULT}[{LIGHTBLUE}CustomRounds{DEFAULT}] Плагин был выгружен! Применяем дефолтные настройки");
}

public Action CB_Block(int iClient, const char[] command, int argc)
{
	if(bCustomRound)
	{
		CGOPrintToChat(iClient, "{DEFAULT}[{LIGHTBLUE}CustomRounds{DEFAULT}] Во время кастомного раунда {RED}нельзя {DEFAULT}использовать данную команду!");
		return Plugin_Stop;
	} 

	return Plugin_Continue;
}

public Action OnPlayerRunCmd(int iClient, int& iButtons)
{
	if(bCustomRound == false)
	{
		return Plugin_Continue;
	}

	if (customRound[numCurrentRound].typeCustomGame == LongJump && IsPlayerAlive(iClient) && iButtons & IN_JUMP && !(GetEntityFlags(iClient) & FL_ONGROUND) && !(GetEntityMoveType(iClient) & MOVETYPE_LADDER) && GetEntProp(iClient, Prop_Data, "m_nWaterLevel") <= 1) 
		iButtons &= ~IN_JUMP;

	if(customRound[numCurrentRound].typeCustomGame != WallFists)
	{
		return Plugin_Continue;
	}
	
	if(IsPlayerAlive(iClient) && iButtons & IN_ATTACK2)
	{
		static int iWeapon; static char szWeapon[24];
		iWeapon = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
		if(iWeapon != 1 && IsValidEdict(iWeapon))
		{
			GetEdictClassname(iWeapon, szWeapon, sizeof szWeapon);
			if(!strcmp(szWeapon[7], "melee"))
			{
				iButtons &= ~IN_ATTACK2;
				return Plugin_Changed;
			}
		}
	}

	return Plugin_Continue;
}

public Action Say_Callback(int iClient, const char[] sCommand, int args)
{
	if(bIsSettingSet[iClient])
	{
		bIsSettingSet[iClient] = false;

		char sText[192];
    	GetCmdArg(1, SettingSet_Name[iClient], 32);

		ChoiceTypeGameMenu().Display(iClient, 15);

		return Plugin_Handled;
		
	}

    return Plugin_Continue;
}