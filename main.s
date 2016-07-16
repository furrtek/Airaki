;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;Score is capped to 99999, time to 99:59 (player dies if exceeded)
;Potion has no mod value

;Possible space optimizations:
;Simplify no-match check after panel generation
;Make setup lists for loadtiles and mapinc
;Rewrite renderflip

;PANEL values:	0~7: Icons
;		$80 (bit 7=1): Redraw needed
;               $18~$1B: To delete, delete animation index (flash tiles 8~B)...
;		$20: Empty, to fill

  .DEFINE ATK_PUNCH	0	;For FIFO
  .DEFINE ATK_SWORD	1
  .DEFINE ATK_SCOURGE	2
  .DEFINE ATK_BEER	3
  .DEFINE ATK_HAMMER    4

  .DEFINE BOMB_ICON	6

  .DEFINE MAX_LEVEL	8

  .DEFINE LINKTIMEOUT_DURATION	10
  .DEFINE LINK_MASTERID		$EC
  .DEFINE LINK_HANDSHAKE	$EA

  .INCLUDE "gameplay.asm"

.ROMGBC
.NAME "AIRAKI1     "
.CARTRIDGETYPE 0                ;ROM only
.RAMSIZE 0
.COMPUTEGBCHECKSUM
.COMPUTEGBCOMPLEMENTCHECK
.LICENSEECODENEW "00"
.EMPTYFILL $00

.MEMORYMAP
SLOTSIZE $4000
DEFAULTSLOT 0
SLOT 0 $0000
SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

.BANK 0 SLOT 0

  .INCLUDE "ram.asm"

.ORG $0000                      ;A=(HL+A) LUT
  add    l
  jr     nc,+
  inc    h
+:
  ld     l,a
  ld     a,(hl)
  ret

.org $0010                      ;(HL)=DE
  ld     (hl),d
  inc    hl
  ld     (hl),e
  ret

.org $0020                      ;CALL (HL) if (HL) != 0
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a
  or     h
  call   nz,dojump
  ret
  
.org $0030
  sla    a
  rst    0
  inc    hl
  ld     h,(hl)
  ld     l,a
  call   dojump			;JT
  ret

.ORG $0040
jp      VBlank

.ORG $0048
jp      RLI
.dw     $6A2B			;Useless bullshit
checksum:                   	;Checksum ($004D)
.dw     0

.ORG $0050
  reti

.ORG $0058
jp      link_int

  .INCLUDE "stuff.asm"

.ORG $0100
nop
jp      start                   ;Entry point

.ORG $0104
;Nintendo logo
.db $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C
.db $00,$0D,$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6
.db $DD,$DD,$D9,$99,$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC
.db $99,$9F,$BB,$B9,$33,$3E

.org $014A
.db 1				;Non-Japanese

.org $0152

start:
  di

  ld     sp,$FFF4               ;SP in HRAM

  ld     (A_REG),a

  xor    a
  ldh    ($26),a                ;Sound off

restart:
  ld     hl,$C001		;Clear RAM (keep A_REG)
  ld     bc,$1FFE
  call   clear

  ld     a,$C3
  ld     (RLI),a		;JP opcode for RAM jump to RLI routine

  ld     a,(A_REG)
  cp     $11
  jr     nz,+
  and    1
  ld     (GBCOLOR),a
+:

  call   sumcheck

  call   nscrollout_setup

-:
  ld     a,(GOTVBL)
  or     a
  jr     z,-
  xor    a
  ld     (GOTVBL),a
  
  ld     hl,VBL_HANDLER
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a
  call   dojump

  jr     -

  .INCLUDE "system.asm"         ;Various utils and math
  .INCLUDE "interrupts.asm"
  .INCLUDE "gfxutil.asm"
  .INCLUDE "sumcheck.asm"       ;Checksum and error screen
  .INCLUDE "link_hs.asm"	;Link handshake
  .INCLUDE "link_game.asm"	;Link game streaming
  .INCLUDE "link_master.asm"
  .INCLUDE "link_slave.asm"
  .INCLUDE "motionlut.asm"	;Motion LUTs and reader
  .INCLUDE "fader.asm"
  .INCLUDE "palettes.asm"

  .INCLUDE "nscrollout.asm"	;Nintendo & FSE logo scrolling
  
  .INCLUDE "intro_setup.asm"
  .INCLUDE "intro_vbl.asm"
  .INCLUDE "intro_aux.asm"

  .INCLUDE "menu_setup.asm"
  .INCLUDE "menu_vbl.asm"
  .INCLUDE "menu_input.asm"
  
  .INCLUDE "link_setup.asm"

  .INCLUDE "aanimator.asm"
  .INCLUDE "aanimations.asm"
  
  .INCLUDE "score.asm"
  .INCLUDE "time.asm"
  .INCLUDE "bonus.asm"

  .INCLUDE "game_setup.asm"
  .INCLUDE "game_vbl.asm"
  .INCLUDE "game_input.asm"
  .INCLUDE "game_match.asm"     ;Matching check
  .INCLUDE "game_aux.asm"	;Gravity and others
  .INCLUDE "game_gen.asm"       ;Panel generation
  .INCLUDE "game_gfx.asm"       ;Special gfx drawing routines
  .INCLUDE "game_cursor.asm"	;Cursor drawing
  .INCLUDE "game_solve.asm"     ;Solution finding
  .INCLUDE "game_enemy.asm"	;Random "AI" for attacking player
  .INCLUDE "game_action.asm"    ;Icon match behavior
  .INCLUDE "game_flip.asm"      ;Flipping (state machine)
  .INCLUDE "game_pop.asm"       ;Special match popup sprites
  .INCLUDE "game_attack.asm"    ;Player attack FIFO processing
  .INCLUDE "game_dxcp.asm"      ;Distortion effect (illness or special attack)
  .INCLUDE "game_bomb.asm"
  .INCLUDE "game_death.asm"
  .INCLUDE "game_ss.asm"
  .INCLUDE "game_victory.asm"
  
  .INCLUDE "pause.asm"

  .INCLUDE "credits.asm"

probas:
  .db 1,2,2,1,1,6,1,1
  .db 0,7,0,2,0,0,0,5
  .db 2,1,1,2,3,3,3,4
  .db 4,5,4,1,5,1,7,7
  .db 2,1,1,5,1,1,0,0
  .db 0,0,5,0,2,4,0,0
  .db 2,1,2,2,3,3,3,4
  .db 0,4,0,3,5,0,7,7

  .INCLUDE "sfx_player.asm"

  .INCLUDE "sfx_data.asm"

text_cerror:
.db "CHECKSUM ERROR",$FF

.BANK 1 SLOT 0
.ORG $0000
  .INCLUDE "gfx_bank1.asm"

;Max=8.5s
;See pal_enemy_lut
difficulty_lut:
  ;   MIN, AMPLITUDE, WARN, FORCE
  ;   IDLEGFX, ATKGFX, DEADGFX
  .db 160,90,90,10
  .dw tiles_enemy_i,tiles_enemy_a,tiles_enemy_d
  .db 150,80,90,10
  .dw tiles_enemy_i,tiles_enemy_a,tiles_enemy_d

  .db 140,70,85,10+3
  .dw tiles_enemy_i2,tiles_enemy_a2,tiles_enemy_d2
  .db 130,60,80,10+3+3
  .dw tiles_enemy_i2,tiles_enemy_a2,tiles_enemy_d2

  .db 120,60,75,10+3+3
  .dw tiles_enemy_i3,tiles_enemy_a3,tiles_enemy_d3
  .db 110,60,70,10+3+3+3
  .dw tiles_enemy_i3,tiles_enemy_a3,tiles_enemy_d3

  .db 100,60,60,10+3+3+3+3
  .dw tiles_enemy_i4,tiles_enemy_a4,tiles_enemy_d4
  .db 90,50,60,10+3+3+3+3+3+3
  .dw tiles_enemy_i4,tiles_enemy_a4,tiles_enemy_d4


fanfare:
  .db 0
  .INCBIN "sfx\airaki.bin"

.ORG $4000-256
  .INCLUDE "cosine.asm"
