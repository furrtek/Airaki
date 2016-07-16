;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

dofade:
  ld     a,(FADER)
  cp     $40-1
  ret    z
  inc    a
  ld     (FADER),a
  ;ld     a,(GBCOLOR)
  ;or     a
  ;jr     nz,+
  swap   a
  and    $F
  ld     b,a
  ld     hl,fade_wton
  rst    0
  ldh    ($47),a		;BG palette
  ;ld     a,b
  ;ld     hl,fade_wton
  ;rst    0
  ldh    ($48),a
  ret

+:
  ret

fade_ispr:
  .db %01000000
  .db %01010000
  .db %10010000
  .db %11010000
  
fade_wton:
  .db %00000000
  .db %01010000
  .db %10100100
  .db %11100100
