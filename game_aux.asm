;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

lvlsetup:
  di
  call	 screen_off

  ld     a,(LEVEL)
  add    a
  ld     b,a
  add    a			;*10 (*8 + *2)
  add    a
  add    b
  ld     hl,(:difficulty_lut*$4000)+difficulty_lut
  rst    0
  inc    hl
  ld     (ENEMYATK_LVLMIN),a
  ldi    a,(hl)
  ld     (ENEMYATK_LVLAMP),a
  ldi    a,(hl)
  ld     (ENEMYATK_LVLWARN),a
  ldi    a,(hl)
  ld     (ENEMYATK_FORCE),a

  ldi    a,(hl)
  ld     (ENEMYGFX_IDLE),a
  ldi    a,(hl)
  or     $40			;Bank 1
  ld     (ENEMYGFX_IDLE+1),a
  
  ldi    a,(hl)
  ld     (ENEMYGFX_ATK),a
  ldi    a,(hl)
  or     $40			;Bank 1
  ld     (ENEMYGFX_ATK+1),a

  ldi    a,(hl)
  ld     (ENEMYGFX_DEAD),a
  ld     a,(hl)
  or     $40			;Bank 1
  ld     (ENEMYGFX_DEAD+1),a

  ld     a,(LEVEL)
  ld     b,a
  ld     hl,$9C00+(32*3)+5
  add    $D0+1
  call   wait_write
  ldi    (hl),a
  ld     a,b
  sla    a
  ld     hl,pal_enemy_lut
  rst    0
  inc    hl
  ld     h,(hl)
  ld     l,a
  ld     b,1*4*2
  ld     a,PALETTE_ENEMY*4*2
  call   loadbgpal
  
  ld     hl,ENEMYGFX_IDLE
  call   loadenemy

  call   genpanel
  call   drawpanel

  ld     a,255
  ld     (ENEMY_HP),a

  ;Heal player a bit (fairness)
  ld     hl,PLAYER_HP
  ld     a,HEAL_VALUE
  add    (hl)
  jr     nc,+
  ld     a,255				;Cap HP to 255
+:
  ld     (hl),a
  ld     hl,HPBAR_REFRESH
  set    1,(hl)

  ;Clear aanimator lists
  ld    b,16*4
  ld    hl,AA_SPR
  xor   a
-:
  ldi   (hl),a
  dec    b
  jr     nz,-

  xor    a
  ld     (AA_E_RUN),a
  ld     (AA_P_RUN),a
  ld     (FALLEN),a
  ld     (SHIELD_UP),a
  ld     (FLIP_FLAGS),a
  ld     (AFIFO_PUT),a
  ld     (AFIFO_GET),a
  ld     (ENEMY_DIZZY),a
  ld     (ENEMYATK_ANIM),a
  ld     (ENEMYATK_WARNTIMER),a
  ld     (ENEMYATK_TIMER),a
  ld     (SCOREEN),a
  ld     (SCOREEN+1),a
  ld     (SCOREEN+2),a
  ld     (TIMEEN_SEC),a
  ld     (TIMEEN_SEC+1),a
  ld     a,BLINK_TIME
  ld     (ENEMY_BLINK),a
  ld     a,1+2
  ld     (HPBAR_REFRESH),a
  
  ld     a,SHAKE_DURATION	;Start with shake
  ld     (ANIM_SHAKE),a
  
  call   prepareatk
  ret


gravity:
  xor    a
  ld     (FALLEN),a
  ld     hl,PANEL
  ld     c,7*(9-1)
-:
  ld     a,(hl)
  and    $7F		;Ignore flag
  cp     8
  jr     nc,++		;Is steady icon ?
  ;Yes: see if tile below is empty
  ld     b,a
  push   hl
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)
  bit    5,a		;Empty flag
  jr     z,+
  ;Empty, can fall
  ld     a,b
  or     $80		;Refresh flag
  ld     (hl),a		;Tile below = Tile from above
  pop    hl
  ld     a,$20+$80	;Tile above = Refresh + empty flag
  ld     (hl),a
  ld     (FALLEN),a
  jr     ++
+:
  pop    hl
++:
  inc    l
  dec    c
  jr     nz,-

; See if some tiles are empty in the top row to fill them up
  ld     de,PANEL
  ld     c,7
-:
  ld     a,(de)
  and    $7F
  cp     $20
  jr     nz,++
  call   new_icon
  ld     (de),a
  ld     a,1
  ld     (FALLEN),a	;Force gravity pass again, in case match was on the top
++:
  inc    de
  dec    c
  jr     nz,-

  ld     a,(FALLEN)
  or     a		;If no icons fell, then everything is steady: recheck for matches
  ret    nz
  ld     a,1		;Check for matches
  ld     (NEED_CHECKMATCH),a
  ret


declives:
  ld     a,(GAME_LIVES)
  dec    a
  or     a
  jp     z,pdeath
  ld     (GAME_LIVES),a
  dec    a
  ld     hl,$9C00+(15*32)+1
  add    l
  ld     l,a
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  xor    a
  call   wait_write
  ld     (hl),a
  ld     a,255
  ld     (PLAYER_HP),a
  ld     hl,HPBAR_REFRESH
  set    1,(hl)
  pop    af
  ldh    ($FF),a
  ret


useshield:
  ld     hl,sfxdata_hitshield
  call   sfx_play
  ld     a,(PLAYER_SH2)		;Shift Shield2 in Shield1
  ld     (PLAYER_SH1),a
  xor    a
  ld     (PLAYER_SH2),a
  ld     (SHIELD_UP),a
  call   loadplayer
  ;Inc score
  ld     b,SCORE_USESHIELD
  call   inc_score
  ld     hl,$9C00+(1*32)+1
  ld     de,SCORE
  call   drawscore
  ld     a,1
  ld     (SHIELD_REFRESH),a
  ret
  