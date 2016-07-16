;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

game_input:
  ld     a,(PAUSE_FLAG)		;Only allow going out of pause if we're already in pause
  or     a
  jp     nz,++++

  ld     a,(JOYP_ACTIVE)
  bit    2,a
  jr     z,+                    ;Select button: Special attack
  ld     a,(HAS_SPECIAL)
  or     a
  jr     z,+
  ld     a,(MCURSOR_SSEL)
  ld     hl,ssaction_lut
  rst    $30
  call   drawsskill
+:

  ld     a,(JOYP_ACTIVE)
  bit    0,a
  jr     z,+                    ;Button A: flip
  ld     a,(FLIP_FLAGS)
  ld     b,a
  ld     a,(NEED_CHECKMATCH)
  or     b
  jr     nz,+			;Can't flip while flipping or animating panel

  ld     a,(ANIM_SHAKE)
  or     a
  jr     nz,+          		;Can't flip either if the panel is getting shaked up (regen)
  ld     a,1
  ld     (FLIP_TOSET),a		;User-initiated flip
  call   makeflip
+:


  ld     a,(JOYP_ACTIVE)
  bit    1,a
  jr     z,+         		;Button B: Short=Change cursor, Long=Use shield
  xor    a
  ld     (B_COUNTER),a
+:

  ld     a,(JOYP_CURRENT)
  bit    1,a
  jr     z,++
  ld     a,(B_COUNTER)
  inc    a
  cp     $FF
  jr     z,+++
  ld     (B_COUNTER),a
+++:
  cp     SHIELD_UP_DELAY
  jr     nz,+
  ld     a,(PLAYER_SH1)
  or     a
  jr     z,++
  ld     a,1
  ld     (SHIELD_UP),a
  call   loadplayer
++:

  ld     a,(JOYP_LAST)
  ld     b,a
  ld     a,(JOYP_CURRENT)
  xor    b
  and    b
  bit    1,a			;Button B release
  jr     z,+
  xor    a
  ld     (SHIELD_UP),a
  call   loadplayer
  ld     a,(B_COUNTER)
  cp     SHIELD_UP_DELAY-1
  jr     nc,+
  ld     a,(FLIP_FLAGS)
  dec    a
  jr     z,+
  dec    a
  jr     z,+			;Can't change cursor while flipping (1 or 2)
  cp     4
  jr     z,+			;Can't change cursor while reflip
  call   changecursor
+:



  ld     a,(FLIP_FLAGS)		;Can only move cursor if flags=0 (nothing) or >2 (moving), not flipping
  or     a
  jr     z,+
  cp     2+1
  jr     nc,+
  jp     ++++
+:

  ld     a,(JOYP_ACTIVE)
  bit    4,a                    ;Right
  jr     z,++
  ld     a,(CURSOR_MODE)
  or     a
  jr     nz,+
  ;H
  ld     a,(CURSOR_X)
  cp     5
  jr     z,++
  inc    a
  ld     (CURSOR_X),a
  ld     hl,sfxdata_move
  call   sfx_play
  jr     ++
+:
  ;V
  ld     a,(CURSOR_X)
  cp     6
  jr     z,++
  inc    a
  ld     (CURSOR_X),a
  ld     hl,sfxdata_move
  call   sfx_play
++:

  ld     a,(JOYP_ACTIVE)
  bit    5,a                    ;Left
  jr     z,+
  ld     a,(CURSOR_X)
  or     a
  jr     z,+
  dec    a
  ld     (CURSOR_X),a
  ld     hl,sfxdata_move
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)
  bit    6,a                    ;Up
  jr     z,+
  ld     a,(CURSOR_Y)
  or     a
  jr     z,+
  dec    a
  ld     (CURSOR_Y),a
  ld     hl,sfxdata_move
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)
  bit    7,a                    ;Down
  jr     z,++
  ld     a,(CURSOR_MODE)
  or     a
  jr     nz,+
  ;H
  ld     a,(CURSOR_Y)
  cp     8
  jr     z,++
  inc    a
  ld     (CURSOR_Y),a
  ld     hl,sfxdata_move
  call   sfx_play
  jr     ++
+:
  ;V
  ld     a,(CURSOR_Y)
  cp     7
  jr     z,++
  inc    a
  ld     (CURSOR_Y),a
  ld     hl,sfxdata_move
  call   sfx_play
++:


++++:
  ld     a,(JOYP_ACTIVE)
  bit    3,a
  jr     z,+                    ;Start button
  ld     a,(PAUSE_FLAG)
  or     a
  jp     nz,exitpause
  jp     enterpause
+:
  ret

text_pause:
  .db "PAUSED",$FF
