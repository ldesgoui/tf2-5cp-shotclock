#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <tf2>

#define PLUGIN_VERSION "0.2.0"
#define MIDDLE_UNTOUCHED -1
#define RED_CAPTURED_LAST 0
#define RED_CAPTURED_SECOND 1
#define RED_CAPTURED_MIDDLE 2
#define BLU_CAPTURED_MIDDLE 3
#define BLU_CAPTURED_SECOND 4
#define BLU_CAPTURED_LAST 5

public Plugin myinfo = {
    name = "5CP Shot Clock",
    author = "twiikuu",
    description = "Reduce round timers and attribute points to whichever are holding offensive points",
    version = PLUGIN_VERSION,
    url = "https://github.com/ldesgoui/tf2-5cp-shotclock"
    // thanks to ChrisWalkerTalker, GEMM, neto
};

static int g_state = MIDDLE_UNTOUCHED;
static Handle g_enabled = INVALID_HANDLE;
static Handle g_score_last = INVALID_HANDLE;
static Handle g_score_middle = INVALID_HANDLE;
static Handle g_score_second = INVALID_HANDLE;
static Handle g_time_last = INVALID_HANDLE;
static Handle g_time_middle = INVALID_HANDLE;
static Handle g_time_second = INVALID_HANDLE;

public void OnPluginStart() {
    CreateConVar("sm_shotclock_version", PLUGIN_VERSION, "5CP Shot Clock Version", FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY);
    g_enabled      = CreateConVar("sm_shotclock",              "0",   "", FCVAR_NOTIFY, true, 0.0, true,  1.0);
    g_score_last   = CreateConVar("sm_shotclock_score_last",   "4",   "", FCVAR_NOTIFY, true, 1.0, false, 0.0);
    g_score_second = CreateConVar("sm_shotclock_score_second", "2",   "", FCVAR_NOTIFY, true, 0.0, false, 0.0);
    g_score_middle = CreateConVar("sm_shotclock_score_middle", "1",   "", FCVAR_NOTIFY, true, 0.0, false, 0.0);
    g_time_last    = CreateConVar("sm_shotclock_time_last",    "60",  "", FCVAR_NOTIFY, true, 0.0, false, 0.0);
    g_time_second  = CreateConVar("sm_shotclock_time_second",  "120", "", FCVAR_NOTIFY, true, 0.0, false, 0.0);
    g_time_middle  = CreateConVar("sm_shotclock_time_middle",  "305", "", FCVAR_NOTIFY, true, 0.0, false, 0.0);
    HookEvent("teamplay_point_captured", Event_PointCaptured);
    HookEvent("teamplay_round_start", Event_RoundStart);
    HookEvent("teamplay_round_win", Event_RoundWin);
}

public void Event_PointCaptured(Event event, const char[] name, bool dontBroadcast) {
    if (!GetConVarBool(g_enabled)) { return ; }

    g_state = GetEventInt(event, "cp") + ( GetEventInt(event, "team") == TFTeam_Red ? 0 : 1 );
    CreateTimer(0.0, updateTime);
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
    if (!GetConVarBool(g_enabled)) { return ; }

    g_state = MIDDLE_UNTOUCHED;
    setTime(g_time_middle);
}

public void Event_RoundWin(Event event, const char[] name, bool dontBroadcast) {
    if (!GetConVarBool(g_enabled)) { return ; }

    int team = GetEventInt(event, "team");

    // TODO: Show this on end of round screen

    if (team == TFTeam_Unassigned) {
        switch (g_state) {
            case MIDDLE_UNTOUCHED:
                {}
            case RED_CAPTURED_MIDDLE:
                SetTeamScore(TFTeam_Red, GetTeamScore(TFTeam_Red) + GetConVarInt(g_score_middle));
            case BLU_CAPTURED_MIDDLE:
                SetTeamScore(TFTeam_Blue, GetTeamScore(TFTeam_Blue) + GetConVarInt(g_score_middle));
            case RED_CAPTURED_SECOND:
                SetTeamScore(TFTeam_Red, GetTeamScore(TFTeam_Red) + GetConVarInt(g_score_second));
            case BLU_CAPTURED_SECOND:
                SetTeamScore(TFTeam_Blue, GetTeamScore(TFTeam_Blue) + GetConVarInt(g_score_second));
            default:
                PrintToChatAll("UNKNOWN WIN CASE winner:%i state:%i", team, g_state);
        }
    } else {
        SetTeamScore(team, GetTeamScore(team) + GetConVarInt(g_score_last) - 1);
    }
    PrintToChatAll("Round ended, score: RED %i - %i BLU", GetTeamScore(TFTeam_Red), GetTeamScore(TFTeam_Blue));
}

static Action updateTime(Handle timer) {
    KillTimer(timer);

    switch (g_state) {
        case MIDDLE_UNTOUCHED:
            setTime(g_time_middle);
        case RED_CAPTURED_MIDDLE:
            setTime(g_time_second);
        case BLU_CAPTURED_MIDDLE:
            setTime(g_time_second);
        case RED_CAPTURED_SECOND:
            setTime(g_time_last);
        case BLU_CAPTURED_SECOND:
            setTime(g_time_last);
        case RED_CAPTURED_LAST:
            {}
        case BLU_CAPTURED_LAST:
            {}
        default:
            PrintToChatAll("UNKNOWN CAP CASE state:%i", g_state);
    }
}

static void setTime(Handle convar) {
    int time = GetConVarInt(convar);
    int timer = FindEntityByClassname(-1, "team_round_timer");

    if (timer > -1) {
        SetVariantInt(time);
        AcceptEntityInput(timer, "SetTime");
        PrintToChatAll("Shot Clock set to %i:%02i", time / 60, time % 60);
    } else {
        PrintToChatAll("Shot Clock could not be set, round timer not found.");
    }
}
