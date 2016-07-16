;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

intro_vbl:
  call   RAMtoOAM
  
  call   sfx_update

  ld     a,(BKG_X)
  ldh    ($43),a                ;Scroll X
  ld     a,(BKG_Y)
  ldh    ($42),a                ;Scroll Y
  ld     a,(WIN_X)
  ldh    ($4B),a                ;Scroll X
  ld     a,(WIN_Y)
  ldh    ($4A),a                ;Scroll Y

  ld     a,(INTRO_STEP)
  cp     9
  jr     nc,+
  call   readinput
  ld     a,(JOYP_ACTIVE)
  bit    0,a
  jr     z,+
  call   intro_set_2
  call   intro_set_3
  ld     a,9
  ld     (INTRO_STEP),a
  ld     a,$2C
  ld     (ISWORD1_X),a
  ld     a,$74
  ld     (ISWORD2_X),a
  ld     a,$19
  ld     (ISWORD_Y),a
  ld     a,7
  ld     (WIN_X),a
  ld     a,$38
  ld     (WIN_Y),a
  xor    a
  ld     (BKG_Y),a
  ld     hl,OAMCOPY
  ld     a,(ISWORD1_X)
  ld     d,a
  call   rendersword
  ld     a,(ISWORD2_X)
  ld     d,a
  call   rendersword
+:


  ld     a,(INTRO_STEP)
  sla    a
  ld     hl,intro_vbl_lut
  rst    0
  inc    hl
  ld     h,(hl)
  ld     l,a
  call   dojump

  xor    a
  ldh    ($0F),a                ;Clear pending interrupts

  ret

  
nextstep:
  ld     a,(INTRO_STEP)
  inc    a
  ld     (INTRO_STEP),a
  ret

intro_vbl_lut:
  .dw intro_vbl_0		;Fade sword in
  .dw intro_wait
  .dw intro_set_1		;Enable BG and window (player and enemy)
  .dw intro_vbl_1		;Fade chars in
  .dw intro_wait
  .dw intro_vbl_2               ;Scroll left and right
  .dw intro_set_2               ;Remap
  .dw intro_vbl_3               ;Scroll up
  .dw intro_set_3               ;Flash to white
  .dw intro_vbl_4               ;Fade from white
  .dw intro_set_4               ;Map copyright
  .dw intro_vbl_5               ;Wait for player input


intro_vbl_0:
  ld     a,(FADER)
  inc    a
  ld     (FADER),a
  swap   a
  and    $F
  ld     hl,fade_ispr
  rst    0
  ldh    ($48),a		;SPR0 palette
  ld     a,(FADER)
  cp     $3F			;Just before $40
  ret    c
  xor    a
  ld     (FADER),a
  ld     a,40
  ld     (INTRO_TIMER),a
  jp     nextstep		;Call+ret

intro_vbl_1:
  ld     a,(FADER)
  inc    a
  ld     (FADER),a
  swap   a
  and    $F
  ld     hl,fade_wton
  rst    0
  ldh    ($47),a		;BG palette
  ld     a,(FADER)
  cp     $3F			;Just before $40
  ret    c
  xor    a
  ld     (FADER),a
  ld     a,40
  ld     (INTRO_TIMER),a
  jp     nextstep		;Call+ret

intro_wait:
  ld     a,(INTRO_TIMER)
  dec    a
  ld     (INTRO_TIMER),a
  ret    nz
  ld     a,(INTRO_STEP)
  inc    a
  ld     (INTRO_STEP),a
  ret


intro_set_1:
  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear
  
  ld     hl,OAMCOPY
  ld     a,(ISWORD1_X)
  ld     d,a
  call   rendersword

  call   RAMtoOAM		;Reload OAM right now to avoid late update and glitches

  ;Enable BG and window
  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a

  ld     a,40
  ld     (INTRO_TIMER),a
  jp     nextstep		;Call+ret


intro_vbl_2:
  ld     a,(INTRO_TIMER)
  cp     40
  jp     z,nextstep		;Call+ret
+:
  inc    a
  ld     (INTRO_TIMER),a
  dec    a
  ld     hl,lut_icharsa
  call   getbitlut
  ld     c,a

  ld     a,(BKG_X)
  add    c
  ld     (BKG_X),a
  ld     a,(WIN_X)
  add    c
  ld     (WIN_X),a
  ld     a,(ISWORD1_X)
  sub    c
  ld     (ISWORD1_X),a
  ld     a,(ISWORD2_X)
  add    c
  ld     (ISWORD2_X),a

  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear
  
  ld     hl,OAMCOPY

  ld     a,(ISWORD1_X)
  ld     d,a
  call   rendersword
  ld     a,(ISWORD2_X)
  ld     d,a
  call   rendersword
  
+:
  ret


intro_set_2:
  call	 screen_off

  xor    a
  ld     (BKG_X),a
  ld     a,48
  ld     (BKG_Y),a
  ld     a,7
  ld     (WIN_X),a
  ld     a,80
  ld     (WIN_Y),a

  ;Remap both characters on window, unwanted flash but no choice :(

  call   clearbkg

  ld     a,T_IPLAYERB
  ld     hl,(:map_iplayerb*$4000)+map_iplayerb
  ld     de,$9C00
  call   map

  ld     a,T_IENEMYB
  ld     hl,(:map_ienemyb*$4000)+map_ienemyb
  ld     de,$9C00+13
  call   map
  
  ld     a,PALETTE_CHARLEFT
  ld     hl,$9C00
  ld     bc,$070B
  call   settilepal
  ld     a,PALETTE_CHARRIGHT
  ld     hl,$9C00+13
  ld     bc,$070B
  call   settilepal
  
  ;Map title
  
  ld     a,T_TITLE
  ld     hl,(:map_title*$4000)+map_title
  ld     de,$9800+2
  call   map
  
  ld     a,PALETTE_TITLE
  ld     hl,$9800+2
  ld     bc,$0F06
  call   settilepal

  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a

  xor    a
  ld     (INTRO_TIMER),a

  jp     nextstep		;Call+ret


intro_vbl_3:
  ld     a,(INTRO_TIMER)
  cp     40
  jp     z,nextstep		;Call+ret
+:
  inc    a
  ld     (INTRO_TIMER),a
  dec    a
  ld     hl,lut_icharsb
  call   getbitlut
  ld     c,a

  ld     a,(BKG_Y)
  sub    c
  sub    c
  ld     (BKG_Y),a
  ld     a,(WIN_Y)
  sub    c
  ld     (WIN_Y),a
  ld     a,(ISWORD_Y)
  sub    c
  ld     (ISWORD_Y),a

  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear

  ld     hl,OAMCOPY

  ld     a,(ISWORD1_X)
  ld     d,a
  call   rendersword
  ld     a,(ISWORD2_X)
  ld     d,a
  call   rendersword

  ret
  
  
intro_set_3:
  xor    a
  ld     (WAVE_START),a
  ldh    ($48),a		;SPR0 palette
  ldh    ($47),a		;BG palette

  ld     de,RLI_title
  call   load_RLI

  ld     a,%00001000		;STAT Hblank
  ldh    ($41),a
  ld     a,%00000011		;STAT+Vblank
  ldh    ($FF),a
  
  ld     hl,(:fanfare*$4000)+fanfare
  call   sfx_play

  jp     nextstep		;Call+ret


intro_vbl_4:
  call   initwave
  ld     a,(FADER)
  inc    a
  ld     (FADER),a
  swap   a
  and    $F
  ld     b,a
  ld     hl,fade_wton
  rst    0
  ldh    ($47),a		;BG palette
  ld     a,b
  ld     hl,fade_ispr
  rst    0
  ldh    ($48),a		;SPR0 palette
  ld     a,(FADER)
  cp     $3F			;Just before $40
  ret    c
  xor    a
  ld     (FADER),a
  ld     a,200
  ld     (INTRO_TIMER),a
  jp     nextstep		;Call+ret
  
  
intro_set_4:
  call   initwave

  ld     a,%11100100
  ldh    ($49),a		;SPR1 palette

  ld     a,T_COPYRIGHT
  ld     hl,$9C00+8+(32*9)
  ld     bc,$0402
  call   mapinc_w

  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     a,PALETTE_SWORD
  ld     hl,$9C00+8+(32*9)
  ld     bc,$0402
  call   settilepal
  pop    af
  ldh    ($FF),a

  jp     nextstep		;Call+ret
  

intro_vbl_5:
  call   initwave

  ld     de,OAMCOPY+(15*4*2)	;Optimization to avoid rendering swords over and over

  ;Render "START"

  ld     b,6                    ;Number of sprites
  ld     c,(7*8)+8		;Initial X
-:
  ld     a,b
  swap   a
  ld     hl,WAVE_START
  add    (hl)
  add    (hl)
  sla    a
  ld     hl,(:tiles_gb*$4000)+lut_cos
  add    l
  ld     l,a
  ld     a,(hl)
  rlca
  rlca
  and    3
  add    96
  ld     (de),a
  inc    de
  ld     a,c
  ld     (de),a
  inc    de
  ld     a,(T_START+12)/2	;6->0 0->6
  sub    b
  sla    a
  ld     (de),a
  inc    de
  ld     a,%00010000+PALETTE_START	;SPR1 palette (different from swords)
  ld     (de),a
  inc    de
  ld     a,c
  add    8
  ld     c,a
  dec    b
  jr     nz,-
  
  call   readinput

  ld     a,(JOYP_ACTIVE)
  and    $F
  ret    z
  
  ldh    a,($04)
  or     a
  jr     nz,+
  inc    a
+:
  ld     (RAND8),a              ;DIV timer register used as random seed

  xor    a
  ld     (FADER),a
  ld     hl,sfxdata_menu
  call   sfx_play
  jp     menu_setup



initwave:
  xor    a
  ldh    ($43),a                ;Scroll X reset for wave
  ld     a,(WAVE_START)
  inc    a
  ld     (WAVE_START),a
  ret



RLI_title:
  push   af
  push   hl
  ldh    a,($44)
  cp     48
  jr     nc,+
  bit    0,a
  jr     z,+
  ld     hl,WAVE_START
  add    (hl)
  sla    a
  sla    a
  ld     hl,(:tiles_gb*$4000)+lut_cos
  add    l
  ld     l,a
  ld     a,(hl)
  swap   a
  and    $F
  srl    a
  sub    4			;Esthetic
  ldh    ($43),a
+:
  pop    hl
  pop    af
  reti
