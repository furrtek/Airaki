;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

menu_input:
  ld     a,(JOYP_ACTIVE)
  bit    0,a
  jr     z,+                    ;Button A: go to next menu line
  ld     a,(MCURSOR_LINE)
  cp     1
  jp     z,menu_exit
  inc    a
  ld     (MCURSOR_LINE),a
  ld     hl,sfxdata_menu
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)
  bit    1,a
  jr     z,+                    ;Button B: go to previous menu line
  ld     a,(MCURSOR_LINE)
  or     a
  jr     z,+
  dec    a
  ld     (MCURSOR_LINE),a
  ld     hl,sfxdata_menu
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)
  bit    4,a                    ;Right
  jr     z,+
  call   mcur_getrange
  ld     b,a
  call   mcur_getvar
  cp     b
  jr     z,+
  inc    a
  ld     (hl),a
  ld     hl,sfxdata_menu
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)
  bit    5,a                    ;Left
  jr     z,+
  call   mcur_getvar
  or     a
  jr     z,+
  dec    a
  ld     (hl),a
  ld     hl,sfxdata_menu
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)
  bit    6,a                    ;Up
  jr     z,+
  ld     a,(MCURSOR_LINE)
  or     a
  jr     z,+
  dec    a
  ld     (MCURSOR_LINE),a
  ld     hl,sfxdata_menu
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)
  bit    7,a                    ;Down
  jr     z,+
  ld     a,(MCURSOR_LINE)
  cp     1
  jr     z,+
  inc    a
  ld     (MCURSOR_LINE),a
  ld     hl,sfxdata_menu
  call   sfx_play
+:

  ld     a,(JOYP_ACTIVE)	;Start
  bit    3,a
  call   nz,menu_exit

  ret

mcur_getrange:
  ld     hl,mcur_range_lut
  ld     a,(MCURSOR_LINE)
  ld     c,a
  sla    a
  add    c			;*3
  rst    0
  ld     a,(hl)
  ret
mcur_getvar:
  ld     hl,mcur_range_lut+1
  ld     a,(MCURSOR_LINE)
  ld     c,a
  sla    a
  add    c			;*3
  rst    0
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a
  ld     a,(hl)
  ret

mcur_range_lut:
  .db    1
  .dw    MCURSOR_PSEL
  .db    2
  .dw    MCURSOR_SSEL

menu_exit:
  ;Copy special skill to game variable
  ld     a,(MCURSOR_SSEL)
  ld     (PLAYER_SS),a
  
  xor    a
  ld     (LINK_FIELD),a

  ld     a,(MCURSOR_PSEL)
  sla    a
  sla    a
  ld     hl,menu_gs_lut
  ld     d,0
  ld     e,a
  add    hl,de
  ldi    a,(hl)
  ld     (GAME_MODE),a
  ldi    a,(hl)
  ld     (GAME_LIVES),a
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a
  jp     hl

 ;PSEL MSEL 		GAME_MODE,Lives,jumpto
 ;00 	1P 1life
 ;01 	1P 3lives
 ;10 	2P 1life
 ;11 	2P 3lives
menu_gs_lut:
  .db 0,4
  .dw game_setup
  .db 1,1
  .dw link_setup
