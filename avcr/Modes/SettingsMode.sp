public void SetNoScopeMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = NoScope;
  cr[numMode].sCurrentWeapon = "weapon_awp";
	cr[numMode].g_bKnife = true;

	cr[numMode].IsTooled = true;
}

public void SetOnlyKnifeMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = OnlyKnife;
	cr[numMode].g_bKnife = true;
	cr[numMode].sNameCurWeapon = "ножах";
	cr[numMode].g_bSetHsMode = false;
	cr[numMode].g_bKnifeDamage = true;

	cr[numMode].IsTooled = true;
}

public void SetChickenWarMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = ChickenWar;
	cr[numMode].g_bKnife = true;
	cr[numMode].g_bSetHsMode = false;
}

public void SetGrenadeWarMode(CustomRound [] cr, int numMode, char[] weapon)
{
	cr[numMode].typeCustomGame = GrenadeWar;
	cr[numMode].g_bKnife = true;
	cr[numMode].g_bSetHsMode = false;
	strcopy(cr[numMode].sCurrentWeapon, LENGTH_WEAPON, weapon);

	cr[numMode].IsTooled = true;
}

public void SetWallFistsMode(CustomRound [] cr, int numMode, char[] weapon)
{
	cr[numMode].typeCustomGame = WallFists;
	cr[numMode].g_bKnife = false;
	cr[numMode].g_bSetHsMode = false;
	strcopy(cr[numMode].sCurrentWeapon, LENGTH_WEAPON, weapon);

	cr[numMode].IsTooled = true;
}

public void SetPoebenMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = Poeben;
	cr[numMode].sCurrentWeapon = "weapon_awp";
	cr[numMode].g_bKnife = true;

	cr[numMode].IsTooled = true;
}

public void SetLongJumpMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = LongJump;
	cr[numMode].sCurrentWeapon = "weapon_awp";
	cr[numMode].g_bKnife = true;

	cr[numMode].IsTooled = true;
}

public void SetWallHackMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = WallHack;
	cr[numMode].sCurrentWeapon = "weapon_awp";
	cr[numMode].g_bKnife = true;

	cr[numMode].IsTooled = true;
}

public void SetCatchUpMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = CatchUp;
	cr[numMode].sCurrentWeapon = "weapon_taser";
	cr[numMode].g_bKnife = true;
	cr[numMode].g_bModQueue = false;

	cr[numMode].IsTooled = true;
}

public void SetDeagleMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = Deagle;
	cr[numMode].sCurrentWeapon = "weapon_awp";
	cr[numMode].g_bKnife = true;
	cr[numMode].g_bModQueue = false;

	cr[numMode].IsTooled = true;
}

public void SetArenaMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = Arena;

	cr[numMode].IsTooled = true;
}

public void SetKingOfTheHill(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = KingOfTheHill;

	cr[numMode].IsTooled = true;
	cr[numMode].g_bKnife = true;
	cr[numMode].sCurrentWeapon = "";
}

public void SetTeleportersMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = Teleporters;
	cr[numMode].sCurrentWeapon = "weapon_awp";
	cr[numMode].IsTooled = true;
	cr[numMode].g_bKnife = true;
	cr[numMode].g_bKnifeDamage = true;
}

public void SetBombManMode(CustomRound [] cr, int numMode)
{
	cr[numMode].typeCustomGame = BombMan;
	cr[numMode].sCurrentWeapon = "weapon_nova";
	cr[numMode].IsTooled = true;
	cr[numMode].g_bKnife = true;
	cr[numMode].g_bKnifeDamage = true;
}