#define EXPLODE_SOUND 			"weapons/hegrenade/explode3.wav"
#define EXPLODE_VOLUME			0.1
#define BULLET_SPEED			1000.0
#define MAX_DISTANCE			160.0
#define JUMP_FORCE_UP			8.0
#define JUMP_FORCE_FORW			1.20
#define JUMP_FORCE_BACK			1.25
#define JUMP_FORCE_MAIN			270.0
#define RUN_FORCE_MAIN			0.8

int g_ExplosionSprite;
char ModelPath[128] = "models/props_junk/watermelon01.mdl";

bool g_bStopSound[MAXPLAYERS + 1] = false;
bool g_bHidePlayers[MAXPLAYERS + 1] = false;

int g_iUtils_EffectDispatchTable;
int g_iUtils_DecalPrecacheTable;

public void BombMan_OnConfigsExecuted()
{
    //Precache
    PrecacheSound(EXPLODE_SOUND, true);
    PrecacheModel(ModelPath);
}

public void BombMan_WeaponFire(Handle event)
{
    //Get client who is shooting
    int client = GetClientOfUserId(GetEventInt(event, "userid"));


    char weapon[50];
    GetEventString(event, "weapon", weapon, sizeof(weapon));
    if(!StrEqual(weapon, "weapon_nova"))
    {
        return;
    }

    //Get ORG from where to shoot bullet
    float bulletSpawnORG[3], eyeposition[3], eyeangles[3];
    GetClientEyePosition(client, eyeposition);
    GetClientEyeAngles(client, eyeangles);
    AddInFrontOf(eyeposition, eyeangles, 10.0, bulletSpawnORG);
    
    //Get player velocity
    float clientVelocity[3];
    GetEntPropVector(client, Prop_Data, "m_vecVelocity", clientVelocity);
    
    //Create velocity for bullet
    float bulletVelocity[3], bullenAngle[3];
    GetAngleVectors(eyeangles, bulletVelocity, NULL_VECTOR, NULL_VECTOR);
    GetClientEyeAngles(client, bullenAngle);
    NormalizeVector(bulletVelocity, bulletVelocity);
    ScaleVector(bulletVelocity, BULLET_SPEED);
    
    //Add player velocity to bullet velocity
    AddVectors(bulletVelocity, clientVelocity, bulletVelocity);
    
    //Shoot bullet
    ShootBullet(client, bulletSpawnORG, bulletVelocity, bullenAngle);
}

public void ShootBullet(int client, float bulletSpawnORG[3], float bulletVelocity[3], float bulletAngle[3])
{	
    //Create bullet
    int bullet = CreateEntityByName("decoy_projectile");
    DispatchSpawn(bullet);

    //Set bullet owner
    SetEntPropEnt(bullet, Prop_Send, "m_hOwnerEntity", client);

    //Make bullet go thru other players
    SetEntProp(bullet, Prop_Data, "m_nSolidType", 6); // SOLID_VPHYSICS 
    SetEntProp(bullet, Prop_Send, "m_CollisionGroup", 1); // COLLISION_GROUP_DEBRIS  

    //Change bullet model
    if(!IsModelPrecached(ModelPath))
        PrecacheModel(ModelPath);
        
    SetEntityModel(bullet, ModelPath);

    //Give bullet gravity (dont fall down)
    SetEntityGravity(bullet, 0.001);

    //Shoot bullet
    TeleportEntity(bullet, bulletSpawnORG, bulletAngle, bulletVelocity);

    //SDK hook 
    SDKHook(bullet, SDKHook_StartTouch, OnBulletTouchWall);
    SDKHook(bullet, SDKHook_SetTransmit, Hook_BulletSetTransmit);
}

void CreateExplosion(int entity)
{	
    float MissilePos[3];
    GetEntPropVector(entity, Prop_Send, "m_vecOrigin", MissilePos);
    //int MissileOwner = GetEntPropEnt(entity, Prop_Send, "m_hThrower");
    int MissileOwnerTeam = GetEntProp(entity, Prop_Send, "m_iTeamNum");


    int ExplosionIndex = CreateEntityByName("env_explosion");
    if (ExplosionIndex != -1)
    {
        DispatchKeyValue(ExplosionIndex, "classname", "decoy_projectile");
        
        SetEntProp(ExplosionIndex, Prop_Data, "m_spawnflags", 6146);
        SetEntProp(ExplosionIndex, Prop_Data, "m_iMagnitude", 100);
        SetEntProp(ExplosionIndex, Prop_Data, "m_iRadiusOverride", 350);
        
        DispatchSpawn(ExplosionIndex);
        ActivateEntity(ExplosionIndex);
        
        TeleportEntity(ExplosionIndex, MissilePos, NULL_VECTOR, NULL_VECTOR);

        SetEntPropEnt(ExplosionIndex, Prop_Send, "m_hOwnerEntity", GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity"));
        SetEntProp(ExplosionIndex, Prop_Send, "m_iTeamNum", MissileOwnerTeam);
        
        EmitSoundToAll("weapons/hegrenade/explode5.wav", ExplosionIndex, 1, 90);
        
        AcceptEntityInput(ExplosionIndex, "Explode");
        
        DispatchKeyValue(ExplosionIndex, "classname","env_explosion");
        
        AcceptEntityInput(ExplosionIndex, "Kill");
    }

    AcceptEntityInput(entity, "Kill");
}

public void OnBulletTouchWall(int bullet, int client) 
{
    //Check if bullet is valid
    if (!IsValidEntity(bullet))
        return;
        
    //Get shooter
    int shooter = GetEntPropEnt(bullet, Prop_Send, "m_hOwnerEntity");

    if(IsValidClient(client) && client != shooter)
        return;

    //Remove SDK hook
    SDKUnhook(bullet, SDKHook_StartTouch, OnBulletTouchWall);
    SDKUnhook(bullet, SDKHook_SetTransmit, Hook_BulletSetTransmit);


    //GetClientAbsOrigin(shooter, ShooterORG);

    if(IsClientInGame(shooter) && IsPlayerAlive(shooter))
    {
        //Get player and bullet ORG
        float ShooterORG[3], bulletORG[3];
        GetClientEyePosition(shooter, ShooterORG);
        GetEntPropVector(bullet, Prop_Send, "m_vecOrigin", bulletORG);
        
        //Create explodition
    //	TE_SetupExplosion(bulletORG, g_ExplosionSprite, 10.0, 1, 80, 600, 5000);

        CreateExplosion(bullet);

        /*int AllPlayers[MAXPLAYERS + 1], count = 0;
        LoopAllPlayers(i)
        {
            if(i > 0) 
            {
                if(IsClientInGame(i)) 
                {
                    if(!g_SoundOff[i]) 
                    {
                        AllPlayers[count] = i;
                        count++;
                    }	
                }
            }
        }
        
        TE_Send(AllPlayers, count);*/
        
        //Uncomment if you want loud explode sounds :D
        //EmitSoundToAll(EXPLODE_SOUND, bullet, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, EXPLODE_VOLUME);
            
        //Get distance between bullet and player
        float distance = GetVectorDistance(bulletORG, ShooterORG);
        
        //Kill bullet entity
        AcceptEntityInput(bullet, "kill");
        
        //Make client jump
        RJ_Jump(shooter, distance, bulletORG, ShooterORG);
        
    }
}

public void RJ_Jump(int shooter, float distance, float clientORG[3], float explodeORG[3])
{
    //Check, how far is player from bullet
    if(distance < MAX_DISTANCE)
    {
        bool down = false;
        
        //Create velocity
        float velocity[3];
        MakeVectorFromPoints(clientORG, explodeORG, velocity);
        
        if(velocity[2] < 0)
            down = true;
        
        NormalizeVector(velocity, velocity);
        
        float clientVelocity[3];
        GetEntPropVector(shooter, Prop_Data, "m_vecVelocity", clientVelocity);
        
        ScaleVector(velocity, JUMP_FORCE_MAIN);
        AddVectors(velocity, clientVelocity, velocity);
            
        clientVelocity[2] = 0.0;
        velocity[2] = 0.0;
        
        if (clientVelocity[0] < 0) {
            if (explodeORG[0] > clientORG[0]) {
                ScaleVector(velocity, JUMP_FORCE_FORW);
                
            } else {
                ScaleVector(velocity, JUMP_FORCE_BACK);
            }
        } else {
            if (explodeORG[0] < clientORG[0]) {
                ScaleVector(velocity, JUMP_FORCE_FORW);
                
            } else {
                ScaleVector(velocity, JUMP_FORCE_BACK);
            }
        }
        
        
        if (clientVelocity[1] < 0) {
            
            if (explodeORG[1] > clientORG[1])
                ScaleVector(velocity, JUMP_FORCE_FORW);
            else
                ScaleVector(velocity, JUMP_FORCE_BACK);
                
        } else {
            
            if (explodeORG[1] < clientORG[1])
                ScaleVector(velocity, JUMP_FORCE_FORW);
            else
                ScaleVector(velocity, JUMP_FORCE_BACK);
                
        }
        
        if((GetEntityFlags(shooter) & FL_ONGROUND))
            ScaleVector(velocity, RUN_FORCE_MAIN);


        if(distance > 37.0)
        {
            if(velocity[2] > 0.0)
                velocity[2] = 1000.0 + (JUMP_FORCE_UP * (MAX_DISTANCE - distance));
            else
                velocity[2] = velocity[2] + (JUMP_FORCE_UP * (MAX_DISTANCE - distance));	
        } else {
            
            velocity[2] = velocity[2] + (JUMP_FORCE_UP * (MAX_DISTANCE - distance)) / 1.37;	
        }
        
        if(down)
            velocity[2] *= -1;
        
        TeleportEntity(shooter, NULL_VECTOR, NULL_VECTOR, velocity);

    }

}

public Action Hook_BulletSetTransmit(int entity, int client) 
{ 
    if(IsValidEntity(entity))
    {
        int shooter = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");	
        if(shooter != client && g_bHidePlayers[client])
            return Plugin_Handled;
    }

    return Plugin_Continue;
}

//Fall damage

public Action SoundHook(int clients[64], int &numClients, char sound[PLATFORM_MAX_PATH], int &Ent, int &channel, float &volume, int &level, int &pitch, int &flags)
{
    if (StrEqual(sound, "player/damage1.wav", false)) return Plugin_Stop;
    if (StrEqual(sound, "player/damage2.wav", false)) return Plugin_Stop;
    if (StrEqual(sound, "player/damage3.wav", false)) return Plugin_Stop;

    return Plugin_Continue;
}


//Functions , functions and more functions!!!

void AddInFrontOf(float vecOrigin[3], float vecAngle[3], float units, float output[3])
{
    float vecAngVectors[3];
    vecAngVectors = vecAngle;
    GetAngleVectors(vecAngVectors, vecAngVectors, NULL_VECTOR, NULL_VECTOR);
    for (int i; i < 3; i++)
    output[i] = vecOrigin[i] + (vecAngVectors[i] * units);
}

public void BombMan_OnPreThink(int iClient)
{
    if(IsValidClient(iClient) && IsPlayerAlive(iClient))
    {
        SetEntPropFloat(iClient, Prop_Send, "m_flStamina", 0.0); 
    }
}

int waterCheck(int client)
{
    return GetEntProp(client, Prop_Data, "m_nWaterLevel");
}

stock bool IsValidClient(int client)
{
    if(client <= 0 ) return false;
    if(client > MaxClients) return false;
    if(!IsClientConnected(client)) return false;
    return IsClientInGame(client);
}

public Action TE_OnEffectDispatch(const char[] te_name, const Players[], int numClients, float delay)
{
    int iEffectIndex = TE_ReadNum("m_iEffectName");
    char sEffectName[9];

    ReadStringTable(g_iUtils_EffectDispatchTable, iEffectIndex, sEffectName, sizeof(sEffectName));

    if(StrEqual(sEffectName, "csblood"))
        return Plugin_Handled;

    return Plugin_Continue;
}

public Action TE_OnDecal(const char[] te_name, const Players[], int numClients, float delay)
{
    int nIndex = TE_ReadNum("m_nIndex");
    char sDecalName[13];

    ReadStringTable(g_iUtils_DecalPrecacheTable, nIndex, sDecalName, sizeof(sDecalName));
        
    if(StrEqual(sDecalName, "decals/blood"))
        return Plugin_Handled;

    return Plugin_Continue;
}  

public Action CSS_Hook_ShotgunShot(const char[] te_name, const Players[], int numClients, float delay)
{
	
    // Check which clients need to be excluded.
    decl newClients[MaxClients], client, i;
    int newTotal = 0;

    for (i = 0; i < numClients; i++)
    {
        client = Players[i];
        
        if (!g_bStopSound[client])
        {
            newClients[newTotal++] = client;
        }
    }

    // No clients were excluded.
    if (newTotal == numClients)
        return Plugin_Continue;

    // All clients were excluded and there is no need to broadcast.
    else if (newTotal == 0)
        return Plugin_Stop;

    // Re-broadcast to clients that still need it.
    float vTemp[3];
    TE_Start("Shotgun Shot");
    TE_ReadVector("m_vecOrigin", vTemp);
    TE_WriteVector("m_vecOrigin", vTemp);
    TE_WriteFloat("m_vecAngles[0]", TE_ReadFloat("m_vecAngles[0]"));
    TE_WriteFloat("m_vecAngles[1]", TE_ReadFloat("m_vecAngles[1]"));
    TE_WriteNum("m_iWeaponID", TE_ReadNum("m_iWeaponID"));
    TE_WriteNum("m_iMode", TE_ReadNum("m_iMode"));
    TE_WriteNum("m_iSeed", TE_ReadNum("m_iSeed"));
    TE_WriteNum("m_iPlayer", TE_ReadNum("m_iPlayer"));
    TE_WriteFloat("m_fInaccuracy", TE_ReadFloat("m_fInaccuracy"));
    TE_WriteFloat("m_fSpread", TE_ReadFloat("m_fSpread"));
    TE_Send(newClients, newTotal, delay);

    return Plugin_Stop;
}
