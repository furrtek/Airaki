;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

rendersword:
  ld     a,(ISWORD_Y)			;Tip of sword
  ldi    (hl),a
  ld     a,d
  ldi    (hl),a
  ld     a,T_ISWORD
  ldi    (hl),a
  ld     a,%10000000+PALETTE_SWORD
  ldi    (hl),a
  ld     a,(ISWORD_Y)
  ldi    (hl),a
  ld     a,d
  add    8
  ldi    (hl),a
  ld     a,T_ISWORD+2
  ldi    (hl),a
  ld     a,%10000000+PALETTE_SWORD
  ldi    (hl),a
  
  ld     b,5				;Core
  ld     a,(ISWORD_Y)
  add    16
  ld     c,a
-:
  ld     a,c
  ldi    (hl),a
  ld     a,d
  ldi    (hl),a
  ld     a,T_ISWORD+4
  ldi    (hl),a
  ld     a,%10000000+PALETTE_SWORD
  ldi    (hl),a

  ld     a,c
  ldi    (hl),a
  add    16
  ld     c,a
  ld     a,d
  add    8
  ldi    (hl),a
  ld     a,T_ISWORD+6
  ldi    (hl),a
  ld     a,%10000000+PALETTE_SWORD
  ldi    (hl),a
  dec    b
  jr     nz,-
  
  ld     a,(ISWORD_Y)			;Handguard
  add    96
  ldi    (hl),a
  ld     a,d
  sub    4
  ldi    (hl),a
  ld     a,T_ISWORD+8
  ldi    (hl),a
  ld     a,PALETTE_SWORD
  ldi    (hl),a
  ld     a,(ISWORD_Y)
  add    96
  ldi    (hl),a
  ld     a,d
  add    4
  ldi    (hl),a
  ld     a,T_ISWORD+10
  ldi    (hl),a
  ld     a,PALETTE_SWORD
  ldi    (hl),a
  ld     a,(ISWORD_Y)
  add    96
  ldi    (hl),a
  ld     a,d
  add    12
  ldi    (hl),a
  ld     a,T_ISWORD+12
  ldi    (hl),a
  ld     a,PALETTE_SWORD
  ldi    (hl),a
  ret
