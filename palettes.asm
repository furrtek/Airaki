;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE PALETTE_FSE 0
  .DEFINE PALETTE_SWORD 1
  .DEFINE PALETTE_CHARLEFT 2
  .DEFINE PALETTE_CHARRIGHT 3
  .DEFINE PALETTE_TITLE 4
  .DEFINE PALETTE_START 5

  .DEFINE PALETTE_NUMPLAYERS 1
  .DEFINE PALETTE_GBS 2
  .DEFINE PALETTE_MODES 3
  .DEFINE PALETTE_SS 4

  .DEFINE PALETTE_GREYIF 0
  .DEFINE PALETTE_RED 3
  .DEFINE PALETTE_FIST 4
  .DEFINE PALETTE_SHIELD 5
  .DEFINE PALETTE_DEBRIS 1
  .DEFINE PALETTE_IMMDEATH 1
  .DEFINE PALETTE_BOMB 1
  .DEFINE PALETTE_DIZZY 5
  .DEFINE PALETTE_BEER 6
  .DEFINE PALETTE_ENEMY 2

initpals:
  ld     a,$80		;Autoinc
  ldh    ($68),a
  ld     b,4*8*2
  xor    a
-:
  ldh    ($69),a
  dec    b
  jr     nz,-
  ld     a,$80		;Autoinc
  ldh    ($6A),a
  ld     b,4*8*2
  xor    a
-:
  ldh    ($6B),a
  dec    b
  jr     nz,-
  ret

loadbgpal:
  or     $80		;Autoinc
  ldh    ($68),a
-:
  call   wait_write
  ldi    a,(hl)
  ldh    ($69),a
  dec    b
  jr     nz,-
  ret

loadsprpal:
  or     $80		;Autoinc
  ldh    ($6A),a
-:
  call   wait_write
  ldi    a,(hl)
  ldh    ($6B),a
  dec    b
  jr     nz,-
  ret

pal_intro:
  ;FSE splash
  .db $FF,$7F
  .db $5F,$2
  .db $13,$58
  .db $8,$10
  
  ;Swords (grey)
  .db $FF,$7F
  .db $39,$57
  .db $B5,$36
  .db $9,$D
  
  ;CharLeft
  .db $FF,$7F
  .db $3D,$37
  .db $37,$1E
  .db $71,$15

  ;CharRight
  .db $FF,$7F
  .db $1F,$2B
  .db $7F,$D
  .db $18,$0

  ;Title (red)
  .db $FF,$7F
  .db $BF,$0
  .db $13,$0
  .db $6,$0

  ;Start (blue)
  .db $FF,$7F
  .db $86,$7D
  .db $C3,$44
  .db $60,$1C
  


  
pal_menu_bg:
  ;Grey
  .db $FF,$7F
  .db $18,$53
  .db $10,$32
  .db $84,$10

  ;Green
  .db $FF,$7F
  .db $EB,$3
  .db $A0,$2
  .db $20,$1

  ;Grey
  .db $DD,$5B
  .db $10,$42
  .db $08,$21
  .db $84,$10
  
  ;Grey/brown
  .db $DD,$5B
  .db $36,$1E
  .db $EA,$0
  .db $42,$0
  
  ;Grey/gold
  .db $DD,$5B
  .db $DA,$12
  .db $BA,$1
  .db $D,$1

pal_menu_spr:
  ;Blue
  .db $FF,$7F
  .db $86,$7D
  .db $C3,$44
  .db $60,$1C

pal_icon_lut:
  .db 5,4,5,1,3,6,1,7

pal_game_bg:
  ;Grey (interface)
  .db $FF,$7F
  .db $18,$53
  .db $10,$32
  .db $84,$10
  
pal_game_spr:
  ;Blue (cursor)
  .db $FF,$7F
  .db $86,$7D
  .db $C3,$44
  .db $60,$1C
  
pal_game_common:
  ;Grey (bombs)
  .db $FF,$7F
  .db $10,$42
  .db $08,$21
  .db $84,$10

  ;Enemy color (debug green)
  .db $FF,$7F
  .db $E0,$3
  .db $E0,$3
  .db $E0,$3

  ;Red (potion, lives indicator)
  .db $FF,$7F
  .db $FF,$2D
  .db $BF,$8
  .db $54,$4

  ;Brown (fist)
  .db $FF,$7F
  .db $3D,$37
  .db $37,$1E
  .db $71,$15

  ;Grey/green (shield)
  .db $FF,$7F
  .db $EF,$36
  .db $EB,$21
  .db $25,$D

  ;Yellow (beer)
  .db $FF,$7F
  .db $5A,$F
  .db $35,$A
  .db $4E,$1

  ;Red/purple (mana)
  .db $FF,$7F
  .db $5F,$52
  .db $1E,$35
  .db $71,$20
  
pal_enemy_lut:
  .dw pal_enemy_0	;Green
  .dw pal_enemy_2       ;Orange
  .dw pal_enemy_0	;Green
  .dw pal_enemy_2       ;Orange
  .dw pal_enemy_1       ;Blue
  .dw pal_enemy_2       ;Orange
  .dw pal_enemy_1       ;Blue
  .dw pal_enemy_3       ;Red
  
pal_enemy_0:
  .db $FF,$7F
  .db $F4,$37
  .db $68,$3
  .db $26,$2
  
pal_enemy_1:
  .db $FF,$7F
  .db $57,$7F
  .db $4E,$6E
  .db $E0,$60

pal_enemy_2:
  .db $FF,$7F
  .db $BF,$4F
  .db $3F,$23
  .db $1F,$2
  
pal_enemy_3:
  .db $FF,$7F
  .db $BF,$32
  .db $9F,$0
  .db $11,$0


pal_credits_bg:
  ;Grey (bombs)
  .db $FF,$7F
  .db $10,$42
  .db $08,$21
  .db $84,$10
  
  .db $FF,$7F
  .db $54,$4
  .db $54,$4
  .db $54,$4
  
pal_link:
  ;Grey
  .db $7F,$FF
  .db $18,$53
  .db $10,$32
  .db $84,$10
