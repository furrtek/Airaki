;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE T_MBLANK	0

  .DEFINE T_GB		16	;GameBoy icon
  .DEFINE T_1P		28
  .DEFINE T_2P		34
  .DEFINE T_MCURSOR	46
  .DEFINE T_SSKILL	99
  .DEFINE T_SPECIAL0	108
  .DEFINE T_SPECIAL1	117
  .DEFINE T_SPECIAL2	126
  .DEFINE T_SPECIAL3	135
  .DEFINE T_VAL		144

menu_setup:
  di
  call	 screen_off

  call   clearbkg
  call   clearsprites
  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear
  ld     hl,$8000
  ld     bc,16
  call   clear
  
  ld     a,0
  ld     hl,$9800
  ld     bc,$2020
  call   settilepal

  ld     hl,(:tiles_gb*$4000)+tiles_gb
  ld     de,$8000+(T_GB*16)
  call   loadtiles_auto
  
  ld     hl,(:tiles_1p*$4000)+tiles_1p
  ld     de,$8000+(T_1P*16)
  call   loadtiles_auto
  ld     hl,(:tiles_2p*$4000)+tiles_2p
  ld     de,$8000+(T_2P*16)
  call   loadtiles_auto

  ld     hl,(:tiles_sskill*$4000)+tiles_sskill
  ld     de,$8000+(T_SSKILL*16)
  call   loadtiles_auto
  
  ld     hl,(:tiles_spec0*$4000)+tiles_spec0
  ld     de,$8000+(T_SPECIAL0*16)
  call   loadtiles_auto
  ld     hl,(:tiles_spec1*$4000)+tiles_spec1
  ld     de,$8000+(T_SPECIAL1*16)
  call   loadtiles_auto
  ld     hl,(:tiles_spec2*$4000)+tiles_spec2
  ld     de,$8000+(T_SPECIAL2*16)
  call   loadtiles_auto

  ld     hl,(:tiles_cursorv*$4000)+tiles_cursorv
  ld     de,$8000+(T_MCURSOR*16)
  call   loadtiles_auto

  ld     hl,(:tiles_val*$4000)+tiles_val
  ld     de,$8000+(T_VAL*16)
  call   loadtiles_auto

  ld     hl,$8000+((T_VAL+1)*16)
  ld     bc,16
  call   clear_w

  ld     hl,$9800+(32*3)+4
  ld     bc,$0304
  ld     a,T_GB
  call   mapinc
  ld     hl,$9800+(32*7)+4
  ld     bc,$0302
  ld     a,T_1P
  call   mapinc

  
  ld     hl,$9800+(32*3)+11
  ld     bc,$0304
  ld     a,T_GB
  call   mapinc
  ld     hl,$9800+(32*3)+14
  ld     bc,$0304
  ld     a,T_GB
  call   mapinc
  ld     hl,$9800+(32*7)+11
  ld     bc,$0602
  ld     a,T_2P
  call   mapinc

  ld     hl,$9800+(32*10)+5
  ld     bc,$0901
  ld     a,T_SSKILL
  call   mapinc

  ld     hl,$9800+(32*12)+2
  ld     bc,$0303
  ld     a,T_SPECIAL0
  call   mapinc
  ld     hl,$9800+(32*12)+8
  ld     bc,$0303
  ld     a,T_SPECIAL1
  call   mapinc
  ld     hl,$9800+(32*12)+14
  ld     bc,$0303
  ld     a,T_SPECIAL2
  call   mapinc

  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  xor    a
  ld     hl,$9800		; BG
  ld     bc,$2020
  call   settilepal
  ld     a,PALETTE_GBS
  ld     hl,$9800+(32*3)	; Line 1 Gameboy icons
  ld     bc,$1404
  call   settilepal
  ld     a,PALETTE_NUMPLAYERS
  ld     hl,$9800+(32*7)+4	; Line 1 "1P/2P"
  ld     bc,$1402
  call   settilepal
  ld     a,PALETTE_SS
  ld     hl,$9800+(32*12)	; Line 2
  ld     bc,$2003
  call   settilepal
  ;CGB palettes init
  ld     hl,pal_menu_bg
  ld     b,5*4*2
  xor    a
  call   loadbgpal

  ld     hl,pal_menu_spr
  ld     b,1*4*2
  xor    a
  call   loadsprpal
+:

  xor    a
  ld     (MCURSOR_PSEL),a
  ld     (MCURSOR_SSEL),a
  ld     (MCURSOR_LINE),a

  xor    a
  ldh    ($42),a                ;Scroll Y
  ldh    ($43),a                ;Scroll X

  ld     a,145
  ldh    ($4A),a		;Window Y
  xor    a
  ldh    ($4B),a                ;Window X

  ld     a,%11100100            ;BG palette
  ldh    ($47),a
  ld     a,%11100100            ;SPR0 palette
  ldh    ($48),a
  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a
  ld     a,%01000000            ;STAT is LYC
  ldh    ($41),a
  ld     a,90			;LYC value
  ldh    ($45),a
  ld     a,%00000011            ;Vblank+STAT
  ldh    ($FF),a

  ld     hl,VBL_HANDLER
  ld     de,menu_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d

  ld     de,RLI_menu
  call   load_RLI

  xor    a
  ldh    ($0F),a                ;Clear pending interrupts
  ei

  ret
