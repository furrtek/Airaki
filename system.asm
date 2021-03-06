;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

readinput:
  push   bc
  ld     a,(JOYP_CURRENT)
  ld     (JOYP_LAST),a
  ld     a,%00010000		;Buttons
  ldh    ($00),a
  nop
  nop
  nop
  ldh    a,($00)
  and    $0F
  xor    $0F
  ld     b,a
  ld     a,%00100000  		;Directions
  ldh    ($00),a
  nop
  nop
  nop
  ldh    a,($00)
  and    $0F
  xor    $0F
  swap   a
  or     b
  ld     (JOYP_CURRENT),a
  ld     b,a
  ld     hl,PREVJP
  ld     a,(hl)
  xor    b
  and    b            		;Keep rising edges
  ld     (hl),b
  ld     (JOYP_ACTIVE),a
  pop    bc
  ret

;Input: D = Dividend, E = Divisor, A = 0
;Output: D = Quotient, A = Remainder
;Stolen from "Z80 Bits"
div8_8:
  xor    a

  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  sla	 d		; unroll 8 times
  rla			; ...
  cp	 e		; ...
  jr	 c,+		; ...
  sub	 e		; ...
  inc	 d		; ...
+:
  ret
