;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

clear:				;Clears HL to HL+BC
  xor    a
  ldi    (hl),a
  dec    bc
  ld     a,c
  or     b
  jr     nz,clear
  ret

screen_off:               	;Turns off display in Vblank
  call   wait_vbl
  ld     a,%00010001
  ldh    ($40),a
  ret
  