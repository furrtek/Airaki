;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE T_SPLASHFSE	32

nscrollout_setup:
  di
  call	 screen_off
  
  ld     hl,(:tiles_splashfse*$4000)+tiles_splashfse
  ld     de,$8000+(T_SPLASHFSE*16)
  call   loadtiles_auto
  
  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  call   initpals
  ld     hl,pal_intro
  ld     b,4*2*6
  ld     a,0
  call   loadbgpal
  ld     hl,pal_intro
  ld     b,4*2*6
  ld     a,0
  call   loadsprpal
+:

  ld     a,T_SPLASHFSE
  ld     hl,$9800+6+(32*22)
  ld     bc,$0803
  call   mapinc_w

  xor    a
  ld     (BKG_Y),a
  ld     a,(GBCOLOR)		;Skip Nintendo logo scrollout if we're on GBA or GBC
  or     a
  jr     z,+
  ld     a,PALETTE_FSE
  ld     hl,$9800
  ld     bc,$2020
  call   settilepal
  ld     a,120
  ld     (BKG_Y),a
  ld     a,$55
+:
  ld     (LOGOS_TIMER),a

  ld     hl,VBL_HANDLER
  ld     de,scrollout_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d

  ld     de,RLI_null
  call   load_RLI

  ld     a,%00000001		;Vblank only
  ldh    ($FF),a
  
  ld     a,145			;Window Y off the screen, needed for CGB bootup
  ldh    ($4A),a
  ld     a,%11110101            ;Display on, BG on, sprites off, window on, tiles at $8000
  ldh    ($40),a		;Needed for CGB bootup

  xor    a
  ldh    ($0F),a                ;Clear pending interrupts
  ei
  ret
  
scrollout_vbl:
  ld     a,(LOGOS_TIMER)
  cp     36
  jr     nz,+
  ;Clear Nintendo logo to avoid wrap
  ld     hl,$9800+4+(32*8)
  ld     bc,32+32-4
  call   clear_w
  ld     a,%11100100
  ldh    ($47),a		;BG palette
+:
  ld     a,(LOGOS_TIMER)
  cp     200
  jr     z,+

  inc    a
  ld     (LOGOS_TIMER),a
  dec    a
  ld     hl,lut_logos
  call   getbitlut
  ld     c,a
  ld     a,(BKG_Y)
  sub    c
  ld     (BKG_Y),a
  ldh    ($42),a                ;Scroll Y
  ret
+:
  call   screen_off
  call   clearbkg
  
  jp   intro_setup		;Call+ret
