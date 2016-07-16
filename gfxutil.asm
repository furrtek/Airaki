;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

clearsprites:
  call   wait_vbl
  ld     hl,$FE00               ;Empties OAM
  ld     b,40*4
clspr:
  ld     (hl),$00
  inc    l                      ;Avoids hardware bug
  dec    b
  jr     nz,clspr
  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear
  ret

;Clears VRAM from HL to HL+BC
clear_w:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
-:
  call   wait_write
  xor    a
  ldi    (hl),a
  dec    bc
  ld     a,c
  or     b
  jr     nz,-
  pop    af
  ldh    ($FF),a
  ret


;a=first tile
;bc=width/height
;hl=vram
mapinc:
  ld     d,a
mapinc_:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  push   de
  push   hl
  ld     a,d
mapib:
  ld     d,b
mapia:
  ldi    (hl),a
  inc    a
  dec    d
  jr     nz,mapia
  pop    hl
  ld     de,32
  add    hl,de
  push   hl
  dec    c
  jr     nz,mapib
  pop    hl
  pop    de
  pop    af
  ldh    ($FF),a
  ret

;a=first tile
;bc=width/height
;hl=vram
mapinc_w:
  ld     d,a
  ldh    a,($40)
  bit    7,a
  jr     z,mapinc_
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     a,d
  push   de
  push   hl
  ld     de,32
--:
  ld     d,b
-:

  push   af		;Is VRAM available ?
---:
  ldh    a,($41)
  and    3
  cp     3
  jr     nz,---
---:
  ldh    a,($41)
  and    3
  cp     3
  jr     z,---
  pop    af

  ldi    (hl),a
  inc    a
  dec    d
  jr     nz,-
  pop    hl
  add    hl,de
  push   hl
  dec    c
  jr     nz,--
  pop    hl
  pop    de
  pop    af
  ldh    ($FF),a
  ret
  
  
;a=palette
;bc=width/height
;hl=vram
settilepal:
  push   de
  push   hl
  push   af
  ld     a,(GBCOLOR)
  or     a
  jr     z,++
  ld     a,1
  ldh    ($4F),a
  pop    af
  ld     de,32
--:
  ld     d,b
-:
  push   af
  ldh    a,($40)
  bit    7,a
  jr     z,+
---:
  ldh    a,($41)
  and    3
  cp     3
  jr     nz,---
---:
  ldh    a,($41)
  and    3
  cp     3
  jr     z,---
+:
  pop    af

  ldi    (hl),a
  dec    d
  jr     nz,-
  pop    hl
  add    hl,de
  push   hl
  dec    c
  jr     nz,--
  xor    a
  ldh    ($4F),a
  pop    hl
  pop    de
  ret
++:
  pop    af
  pop    hl
  pop    de
  ret


;de=text
;hl=vram
;b=ASCII index (32 ?)
maptext:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  push   hl
maptextlp:
  ld     a,(de)
  cp     $FF
  jr     nz,+
  pop    hl
  pop    af
  ldh    ($FF),a
  ret
+:
  cp     $FE
  jr     nz,+
  pop    hl
  push   de
  ld     de,32
  add    hl,de
  pop    de
  push   hl
  inc    de
  jr     maptextlp
+:
  sub    b
  
  push   af		;Is VRAM available ?
  ldh    a,($40)
  bit    7,a
  jr     z,+
---:
  ldh    a,($41)
  and    3
  cp     3
  jr     nz,---
---:
  ldh    a,($41)
  and    3
  cp     3
  jr     z,---
+:
  pop    af

  ldi    (hl),a
  inc    de
  jr     maptextlp

;a=first tile
;hl=map
;de=vram
map:
  ld     (MAP_FIRST),a
  ldi    a,(hl)
  ld     (MAP_W),a
  ldi    a,(hl)
  ld     c,a
  push   de

mapb:
  ld     a,(MAP_W)
  ld     b,a
mapa:
  ldi    a,(hl)
  push   hl
  ld     hl,MAP_FIRST
  add    (hl)
  pop    hl
  call   wait_write
  ld     (de),a
  inc    de
  dec    b
  jr     nz,mapa

  pop    de
  ld     a,e
  add    32
  jr     nc,+
  inc    d
+:
  ld     e,a
  push   de

  dec    c
  jr     nz,mapb
  pop    de
  ret

wait_vbl:
  ldh    a,($40)
  rlca
  ret    nc
wait_vbll:
  ldh    a,($44)                ;Wait for Vblank start
  cp     144
  jr     c,wait_vbll
  ret

clearbkg:
  ld     de,32*32               ;Clear BG map
  ld     hl,$9800
-:
  xor    a
  ldi    (hl),a
  dec    de
  ld     a,e
  or     d
  jr     nz,-
  
  ld     de,32*32               ;Clear window map
  ld     hl,$9C00
-:
  xor    a
  ldi    (hl),a
  dec    de
  ld     a,e
  or     d
  jr     nz,-
  ret
  
writeDE:
  ld     a,d
  swap   a
  and    $F
  call   checkhex
  add    16
  call   wait_write
  ldi    (hl),a
  ld     a,d
  and    $F
  call   checkhex
  add    16
  call   wait_write
  ldi    (hl),a
  ld     a,e
  swap   a
  and    $F
  call   checkhex
  add    16
  call   wait_write
  ldi    (hl),a
  ld     a,e
  and    $F
  call   checkhex
  add    16
  call   wait_write
  ldi    (hl),a
  ret

checkhex:
  cp     $0A
  ret    c
  add    7
  ret

wait_write:
  push   af
-:
  ldh    a,($41)
  bit    1,a
  jr     nz,-
  pop    af
  ret
  
wait_hblank:
  push   af
  ldh    a,($40)
  rlca
  jr     c,+
  pop    af
  ret
+:
-:
  ldh    a,($41)
  and    3
  jr     z,-
-:
  ldh    a,($41)
  and    3
  jr     nz,-
  pop    af
  ret

;Copy DMA routine to HRAM
RAMtoOAM:
  ld     hl,doDMA
  ld     de,$FF80
  ld     b,doDMAend-doDMA
ldhram:
  ldi    a,(hl)
  ld     (de),a
  inc    de
  dec    b
  jr     nz,ldhram
  call   $FF80          ;DMA start
  ret
  
doDMA:
   ld    a,$DF
   ldh   ($46),a        ;Start DMA from $DF00
   ld    a,$28          ;Wait...
-:
   dec   a
   jr    nz,-
   ret
doDMAend:

   .INCLUDE "loadtile.asm"
