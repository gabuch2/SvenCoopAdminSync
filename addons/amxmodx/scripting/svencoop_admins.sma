#include <amxmodx>
#include <amxmisc>

#define PLUGIN_NAME     "Sven Co-op Admin Sync"
#define PLUGIN_VERSION  "1.0.1"
#define PLUGIN_AUTHOR   "gabuch2"

#pragma semicolon 1

new g_cvarEnabled, g_cvarOwnerFlags, g_cvarAdminFlags, g_cvarAdminsFile;

new g_iPluginFlags;

public plugin_init()
{
    register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);

    g_cvarEnabled = register_cvar("amx_svenadmin_enabled", "1");
    g_cvarOwnerFlags = register_cvar("amx_svenadmin_ownerflags", "abcdefghijklmnopqrstuv", FCVAR_PROTECTED);
    g_cvarAdminFlags = register_cvar("amx_svenadmin_adminflags", "bcdefghijklmnopqrstuv", FCVAR_PROTECTED);
    g_cvarAdminsFile = get_cvar_pointer("adminsfile");
    register_cvar("amx_svenadmin_version", PLUGIN_VERSION, FCVAR_SERVER);

    g_iPluginFlags = plugin_flags();
}

public plugin_cfg()
{
    if(get_pcvar_bool(g_cvarEnabled))
    {
        new sOwnerFlags[32];
        new sAdminFlags[32];
        new sAdminsFile[32];
        get_pcvar_string(g_cvarOwnerFlags, sOwnerFlags, charsmax(sOwnerFlags));
        get_pcvar_string(g_cvarAdminFlags, sAdminFlags, charsmax(sAdminFlags));
        get_pcvar_string(g_cvarAdminsFile, sAdminsFile, charsmax(sAdminsFile));
        new hAdminFile = fopen(sAdminsFile, "w");

        if(hAdminFile == INVALID_HANDLE)
            set_fail_state("Can't open admin file");

        if(g_iPluginFlags & AMX_FLAG_DEBUG)
            server_print("[Sven Co-op Admins] AMXX admin count: %d", admins_num());

        if(admins_num() > 0)
        {
            for(new x=0; x < admins_num();x++)
            {
                new sAuthId[64];
                if(g_iPluginFlags & AMX_FLAG_DEBUG)
                    server_print("[Sven Co-op Admins] Looking up admin: %d", x);
                new iAuthFlags = admins_lookup(x, AdminProp_Flags);
                if(g_iPluginFlags & AMX_FLAG_DEBUG)
                    server_print("[Sven Co-op Admins] Admin %d authflags are %d", x, iAuthFlags);
                if(iAuthFlags & FLAG_AUTHID)
                {
                    if(g_iPluginFlags & AMX_FLAG_DEBUG)
                        server_print("[Sven Co-op Admins] Admin %d is SteamID", x);
                    //is steamID
                    //check if user has required permissions
                    new iAuthAccess = admins_lookup(x, AdminProp_Access);
                    if(g_iPluginFlags & AMX_FLAG_DEBUG)
                        server_print("[Sven Co-op Admins] Admin %d permissions are %d. C-OWNER %d. C-ADMIN %d", x, iAuthAccess, iAuthAccess & read_flags(sOwnerFlags), iAuthAccess & read_flags(sAdminFlags));

                    admins_lookup(x, AdminProp_Auth, sAuthId, charsmax(sAuthId));

                    if(iAuthAccess & read_flags(sOwnerFlags) == read_flags(sOwnerFlags))
                    {
                        if(g_iPluginFlags & AMX_FLAG_DEBUG)
                        {
                            server_print("[Sven Co-op Admins] Admin %d is an owner.", x);
                            server_print("[Sven Co-op Admins] Writing *%s into file.", sAuthId);
                        }
                        fputs(hAdminFile, "*");
                        fputs(hAdminFile, sAuthId);
                        fputs(hAdminFile, "^n");
                    }
                    else if(iAuthAccess & read_flags(sAdminFlags) == read_flags(sAdminFlags))
                    {
                        if(g_iPluginFlags & AMX_FLAG_DEBUG)
                        {
                            server_print("[Sven Co-op Admins] Admin %d is an administrator.", x);
                            server_print("[Sven Co-op Admins] Writing %s into file.", sAuthId);
                        }
                        fputs(hAdminFile, sAuthId);
                        fputs(hAdminFile, "^n");
                        continue;
                    }
                    else
                    {
                        if(g_iPluginFlags & AMX_FLAG_DEBUG)
                            server_print("[Sven Co-op Admins] Admin %d isn't an administrator or owner.", x);
                    }
                }
                else
                    continue;
            }

            fclose(hAdminFile);
        }
    }
    else
        pause("ad");
}

#if AMXX_VERSION_NUM < 183
stock get_pcvar_bool(const iHandle)
{
	return get_pcvar_num(iHandle) != 0;
}
#endif