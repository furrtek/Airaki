;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

sfx_update:
  ld     a,(SFX_PLAYING)
  or     a
  ret    z
  ld     hl,SFX_PTR
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a
--:
  ldi    a,(hl)
  cp     $80
  jr     nc,+
  add    $10			;$FF10 offset
  ld     c,a
  ldi    a,(hl)
  ld     ($FF00+c),a
  jr     --
+:
  cp     $82
  jr     z,c66
  cp     $80
  jr     z,+
  sub    $90
  ;inc    a
  ld     b,a
  ldi    a,(hl)
  add    $10			;$FF10 offset
  ld     c,a
  ldi    a,(hl)
-:
  ld     ($FF00+c),a
  dec    b
  jr     nz,-
  jr     --
+:
  ld     a,l
  ld     (SFX_PTR),a
  ld     a,h
  ld     (SFX_PTR+1),a
  ret

c66:
  xor    a
  ld     (SFX_PLAYING),a
  ldh    ($26),a		;Shut APU down
  ret


sfx_play:
  ld     b,(hl)
  ld     a,(SFX_PLAYING)
  and    b
  ret    nz			;Don't play sfx if already playing and bg flag set
  xor    a			;Kill all channels
  ldh    ($12),a
  ldh    ($17),a
  ldh    ($1A),a
  ldh    ($21),a
  inc    hl
  ld     a,l
  ld     (SFX_PTR),a
  ld     a,h
  ld     (SFX_PTR+1),a
  ld     a,1
  ld     (SFX_PLAYING),a
  ret
