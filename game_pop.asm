;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

makepop:
  push   bc
  push   de
  push   hl
  ld     (POP_GFX),a
  ;Compute pop position from HL (L really, should be position of match in PANEL)
  ld     a,l
  sub    <PANEL		;Subtract LSB (in case PANEL address is changed one day...)
  ld     d,a
  ld     e,7
  call   div8_8
  swap   a		;*16
  and    $F0
  add    8+8		;Esthetical
  ld     (POP_X),a
  ld     a,d
  swap   a		;*16
  and    $F0
  add    8		;+16 normally for HW sprite -16 quirk, but 8 esthetically is good
  ld     (POP_Y),a
  ld     a,32
  ld     (POP_ANIM),a
  pop    hl
  pop    de
  pop    bc
  ret

renderpop:
  ld     a,(POP_Y)
  ldi    (hl),a
  ld     a,(POP_X)
  ldi    (hl),a
  ld     a,(POP_GFX)
  ldi    (hl),a
  xor    a
  ldi    (hl),a

  ld     a,(POP_Y)
  ldi    (hl),a
  ld     a,(POP_X)
  add    8
  ldi    (hl),a
  ld     a,(POP_GFX)
  add    2
  ldi    (hl),a
  xor    a
  ldi    (hl),a
  ret

animpop:
  ld     a,(POP_ANIM)
  or     a
  ret    z
  dec    a
  ld     (POP_ANIM),a
  and    1
  ret    z		;1 frame out of 2
  ld     hl,POP_Y
  dec    (hl)
  ret
