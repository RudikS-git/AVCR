public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max) 
{
    CreateNative("CR_IsCustomRounds", Native_IsCustomRounds);
    CreateNative("CR_BlockWeapons", Native_BlockWeapons);
    CreateNative("CR_GetRounds", Native_Rounds);
    CreateNative("CR_GetTypeRound", Native_TypeRound);
    CreateNative("CR_GetNumRound", Native_NumRound);

    g_hGFwd_CustomRoundStart = CreateGlobalForward("CR_CustomRoundStart", ET_Ignore, Param_Cell);

    RegPluginLibrary("custom_rounds");

    return APLRes_Success;
}

public int Native_IsCustomRounds(Handle hPlugin, int iNumParams)
{
    if(bCustomRound)
    {
        return 1;
    }
    else return 0;
}

public int Native_NumRound(Handle hPlugin, int iNumParams)
{
    return numCurrentRound;
}

public int Native_Rounds(Handle hPlugin, int iNumParams)
{
    return iCountRound;
}

public int Native_TypeRound(Handle hPlugin, int iNumParams)
{
    int num = GetNativeCell(1);

    if(num >= 0 && num <= COUNT_ROUNDS)
    {
        return view_as<int>(customRound[num].typeCustomGame);
    }

    return -1;
}

public int Native_BlockWeapons(Handle hPlugin, int iNumParams)
{ 
    api_IsWeaponBlock = view_as<bool>(GetNativeCell(1));  // true - on, false - off
    
    return 0;
}