;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

game_vbl:
  call   sfx_update

  ld     a,(PAUSE_FLAG)
  or     a
  jp     nz,paused

  ld     a,(PLAYER_DIZZY)
  or     a
  call   nz,dxcp_vbl

  call   dofade

  ;HP bars refresh
  ld     a,(HPBAR_REFRESH)
  bit    0,a
  jr     z,+
  res    0,a
  ld     (HPBAR_REFRESH),a
  ld     hl,$9C00+(32*3)
  ld     a,(ENEMY_HP)
  call   drawhpbar
+:
  ld     a,(HPBAR_REFRESH)
  bit    1,a
  jr     z,+
  res    1,a
  ld     (HPBAR_REFRESH),a
  ld     hl,$9C00+(32*14)
  ld     a,(PLAYER_HP)
  call   drawhpbar
+:

  ;Enemy/player blink
  ld     a,(ENEMY_BLINK)
  or     a
  jr     z,+
  dec    a
  ld     (ENEMY_BLINK),a
  and    %00000011
  cp     %00000010
  jr     nz,++
  ;Clear enemy
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     hl,$9C00+(32*4)+1
  ld     bc,4
  call   clear_w
  ld     hl,$9C00+(32*5)+1
  ld     bc,4
  call   clear_w
  ld     hl,$9C00+(32*6)+1
  ld     bc,4
  call   clear_w
  ld     hl,$9C00+(32*7)+1
  ld     bc,4
  call   clear_w
  pop    af
  ldh    ($FF),a
  jr     +
++:
  cp     %00000000
  jr     nz,+
  ld     hl,$9C00+(32*4)+1
  ld     bc,$0404
  ld     a,T_ENEMY
  call   mapinc_w
+:


  ld     a,(PLAYER_BLINK)
  or     a
  jr     z,+
  dec    a
  ld     (PLAYER_BLINK),a
  and    %00000011
  cp     %00000010
  jr     nz,++
  ;Clear player
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     hl,$9C00+(32*10)+1
  ld     bc,4
  call   clear_w
  ld     hl,$9C00+(32*11)+1
  ld     bc,4
  call   clear_w
  ld     hl,$9C00+(32*12)+1
  ld     bc,4
  call   clear_w
  ld     hl,$9C00+(32*13)+1
  ld     bc,4
  call   clear_w
  pop    af
  ldh    ($FF),a
  jr     +
++:
  cp     %00000000
  jr     nz,+
  ;Draw player
  ld     hl,$9C00+(32*10)+1
  ld     bc,$0404
  ld     a,T_PLAYER
  call   mapinc_w
+:

  ;Shake screen only if we're not in dxcp (and regen panel in the middle of the animation)
  ld     a,(ANIM_SHAKE)
  or     a
  jr     z,++
  dec    a
  ld     (ANIM_SHAKE),a
  or     a
  jr     z,+
  ld     b,a
  ld     a,(PLAYER_DIZZY)
  or     a
  jr     nz,++
  ld     a,b
  swap   a
  and    $F0
  sla    a
  ld     b,a
  ld     hl,(:tiles_gb*$4000)+lut_cos
  add    l
  ld     l,a
  ld     a,(hl)
  swap   a
  srl    a
  and    $7
  add    256-4		;Center (esthetic)
  ldh    ($42),a 	;Scroll X
  ld     a,b
  add    $3F		;Dephase (sin)
  ld     hl,(:tiles_gb*$4000)+lut_cos
  add    l
  ld     l,a
  ld     a,(hl)
  swap   a
  srl    a
  and    $7
  add    256-4          ;Center (esthetic)
  ldh    ($43),a	;Scroll Y
  jr     ++
+:
  xor    a		;No shake: reposition
  ldh    ($42),a 	;Scroll X
  ldh    ($43),a	;Scroll Y
++:

  ;Redraw icons which need refresh
  call   drawpanel

  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear
  
  ;Sprite generation
  ld     hl,OAMCOPY
  call   rendercursor
  ld     a,(POP_ANIM)
  or     a
  call   nz,renderpop
  call   renderdizzy
  ld     a,(ENEMY_HP)
  cp     IMMINENT_DEATH
  call   c,renderimmdeath
  ld     a,(DEBRIS_TIMER)
  or     a
  call   nz,renderdebris

  ;Flipping icons ?
  ld     a,(FLIP_FLAGS)         ;See flow.odg :)
  cp     1
  jr     z,+
  cp     6
  jr     z,+
  jr     ++
+:
  call   renderflip
++:

  call   aa_render

  ld     a,(SHIELD_REFRESH)
  or     a
  call   nz,drawshields

  call   aa_run_e
  call   aa_run_p

  ;Update stuff
  
  call   inc_time

  ld     a,(DEBRIS_TIMER)
  or     a
  jr     z,+++
  dec    a
  ld     (DEBRIS_TIMER),a
  ld     b,4
  ld     hl,DEBRIS_SPR
-:
  ldi    a,(hl)
  or     a
  jr     z,++
  inc    hl
  inc    hl
  ldd    a,(hl)		;XSPD
  dec    hl
  ld     c,(hl)		;XPOS
  add    c
  ld     (hl),a		;XPOS
  srl    a
  cp     8
  jr     nc,+
  dec    hl
  xor    a
  ldi    (hl),a		;ACTIVE
  jr     ++
+:
  inc    hl
  inc    hl
  inc    hl
  ld     a,(hl)		;YSPD
  inc    a
  ldd    (hl),a
  dec    hl
  sra    a
  sra    a
  ld     c,(hl)		;YPOS
  add    c
  ld     (hl),a		;YPOS
  srl    a
  cp     16
  jr     nc,+
  dec    hl
  dec    hl
  xor    a
  ldi    (hl),a		;ACTIVE
++:
  inc    hl
+:
  inc    hl
  inc    hl
  inc    hl
  dec    b
  jr     nz,-
+++:

  ;Animate icons getting deleted
  ld     a,(FRAME)		;Slow the fuck down
  and    3
  jr     nz,+++
  ld     hl,PANEL
  ld     c,7*9
-:
  ld     a,(hl)
  bit    4,a
  jr     z,+
  ;Icon is getting deleted
  and    $F
  cp     11
  jr     nz,++
  ;Delete animation done, clear tile
  ld     a,$80+$20		;Refresh + clear flag
  ld     (hl),a
  ld     a,1
  ld     (FALLEN),a		;Need gravity now
  jr     +
++:
  inc    a
  or     $90			;Refresh + deleting flag
  ld     (hl),a
+:
  inc    hl
  dec    c
  jr     nz,-
+++:

  ld     a,(FLIP_FLAGS)         ;See flow.odg :)
  cp     2			;Flip just done flag, now we just need to check matches
  jr     z,+
  cp     5
  jr     z,+
  ld     a,(NEED_CHECKMATCH)
  or     a
  jr     z,++
  xor    a
  ld     (NEED_CHECKMATCH),a
  ld     a,5
  ld     (FLIP_FLAGS),a
  jr     ++
+:
  call   checkmatches
++:

  ld     a,(FALLEN)
  or     a			;Need to apply gravity
  jr     z,+
  ld     a,(FRAME)		;Slow the fuck down
  and    3
  call   z,gravity		;Make icons fall
+:

  ld     a,(FLIP_FLAGS)         ;See flow.odg :)
  cp     1
  jr     z,+
  cp     6
  jr     z,+
  jr     ++
+:
  call   animflip
++:             

  call   animpop

  ld     a,(AA_P_RUN)
  or     a
  call   z,processfifo

  ;See if we need to shake (regen) panel
  ld     a,(CANSOLVE)
  or     a
  jr     nz,+
  ld     a,(ANIM_SHAKE)
  or     a
  jr     z,++
  cp     SHAKE_DURATION/2	;Regen right in the middle of the shake animation
  call   z,genpanel
  jr     +
++:
  call   dxcp_over		;Cure drunkenness before regen (sympathy)
  ld     a,SHAKE_DURATION
  ld     (ANIM_SHAKE),a
+:

  ld     a,(GAME_MODE)
  bit    0,a
  jr     nz,+			;Take care of enemy dizzy timeout only in 1p mode
  ld     a,(ENEMY_DIZZY)	;ENEMY_DIZZY, like DXCP_TIMER unit is in 4 frames
  or     a
  jr     z,+
  ld     b,a
  ld     a,(FRAME)
  and    3
  jr     nz,+
  ld     a,b
  dec    a
  ld     (ENEMY_DIZZY),a
+:

  ld     a,(HAS_SPECIAL)
  or     a
  call   nz,drawsskill

  ld     a,(GAME_MODE)
  bit    0,a
  jr     nz,+++
  ld     a,(ANIM_SHAKE)		;Ignore enemy attack timer during shake or his dizzyness (fair !)
  ld     b,a
  ld     a,(ENEMY_DIZZY)
  or     b
  jr     nz,+++
  ld     a,(ENEMYATK_WARNTIMER)
  or     a
  jr     z,+
  dec    a
  jr     nz,+
  call   attackplayer
  xor    a
+:
  ld     (ENEMYATK_WARNTIMER),a
  ld     a,(FRAME)
  and    1
  jr     z,+++			;ENEMYATK_TIMER unit is 2 frames
  ld     a,(ENEMYATK_TIMER)
  or     a
  jr     z,+++
  dec    a
  ;Is =1 ?
  jr     nz,++
  ;Attack player !
  push   af
  call   warnattackplayer
  pop    af
++:
  ld     (ENEMYATK_TIMER),a
+++:

paused:
  call   readinput
  call   game_input
  call   do_comm
  ret
