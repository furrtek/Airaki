;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

inc_time:
  ld     a,(TIME_FRAME)
  inc    a
  ld     (TIME_FRAME),a
  cp     60
  jr	 nz,++
  xor    a
  ld     (TIME_FRAME),a
  
  call   inc_timeen

  ld     a,(TIME_SEC)		;Inc units seconds
  inc    a
  ld     (TIME_SEC),a
  and    $F
  cp     $A
  jr	 nz,+
  ld     a,(TIME_SEC)
  and    $F0
  add    $10                    ;Inc tens seconds
  ld     (TIME_SEC),a

  and    $F0
  cp     $60
  jr	 nz,+
  xor    a
  ld     (TIME_SEC),a
  ld     a,(TIME_MIN)		;Inc units minutes
  inc    a
  ld     (TIME_MIN),a

  and    $F
  cp     $A
  jr	 nz,+
  ld     a,(TIME_MIN)
  and    $F0
  add    $10                    ;Inc tens minutes
  ld     (TIME_MIN),a
+:

  call   disp_time
++:

  ld     a,(TIME_SEC)
  cp     $59
  ret    nz
  ld     a,(TIME_MIN)		;Game over after 99:99
  cp     $99
  ret    nz
  jp     pdeath


inc_timeen:
  ld     a,(TIMEEN_SEC)		;LSB
  ld     l,a
  ld     a,(TIMEEN_SEC+1)	;MSB
  ld     h,a
  cp     $FF
  jr     nz,+
  ld     a,l
  cp     $FF
  ret    z
+:
  inc    hl
  ld     a,l
  ld     (TIMEEN_SEC),a		;LSB
  ld     a,h
  ld     (TIMEEN_SEC+1),a	;MSB
  ret

;HL = VRAM, DE = min/sec, B = ASCII index
disp_time:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a

  ld     hl,$9C00+1
  ld     b,$D0
  ld     a,(TIME_MIN)
  ld     d,a
  ld     a,(TIME_SEC)
  ld     e,a
  ld     a,d
  swap   a
  and    $F
  add    b
  call   wait_write
  ldi    (hl),a
  ld     a,d
  and    $F
  add    b
  call   wait_write
  ldi    (hl),a
  ld     a,':'-48
  add    b
  call   wait_write
  ldi    (hl),a
  ld     a,e
  swap   a
  and    $F
  add    b
  call   wait_write
  ldi    (hl),a
  ld     a,e
  and    $F
  add    b
  call   wait_write
  ldi    (hl),a
  
  pop    af
  ldh    ($FF),a
  ret
