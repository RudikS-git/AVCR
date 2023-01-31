
public Action CreateRandomCustomRoundsHandler(Handle hTime) {

  if(!preVote && !bCustomRound) { // если нет голосования и кастомки не идут
  
    int randomInt = GetRandomInt(1, COUNT_ROUNDS);
    piCountRound[0] = randomInt;
    numRound = randomInt;

    GetRandomModes(pCustomRound[0], randomInt);

    WithVoting = true;
    g_iAdminChoses = 0;
    preVote = true;		
    bNewVote = true;		
    iHSMODE = hs_mode.IntValue;
    iFreezeTime = mp_freezetime.IntValue;
    GetMapTimeLeft(g_iRemainderTimeLeft);
    // ExtendMapTimeLimit(50000);
    // CS_TerminateRound(0.1, CSRoundEnd_Draw);

    PlayerCrToCommonCr(0);
    ResetCR(pCustomRound[0]);

    CGOPrintToChatAll("{DEFAULT}[{LIGHTBLUE}CustomRounds{DEFAULT}] Идет автоматическая установка кастомных %d раундов...", randomInt);
		ShowHudTextAll("[CustomRounds] Идет автоматическая установка кастомных раундов...");
  }

  return Plugin_Continue;
}