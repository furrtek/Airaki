;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE T_LWAIT	1

link_setup:
  di
  call	 screen_off

  call   clearbkg
  call   clearsprites
  
  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  ld     hl,pal_link
  ld     b,4*2*1
  ld     a,0
  call   loadbgpal
  xor    a
  ld     hl,$9800
  ld     bc,$2020
  call   settilepal
+:

  ld     hl,(:tiles_linkwait*$4000)+tiles_linkwait
  ld     de,$8000+(T_LWAIT*16)
  call   loadtiles_auto

  ld     a,T_LWAIT
  ld     hl,(:map_linkwait*$4000)+map_linkwait
  ld     de,$9800+(7*32)+6
  call   map

  ld     a,%11100100
  ldh    ($47),a
  
  ld     a,LINK_HANDSHAKE
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a

  ld     hl,LINK_HANDLER
  ld     de,linkh_wm			;No special code for handling serial interrupt
  ld     (hl),e
  inc    hl
  ld     (hl),d

  xor    a
  ld     (LINK_STATE),a
  ld     (LINK_TIMEOUT),a
  ld     (LINK_RX),a
  ld     hl,VBL_HANDLER
  ld     de,link_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d
  
  ld     a,%00001001		;Vblank+Serial interrupts
  ldh    ($FF),a

  ld     a,%11010111            ;Display on, BG on, sprites on 8x16, window off, tiles at $8000
  ldh    ($40),a

  xor    a
  ldh    ($0F),a                ;Clear pending interrupts
  ei
  ret
