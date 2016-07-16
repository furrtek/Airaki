;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

sumcheck:
  ld     hl,$0150		;16bit add loop
  ld     bc,32768-$150
  ld     de,0
-:
  ld     a,e
  add    (hl)
  ld     e,a
  jr     nc,+
  inc    d
+:
  inc    hl
  dec    bc
  ld     a,b
  or     c
  jr     nz,-
  
  ld     hl,checksum
  ldi    a,(hl)
  cp     e
  jp     nz,lock_checksum
  ld     a,(hl)
  jp     nz,lock_checksum
  ret
  
lock_checksum:
  call   wait_vbl
  xor    a                      ;Display off
  ldh    ($40),a

  ld     hl,(:tiles_alpha*$4000)+tiles_alpha
  ld     de,$8000
  call   loadtiles_auto

  call   clearbkg
  call   clearsprites
  
  ld     hl,$9800+(32*8)+3
  ld     de,text_cerror
  ld     b,32
  call   maptext
  
  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  ld     a,PALETTE_RED
  ld     hl,$9800
  ld     bc,$2020
  call   settilepal
  ld     hl,pal_game_common
  ld     b,7*4*2
  ld     a,1*4*2
  call   loadbgpal
+:

  xor    a
  ldh    ($42),a                ;Scroll Y
  ldh    ($43),a                ;Scroll X

  ld     a,%11100100
  ldh    ($47),a

  ld     a,%10010001            ;Display on, BG on, sprites off, window off, tiles at $8000
  ldh    ($40),a

-:
  halt
  nop
  jr     -

text_sumerror:
.db "Checksum error",$FF
