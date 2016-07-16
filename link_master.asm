;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

link_comm:
  ld     a,(LINK_ISMASTER)
  or     a
  jr     z,+
  ;Master communication
  ld     a,(LINK_FIELD)
  ld     hl,linkcomm_m_jt
  rst    $30
  ret
+:
  ;Slave communication
  call   linkerror		;Timeout reset by slave serial interrupt, keep here
  ret

linkcomm_m_jt:
  .dw linkcm_0
  .dw linkcm_1
  .dw linkcm_2
  .dw linkcm_3
  .dw linkcm_4
  .dw linkcm_5

linkcm_0:
  ;Send 0F, get 13
  ld     a,$0F
  ldh    ($01),a
  ld     a,$81
  ldh    ($02),a
  ret

linkcm_1:
  ;Send HP MSB, get HP MSB
  ld     a,(ENEMY_HP)
  swap   a
  and    $F
  or     $20
  ldh    ($01),a
  ld     a,$81
  ldh    ($02),a
  ret

linkcm_2:
  ;Send HP LSB, get HP LSB
  ld     a,(ENEMY_HP)
  and    $F
  or     $40
  ldh    ($01),a
  ld     a,$81
  ldh    ($02),a
  ret

linkcm_3:
  ;Send shield, receive shield
  ld     a,(SHIELD_UP)
  or     a
  jr     z,+
  ld     a,(PLAYER_SH1)
  and    $F
+:
  or     $60
  ldh    ($01),a
  ld     a,$81
  ldh    ($02),a
  ret

linkcm_4:
  ;Send attack, get attack
  ld     a,(PLAYERATK_TOSEND)
  ld     b,a
  ld     a,(LINK_SENDBOMB)
  sla    a
  sla    a
  or     b
  and    $F
  or     $80
  ldh    ($01),a
  ld     a,$81
  ldh    ($02),a
  xor    a
  ld     (PLAYERATK_TOSEND),a
  ld     (LINK_SENDBOMB),a
  ret

linkcm_5:
  ;Send status, get status
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
  ld     a,(LINK_SENDDEAD)		;Player died
  or     b
  and    $F
  or     $A0
  ldh    ($01),a
  ld     a,$81
  ldh    ($02),a
  xor    a
  ld     (PLAYER_USEPOTION),a
  ld     (LINK_SENDDEAD),a
  ret


linkh_master:
  ld     a,(LINK_RX)
  swap   a
  and    $F
  srl    a
  cp     6
  jr     c,+
  ld     a,(LINK_FIELD)		;Rewind one step, let's do this over again...
  or     a
  jr     z,+++
  dec    a
  jr     ++
+++:
  ld     a,5
++:
  ld     (LINK_FIELD),a
  jp     linkerror
+:
  ld     hl,linkser_m_jt
  rst    $30
  xor    a
  ld     (LINK_TIMEOUT),a
  ret

linkser_m_jt:
  .dw linksm_0
  .dw linksm_1
  .dw linksm_2
  .dw linksm_3
  .dw linksm_4
  .dw linksm_5

linksm_0:
  ld     a,(LINK_RX)		;Presence check
  cp     $13
  jp     nz,linkerror
  jp     link_nextfield

linksm_1:
  ld     a,(LINK_RX)		;Slave HP MSB
  and    $F0
  cp     $30
  jp     nz,linkerror
  ld     a,(LINK_RX)
  and    $F
  swap   a
  ld     (LINK_HPBUFFER),a
  jp     link_nextfield

linksm_2:
  ld     a,(LINK_RX)		;Slave HP LSB
  and    $F0
  cp     $50
  jp     nz,linkerror
  ld     a,(PLAYER_USEPOTION)	;Dirty kludge to avoid bouncy HP bar after health potion
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
  jr     z,+
  ld     (PLAYER_HP),a
  ld     hl,HPBAR_REFRESH
  set    1,(hl)
+:
  jp     link_nextfield

linksm_3:
  ld     a,(LINK_RX)		;Slave shield
  and    $F0
  cp     $70
  jp     nz,linkerror
  ld     a,(LINK_RX)
  and    $F
  ld     (ENEMY_SH),a
  jp     link_nextfield
  
linksm_4:
  ld     a,(LINK_RX)		;Slave attack
  and    $F0
  cp     $90
  jp     nz,linkerror
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
  jr     z,link_nextfield
  dec    a
  jr     nz,+
  call   attackplayer		;Regular attack (slash animation)
  jr     link_nextfield
+:
  ld     de,aap_beer
  call   aa_init_enemy		;Beer special attack
  jr     link_nextfield

linksm_5:
  ld     a,(LINK_RX)		;Slave status
  and    $F0
  cp     $B0
  jp     nz,linkerror
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
  jr     link_nextfield

link_nextfield:
  xor    a
  ld     (LINK_TIMEOUT),a
  ld     a,(LINK_FIELD)
  inc    a
  cp     6
  jr     nz,+
  xor    a
+:
  ld     (LINK_FIELD),a
  ret
