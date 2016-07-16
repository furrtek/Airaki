;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;A is mod value
;B is icon number
matchaction:
  push   de
  push   hl
  push   bc
  ld     c,a		;Mod value
  push   bc
  ld     a,b
  and    7		;LUT index security
  sla    a
  ld     hl,action_jt
  rst    0
  inc    hl
  ld     h,(hl)
  ld     l,a
  call   dojump

  ;Take care of score inc
  pop    bc
  ld     a,b
  and    7		;LUT index security
  ld     hl,action_score
  rst    0
  ld     h,a
  ld     e,c
  call   mul8_8		;Score += LUT value * mod
  ld     b,l
  call   inc_score
  ld     hl,$9C00+(1*32)+1
  ld     de,SCORE
  call   drawscore

  pop    bc
  pop    hl
  pop    de
  ret
  
action_score:
  .db SCORE_SHIELD
  .db SCORE_PUNCH
  .db SCORE_SWORD
  .db SCORE_SCOURGE
  .db SCORE_POTION
  .db SCORE_POISON
  .db SCORE_BOMB
  .db SCORE_SSKILL

action_jt:
  .dw action_shield
  .dw action_punch	;Can be hammer
  .dw action_sword	;Can be hammer
  .dw action_scourge
  .dw action_potion
  .dw action_poison
  .dw action_null	;Bomb
  .dw action_sskill

action_shield:
  ld     a,(PLAYER_SH2)
  or     a
  ret    nz
  ld     a,(PLAYER_SH1)
  or     a
  jr     nz,+
  ld     a,c
  ld     (PLAYER_SH1),a		;Add in SH1
  jr     ++
+:
  ld     a,c
  ld     (PLAYER_SH2),a		;Add in SH2
++:
  ld     a,1
  ld     (SHIELD_REFRESH),a
  ret

action_punch:
  ld     a,(HAMMER_MODE)
  or     a
  jr     z,++
  ld     a,(HAMMER_COUNTER)
  inc    a
  ld     (HAMMER_COUNTER),a
  cp     MAX_HAMMERS
  jr     nz,+
  push   bc			;Save mod value for adding ATK_HAMMER
  call   loadicons
  xor    a
  ld     (HAMMER_MODE),a
  pop    bc
+:
  ld     b,ATK_HAMMER
  jr     +
++:
  ld     b,ATK_PUNCH
  jr     +
action_sword:
  ld     b,ATK_SWORD
  jr     +
action_scourge:
  ld     b,ATK_SCOURGE
+:
  call   addattack
  ret

action_potion:
  ld     hl,PLAYER_HP
  ld     a,POTION_VALUE
  add    (hl)
  jr     nc,+
  ld     a,255				;Cap HP to 255
+:
  ld     (hl),a
  ld     hl,HPBAR_REFRESH
  set    1,(hl)
  call   dxcp_over
  ld     a,1
  ld     (PLAYER_USEPOTION),a
  ret
action_poison:
  ld     a,(PLAYER_DIZZY)
  or     a
  call   z,init_dxcp_beer
  ret

action_sskill:
  ld     a,1
  ld     (HAS_SPECIAL),a
  call   drawsskill
  ret
action_null:
  ret

got2ppotion:
  ld     hl,ENEMY_HP
  ld     a,POTION_VALUE
  add    (hl)
  jr     nc,+
  ld     a,255				;Cap HP to 255
+:
  ld     (hl),a
  ld     hl,HPBAR_REFRESH
  set    0,(hl)
  ret
