;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

linkh_slave:
  ld     a,(LINK_RX)
  swap   a
  and    $F
  cp     $E
  jr     nz,+
  ld     a,$13
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  ret
+:
  srl    a
  cp     6
  jp     nc,linkerror
  ld     hl,linkset_s_jt
  rst    $30
  xor    a
  ld     (LINK_TIMEOUT),a
  ret
  
linkset_s_jt:
  .dw linkss_0
  .dw linkss_1
  .dw linkss_2
  .dw linkss_3
  .dw linkss_4
  .dw linkss_5


linkss_0:
  ;Get 0F, prepare HP MSB
  ld     a,(ENEMY_HP)
  swap   a
  and    $F
  or     $30
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  ret

linkss_1:
  ;Get 0x HP MSB, prepare HP LSB
  ld     a,(ENEMY_HP)
  and    $F
  or     $50
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  ld     a,(LINK_RX)
  and    $F
  swap   a
  ld     (LINK_HPBUFFER),a
  ret

linkss_2:
  ;Get 2x HP LSB, prepare Shield
  ld     a,(SHIELD_UP)
  or     a
  jr     z,+
  ld     a,(PLAYER_SH1)
  and    $F
+:
  or     $70
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  ld     a,(PLAYER_USEPOTION)
  or     a
  jr     nz,+
  ld     a,(LINK_RX)
  and    $F
  ld     b,a
  ld     a,(PLAYER_HP)
  ld     c,a
  ld     a,(LINK_HPBUFFER)
  or     b
  cp     c
  ret    z
  ld     (PLAYER_HP),a
  ld     hl,HPBAR_REFRESH
  set    1,(hl)
+:
  ret
  
linkss_3:
  ;Get shield, send attack
  ld     a,(PLAYERATK_TOSEND)
  ld     b,a
  ld     a,(LINK_SENDBOMB)
  sla    a
  sla    a
  or     b
  and    $F
  or     $90
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  xor    a
  ld     (PLAYERATK_TOSEND),a
  ld     (LINK_SENDBOMB),a
  ld     a,(LINK_RX)
  and    $F
  ld     (ENEMY_SH),a
  ret

linkss_4:
  ;Get attack, send status
  ld     a,(PLAYER_USEPOTION)
  and    1
  swap   a
  srl    a
  ld     b,a
  ld     a,(PAUSE_FLAG)
  and    1
  sla    a
  sla    a
  or     b
  ld     b,a
  ld     a,(PLAYER_DIZZY)
  or     a
  ld     a,b
  jr     z,+
  or     2
+:
  ld     b,a
  ld     a,(LINK_SENDDEAD)	;Player died
  or     b
  and    $F
  or     $B0
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  ld     a,(LINK_RX)
  bit    2,a
  jr     z,+
  push   af
  ld     a,DAMAGE_BOMB
  ld     (PLAYERATK_FORCE),a
  ld     a,BLINK_TIME
  ld     (PLAYER_BLINK),a
  call   setdamage
  pop    af
  and    3
+:
  and    $F
  or     a
  jr     z,++
  dec    a
  jr     nz,+
  call   attackplayer		;Regular attack (slash animation)
  jr     ++
+:
  ld     de,aap_beer
  call   aa_init_enemy		;Beer special attack
++:
  xor    a
  ld     (PLAYER_USEPOTION),a
  ld     (LINK_SENDDEAD),a
  ret

linkss_5:
  ;Get status
  ld     a,$13
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  ld     a,(LINK_RX)
  bit    0,a
  jp     nz,p2pdeath		;Player died
  bit    3,a
  call   nz,got2ppotion
  ld     a,(LINK_RX)
  ld     b,a
  ld     hl,LINK_IGNOREPAUSE
  ld     a,(LINK_IGNOREPAUSE)
  res    0,(hl)
  or     a
  jr     nz,++
  ld     a,b
  srl    a
  srl    a
  and    1
  xor    1
  ld     c,a
  ld     a,(PAUSE_FLAG)
  or     c
  jr     nz,+
  call   enterpause
  jr     ++
+:
  ld     a,(PAUSE_FLAG)
  and    c
  jr     z,++
  call   exitpause
++:
  ld     a,b
  srl    a
  and    1
  ld     (ENEMY_DIZZY),a
  ret
