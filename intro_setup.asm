;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE T_IBLANK	0

  .DEFINE T_ISWORD	2
  .DEFINE T_IPLAYERB	20
  .DEFINE T_IENEMYB	64
  .DEFINE T_IPLAYERA	108
  .DEFINE T_IENEMYA	133
  .DEFINE T_TITLE	157
  .DEFINE T_COPYRIGHT	210
  .DEFINE T_START	218

intro_setup:
  di
  call	 screen_off

  call   clearbkg
  call   clearsprites
  ld     hl,OAMCOPY		;Clear OAM buffer
  ld     bc,$A0
  call   clear
  ld     hl,$8000		;Clear first tile
  ld     bc,16
  call   clear

  ld     hl,(:tiles_isword*$4000)+tiles_isword
  ld     de,$8000+(T_ISWORD*16)
  call   loadtiles_auto

  ld     hl,(:tiles_iplayera*$4000)+tiles_iplayera
  ld     de,$8000+(T_IPLAYERA*16)
  call   loadtiles_auto
  ld     hl,(:tiles_iplayerb*$4000)+tiles_iplayerb
  ld     de,$8000+(T_IPLAYERB*16)
  call   loadtiles_auto

  ld     hl,(:tiles_ienemya*$4000)+tiles_ienemya
  ld     de,$8000+(T_IENEMYA*16)
  call   loadtiles_auto
  ld     hl,(:tiles_ienemyb*$4000)+tiles_ienemyb
  ld     de,$8000+(T_IENEMYB*16)
  call   loadtiles_auto
  
  ld     hl,(:tiles_title*$4000)+tiles_title
  ld     de,$8000+(T_TITLE*16)
  call   loadtiles_auto
  
  ld     hl,(:tiles_copyright*$4000)+tiles_copyright
  ld     de,$8000+(T_COPYRIGHT*16)
  call   loadtiles_auto
  
  ld     hl,(:tiles_start*$4000)+tiles_start
  ld     de,$8000+(T_START*16)
  call   loadtiles_auto

  ld     a,T_IPLAYERA
  ld     hl,(:map_iplayera*$4000)+map_iplayera
  ld     de,$9800+22+(32*10)
  call   map
  ld     a,T_IPLAYERB
  ld     hl,(:map_iplayerb*$4000)+map_iplayerb
  ld     de,$9800+25+(32*10)
  call   map

  ld     a,T_IENEMYA
  ld     hl,(:map_ienemya*$4000)+map_ienemya
  ld     de,$9C00+7+(32*10)
  call   map
  ld     a,T_IENEMYB
  ld     hl,(:map_ienemyb*$4000)+map_ienemyb
  ld     de,$9C00+(32*10)
  call   map
  
  ld     a,PALETTE_CHARLEFT
  ld     hl,$9800+22+(32*10)
  ld     bc,$0A0B
  call   settilepal
  ld     a,PALETTE_CHARRIGHT
  ld     hl,$9C00+(32*10)
  ld     bc,$0A0B
  call   settilepal

  xor    a
  ld     (INTRO_STEP),a
  ld     (FADER),a

  ld     a,72+8
  ld     (ISWORD1_X),a
  ld     (ISWORD2_X),a
  ld     a,33+16
  ld     (ISWORD_Y),a

  ld     a,164
  ld     (BKG_X),a
  xor    a
  ld     (BKG_Y),a

  ld     a,75
  ld     (WIN_X),a
  xor    a
  ld     (WIN_Y),a
  
  ld     hl,OAMCOPY
  ld     a,(ISWORD1_X)
  ld     d,a
  call   rendersword

  ld     a,%00000000            ;BG palette (all clear)
  ldh    ($47),a
  ld     a,%00000000            ;SPR0 palette (all clear)
  ldh    ($48),a
  ld     a,%11110110            ;Display on, BG off, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a
  ld     a,%00000001            ;Vblank only
  ldh    ($FF),a

  ld     hl,VBL_HANDLER
  ld     de,intro_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d

  ld     de,RLI_null
  call   load_RLI

  xor    a
  ldh    ($0F),a                ;Clear pending interrupts
  ei

  ret
