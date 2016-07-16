;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

ssaction_find:
  ld     a,(FLIP_FLAGS)
  or     a
  ret    nz			;Can't while flipping or animating panel
  ld     a,(ANIM_SHAKE)
  or     a
  ret    nz          		;Can't either if the panel is getting shaked up (regen)
  ld     a,(SOLUTION_X)
  ld     (CURSOR_X),a
  ld     a,(SOLUTION_Y)
  ld     (CURSOR_Y),a
  ld     a,(SOLUTION_MODE)
  ld     (CURSOR_MODE),a
  ld     a,1
  ld     (FLIP_TOSET),a		;Treat flip as user-initiated
  call   makeflip
  xor    a
  ld     (HAS_SPECIAL),a
  ret

ssaction_beer:
  ld     b,ATK_BEER
  ld     c,0
  call   addattack
  xor    a
  ld     (HAS_SPECIAL),a
  ret
  
enemy_dizzy:
  ld     a,DXCP_ATTACK
  ld     (ENEMY_DIZZY),a
  ret
  
ssaction_hammer:
  ;Replace punch with hammer
  ld     hl,(:tiles_hammer*$4000)+tiles_hammer
  ld     de,$8000+((T_ICONS+4)*16)
  call   loadtiles_auto
  xor    a
  ld     (HAMMER_COUNTER),a
  ld     (HAS_SPECIAL),a
  ld     a,1
  ld     (HAMMER_MODE),a
  ret
  
ssaction_lut:
  .dw ssaction_find
  .dw ssaction_beer
  .dw ssaction_hammer
