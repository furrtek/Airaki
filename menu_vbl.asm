;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

menu_vbl:
  call   RAMtoOAM

  xor    a
  ldh    ($43),a	;Scroll X
  
  call   sfx_update

  call   dofade

  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear
  
  ld     hl,OAMCOPY

  ;Render selection markers

  ld     a,(MCURSOR_PSEL)
  ld     c,(6*8)+10
  or     a
  jr     z,+
  ld     c,(16*8)+9
+:
  ld     a,65+16
  ldi    (hl),a
  ld     a,c
  ldi    (hl),a
  ld     a,T_VAL
  ldi    (hl),a
  xor    a
  ldi    (hl),a

  ld     a,(MCURSOR_SSEL)
  swap   a
  ld     b,a
  sla    a
  add    b		;*48
  add    47
  ld     c,a
  ld     a,147-16
  ldi    (hl),a
  ld     a,c
  ldi    (hl),a
  ld     a,T_VAL
  ldi    (hl),a
  xor    a
  ldi    (hl),a

  ;Render cursor

  ld     a,(MCURSOR_LINE)
  or     a
  jr     nz,+

  ld     a,(MCURSOR_PSEL)
  or     a
  ld     de,mcur_lut2		;Cursor is 2P
  jr     nz,++
  ld     de,mcur_lut1           ;Cursor is 1P
++:
  ld     b,3
-:
  ld     a,(de)
  ldi    (hl),a
  inc    de
  ld     a,(de)
  ldi    (hl),a
  inc    de
  ld     a,T_MCURSOR
  ldi    (hl),a
  ld     a,(de)
  ldi    (hl),a
  inc    de
  dec    b
  jr     nz,-
  jr     +++

+:
  ld     a,(MCURSOR_SSEL)
  swap   a
  ld     b,a
  sla    a
  add    b		;*48
  ld     c,a
  ld     de,mcur_lut3		;Cursor is special skill
  ld     b,3
-:
  ld     a,(de)
  ldi    (hl),a
  inc    de
  ld     a,(de)
  add    c
  ldi    (hl),a
  inc    de
  ld     a,T_MCURSOR
  ldi    (hl),a
  ld     a,(de)
  ldi    (hl),a
  inc    de
  dec    b
  jr     nz,-

+++:

  call   readinput
  call   menu_input
  ret

;Y,X,tile,attr
mcur_lut1:
  ;1P
  .db 5+16+16,29+8,0
  .db 5+16+16,50+8,%00100000
  .db 41+16+16,29+8,%01000000

mcur_lut2:
  ;2P
  .db 5+16+16,86+8,0
  .db 5+16+16,129+8,%00100000
  .db 41+16+16,86+8,%01000000

mcur_lut3:
  ;Special
  .db 109,17+8,0
  .db 109,39+8,%00100000
  .db 123,17+8,%01000000

RLI_menu:
  push   af
  ld     a,-4
  ldh    ($43),a	;Scroll X
  pop    af
  reti
