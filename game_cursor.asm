;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

changecursor:
  ld     hl,sfxdata_curch
  call   sfx_play
  ld     a,(CURSOR_MODE)
  or     a
  jr     nz,++
  ;Change from H to V: correct position if needed (Y=8 ?)
  ld     a,(CURSOR_Y)
  cp     8
  jr     nz,+
  dec    a
  ld     (CURSOR_Y),a
+:
  ld     a,1
  ld     (CURSOR_MODE),a
  ret
++:
  ;Change from V to H: correct position if needed (X=6 ?)
  ld     a,(CURSOR_X)
  cp     6
  jr     nz,+
  dec    a
  ld     (CURSOR_X),a
+:
  xor    a
  ld     (CURSOR_MODE),a
  ret

rendercursor:
  ld     a,(FRAME)
  and    8
  srl    a
  srl    a
  srl    a
  ld     c,a			;C is cursor shrink animation

  ld     a,(CURSOR_MODE)
  or     a
  jr     nz,+
  ;Render H
  ;Cursor left
  ld     a,(CURSOR_Y)
  swap   a
  add    16
  ldi    (hl),a
  ld     a,(CURSOR_X)
  swap   a
  add    8
  sub    c
  ldi    (hl),a
  ld     a,T_CURSORH
  ldi    (hl),a
  xor    a
  ldi    (hl),a

  ;Cursor right
  ld     a,(CURSOR_Y)
  swap   a
  add    16
  ldi    (hl),a
  ld     a,(CURSOR_X)
  swap   a
  add    8+24
  add    c
  ldi    (hl),a
  ld     a,T_CURSORH
  ldi    (hl),a
  ld     a,%00100000
  ldi    (hl),a
  ret
  
+:
  ;Render V
  ;Cursor top left
  ld     a,(CURSOR_Y)
  swap   a
  add    16
  sub    c
  ldi    (hl),a
  ld     a,(CURSOR_X)
  swap   a
  add    8
  ldi    (hl),a
  ld     a,T_CURSORV
  ldi    (hl),a
  xor    a
  ldi    (hl),a

  ;Cursor top right
  ld     a,(CURSOR_Y)
  swap   a
  add    16
  sub    c
  ldi    (hl),a
  ld     a,(CURSOR_X)
  swap   a
  add    8+8
  ldi    (hl),a
  ld     a,T_CURSORV
  ldi    (hl),a
  ld     a,%00100000
  ldi    (hl),a
  
  ;Cursor bottom left
  ld     a,(CURSOR_Y)
  swap   a
  add    16+16
  add    c
  ldi    (hl),a
  ld     a,(CURSOR_X)
  swap   a
  add    8
  ldi    (hl),a
  ld     a,T_CURSORV
  ldi    (hl),a
  ld     a,%01000000
  ldi    (hl),a

  ;Cursor bottom right
  ld     a,(CURSOR_Y)
  swap   a
  add    16+16
  add    c
  ldi    (hl),a
  ld     a,(CURSOR_X)
  swap   a
  add    8+8
  ldi    (hl),a
  ld     a,T_CURSORV
  ldi    (hl),a
  ld     a,%01100000
  ldi    (hl),a
  ret
