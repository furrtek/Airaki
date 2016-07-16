;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

VBlank:
  push   af
  push   bc
  push   de
  push   hl
  
  call   RAMtoOAM
  
  ld     a,1
  ld     (GOTVBL),a

  ; Makes most Action Replays crash :)
  ld     hl,FRAME
  inc   (hl)
  ld     l,(hl)
  ld     h,$1A
  ld     a,(hl)

  pop    hl
  pop    de
  pop    bc
  pop    af
  reti

link_int:
  push   af
  push   bc
  push   de
  push   hl

  ldh    a,($01)
  ld     (LINK_RX),a
  ld     hl,LINK_HANDLER
  rst    $20

  pop    hl
  pop    de
  pop    bc
  pop    af
  reti

dojump:
  jp     hl
  
load_RLI:
  ld     a,e
  ld     (RLI+1),a
  ld     a,d
  ld     (RLI+2),a
  ret

RLI_null:
  reti
