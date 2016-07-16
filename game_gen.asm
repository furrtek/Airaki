;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

genpanel:
  ld     de,PANEL
  ld     c,7*9
-:
  call   new_icon
  ld     (de),a
  inc    e
  dec    c
  jr     nz,-

  xor    a
  ld     (P_CORRPASS),a

  ; Find and scramble matches (C is a double counter nibble/nibble, do NOT use B)
corrpanel:

  xor    a
  ld     (P_CORRECTED),a

  ld     hl,PANEL
  ld     c,0
-:
  push   hl

  ; Pattern 0
  ld     de,7
  call   findmatch_corr
  ; Pattern 1  +0,+1
  ld     de,1
  call   findmatch_corr
  ; Pattern 2  +1,+7
  inc    hl
  ld     de,7
  call   findmatch_corr
  ; Pattern 3  +2,+7
  inc    hl
  ld     de,7
  call   findmatch_corr
  ; Pattern 4  +7,+1
  ld     de,5
  add    hl,de
  ld     de,1
  call   findmatch_corr
  ; Pattern 5  +14,+1
  ld     de,7
  add    hl,de
  ld     de,1
  call   findmatch_corr
  
  pop    hl
  inc    hl
  inc    c
  ld     a,c
  and    $F
  cp     5		; 6 ?
  jr     nz,-
  inc    hl
  inc    hl
  ld     a,c
  and    $F0
  add    $10
  ld     c,a
  cp     $70		; $80 ?
  jr     nz,-

  ld     a,(P_CORRECTED)
  or     a
  jr     z,+
  ld     a,(P_CORRPASS)
  inc    a
  ld     (P_CORRPASS),a
  cp     20			; Arbitrary
  jr     c,corrpanel		; If can't correct panel in 20 passes, regen all panel
  jp     genpanel
+:

  call   checksolve		; Save first solution, in case player is already stuck :p
  ret
  
  
findmatch_corr:
  push   hl
  ld     a,(hl)
  and    $F
  ld     b,a
  add    hl,de
  ld     a,(hl)
  and    $F
  cp     b
  jr     nz,+
  add    hl,de
  ld     a,(hl)
  and    $F
  cp     b
  jr     nz,+
  ;Match found
  call   new_icon
  pop    hl
  ld     (hl),a
  ld     a,1
  ld     (P_CORRECTED),a
  ret
+:
  pop    hl
  ret


;Busts B and HL !
new_icon:
  call   get_random
  swap   a
  and    $3F
  ld     hl,probas
  rst    0
  or     $80		;Refresh flag
  ret
