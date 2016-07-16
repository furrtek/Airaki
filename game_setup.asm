;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE T_BLANK	0

  .DEFINE T_SEP		1	;Vertical separator line

  .DEFINE T_ICONS	32-16	;Needs to be together (flash anim is an extension of the icons set)
  .DEFINE T_FLASH	64-16

  .DEFINE T_CURSORH	80-16
  .DEFINE T_CURSORV	82-16

  .DEFINE T_HPBAR	84-16
  .DEFINE T_HPBARE	84+1-16
  .DEFINE T_HPBARF	84+9-16

  .DEFINE T_HEARTH	94-16
  .DEFINE T_SSI		95-16

  .DEFINE T_POP2	96-16
  .DEFINE T_POP3	100-16
  .DEFINE T_POPHZ	104-16

  .DEFINE T_DIZZY	108-16
  .DEFINE T_IMMDEATH	112-16

  .DEFINE T_SHIELD	116-16

  .DEFINE T_ENEMY	124-16
  .DEFINE T_PLAYER	140-16

  .DEFINE T_AASPRE	160-16 		;Start of dynamic enemy sprite loading for attack animations
  .DEFINE T_AASPRP	184-16		;Same for player

  .DEFINE T_ALPHA	192

game_setup:
  di
  call	 screen_off

  call   clearbkg
  call   clearsprites
  ld     hl,$8000		;Clear first tile
  ld     bc,16
  call   clear
  
  ld     hl,(:tiles_flash*$4000)+tiles_sep
  ld     de,$8000+(T_SEP*16)
  call   loadtiles_auto
  
  call   loadicons

  ld     hl,(:tiles_flash*$4000)+tiles_flash
  ld     de,$8000+(T_FLASH*16)
  call   loadtiles_auto

  ld     hl,(:tiles_cursorh*$4000)+tiles_cursorh
  ld     de,$8000+(T_CURSORH*16)
  call   loadtiles_auto
  ld     hl,(:tiles_cursorv*$4000)+tiles_cursorv
  ld     de,$8000+(T_CURSORV*16)
  call   loadtiles_auto

  ld     hl,(:tiles_hpbar*$4000)+tiles_hpbar
  ld     de,$8000+(T_HPBAR*16)
  call   loadtiles_auto
  
  ld     hl,(:tiles_shield*$4000)+tiles_shield
  ld     de,$8000+(T_SHIELD*16)
  call   loadtiles_auto
  ld     hl,(:tiles_hearth*$4000)+tiles_hearth
  ld     de,$8000+(T_HEARTH*16)
  call   loadtiles_auto
  
  ;SpecialSkillIndicator loading
  ld     a,(MCURSOR_SSEL)
  sla    a
  ld     hl,ssi_lut
  rst    0
  inc    hl
  ld     h,(hl)
  ld     l,a
  ld     de,$8000+(T_SSI*16)
  call   loadtiles_auto

  ld     hl,(:tiles_pop2*$4000)+tiles_pop2
  ld     de,$8000+(T_POP2*16)
  call   loadtiles_auto
  ld     hl,(:tiles_pop3*$4000)+tiles_pop3
  ld     de,$8000+(T_POP3*16)
  call   loadtiles_auto
  ld     hl,(:tiles_pophz*$4000)+tiles_pophz
  ld     de,$8000+(T_POPHZ*16)
  call   loadtiles_auto

  ld     hl,(:tiles_dizzy*$4000)+tiles_dizzy
  ld     de,$8000+(T_DIZZY*16)
  call   loadtiles_auto
  ld     hl,(:tiles_immdeath*$4000)+tiles_immdeath
  ld     de,$8000+(T_IMMDEATH*16)
  call   loadtiles_auto
  
  ld     hl,(:tiles_alpha*$4000)+tiles_alpha
  ld     de,$8000+(T_ALPHA*16)
  call   loadtiles_auto

  ;Map separator bar (window)
  ld     hl,$9C00
  ld     b,18
  ld     a,T_SEP
  ld     de,32
-:
  ld     (hl),a
  add    hl,de
  dec    b
  jr     nz,-

  ld     hl,$9C00+(32*4)+1
  ld     bc,$0404
  ld     a,T_ENEMY
  call   mapinc_w

  ld     hl,$9C00+(32*10)+1
  ld     bc,$0404
  ld     a,T_PLAYER
  call   mapinc
                  
  xor    a
  ld     (SCORE),a
  ld     (SCORE+1),a
  ld     (SCORE+2),a

  call   drawlives
  ld     hl,$9C00+(1*32)+1
  ld     de,SCORE
  call   drawscore
  call   disp_time

  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  ld     hl,pal_game_bg
  ld     b,1*4*2
  xor    a
  call   loadbgpal
  ld     hl,pal_game_spr
  ld     b,1*4*2
  xor    a
  call   loadsprpal
  ld     hl,pal_game_common
  ld     b,7*4*2
  ld     a,1*4*2
  call   loadbgpal
  ld     hl,pal_game_common
  ld     b,7*4*2
  ld     a,1*4*2
  call   loadsprpal
  ld     a,PALETTE_GREYIF
  ld     hl,$9C00		;Separator bar
  ld     bc,$0112
  call   settilepal
  ld     a,PALETTE_GREYIF
  ld     hl,$9C01		;Score/time
  ld     bc,$0502
  call   settilepal
  ld     a,PALETTE_RED
  ld     hl,$9C01+(32*3)	;Enemy HP bar
  ld     bc,$0401
  call   settilepal
  ld     a,PALETTE_ENEMY
  ld     hl,$9C01+(32*4)	;Enemy
  ld     bc,$0505
  call   settilepal
  ld     a,PALETTE_FIST
  ld     hl,$9C01+(32*10)	;Player
  ld     bc,$0405
  call   settilepal
  ld     a,PALETTE_RED
  ld     hl,$9C00+(15*32)+1  	;Red hearts
  ld     bc,$0301
  call   settilepal
  ld     a,PALETTE_SHIELD
  ld     hl,$9C00+(16*32)+1  	;Shield stack icons
  ld     bc,$0402
  call   settilepal
+:

  ;RAM init

  xor    a
  ld     (FADER),a		;Start with fade (all white)
  ld     (CURSOR_MODE),a        ;V cursor
  ld     a,3
  ld     (CURSOR_X),a		;Center of panel
  ld     a,4
  ld     (CURSOR_Y),a

  xor    a
  ld     (LEVEL),a
  ld     (HAS_SPECIAL),a
  ld     (PLAYER_DIZZY),a
  ld     (PLAYER_SH1),a
  ld     (PLAYER_SH2),a
  ld     (ENEMY_SH),a
  ld     (SCORE),a
  ld     (SCORE+1),a
  ld     (SCORE+2),a
  ld     (TIME_FRAME),a
  ld     (TIME_SEC),a
  ld     (TIME_MIN),a
  ld     (LINK_STATE),a
  ld     (LINK_TIMEOUT),a
  ld     (LINK_FIELD),a

  ld     a,BLINK_TIME
  ld     (PLAYER_BLINK),a

  ld     a,255
  ld     (PLAYER_HP),a

  call   lvlsetup
  
  ld     hl,ENEMYGFX_IDLE
  call   loadenemy
  call   loadplayer

  xor    a
  ldh    ($42),a                ;Scroll Y
  ldh    ($43),a                ;Scroll X
  ldh    ($4A),a		;Window Y
  ld     a,119
  ldh    ($4B),a                ;Window X

  ld     a,%11100100            ;Palette BG
  ldh    ($47),a
  ld     a,%11100100            ;Palette SPR0
  ldh    ($48),a
  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a
  ld     a,%00001001            ;Vblank+serial
  ldh    ($FF),a

  ld     hl,VBL_HANDLER
  ld     de,game_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d

  ld     de,RLI_null
  call   load_RLI

  xor    a
  ldh    ($0F),a                ;Clear pending interrupts
  ei

  ret

ssi_lut:
  .dw (:tiles_ssi0*$4000)+tiles_ssi0
  .dw (:tiles_ssi1*$4000)+tiles_ssi1
  .dw (:tiles_ssi2*$4000)+tiles_ssi2
