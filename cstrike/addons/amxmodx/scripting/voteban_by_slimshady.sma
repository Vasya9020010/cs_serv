/*
������� �� ����� - ������, ����������� ICQ 444444987.
---
������� ������ ������������� �� ������ � �������� ������� ����� ����� �
���� ���, ��� ����������� ���� ��� ��� �����.
---
���� ���� ���������, �� ��� � ����� 10.12.11
---
���� ������� ��� �������� �� ��� ������� ����� QIWI 89177318745
---
�������, ��� ���� ����� ���. ������ CS:GO ������� CS:1.6 ������ �� ������. 
---
� �������� �������� �������, �� ���� ������ �� ���������.
*/
#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <colorchat>

#define MAX_players 32
#define MAX_menudata 1024
#define PLUGIN "VOTEBAN_BY_SLIMSHADY"

new ga_PlayerName[MAX_players][32]
new ga_PlayerAuthID[MAX_players][35]
new ga_PlayerID[MAX_players]
new ga_PlayerIP[MAX_players][16]
new ga_MenuData[MAX_menudata]
new ga_Choice[2]
new gi_VoteStarter
new gi_MenuPosition
new gi_Sellection
new gi_TotalPlayers
new gi_SysTimeOffset = 0
new i
new idol
new idoll[32]
new TempID
new HudSync
new voted
new gi_LastTime
new gi_DelayTime
new gf_Ratio
new gf_MinVoters
new gf_BF_Ratio
new gi_Disable
new szArgs[512]
new timemenu
new gi_BanTime,datestr[11], timestr[9], title[256]
new menutime1,menutime2,menutime3,menutime4,menutime5, adminonline, votetime, banpush, bancfg, menushow, bug, type
new zero = 0

public plugin_init()
{
  register_plugin("VOTEBAN_BY_SLIMSHADY","3.0","SLIMSHADY_MOD")
  register_clcmd("say /voteban","SayIt" )
  register_clcmd("say voteban","SayIt" )
  register_clcmd("say /vtb","SayIt" )
  register_menucmd(register_menuid("ChoosePlayer"),1023,"ChooseMenu")
  register_menucmd(register_menuid("VoteMenu"),1023,"CountVotes")
  register_clcmd("messagemode5", "ClCmdMessageMode3")
  register_clcmd("RUS", "xax")

  gi_LastTime=register_cvar("amxx_voteban_lasttime","0")
  gi_DelayTime=register_cvar("amxx_voteban_delaytime","500")
  gf_Ratio=register_cvar("amxx_voteban_ratio","0.70")
  timemenu=register_cvar("amxx_voteban_timemenu", "1")
  gf_MinVoters=register_cvar("amxx_voteban_minvoters","0.0")
  bancfg=register_cvar("amxx_voteban_bancfg", "amx_ban %name% %time% %reason%")
  gf_BF_Ratio=register_cvar("amxx_voteban_bf_ratio","0.20")
  gi_Disable=register_cvar("amxx_voteban_disable","0")
  gi_BanTime=register_cvar("amxx_voteban_bantime", "60")
  adminonline=register_cvar("amxx_voteban_admin", "1")
  menushow=register_cvar("amxx_voteban_nomshow", "0")
  votetime=register_cvar("amxx_voteban_votetime", "30.0")
  menutime1=register_cvar("menutime1", "15")
  menutime2=register_cvar("menutime2", "30")
  menutime3=register_cvar("menutime3", "60")
  menutime4=register_cvar("menutime4", "120")
  menutime5=register_cvar("menutime5", "180")
  HudSync = CreateHudSyncObj()
  
}


public plugin_cfg()
{
	new configsdir[128]
	get_localinfo("amxx_configsdir", configsdir, 127)
	return server_cmd("exec %s/voteban.cfg", configsdir)
}




public ClCmdMessageMode3(id) 
{
client_cmd(id, "messagemode RUS")
ColorChat(id, RED, "[VOTEBAN] Введите причину голосования для этого игрока (наверху, на русском).")
}




public xax(id)
   {

    read_args(szArgs, 511)
    remove_quotes(szArgs)
    while (replace(szArgs, 511, "q", "й")) {}
    while (replace(szArgs, 511, "w", "ц")) {}
    while (replace(szArgs, 511, "e", "у")) {}
    while (replace(szArgs, 511, "r", "к")) {}
    while (replace(szArgs, 511, "t", "е")) {}
    while (replace(szArgs, 511, "y", "н")) {}
    while (replace(szArgs, 511, "u", "г")) {}
    while (replace(szArgs, 511, "i", "ш")) {}
    while (replace(szArgs, 511, "o", "щ")) {}
    while (replace(szArgs, 511, "p", "з")) {}
    while (replace(szArgs, 511, "[", "х")) {}
    while (replace(szArgs, 511, "]", "ъ")) {}
    while (replace(szArgs, 511, "a", "ф")) {}
    while (replace(szArgs, 511, "s", "ы")) {}
    while (replace(szArgs, 511, "d", "в")) {}
    while (replace(szArgs, 511, "f", "а")) {}
    while (replace(szArgs, 511, "g", "п")) {}
    while (replace(szArgs, 511, "h", "р")) {}
    while (replace(szArgs, 511, "j", "о")) {}
    while (replace(szArgs, 511, "k", "л")) {}
    while (replace(szArgs, 511, "l", "д")) {}
    while (replace(szArgs, 511, ";", "ж")) {}
    while (replace(szArgs, 511, "'", "э")) {}
    while (replace(szArgs, 511, "z", "я")) {}
    while (replace(szArgs, 511, "x", "ч")) {}
    while (replace(szArgs, 511, "c", "с")) {}
    while (replace(szArgs, 511, "v", "м")) {}
    while (replace(szArgs, 511, "b", "и")) {}
    while (replace(szArgs, 511, "n", "т")) {}
    while (replace(szArgs, 511, "m", "ь")) {}
    while (replace(szArgs, 511, ",", "б")) {}
    while (replace(szArgs, 511, ".", "ю")) {}
    while (replace(szArgs, 511, "Q", "Й")) {}
    while (replace(szArgs, 511, "W", "Ц")) {}
    while (replace(szArgs, 511, "E", "У")) {}
    while (replace(szArgs, 511, "R", "К")) {}
    while (replace(szArgs, 511, "T", "Е")) {}
    while (replace(szArgs, 511, "Y", "Н")) {}
    while (replace(szArgs, 511, "U", "Г")) {}
    while (replace(szArgs, 511, "I", "Ш")) {}
    while (replace(szArgs, 511, "O", "Щ")) {}
    while (replace(szArgs, 511, "P", "З")) {}
    while (replace(szArgs, 511, "{", "Х")) {}
    while (replace(szArgs, 511, "}", "Ъ")) {}
    while (replace(szArgs, 511, "A", "Ф")) {}
    while (replace(szArgs, 511, "S", "Ы")) {}
    while (replace(szArgs, 511, "D", "В")) {}
    while (replace(szArgs, 511, "F", "А")) {}
    while (replace(szArgs, 511, "G", "П")) {}
    while (replace(szArgs, 511, "H", "Р")) {}
    while (replace(szArgs, 511, "J", "О")) {}
    while (replace(szArgs, 511, "K", "Л")) {}
    while (replace(szArgs, 511, "L", "Д")) {}
    while (replace(szArgs, 511, ":", "Ж")) {}
    while (replace(szArgs, 511, "Z", "Я")) {}
    while (replace(szArgs, 511, "X", "Ч")) {}
    while (replace(szArgs, 511, "C", "С")) {}
    while (replace(szArgs, 511, "V", "М")) {}
    while (replace(szArgs, 511, "B", "И")) {}
    while (replace(szArgs, 511, "N", "Т")) {}
    while (replace(szArgs, 511, "M", "Ь")) {}
    while (replace(szArgs, 511, "<", "Б")) {}
    while (replace(szArgs, 511, ">", "Ю")) {}
    if(get_pcvar_num(timemenu) == 1)
    {
    timed(id)
   }
    else
   {
   run_vote()
   }
  }


public SayIt(id)
{
  if(get_pcvar_num(gi_Disable))
  {
    ColorChat(id,RED,"[VOTEBAN] VoteBan отключен администратором.")
    return 0
  }

  new Elapsed=get_systime(gi_SysTimeOffset) - get_pcvar_num(gi_LastTime)
  new Delay=get_pcvar_num(gi_DelayTime)

  if((Delay > Elapsed) && !is_user_admin(id))
  {
    new seconds = Delay - Elapsed
    ColorChat(id,RED,"[VOTEBAN] Голосование возможно через %d секунд.",seconds)
    return 0
  }
 
  if(task_exists())
  {
  ColorChat(id,RED,"[VOTEBAN] Дождитесь завершения предыдущего голосования.")
  return 0
}
  get_players(ga_PlayerID,gi_TotalPlayers)
  for(i=0;i<gi_TotalPlayers;i++)
{
   TempID = ga_PlayerID[i]
   if(get_user_flags(TempID) & ADMIN_IMMUNITY)
{
   if(!is_user_admin(id) && get_pcvar_num(adminonline) == 0)
      {
        ColorChat(id,RED,"[VOTEBAN] Администратор в сети. VoteBan в это время отключен.")
        return 0
      }
}
  
if(TempID == id)
gi_VoteStarter=i
bug = get_user_index(ga_PlayerName[gi_VoteStarter])

get_user_name(TempID,ga_PlayerName[i],31)
get_user_authid(TempID,ga_PlayerAuthID[i],34)
get_user_ip(TempID,ga_PlayerIP[i],15,1)
}

  gi_MenuPosition = 0
  ShowPlayerMenu(id)
  return 0
}


public timed(id)
{
	new style[64], style2[64], style3[64], style4[64], style5[64]
	formatex(style, charsmax(style), "\r%d \wминут", get_pcvar_num(menutime1))
	formatex(style2, charsmax(style2), "\r%d \wминут", get_pcvar_num(menutime2))
	formatex(style3, charsmax(style3), "\r%d \wминут", get_pcvar_num(menutime3))
	formatex(style4, charsmax(style4), "\r%d \wминут", get_pcvar_num(menutime4))
	formatex(style5, charsmax(style5), "\r%d \wминут", get_pcvar_num(menutime5))
	new i_Menu = menu_create("\rВыбери время бана:", "server_menu")
	menu_additem(i_Menu, style, "1", 0)
	menu_additem(i_Menu, style2, "2", 0)
	menu_additem(i_Menu, style3, "3", 0)
	menu_additem(i_Menu, style4, "4", 0)
	menu_additem(i_Menu, style5, "5", 0)
	
	menu_setprop(i_Menu, MPROP_EXIT, MEXIT_ALL)
	if(id == bug)
	{
	menu_display(id, i_Menu, 0)
	}
	else
	{
	client_print(id, print_chat, "What you want men?! BYE!")	
	}
	return PLUGIN_HANDLED

	
}



public server_menu(id, menu, item)
	{

	if (item == MENU_EXIT)
	{
	menu_destroy(menu)
        
	return PLUGIN_HANDLED
	}

	new s_Data[6], s_Name[64], i_Access, i_Callback

	menu_item_getinfo(menu, item, i_Access, s_Data, charsmax(s_Data), s_Name, charsmax(s_Name), i_Callback)

	new i_Key = str_to_num(s_Data)

	switch(i_Key)
	{
        
case 1:
	{
	banpush = get_pcvar_num(menutime1)
	run_vote()
	}
case 2:
	{
	banpush = get_pcvar_num(menutime2)
	run_vote()
	}
case 3:
	{
	banpush = get_pcvar_num(menutime3)
	run_vote()
	}
case 4:
	{
	banpush = get_pcvar_num(menutime4)
	run_vote()
	}
case 5:
	{
	banpush = get_pcvar_num(menutime5)
	run_vote()
	}
	
	
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
	}





public ShowPlayerMenu(id)
{
    new arrayloc = 0
    new keys = (1<<9)

    arrayloc = format(ga_MenuData,(MAX_menudata-1),"\r[\wVOTEBAN\r] \wУкажи игрока:^n")
    for(i=0;i<8;i++)

    if( gi_TotalPlayers>(gi_MenuPosition+i))
   {
     new addmin = get_user_index(ga_PlayerName[gi_MenuPosition+i])
     if(is_user_admin(addmin))
     {
     arrayloc += format(ga_MenuData[arrayloc],(MAX_menudata-1-arrayloc),"\y%d.\w%s \y[\wadmin\y]^n",i+1,ga_PlayerName[gi_MenuPosition+i])
     keys |= (1<<i)  	
}
     else
     {
     arrayloc += format(ga_MenuData[arrayloc],(MAX_menudata-1-arrayloc),"\y%d.\w%s^n",i+1,ga_PlayerName[gi_MenuPosition+i])
     keys |= (1<<i)
   }
  }
    if( gi_TotalPlayers>(gi_MenuPosition+8))
  {
    arrayloc += format(ga_MenuData[arrayloc],(MAX_menudata-1-arrayloc),"^n\y9.\r[\wДалее\r]")
    keys |= (1<<8)
   }
    arrayloc += format(ga_MenuData[arrayloc],(MAX_menudata-1-arrayloc),"^n\y0.\r[\wВыход\r]")

    show_menu(id,keys,ga_MenuData,20,"ChoosePlayer")
    return PLUGIN_HANDLED 
}

public ChooseMenu(id,key)
{
  switch(key)
  {
    case 8:
    {
      gi_MenuPosition=gi_MenuPosition+8
      ShowPlayerMenu(id)
    }
    case 9:
    {
      if(gi_MenuPosition>=8)
      {
        gi_MenuPosition=gi_MenuPosition-8
        ShowPlayerMenu(id)
      }
      else
        return 0
    }
    default:
    {
      gi_Sellection=gi_MenuPosition+key
      new admin = get_user_index(ga_PlayerName[gi_Sellection])
      if (get_user_flags(admin) & ADMIN_IMMUNITY)
      {
      	ColorChat(id, RED, "[VOTEBAN] ^x04%s ^x03является админом!", ga_PlayerName[gi_Sellection])
	return 0
}
      else
      {
      ClCmdMessageMode3(id)
      return 0
    }
   }
  }
  return PLUGIN_HANDLED
}

public run_vote()
{
  idol = get_user_index(ga_PlayerName[gi_Sellection])
  if(get_pcvar_num(timemenu) != 1)
    {
    banpush =  get_pcvar_num(gi_BanTime)
   }
  new Now=get_systime(gi_SysTimeOffset)
  set_pcvar_num(gi_LastTime, Now)
  get_time("%Y.%m.%d", datestr, 10)
  get_time("%H:%M:%S", timestr, 8)
  formatex(title, charsmax(title), "---^nVB enable %s for %s on %s %s", ga_PlayerName[gi_VoteStarter],ga_PlayerName[gi_Sellection], datestr, timestr)
  write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
  formatex(title, charsmax(title), "REASON: %s", szArgs)
  write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
  format(ga_MenuData,(MAX_menudata-1),"Инициатор голосования \y%s^n\wПричина: \r%s^n\wЗабанить \r%s \wна \r%d \wминут?^n(\y%d \wфрагов | \y%d \wсмертей)^n\y1.\wДа^n\y2.\wНет",ga_PlayerName[gi_VoteStarter],szArgs,ga_PlayerName[gi_Sellection],banpush,get_user_frags(idol),get_user_deaths(idol))
  ga_Choice[0] = 0
  ga_Choice[1] = 0
  set_task(get_pcvar_float(votetime),"outcom")
  for(new i = 1; i <= get_maxplayers(); i++)
  if(i == idol)
  {
  if(get_pcvar_num(menushow) == 1)
  {
  	if(is_user_connected(i))
	{
  show_menu(i,(1<<0)|(1<<1),ga_MenuData,get_pcvar_num(votetime),"VoteMenu" )
  ColorChat(i, RED, "[VOTEBAN] Голосование запустил ^x04%s ^x03против ^x04%s", ga_PlayerName[gi_VoteStarter],ga_PlayerName[gi_Sellection])
 }
 }
  else 
 {
  ColorChat(i, RED, "[VOTEBAN] You was a nominated on Voteban! You can't use vote.")
}
}
   else if(i != idol)
{
  	if(is_user_connected(i))
	{
 show_menu(i,(1<<0)|(1<<1),ga_MenuData,get_pcvar_num(votetime),"VoteMenu" )
 ColorChat(i, RED, "[VOTEBAN] Голосование запустил ^x04%s ^x03против ^x04%s", ga_PlayerName[gi_VoteStarter],ga_PlayerName[gi_Sellection])
}
}
  return 0
}

public CountVotes(id,key)
{
  new ccntname[32]
  get_user_name(id, ccntname, 31)
  if(key == 0)
  {
  	ColorChat(0, GREY, "%s ^x04За!", ccntname)
}
  else
{
	ColorChat(0, GREY, "%s ^x04Против!", ccntname)
}
  voted++
  ++ga_Choice[key]
  new ccnt = gi_TotalPlayers - voted
  set_hudmessage(0, 255, 0, 0.02, 0.25, 1, 0.0, 10.0, 1.0, 1.0)
  ShowSyncHudMsg(0, HudSync, "Проголосовали %d из %d игроков^nЗа: %d^nПротив: %d^nНе проголосовали %d", voted, gi_TotalPlayers, ga_Choice[0], ga_Choice[1], ccnt)
  return PLUGIN_HANDLED
}

public outcom()
{
  new TotalVotes = ga_Choice[0] + ga_Choice[1]
  new Float:result = (float(ga_Choice[0]) / float(TotalVotes))
  

  if(get_pcvar_float(gf_MinVoters) >= (float(TotalVotes) / float(gi_TotalPlayers)))
  {
    ColorChat(0,RED,"[VOTEBAN] Недостаточно голосов за Бан ^x04%s!",ga_PlayerName[gi_Sellection])
    bug=zero
    formatex(title, charsmax(title), "Проголосовало %d из %d игроков, %d За.",voted, gi_TotalPlayers,ga_Choice[0])
    write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
    formatex(title, charsmax(title), "Недостаточно голосов.^n---")
    write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
    return 0
  }
  else
  {
    if(result < get_pcvar_float(gf_BF_Ratio))
    {
    if(gi_TotalPlayers > 10)
    {
      ColorChat(0,RED,"[VOTEBAN] Инициатор ^x04%s ^x03забанен на ^x04%d ^x03минут.",ga_PlayerName[gi_VoteStarter],banpush)
      type = 1
      ActualBan()
      formatex(title, charsmax(title), "Проголосовало %d из %d игроков, %d За.",voted, gi_TotalPlayers,ga_Choice[0])
      write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
      formatex(title, charsmax(title), "Инициатор %s забанен на %d минут^n---", ga_PlayerName[gi_VoteStarter],banpush)
      write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
    }
    else
    {
	ColorChat(0,RED,"[VOTEBAN] Голосование не состоялось. Недостаточно голосов.")
  	formatex(title, charsmax(title), "Проголосовало %d из %d игроков, %d За.",voted, gi_TotalPlayers,ga_Choice[0])
	write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
	formatex(title, charsmax(title), "Недостаточно голосов.^n---")
	write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
	bug=zero
   }
  }

    if( result >= get_pcvar_float(gf_Ratio) )
    {
      ColorChat(0,RED,"[VOTEBAN] ^x04%s ^x03забанен на ^x04%d ^x03минут.",ga_PlayerName[gi_Sellection],banpush)
      formatex(title, charsmax(title), "Проголосовало %d из %d игроков, %d За.",voted, gi_TotalPlayers,ga_Choice[0])
      write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
      formatex(title, charsmax(title), "%s забанен на %d минут^n---", ga_PlayerName[gi_Sellection],banpush)
      write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
      type = 0
      ActualBan()
    }
    else
    {
      ColorChat(0,RED,"[VOTEBAN] Голосование не состоялось. Недостаточно голосов.")
      formatex(title, charsmax(title), "Проголосовало %d из %d игроков, %d За.",voted, gi_TotalPlayers,ga_Choice[0])
      write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
      formatex(title, charsmax(title), "Недостаточно голосов.^n---")
      write_file("/addons/amxmodx/configs/voteban.txt", title, -1)
    }
  }
  ColorChat(0,RED,"[VOTEBAN] Проголосовало ^x04%d ^x03из ^x04%d ^x03игроков, ^x04%d ^x03За.",voted, gi_TotalPlayers,ga_Choice[0])
  voted = 0
  return 0
}

public ActualBan()
{
new srvcmd[128], generic[36], userip[22], usersteam[34]
if(type == 1)
{
formatex(generic, 33, "#%d", get_user_userid(bug))
get_user_name(bug, idoll, 31) 
get_pcvar_string(bancfg, srvcmd, 127)
get_user_authid(bug, usersteam, 33)
get_user_ip(bug, userip, 21, 1)
}
else
{
formatex(generic, 33, "#%d", get_user_userid(idol))
get_user_name(idol, idoll, 31) 
get_pcvar_string(bancfg, srvcmd, 127)
get_user_authid(idol, usersteam, 33)
get_user_ip(idol, userip, 21, 1)
}
			
replace_all(srvcmd, 127, "%userid%", generic)
			
formatex(generic, 35, "^"%s^"", usersteam)
replace_all(srvcmd, 127, "%steamid%", generic)
			
formatex(generic, 35, "^"%s^"", idoll)
replace_all(srvcmd, 127, "%name%", generic)

replace_all(srvcmd, 127, "%ip%", userip)

replace_all(srvcmd, 127, "%reason%", PLUGIN)

formatex(generic, 33, "%d", banpush)
replace_all(srvcmd, 127, "%time%", generic)
server_cmd(srvcmd)

return 0
}
