;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

calc_bonus:
  ;See if TIMEEN is < 330 seconds
  xor    a
  ld     (SCOREBONUS),a
  ld     (SCOREBONUS+1),a
  ld     (SCOREBONUS+2),a

  ld     a,(TIMEEN_SEC)		;LSB
  ld     l,a
  ld     a,(TIMEEN_SEC+1)	;MSB
  ld     h,a
  cp     2
  ret    nc			;>= $200
  or     a
  jr     z,+
  ld     a,l
  cp     $4A
  ret    nc			;>= $x4A
+:

  ;Do 330-TIMEEN
  ld     a,$4A
  sub    l
  ld     l,a
  ld     a,$1
  sbc    h
  ld     h,a
  
  ;16bit *8
  sla    l
  rl     h
  sla    l
  rl     h
  sla    l
  rl     h

  ;Hex to BCD
  ld     bc,16*256
  ld     de,0
-:
  add    hl,hl
  ld     a,e
  adc    a
  daa
  ld     e,a
  ld     a,d
  adc    a
  daa
  ld     d,a
  ld     a,c
  adc    a
  daa
  ld     c,a
  dec    b
  jr     nz,-
  
  ld     a,e
  ld     (SCOREBONUS),a
  ld     a,d
  ld     (SCOREBONUS+1),a
  xor    a
  ld     (SCOREBONUS+2),a

  ;Add to score
  ld     a,(SCOREEN)	;LSB
  add    e
  daa
  ld     (SCOREEN),a
  ld     a,(SCOREEN+1)
  adc    d
  daa
  ld     (SCOREEN+1),a
  ld     a,(SCOREEN+2)	;MSB
  ld     d,0
  adc    d
  daa
  ld     (SCOREEN+2),a
  ret
