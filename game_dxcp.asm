;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

dxcp_over:
  ;DXCP's over
  ldh    a,($FF)
  and    %11111101		;Disable STAT
  ldh    ($FF),a
  xor    a
  ld     (FADER),a
  ld     (PLAYER_DIZZY),a
  ldh    ($43),a		;BG position
  ldh    ($42),a
  ret

init_dxcp_beer:
  ld     a,DXCP_BEER
  jr     +
  
init_dxcp_attack:
  ld     a,DXCP_ATTACK
  jr     +

+:
  ld     (PLAYER_DIZZY),a

  xor    a
  ld     (WAVE_START),a
  ld     (FADER),a
  
  ld     de,RLI_dxcp
  call   load_RLI

  ld     a,%00001000		;STAT Hblank
  ldh    ($41),a
  ldh    a,($FF)
  or     %00000010		;Enable STAT
  ldh    ($FF),a
  ret

dxcp_vbl:
  ld     a,(WAVE_START)
  inc    a
  ld     (WAVE_START),a
  sla    a
  sla    a
  ld     hl,(:tiles_gb*$4000)+lut_cos
  add    l
  ld     l,a
  ld     a,(hl)
  swap   a
  and    $F
  sub    8			;Esthetic
  ldh    ($43),a
  sra    a
  ldh    ($42),a

  ld     a,(FRAME)
  and    3
  ret    nz
  ld     a,(PLAYER_DIZZY)		;DXCP_TIMER unit is in 4 frames
  dec    a
  ld     (PLAYER_DIZZY),a
  or     a
  ret    nz
  ;DXCP's over
  jr     dxcp_over			;call, ret


RLI_dxcp:
  push   af
  ldh    a,($44)
  cp     143
  jr     nc,+
  bit    0,a
  jr     nz,+
  push   hl
  ld     hl,WAVE_START
  add    (hl)
  sla    a
  sla    a
  ld     hl,(:tiles_gb*$4000)+lut_cos
  add    l
  ld     l,a
  ld     a,(hl)
  swap   a
  and    $F
  sub    8			;Esthetic
  ldh    ($43),a
  sra    a
  ldh    ($42),a
  pop    hl
+:
  pop    af
  reti
