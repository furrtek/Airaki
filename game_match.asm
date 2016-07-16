;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

checkmatches:
  xor    a
  ld     (MATCHED),a

  ld     hl,PANEL
  ld     c,7*(9-2)
-:
  call   checkvmatch
  inc    l
  dec    c
  jr     nz,-

  ld     hl,PANEL
  ld     c,0
-:
  call   checkhmatch
  inc    l
  inc    c
  ld     a,c
  and    $F
  cp     5
  jr     c,-
  inc    l
  inc    l
  ld     a,c
  and    $F0
  add    $10
  ld     c,a
  cp     $90
  jr     nz,-

  ld     a,(MATCHED)
  or     a
  ld     a,4
  jr     nz,+
  ;No matches, see if we need to cancel flip or let player play
  ld     a,(FLIP_FLAGS)
  cp     5
  jr     z,++		;Just let player go
  ;Can only be "2" here (normally): cancel flip before letting player go
  ld     a,6            ;CPU-initiated flip
  ld     (FLIP_TOSET),a
  jp     makeflip	;Call+ret
++:
  call   checksolve	;Check if panel is still solvable right before letting player play
  ld     a,0
+:
  ;Matches found: proceed to deletion
  ld     (FLIP_FLAGS),a
  ret


checkhmatch:
  ld     a,(hl)
  cp     8
  ret    nc
  push   hl
  ld     b,(hl)
  inc    l
  ld     a,(hl)
  cp     b
  jr     nz,+		;No match 2
  inc    l
  ld     a,(hl)
  cp     b
  jr     nz,+		;No match 3
  ;Match at least 3: mark last 2 and current
  dec    l
  dec    l
  ld     a,$98		;Delete anim flag  + redraw + flash icon start
  ld     (MATCHED),a
  ld     (hl),a		;First
  inc    l
  ld     (hl),a         ;Second
  inc    l
  ld     (hl),a         ;Current
  ;See if we can continue rightwards
  inc    l
  ld     a,l
  call   xOOBcheck
  jr     nz,++
  ;No: matched only 3
-:
  pop    hl
  push   hl
  ld     a,MOD_H
  call   matchaction
  ld     a,T_POPHZ
  call   makepop
  ld     hl,sfxdata_match1	;Match sound
  call   sfx_play
  jr     +
++:
  ;Yes
  ld     a,(hl)
  cp     b
  jr     nz,-		;No match 4, so we matched 3 only
  ;Match at least 4
  ld     a,$98		;Delete anim flag  + redraw + flash icon start
  ld     (hl),a		;Current
  ;See if we can continue rightwards
  inc    l
  ld     a,l
  call   xOOBcheck
  jr     z,+++		;No
  ;Yes
  ld     a,(hl)
  cp     b
  jr     z,++		;Match 5
+++:
  ;No match 5, so we matched 4 only
  pop    hl
  push   hl
  ld     a,MOD_2
  call   matchaction
  ld     a,T_POP2
  call   makepop
  ld     hl,sfxdata_match2	;Match sound
  call   sfx_play
  jr     +
++:
  ld     a,$98		;Delete anim flag + redraw + flash icon start
  ld     (hl),a		;Current
  ;Matched 5 (max)
  pop    hl
  push   hl
  ld     a,MOD_3
  call   matchaction
  ld     a,T_POP3
  call   makepop
  ld     hl,sfxdata_match2	;Match sound
  call   sfx_play
+:
  pop    hl
  ret

;See if A doesn't match an OOB on X in PANEL (stupid but fast)
xOOBcheck:
  cp     $80+7
  ret    z
  cp     $80+7+7
  ret    z
  cp     $80+7+7+7
  ret    z
  cp     $80+7+7+7+7
  ret    z
  cp     $80+7+7+7+7+7
  ret    z
  cp     $80+7+7+7+7+7+7
  ret    z
  cp     $80+7+7+7+7+7+7+7
  ret    z
  cp     $80+7+7+7+7+7+7+7+7
  ret    z
  cp     $80+7+7+7+7+7+7+7+7+7
  ret    z
  ld     a,1
  or     a	;Clear Z
  ret

checkvmatch:
  ld     a,(hl)
  cp     8
  ret    nc
  push   hl
  ld     de,7
  ld     b,(hl)
  add    hl,de
  ld     a,(hl)
  cp     b
  jr     nz,+		;No match 2
  add    hl,de
  ld     a,(hl)
  cp     b
  jr     nz,+		;No match 3
  ;Match at least 3: Mark last 2 and current
  pop    hl
  push   hl
  ld     a,$98		;Delete anim flag  + redraw + flash icon start
  ld     (MATCHED),a
  ld     (hl),a		;First
  add    hl,de
  ld     (hl),a         ;Second
  add    hl,de
  ld     (hl),a         ;Current
  ;See if we can continue downwards
  add    hl,de
  ld     a,l
  cp     $80+63
  jr     c,++
  ;No: matched only 3
-:
  ld     a,MOD_NOTHING
  call   matchaction
  ld     hl,sfxdata_match1	;Match sound
  call   sfx_play
  jr     +
++:
  ;Yes
  ld     a,(hl)
  cp     b
  jr     nz,-		;No match 4, so we matched 3 only
  ;Match at least 4
  ld     a,$98		;Delete anim flag  + redraw + flash icon start
  ld     (hl),a		;Current
  ;See if we can continue downwards
  add    hl,de
  ld     a,l
  cp     $80+63
  jr     nc,+++		;No, reached bottom boundary, so 4
  ;Yes
  ld     a,(hl)
  cp     b
  jr     z,++		;Match 5
  ;No match 5, so we matched 4 only
+++:
  ld     a,MOD_2
  call   matchaction
  ld     a,T_POP2
  call   makepop
  ld     hl,sfxdata_match2	;Match sound
  call   sfx_play
  jr     +
++:
  ld     a,$98		;Delete anim flag + redraw + flash icon start
  ld     (hl),a		;Current
  ;Matched 5 (max)
  ld     a,MOD_3
  call   matchaction
  ld     a,T_POP3
  call   makepop
  ld     hl,sfxdata_match2	;Match sound
  call   sfx_play
+:
  pop    hl
  ret
