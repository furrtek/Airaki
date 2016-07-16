;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

victory_vbl:
  call   sfx_update
  call   readinput

  call   dofade

  ld     a,(EDEATH_TIMER)
  inc    a

  cp     40
  jr     nz,+
  ld     (EDEATH_TIMER),a
  ;Write points earned
  ld     hl,$9800+(32*7)+1
  ld     de,text_pearned
  ld     b,T_ALPHA-96
  call   maptext
  ld     hl,$9800+(32*9)+8
  ld     de,SCOREEN
  call   drawscore
  ld     hl,sfxdata_move
  call   sfx_play
  ret
+:

  cp     80
  jr     nz,+
  ld     (EDEATH_TIMER),a
  call   calc_bonus
  ;Write time bonus
  ld     hl,$9800+(32*11)+1
  ld     de,text_bonus
  ld     b,T_ALPHA-96
  call   maptext
  ld     hl,$9800+(32*12)+8
  ld     de,SCOREBONUS
  call   drawscore
  ld     hl,sfxdata_move
  call   sfx_play
  ret
+:

  cp     120
  jr     nz,+
  ld     (EDEATH_TIMER),a
  ;Write points total
  ld     hl,$9800+(32*14)+1
  ld     de,text_total
  ld     b,T_ALPHA-96
  call   maptext
  ld     hl,$9800+(32*15)+8
  ld     de,SCOREEN
  call   drawscore
  ld     hl,sfxdata_move
  call   sfx_play
  ret
+:

  cp     160
  jr     nz,+
  ld     (EDEATH_TIMER),a
  ;Write points total + total
  ;Add to score
  ld     hl,SCORE
  ld     a,(SCOREBONUS)	;LSB
  add    (hl)
  daa
  ld     (hl),a
  inc    hl
  ld     a,(SCOREBONUS+1)
  adc    (hl)
  daa
  ld     (hl),a
  inc    hl
  ld     a,(SCOREBONUS+2)	;MSB
  adc    (hl)
  daa
  ld     (hl),a
  ld     hl,$9C00+(1*32)+1
  ld     de,SCORE
  call   drawscore
  ld     hl,sfxdata_menu
  call   sfx_play
  ret
+:

  cp     200
  jr     nz,+
  ld     a,(JOYP_ACTIVE)
  and    $F
  ret    z
  ld     a,(LEVEL)
  inc    a
  cp     MAX_LEVEL
  jp     z,credits_setup
  ld     (LEVEL),a
  call   lvlsetup
  ld     hl,VBL_HANDLER
  ld     de,game_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d
  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a
  ei
  ret

+:
  ld     (EDEATH_TIMER),a
  ret

;xxxxxxxxxxxxxx
;   VICTORY!
;
; Points
;  earned:
;        xxxxx
; Time bonus:
;        xx:xx
; Total:
;        xxxxx

text_victory:
.db "VICTORY!",$FF
text_pearned:
.db "POINTS",$FE," EARNED:",$FF
text_bonus:
.db "TIME BONUS:",$FF
text_total:
.db "TOTAL:",$FF
