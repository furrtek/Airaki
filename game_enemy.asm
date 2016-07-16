;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

prepareatk:
  ld     a,(GAME_MODE)
  bit    0,a
  ret    nz
  ;Make random attack interval value between min and min+amp
  call   get_random
  ld     h,a
  ld     a,(ENEMYATK_LVLAMP)
  ld     e,a
  call   mul8_8
  ld     a,h
  ld     hl,ENEMYATK_LVLMIN
  add    (hl)
  ld     (ENEMYATK_TIMER),a
  ret

warnattackplayer:
  ld     hl,ENEMYGFX_ATK
  call   loadenemy
  ld     a,(ENEMYATK_LVLWARN)
  ld     (ENEMYATK_WARNTIMER),a
  ld     hl,sfxdata_warn
  call   sfx_play
  ret

attackplayer:
  ld     hl,ENEMYGFX_IDLE
  call   loadenemy
  call   prepareatk		;Prepare next attack
  ld     de,aap_slash
  call   aa_init_enemy
  ld     a,(GAME_MODE)
  bit    0,a
  ret    z
  ld     hl,sfxdata_warn
  call   sfx_play
  ret
  
getdamage:
  ld     a,(GAME_MODE)
  bit    0,a
  jp     nz,useshield		;Don't cause damage in link mode (auto-updated from other player)
getbombdamage:
  ld     a,(ENEMYATK_FORCE)
  ld     c,a
  ld     a,(SHIELD_UP)		;Is shield up ?
  or     a
  jr     z,+
  ld     a,(PLAYER_SH1)
-:
  srl    c			;Divide damage by shield strength
  dec    a
  jr     nz,-
  push   bc
  call   useshield
  pop    bc
+:
  ld     a,(PLAYER_HP)
  cp     c
  jr     nc,+			;FORCE >= HP : Player survives
  jp     declives
+:
  sub    c
  ld     (PLAYER_HP),a
  ld     a,BLINK_TIME
  ld     (PLAYER_BLINK),a
  ld     hl,HPBAR_REFRESH
  set    1,(hl)
  ret
