;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE T_LERROR	160

linkerror:
  ld     a,(LINK_TIMEOUT)
  inc    a
  ld     (LINK_TIMEOUT),a
  cp     LINKTIMEOUT_DURATION
  ret    c
  ld     a,(LINK_QUIT)
  or     a
  jr     z,+
  xor    a
  ld     (LINK_QUIT),a
  di
  call   screen_off
  call   clearbkg
  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a
  jp     restart
+:
  di
  call	 screen_off
  call   wait_vbl
  call   clearsprites
  ld     hl,(:tiles_linkerror*$4000)+tiles_linkerror
  ld     de,$8000+(T_LERROR*16)
  call   loadtiles_auto
  ld     a,T_LERROR
  ld     hl,(:map_linkerror*$4000)+map_linkerror
  ld     de,$9800+(7*32)+6
  call   map
  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  ld     a,PALETTE_RED
  ld     hl,$9800+(7*32)+6
  ld     bc,$0804
  call   settilepal
+:
  ld     a,2
  ld     (LINK_STATE),a
  ld     hl,VBL_HANDLER
  ld     de,link_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d
  ld     hl,LINK_HANDLER
  ld     de,0
  ld     (hl),e
  inc    hl
  ld     (hl),d
  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a
  ei
  ret

do_comm:
  ld     a,(GAME_MODE)
  bit    0,a
  ret    z
  ld     a,(FRAME)
  and    1
  call   z,link_comm
  ret
