#define CD 900.0 // кд для некст голосования
#define LENGTH_WEAPON 64
#define COUNT_ROUNDS 3
#define DISCHARGE_COUNT 1000
#define PLUGIN_VERSION "4.2"

#define MAX_SETS 10

enum TypeCustomGame
{
	Default = 0,
	OtherWeapons,
	NoScope,
	OnlyKnife,
	ChickenWar,
	GrenadeWar,
	WallFists,
	Poeben,
	LongJump,
	WallHack,
	CatchUp,
	Deagle,
	Arena,
	KingOfTheHill,
	Teleporters,
	BombMan
};

// api
Handle g_hGFwd_CustomRoundStart; // Указатель для вызова глобального форварда
// 

// catch up laser 
int LaserMaterial;
int HaloMaterial;
//=========================

// =======================API======================
bool api_IsWeaponBlock = false;
// ================================================
int		timeCD,
		g_iRemainderTimeLeft;

bool 	bCustomRound = false,
		bNewVote = false,
		preVote = false,
		bAwpMap = false,
		WithVoting = true;

int 	g_iAdminChoses = 0;

int 	iCountRound,
		piCountRound[MAXPLAYERS + 1]
		iHSMODE,
		iFreezeTime;
		//iRound;

Handle	g_hTimer,
		hVoteTimer;

Handle g_hCookie;

ConVar	hs_mode, 
		infinite_ammo_mode,
		mp_freezetime,
		mp_roundtime,
		mp_ignore_round_win_conditions,
		mp_respawn_on_death_t,
		mp_respawn_on_death_ct,
		mp_teammates_are_enemies,
		mp_death_drop_gun;

// Menu 	g_CrAdminMenu,
// 		g_PrimaryMenu,
// 		g_PistolMenu,
// 		g_STWeaponMenu,
// 		g_SetSettings,
// 		g_NumRoundMenu,
// 		g_NewWeaponsMenu,
// 		g_ChoiseGrenade,
// 		g_SettingsRound,
// 		g_ChoiceTypeGame;

KeyValues	kvWallFistsObjects,
		  	kvPoebenObjects,
			kvCatchUpObjects,
			kvArenaObjects,
			kvKingOfTheHillObjects,
			kvWeaponRoundsObjects;

// TopMenu		g_hTopMenu = null;
// TopMenuObject	AdminMenuObject = INVALID_TOPMENUOBJECT;

char sWeapon [] [] =
{
	"weapon_ssg08",
	"weapon_ak47",
	"weapon_mag7",
	"weapon_negev",
	"weapon_p90",
	"weapon_xm1014",
	"weapon_mp5sd",
	"weapon_m4a1_silencer",
	"weapon_m4a1",
	"weapon_scar20",
	"weapon_ump45",
	"weapon_aug",
	"weapon_sg556"

}

char sNameWeapon [] [] =
{
	"SSG",
	"AK47",
	"Mag7",
	"Negev",
	"P90",
	"XM1014",
	"MP5SD",
	"M4A1-S",
	"M4A4",
	"Scar20",
	"UMP45",
	"Aug",
	"SG556"
}

char sPistol [] [] =
{
	"weapon_deagle",
	"weapon_revolver",
	"weapon_elite",
	"weapon_glock",
	"weapon_p250",
	"weapon_tec9",
	"weapon_usp_silencer",
	"weapon_fiveseven",
	"weapon_cz75a"
}

char sNamePistol [] [] =
{
	"Deagle",
	"Revolver",
	"Duel Berettas",
	"Glock",
	"P250",
	"Tec9",
	"USP",
	"Five-Seven",
	"CZ-75A"	
}

char sSpecialWeapons [] [] =
{
	"weapon_fists",
  	"weapon_axe",
    "weapon_hammer",
    "weapon_spanner",
    "weapon_shield"
}

char sGrenades [] [] = 
{
	"weapon_decoy",
    "weapon_hegrenade",
    "weapon_molotov",
    "weapon_snowball"
}

int CtColor[4] = {0, 0, 255, 150};
int TColor[4] = {255, 0, 0, 150};
int defaultColor[4] = {255, 255, 255, 255};

int timerSec[MAXPLAYERS + 1];

char 	pathWallFistsObjects[] = "addons/sourcemod/data/AVCR/WallFistsObjects.txt";
char 	pathPoebenObjects[] = "addons/sourcemod/data/AVCR/PoebenObjects.txt";
char 	pathCatchUpObjects[] = "addons/sourcemod/data/AVCR/CatchUpObjects.txt";
char 	pathArenaObjects[] = "addons/sourcemod/data/AVCR/ArenaObjects.txt";
char	pathKingOfTheHillObjects[] = "addons/sourcemod/data/AVCR/KingOfTheHillObjects.txt";
char	pathWeaponRoundsObjects[] = "addons/sourcemod/data/AVCR/WeaponRoundsObjects.txt";

char 	g_sSoundPath [] = "music/super_admin/chicken.mp3";
char	g_sFreezeSound[] = "physics/glass/glass_impact_bullet4.wav";
char 	g_sSoundCatchUp[] = "avcr/ds_avcr_mus_catchup.mp3";

// ==================Vote Custom Rounds====================
int		yes, no, maxCurPlayer, playerCount;
bool 	g_bVoteClient[MAXPLAYERS+1];

// ==================ChickenWar====================
#define CHICKEN_MAX_COUNT 100

Handle 	g_hTimerChicken[MAXPLAYERS+1] = null;
int 	g_iOffsCollisionGroup,
		g_iCollisionGroup;

// ==================WallHack===================
ConVar	sv_force_transmit_players;

// ==================CatchUp====================
float floatRoundEndDelay;
int i_CountUseFulness[MAXPLAYERS + 1];
DataPack catchUpDataPack;
Handle h_CatchUpEndTimer;
Handle h_CatchUpInfoTimer;
int CatchUpEntObjectsTower[2];

int catchUpStoreEntities[MAXPLAYERS + 1];
int catchUp_EntAntiCamp[MAXPLAYERS + 1];

Handle catchUp_TimerAntiCamp[MAXPLAYERS + 1];

enum CatchUptypeWeapon
{
	Taser,
	Grenade,
	Healthshot
}

CatchUptypeWeapon catchUptypeWeapon[MAXPLAYERS + 1];
bool b_gCatchUpRoundEnd = false;
int i_gCatchUpTime = 120; // каждые 120 сек выдача дропа

bool g_bCatchUpMusic[MAXPLAYERS + 1] = {true, ...};

// Arena ============================================
bool IsArenaBusy[(MAXPLAYERS + 1) / 2]; // busy?
int ArenaClients[MAXPLAYERS + 1];

ArrayList Queue;
// ============================================

//KOTH(царь горы)
Handle KOTH_TimerAntiCamp[MAXPLAYERS + 1];
int iLastPushed[MAXPLAYERS + 1];
int KOTH_entZone;
int kingofthehillZone[4] = {138, 43, 226, 255};
//=============================================

int		m_ArmorValue;
int		m_bHasHelmet;
int		m_flNextSecondaryAttack;
int		m_flLaggedMovementValue;
int 	VelocityOffset_0 = -1;
int 	VelocityOffset_1 = -1;
int 	BaseVelocityOffset = -1;
int		m_hOwnerEntity = -1;

int numRound;
int numCurrentRound = 0;
bool g_bIsSameRounds;
int dischargeCount = DISCHARGE_COUNT;
int lastDischargeTime;

// cvars
bool g_bDeagleRestrict = true;



// DataBase
Database g_hDatabase;


bool bIsSettingSet[MAXPLAYERS + 1] = { false, ... };
char SettingSet_Name[MAXPLAYERS + 1][32];

// struct for customRound
enum struct CustomRound
{
	bool IsTooled;

	bool g_bProps;

	char sCurrentWeapon[64];
	char sNameCurWeapon[64];

	int		g_iSetSpeed;
	int		g_iSetArmor;

	bool	g_bSetHsMode;
	bool	g_bGravity;
	bool	g_bKnife;
	bool	g_bModQueue;
	bool	g_bKnifeDamage;

	TypeCustomGame typeCustomGame;
}

CustomRound customRound[COUNT_ROUNDS];

CustomRound pCustomRound[MAXPLAYERS + 1][COUNT_ROUNDS];