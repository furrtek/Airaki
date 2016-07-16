;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

bombexplode:
  ; Make a 3x3 box to blow up icons

  ;		B C B+C*3
  ;No	No      0 0 0
  ;Xmin No      1 0 1
  ;Xmax No      2 0 2
  ;No   Ymin    0 1 3
  ;Xmin Ymin    1 1 4
  ;Xmax Ymin    2 1 5
  ;No   Ymax    0 2 6
  ;Xmin Ymax    1 2 7
  ;Xmax Ymax    2 2 8

  push   hl

  ld     bc,0
  ld     a,(FLIP_X)
  or     a
  jr     nz,+
  inc    b
  jr     ++
+:
  cp     6
  jr     nz,++
  inc    b
  inc    b
++:
  ld     a,(FLIP_Y)
  or     a
  jr     nz,+
  inc    c
  jr     ++
+:
  cp     8
  jr     nz,++
  inc    c
  inc    c
++:
  ld     a,c
  add    a
  add    c		;B+C*3
  add    b
  sla    a
  ld     hl,bomb3x3_lut
  rst    0
  inc    hl
  ld     h,(hl)
  ld     l,a

  pop    de		;Process boundary box lut
  ld     a,$98
  ld     (de),a		;Delete anim flag + redraw + flash icon start
-:
  ldi    a,(hl)
  or     a
  jr     z,++
  add    e
  ld     e,a
  ld     a,$98
  ld     (de),a		;Delete anim flag + redraw + flash icon start
  jr     -
++:

  ld     hl,sfxdata_bomb
  call   sfx_play
  
  ld     a,(FLIP_X)
  swap   a
  add    8
  sla    a		;8 to 7.1
  ld     b,a
  ld     a,(FLIP_Y)
  swap   a
  add    16
  sla    a		;8 to 7.1
  ld     c,a

  ld     de,debris_lut
  ld     hl,DEBRIS_SPR

-:
  ld     a,1
  ldi    (hl),a		;ACTIVE
  ld     a,b
  ldi    (hl),a		;XPOS
  ld     a,c
  ldi    (hl),a		;YPOS
  ld     a,(de)
  inc    de
  ldi    (hl),a		;XSPD
  ld     a,(de)
  inc    de
  ldi    (hl),a         ;YSPD
  ld     a,(de)
  or     a
  jr     nz,-

  ld     a,(PLAYERATK_FORCE)
  push   af
  ld     a,DAMAGE_BOMB
  ld     (PLAYERATK_FORCE),a
  call   setdamage
  pop    af
  ld     (PLAYERATK_FORCE),a
  ld     a,(GAME_MODE)
  bit    0,a
  jr     z,+
  ld     a,1
  ld     (LINK_SENDBOMB),a
  ld     a,BLINK_TIME
  ld     (PLAYER_BLINK),a
  jr     ++
+:
  ld     a,(ENEMYATK_FORCE)
  push   af
  ld     a,DAMAGE_BOMB
  ld     (ENEMYATK_FORCE),a
  call   getbombdamage
  pop    af
  ld     (ENEMYATK_FORCE),a
++:

  ld     a,50
  ld     (DEBRIS_TIMER),a

  ld     a,SHAKEB_DURATION
  ld     (ANIM_SHAKE),a

  ld     a,4
  ld     (FLIP_FLAGS),a	;Go straight to deletion anim state
  ret

debris_lut:
  .db -2,-5<<2
  .db -2,3
  .db 2,-4<<2
  .db 2,2
  .db 0

bomb3x3_lut:
  .dw b3x3_0
  .dw b3x3_1
  .dw b3x3_2
  .dw b3x3_3
  .dw b3x3_4
  .dw b3x3_5
  .dw b3x3_6
  .dw b3x3_7
  .dw b3x3_8
  
b3x3_0:
  .db -8,1,1,5,2,5,1,1,0
b3x3_1:
  .db -7,1,7,6,1,0
b3x3_2:
  .db -8,1,6,7,1,0
b3x3_3:
  .db -1,2,5,1,1,0
b3x3_4:
  .db 1,6,1,0
b3x3_5:
  .db -1,7,1,0
b3x3_6:
  .db -8,1,1,5,2,0
b3x3_7:
  .db -7,1,7,0
b3x3_8:
  .db -8,1,6,0
