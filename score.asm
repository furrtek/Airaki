;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;B=To add
inc_score:
  push   bc
  ld     a,(SCORE)		;DHL=(SCORE)
  ld     l,a
  ld     a,(SCORE+1)
  ld     h,a
  ld     a,(SCORE+2)
  ld     d,a
  call   inc_24bit
  ld     a,l                    ;(SCORE)=DHL
  ld     (SCORE),a
  ld     a,h
  ld     (SCORE+1),a
  ld     a,d
  ld     (SCORE+2),a
  
  pop    bc
  ld     a,(SCOREEN)		;DHL=(SCOREEN)
  ld     l,a
  ld     a,(SCOREEN+1)
  ld     h,a
  ld     a,(SCOREEN+2)
  ld     d,a
  call   inc_24bit
  ld     a,l                    ;(SCOREEN)=DHL
  ld     (SCOREEN),a
  ld     a,h
  ld     (SCOREEN+1),a
  ld     a,d
  ld     (SCOREEN+2),a

  ret
  
inc_24bit:
  ld     a,b
  call   bin2bcd
  ld     e,a
  ld     a,l
  add    e
  daa
  ld     l,a
  jr     nc,+
  ld     a,h
  add    1
  daa
  ld     h,a
  jr     nc,+
  ld     a,d
  add    1
  daa
  cp     $10			;Cap to 99999
  jr     nz,++
  ld     l,$99
  ld     h,l
  ld     d,9
  jr     +
++:
  ld     d,a
+:
  ret


drawscore:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a

  ld     c,$D0

  inc    de
  inc    de
  ld     a,(de)
  and    $F
  add    c
  call   wait_write
  ldi    (hl),a

  dec    de
  ld     a,(de)
  ld     b,a
  swap   a
  and    $F
  add    c
  call   wait_write
  ldi    (hl),a
  ld     a,b
  and    $F
  add    c
  call   wait_write
  ldi    (hl),a

  dec    de
  ld     a,(de)
  ld     b,a
  swap   a
  and    $F
  add    c
  call   wait_write
  ldi    (hl),a
  ld     a,b
  and    $F
  add    c
  call   wait_write
  ldi    (hl),a

  pop    af
  ldh    ($FF),a
  ret

