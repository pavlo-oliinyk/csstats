/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <csx>
#include <string>
#include <time>

#define PLUGIN "CS Stats per rpound"
#define VERSION "1.0"
#define AUTHOR "cs16tech"

new g_inGame[33]
new maxPlayersCount

new roundStartDay
new roundStartMonth
new roundStartYear
new roundStartString[255]

new roundId;

public plugin_init() {
	register_plugin("CS Stats per rpound", AMXX_VERSION_STR, "cs16tech")
	
	maxPlayersCount = 32
	roundId = 0;
	
	register_logevent("round_ends",2,"3=Terrorists_Win", "3=CTs_Win")
	register_logevent("round_starts",2,"1=Round_Start")
}

public client_connect(id)
{
	g_inGame[id] = 0
}

public client_putinserver(id)
{
	g_inGame[id] = 1
}

public client_disconnect(id)
{
	if (!g_inGame[id])
		return
		
	g_inGame[id] = 0
	
	write_player_stats(id)
}

public round_starts(){
	
	roundId++;
	set_round_start_time()
}

public round_ends(){

	set_task(0.25, "write_all_players_stats", 1, "", 0)
}

public write_all_players_stats(id){
	
	for(new i = 1 ; i <= maxPlayersCount ; i++)
	{
		if(!g_inGame[i])
			continue
		
		write_player_stats(i)
	}
}

public write_player_stats(id){

	if (is_user_bot(id))
	{
		return
	}
	
	new szTeam[16], szName[32], szAuthid[32], iStats[8], iHits[8], szWeapon[25]
	new iUserid = get_user_userid(id)
	new _max = xmod_get_maxweapons()
	new wasStatsWriten = 0
	
	get_user_team(id, szTeam, 15)
	get_user_name(id, szName, 31)
	get_user_authid(id, szAuthid, 31)

	for (new i = 1 ; i < _max ; ++i)
	{
		if (get_user_wrstats(id, i, iStats, iHits))
		{
			xmod_get_wpnname(i, szWeapon, 25)
			
			new logstr[450]
			new buffer[150]
			
			format(buffer, 150, "^"RoundStartTime^":^"%s^";^"RoundId^":^"%d^";^"PlayerName^":^"%s^";^"Team^":^"%s^";", roundStartString, roundId, szName, szTeam)
			strcat(logstr, buffer, 450)
			
			format(buffer, 150, "^"Weapon^":^"%s^";^"Shots^":^"%d^";^"Hits^":^"%d^";^"Kills^":^"%d^";^"Headshots^":^"%d^";^"Tks^":^"%d^";^"Damage^":^"%d^";^"Deaths^":^"%d^";", 
						szWeapon, iStats[4], iStats[5], iStats[0], iStats[2], iStats[3], iStats[6], iStats[1])
			strcat(logstr, buffer, 450)
			
			format(buffer, 150, "^"Head^":^"%d^";^"Chest^":^"%d^";^"Stomach^":^"%d^";^"Leftarm^":^"%d^";^"Rightarm^":^"%d^";^"Leftleg^":^"%d^";^"Rightleg^":^"%d^"", 
						iHits[1], iHits[2], iHits[3], iHits[4], iHits[5], iHits[6], iHits[7])
			strcat(logstr, buffer, 450)
			
			write_string_to_file(logstr)
			
			wasStatsWriten = 1
		}
	}
	
	if(wasStatsWriten == 0) {
		
		write_empty_stats(szName, szTeam)
	}
}

public write_empty_stats(szName[32], szTeam[16]) {
	
	new logstr[450]
	new buffer[150]
			
	format(buffer, 150, "^"RoundStartTime^":^"%s^";^"RoundId^":^"%d^";^"PlayerName^":^"%s^";^"Team^":^"%s^";", roundStartString, roundId, szName, szTeam)
	strcat(logstr, buffer, 450)
	
	format(buffer, 150, "^"Weapon^":^"^";^"Shots^":^"0^";^"Hits^":^"0^";^"Kills^":^"0^";^"Headshots^":^"0^";^"Tks^":^"0^";^"Damage^":^"0^";^"Deaths^":^"0^";")
	strcat(logstr, buffer, 450)
	
	format(buffer, 150, "^"Head^":^"0^";^"Chest^":^"0^";^"Stomach^":^"0^";^"Leftarm^":^"0^";^"Rightarm^":^"0^";^"Leftleg^":^"0^";^"Rightleg^":^"0^"")
	strcat(logstr, buffer, 450)
	
	write_string_to_file(logstr)
}

public write_string_to_file(const text[]){
	
	new filename[100]
	format(filename, 100, "addons/amxmodx/logs/%d-%d-%d_stats.txt", roundStartYear, roundStartMonth, roundStartDay)
	
	write_file(filename,text,-1)
}

public set_round_start_time(){
	
	new roundStartHour
	new roundStartMinute
	new roundStartSecound

	date(roundStartYear,roundStartMonth,roundStartDay)
	time(roundStartHour,roundStartMinute,roundStartSecound)
	
	format(roundStartString, 255, "%d-%d-%d %d:%d:%d", roundStartYear, roundStartMonth, roundStartDay, roundStartHour, roundStartMinute, roundStartSecound)
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1251\\ deff0\\ deflang1049{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ f0\\ fs16 \n\\ par }
*/