public void SpawnBlocks(KeyValues &kv_list)
{
//	PrintToChatAll("Заход в SpawnBlocks %d", kv_list);
	float pos[3], ang[3];
	int entity, color[4];
	char buffer[16], Models[256];

	kv_list.Rewind();
	if(kv_list.GotoFirstSubKey(false))
	{
		int j = 0;

		do
		{
			kv_list.GetVector("Position", pos);
			kv_list.GetVector("Angles", ang);
			kv_list.GetString("Model", Models, sizeof(Models));
			kv_list.GetString("Colors", buffer, sizeof(buffer));

		//	PrintToChatAll("Ставим объект %d %d %d", pos[0], pos[1], pos[2]);

			StringToColor(buffer, color);

			if ((entity = CreateProp(pos, ang, Models)) != -1)
			{
				if(customRound[numCurrentRound].typeCustomGame == CatchUp && StrEqual(Models, "models/props_c17/fence01a.mdl"))
				{
					CatchUpEntObjectsTower[j] = entity;
					j++;
				}

				SetEntityColor(entity, color);
			}

		}
		while (kv_list.GotoNextKey(false));
	}

	kv_list.Rewind();
}

public int CreateProp(const float pos[3], const float ang[3], const char [] sModel)
{
    int Ent = CreateEntityByName("prop_physics_override"); 

    if (Ent == -1)
    {
		return -1;
	}

    if (!IsModelPrecached(sModel))
    {
		PrecacheModel(sModel);
	}

    DispatchKeyValue(Ent, "physdamagescale", "0.0");
    DispatchKeyValue(Ent, "model", sModel);

    DispatchSpawn(Ent);
    SetEntityMoveType(Ent, MOVETYPE_PUSH);
				
    TeleportEntity(Ent, pos, ang, NULL_VECTOR);

    return Ent;
}

stock void SetEntityColor(int entity, int color[4] = {-1, ...})
{
	int dummy_color[4]; 
	
	GetEntityRenderColor(entity, dummy_color[0],  dummy_color[1],  dummy_color[2],  dummy_color[3]);
	
	for (new i = 0; i <= 3; i++){
		if (color[i] != -1){
			dummy_color[i] = color[i];
		}
	}
	
	SetEntityRenderColor(entity, dummy_color[0], dummy_color[1], dummy_color[2], dummy_color[3]);
	SetEntityRenderMode(entity, RENDER_TRANSCOLOR);
}

stock bool StringToColor(const String:str[], color[4], defvalue = -1)
{
	bool result = false;
	char Splitter[4][64];

	if (ExplodeString(str, " ", Splitter, sizeof(Splitter), sizeof(Splitter[])) == 4 && String_IsNumeric(Splitter[0]) && String_IsNumeric(Splitter[1]) && String_IsNumeric(Splitter[2]) && String_IsNumeric(Splitter[3]))
    {
		color[0] = StringToInt(Splitter[0]);
		color[1] = StringToInt(Splitter[1]);
		color[2] = StringToInt(Splitter[2]);
		color[3] = StringToInt(Splitter[3]);
		result = true;
	}
	else
	{
		color[0] = defvalue;
		color[1] = defvalue;
		color[2] = defvalue;
		color[3] = defvalue;
	}

	return result;
}

stock bool String_IsNumeric(const String:str[])
{
	int x = 0;
	int numbersFound = 0;

	if (str[x] == '+' || str[x] == '-')
    {
		x++;
	}

	while (str[x] != '\0')
    {
		if (IsCharNumeric(str[x]))
        {
			numbersFound++;
		}
		else
		{
			return false;
		}

		x++;
	}
	if (!numbersFound)
    {
		return false;
	}
	return true;
}

void DeleteProp(int entity)
{
	if(IsValidEntity(entity)) {
		static char dname[16];

		Format(dname, sizeof(dname), "dis_%d", entity);
		DispatchKeyValue(entity, "targetname", dname);

		int diss = CreateEntityByName("env_entity_dissolver");

		DispatchKeyValue(diss, "dissolvetype", "3");
		DispatchKeyValue(diss, "target", dname);

		AcceptEntityInput(diss, "Dissolve");
		AcceptEntityInput(diss, "kill");
	}
}