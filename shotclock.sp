#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "0.1.0"
#define RED 2
#define BLU 3

public Plugin:myinfo =
{
    name = "5CP Shot Clock",
    author = "twiikuu",
    description = "Reduce round timers and attribute points to whichever are holding offensive points",
    version = PLUGIN_VERSION,
    url = "https://github.com/ldesgoui/tf2-5cp-shotclock"
    // thanks to ChrisWalkerTalker, GEMM, neto
};

enum {
    RED_CAPTURED_SECOND = 0,
    RED_CAPTURED_MIDDLE,
    MIDDLE_UNTOUCHED,
    BLU_CAPTURED_MIDDLE,
    BLU_CAPTURED_SECOND
}

new g_state = MIDDLE_UNTOUCHED;
new Handle: g_score_last = INVALID_HANDLE;
new Handle: g_score_middle = INVALID_HANDLE;
new Handle: g_score_second = INVALID_HANDLE;
new Handle: g_time_last = INVALID_HANDLE;
new Handle: g_time_middle = INVALID_HANDLE;
new Handle: g_time_second = INVALID_HANDLE;

public OnPluginStart()
{
    CreateConVar("sm_shotclock_version", PLUGIN_VERSION, "5CP Shot Clock Version", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY);
    g_score_last = CreateConVar("sm_shotclock_score_last", "4", "", _, true, 1, false, 0);
    g_score_second = CreateConVar("sm_shotclock_score_second", "2", "", _, true, 0, false, 0);
    g_score_middle = CreateConVar("sm_shotclock_score_middle", "1", "", _, true, 0, false, 0);
    g_time_last = CreateConVar("sm_shotclock_time_last", "60", "", _, true, 0, false, 0);
    g_time_second = CreateConVar("sm_shotclock_time_second", "120", "", _, true, 0, false, 0);
    g_time_middle = CreateConVar("sm_shotclock_time_middle", "305", "", _, true, 0, false, 0);
    HookEvent("teamplay_point_captured", Event_PointCaptured);
    HookEvent("teamplay_round_start", Event_RoundStart);
    HookEvent("teamplay_round_win", Event_RoundWin);
}

public Action:Event_PointCaptured(Handle: event, const String: name[], bool: dontBroadcast) {
    g_state = GetEventInt(event, "cp") + ( GetEventInt(event, "team") == RED ? -1 : 1 );
    CreateTimer(0.01, updateTime);
}

public Action:Event_RoundStart(Handle: event, const String: name[], bool: dontBroadcast) {
    setTime(GetConVarInt(g_time_middle));
    g_state = MIDDLE_UNTOUCHED;
}

public Action:Event_RoundWin(Handle: event, const String: name[], bool: dontBroadcast) {
    new team = GetEventInt(event, "team");

    // TODO: Show this on end of round screen

    if (team != 0) {
        SetTeamScore(team, GetTeamScore(team) + GetConVarInt(g_score_last) - 1);
    } else if (g_state == RED_CAPTURED_SECOND) {
        SetTeamScore(RED, GetTeamScore(RED) + GetConVarInt(g_score_second));
    } else if (g_state == RED_CAPTURED_MIDDLE) {
        SetTeamScore(RED, GetTeamScore(RED) + GetConVarInt(g_score_middle));
    } else if (g_state == BLU_CAPTURED_MIDDLE) {
        SetTeamScore(BLU, GetTeamScore(BLU) + GetConVarInt(g_score_middle));
    } else if (g_state == BLU_CAPTURED_SECOND) {
        SetTeamScore(BLU, GetTeamScore(BLU) + GetConVarInt(g_score_second));
    }
}

Action updateTime(Handle timer) {
    KillTimer(timer);
    if (g_state == RED_CAPTURED_SECOND || g_state == BLU_CAPTURED_SECOND) {
        setTime(GetConVarInt(g_time_last));
    } else if (g_state == RED_CAPTURED_MIDDLE || g_state == BLU_CAPTURED_MIDDLE) {
        setTime(GetConVarInt(g_time_second));
    }
}

void setTime(int time) {
    new timer = FindEntityByClassname(-1, "team_round_timer");

    if (timer > -1) {
        SetVariantInt(time);
        AcceptEntityInput(timer, "SetTime");
    } else {
        // Not found ?
    }
}
