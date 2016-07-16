;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

loadtiles_auto:
  ldi    a,(hl)
  or     a
  jr     z,loadtiles_1BPP  ;00: 1BPP raw
  bit    0,a
  jr     z,loadtiles_2BPP  ;10: 2BPP raw
  bit    1,a
  jr     z,loadtiles_1BPPc ;01: 1BPP compressed
  jr     loadtiles_2BPPc   ;11: 2BPP compressed
  
;hl=data
;de=vram
;bc=size
loadtiles_1BPP:
  ldi    a,(hl)
  ld     b,a
  ldi    a,(hl)
  ld     c,a
-:
  ldi    a,(hl)
  ld    (de),a
  inc    de
  ld    (de),a
  inc    de
  dec    bc
  ld     a,b
  or     c
  jr     nz,-
  ret
  
;hl=data
;de=vram
;bc=size
loadtiles_2BPP:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ldi    a,(hl)
  ld     b,a
  ldi    a,(hl)
  ld     c,a
-:
  ldh    a,($41)	;Is VRAM available ?
  and    3
  cp     2
  jr     nc,-
  ldi    a,(hl)
  ld    (de),a
  inc    de
  dec    bc
  ld     a,b
  or     c
  jr     nz,-
  pop    af
  ldh    ($FF),a
  ret

;hl=data
;de=vram
loadtiles_1BPPc:
  ld     c,$41
  ldi    a,(hl)
  or     a
  ret    z
  bit    7,a            ;bit7=1:compressed
  jr     nz,compressed1
  and    $7F            ;bit7=0:normal
  ld     b,a
loadnormal1:
-:
  ld     a,($FF00+c)	;Is VRAM available ?
  and    3
  cp     2
  jr     nc,-
  ldi    a,(hl)
  ld     (de),a
  inc    de
  ld     (de),a
  inc    de
  dec    b
  jr     nz,loadnormal1
  jr     loadtiles_1BPPc
compressed1:
  and    $7F
  ld     b,a
  ldi    a,(hl)
loadcompressed1:
  push   af
-:
  ld     a,($FF00+c)	;Is VRAM available ?
  and    3
  cp     2
  jr     nc,-
  pop    af
  ld     (de),a
  inc    de
  ld     (de),a
  inc    de
  dec    b
  jr     nz,loadcompressed1
  jr     loadtiles_1BPPc

;hl=data
;de=vram
loadtiles_2BPPc:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     c,$41
;BP0
  push   de
  call   decompress
  pop    de
  inc    de
;BP1
  call   decompress
  pop    af
  ldh    ($FF),a
  ret

decompress:
  ldi    a,(hl)
  or     a
  ret    z
  bit    7,a            ;bit7=1:compressed
  jr     nz,compressed
  and    $7F            ;bit7=0:normal
  ld     b,a
loadnormal:
-:
  ld     a,($FF00+c)	;Is VRAM available ?
  and    3
  cp     2
  jr     nc,-
  ldi    a,(hl)
  ld     (de),a
  inc    de             ;Skip a bitplane (loaded later)
  inc    de
  dec    b
  jr     nz,loadnormal
  jr     decompress
compressed:
  and    $7F
  ld     b,a
  ldi    a,(hl)
loadcompressed:
  push   af
-:
  ld     a,($FF00+c)	;Is VRAM available ?
  and    3
  cp     2
  jr     nc,-
  pop    af
  ld     (de),a
  inc    de             ;Skip a bitplane (loaded later)
  inc    de
  dec    b
  jr     nz,loadcompressed
  jr     decompress
