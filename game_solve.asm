;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

checksolve:
  ;Check for H cursor vertical solutions (in a 2x3 box, 6 possibilites)
  ;Code size optimization possible by using an add/add/add table for each pattern instead of raw code
  xor    a
  ld     (SOLUTION_MODE),a

  ld     de,PANEL
  ld     c,0
-:
  ld     h,d		;Restore
  ld     l,e
  ;Pattern 0
  ld     b,(hl)		;A
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    6
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $10		;Solution is Y+1
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 1
  inc    hl
  ld     b,(hl)		;A
  ld     a,l
  add    6
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $10		;Solution is Y+1
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 2
  inc    hl
  ld     b,(hl)		;A
  ld     a,l
  add    6
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  call   savesolution   ;Solution is correctly placed already
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 3
  ld     b,(hl)		;A
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  call   savesolution   ;Solution is correctly placed already
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 4
  ld     b,(hl)		;A
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $20		;Solution is Y+2
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 5
  inc    hl
  ld     b,(hl)		;A
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    6
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $20		;Solution is Y+2
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  inc    de
  inc    c
  ld     a,c
  and    $F
  cp     6
  jp     nz,-
  inc    de
  ld     a,c
  and    $F0
  add    $10
  ld     c,a
  cp     $70
  jp     nz,-



  ;Check for H cursor horizontal solutions (in a 4x1 box, 2 possibilites)
  ld     de,PANEL
  ld     c,0
-:
  ld     h,d		;Restore
  ld     l,e
  ;Pattern 6
  ld     b,(hl)		;A
  inc    hl
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  inc    hl
  inc    hl
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $02		;Solution is X+2
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 7
  ld     b,(hl)		;A
  inc    hl
  inc    hl
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  inc    hl
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  call   savesolution   ;Solution is correctly placed already
  jp     ++		;Found at least one solution, quit
+:

  inc    de
  inc    c
  ld     a,c
  and    $F
  cp     4
  jp     nz,-
  inc    de
  inc    de
  inc    de
  ld     a,c
  and    $F0
  add    $10
  ld     c,a
  cp     $90
  jp     nz,-
  
  
  
  ;Check for V cursor horizontal solutions (in a 3x2 box, 6 possibilites)
  ;Code size optimization possible by using a add/add/add table for each pattern instead of raw code
  ld     a,1
  ld     (SOLUTION_MODE),a

  ld     de,PANEL
  ld     c,0
-:
  ld     h,d		;Restore
  ld     l,e
  ;Pattern 0
  ld     b,(hl)		;A
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  sub    6
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $01		;Solution is X+1
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 1
  ld     a,l
  add    7
  ld     l,a
  ld     b,(hl)		;A
  ld     a,l
  sub    6
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $01		;Solution is X+1
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 2
  ld     b,(hl)		;A
  inc    hl
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $02		;Solution is X+2
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 3
  ld     a,l
  add    7
  ld     l,a
  ld     b,(hl)		;A
  inc    hl
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  sub    6
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $02		;Solution is X+2
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 4
  ld     a,l
  add    7
  ld     l,a
  ld     b,(hl)		;A
  ld     a,l
  sub    6
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  inc    hl
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  call   savesolution   ;Solution is correctly placed
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 5
  ld     b,(hl)		;A
  ld     a,l
  add    8
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  inc    hl
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  call   savesolution   ;Solution is correctly placed
  jp     ++		;Found at least one solution, quit
+:

  inc    de
  inc    c
  ld     a,c
  and    $F
  cp     5
  jp     nz,-
  inc    de
  inc    de
  ld     a,c
  and    $F0
  add    $10
  ld     c,a
  cp     $80
  jp     nz,-



  ;Check for V cursor horizontal solutions (in a 1x4 box, 2 possibilites)
  ld     de,PANEL
  ld     c,0
-:
  ld     h,d		;Restore
  ld     l,e
  ;Pattern 6
  ld     b,(hl)		;A
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    14
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  add    $20		;Solution is Y+2
  call   savesolution
  jp     ++		;Found at least one solution, quit
+:

  ld     h,d		;Restore
  ld     l,e
  ;Pattern 7
  ld     b,(hl)		;A
  ld     a,l
  add    14
  ld     l,a
  ld     a,(hl)		;B
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)		;C
  cp     b
  jr     nz,+		;Doesn't match pattern
  ld     a,c
  call   savesolution   ;Solution is correctly placed already
  jp     ++		;Found at least one solution, quit
+:

  inc    de
  inc    c
  ld     a,c
  and    $F
  cp     7
  jp     nz,-
  ld     a,c
  and    $F0
  add    $10
  ld     c,a
  cp     $60
  jp     nz,-


  xor    a
  ld     (CANSOLVE),a

++:
  ret
  
  
  
savesolution:
  ld     b,a
  and    $7
  ld     (SOLUTION_X),a
  ld     a,b
  swap   a
  and    $F
  ld     (SOLUTION_Y),a
  ld     a,1
  ld     (CANSOLVE),a
  ret
