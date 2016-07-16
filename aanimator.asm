;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;Commands:
;00: EOL
;01: Load gfx
;	## first tile #
;	#### address of data
;02: Make sprite
;	## sprid (0~15)
;	## first tile #
;	## attr
;	## X
;	## Y
;03: Move sprite
;	## sprid (0~15)
;	## X
;	## Y
;04: Link MotionLUT to sprite (NOT IMPLEMENTED, DO NOT USE !)
;	## sprid (0~15)
;	## lut size
;	#### address of lut
;05: Run motionLUT(s) (NOT IMPLEMENTED, DO NOT USE !)
;	## speed
;06: Move relative
;	## sprid (0~15)
;	## X
;	## Y
;07: Jump to
;       ## number of loops
;       #### address
;08: Hide sprite
;	## sprid (0~15)
;09: Wait frames
;	## frames
;10: Call routine
;       #### address
;11: Play sound
;       ## sound id

aaecmd_jt:
  .dw aa_00e	;EOL
  .dw aa_01e	;Load gfx
  .dw aa_02e    ;Make sprite
  .dw aa_03	;Move sprite
  .dw aa_04	;Link MoLUT to sprite
  .dw aa_05     ;Run MoLUT
  .dw aa_06     ;Move relative
  .dw aa_07e    ;Jump to
  .dw aa_08     ;Delete sprite
  .dw aa_09e    ;Wait frames
  .dw aa_10	;Call routine
  .dw aa_11
  
aapcmd_jt:
  .dw aa_00p	;EOL
  .dw aa_01p	;Load gfx
  .dw aa_02p    ;Make sprite
  .dw aa_03	;Move sprite
  .dw aa_04	;Link MoLUT to sprite
  .dw aa_05     ;Run MoLUT
  .dw aa_06     ;Move relative
  .dw aa_07p    ;Jump to
  .dw aa_08     ;Delete sprite
  .dw aa_09p    ;Wait frames
  .dw aa_10	;Call routine
  .dw aa_11

aa_00e:
  dec   de
  xor   a
  ld    (AA_E_RUN),a
  jp    aa_ret
aa_00p:
  dec   de
  xor   a
  ld    (AA_P_RUN),a
  jp    aa_ret
aa_01e:
  ld    a,(de)
  add   T_AASPRE
-:
  inc   de
  ld    b,8		;To end up with $8xxx
  ld    c,a
  sla   c
  rl    b
  sla   c
  rl    b
  sla   c
  rl    b
  sla   c
  rl    b		;BC*16
  ld    a,(de)
  ld    l,a
  inc   de
  ld    a,(de)
  inc   de
  ld    h,a
  push  de
  push  bc
  pop   de
  call  loadtiles_auto
  pop   de
  jp    aa_continue
aa_01p:
  ld    a,(de)
  add   T_AASPRP
  jr    -
aa_02e:
  call  aa_getspraddr
  ld    a,(de)
  add   T_AASPRE
-:
  ldi   (hl),a		;Tile
  inc   de
  ld    a,(de)
  ld    (hl),a          ;Attr
  inc   de
  jr    +
aa_02p:
  call  aa_getspraddr
  ld    a,(de)
  add   T_AASPRP
  jr    -
aa_03:
  call  aa_getspraddr
  inc   hl
+:
  inc   hl
  ld    a,(de)
  ldi   (hl),a		;X
  inc   de
  ld    a,(de)
  ld    (hl),a          ;Y
  inc   de
  jp    aa_continue
aa_04:
  ;call  aa_getspraddr
  ;inc   hl
  ;inc   hl
  ;inc   hl
  ;inc   hl
  ;ld    a,(de)
  ;ldi   (hl),a		;Mo LUT address LSB
  ;inc   de
  ;ld    a,(de)
  ;ldi   (hl),a		;Mo LUT address MSB
  ;inc   de
  ;ld    a,(de)
  ;ldi   (hl),a		;Mo LUT size
  ;inc   de
  ;ld    (hl),a		;Mo LUT index = size (stop)
  jp    aa_continue
aa_05:
  ;call  aa_getspraddr
  ;ld    bc,7
  ;add   hl,bc
  ;xor   a
  ;ld    (hl),a		;Mo LUT index = 0 (run)
  jp    aa_continue
aa_06:
  call  aa_getspraddr
  inc   hl
  inc   hl
  ld    a,(de)
  add   (hl)
  ldi   (hl),a		;X
  inc   de
  ld    a,(de)
  add   (hl)
  ld    (hl),a		;Y
  inc   de
  jp    aa_continue
aa_07e:
  ld    a,(AA_E_LOOP)
  or    a
  jr    nz,+
  ld    a,(de)
  inc   a
+:
  inc   de
  dec   a
  ld    (AA_E_LOOP),a
  jr    nz,+
  inc   de
  inc   de
  jp    aa_continue
+:
-:
  push  de
  pop   hl
  ldi   a,(hl)
  ld    d,(hl)
  ld    e,a
  ld    hl,AA_E_PTR
  ld    (hl),e
  inc   hl
  ld    (hl),d
  jp    aa_continue
aa_07p:
  ld    a,(AA_P_LOOP)
  or    a
  jr    nz,+
  ld    a,(de)
  inc   a
+:
  inc   de
  dec   a
  ld    (AA_P_LOOP),a
  jr    nz,+
  inc   de
  inc   de
  jp    aa_continue
+:
-:
  push  de
  pop   hl
  ldi   a,(hl)
  ld    d,(hl)
  ld    e,a
  ld    hl,AA_P_PTR
  ld    (hl),e
  inc   hl
  ld    (hl),d
  jp    aa_continue
aa_08:
  call  aa_getspraddr
  xor   a
  ld    (hl),a		;Tile
  jp    aa_continue
aa_09e:
  ld    a,(de)
  inc   de
  ld    (AA_E_WAIT),a
  jp    aa_ret
aa_09p:
  ld    a,(de)
  inc   de
  ld    (AA_P_WAIT),a
  jp    aa_ret
aa_10:
  ld    a,(de)
  ld    l,a
  inc   de
  ld    a,(de)
  ld    h,a
  inc   de
  push  de
  call  dojump
  pop   de
  jp    aa_continue
aa_11:
  ld    a,(de)
  ld    l,a
  inc   de
  ld    a,(de)
  ld    h,a
  inc   de
  call  sfx_play
  jp    aa_continue


aa_getspraddr:
  ld    a,(de)
  inc   de
  sla   a
  sla   a		;*4
  ld    b,0
  ld    c,a
  ld    hl,AA_SPR
  add   hl,bc
  ret

;de=animation script ptr
aa_init_enemy:
  ld    hl,AA_E_PTR
  ld    (hl),e
  inc   hl
  ld    (hl),d
  xor   a
  ld    (AA_E_WAIT),a
  inc   a
  ld    (AA_E_RUN),a
  ret

aa_init_player:
  ld    hl,AA_P_PTR
  ld    (hl),e
  inc   hl
  ld    (hl),d
  xor   a
  ld    (AA_P_WAIT),a
  inc   a
  ld    (AA_P_RUN),a
  ret

aa_run_e:
  ld    a,(AA_E_RUN)
  or    a
  ret   z
  ld    a,(AA_E_WAIT)
  or    a
  jr    z,+
  dec   a
  ld    (AA_E_WAIT),a
  ret
+:
  ld    hl,AA_E_PTR
  ldi   a,(hl)
  ld    d,(hl)
  ld    e,a
  dec   hl
  push  hl
  ld    hl,aaecmd_jt
  jr    aa_run_lp
  
aa_run_p:
  ld    a,(AA_P_RUN)
  or    a
  ret   z
  ld    a,(AA_P_WAIT)
  or    a
  jr    z,+
  dec   a
  ld    (AA_P_WAIT),a
  ret
+:
  ld    hl,AA_P_PTR
  ldi   a,(hl)
  ld    d,(hl)
  ld    e,a
  dec   hl
  push  hl
  ld    hl,aapcmd_jt
  jr    aa_run_lp

aa_run_lp:
  push  hl
aa_continue:
  ld    a,(de)
  inc   de
  sla   a
  pop   hl
  push  hl
  rst   0
  inc   hl
  ld    h,(hl)
  ld    l,a
  jp    hl

aa_ret:
  pop   hl
  pop   hl
  ld    (hl),e
  inc   hl
  ld    (hl),d
  ret

aa_render:
  ld    b,16
  ld    de,AA_SPR
-:
  ld    a,(de)
  or    a
  jr    nz,+
  ld    a,e
  add   4
  ld    e,a
  jr    nc,++
  inc   d
++:
--:
  dec   b
  jr    nz,-
  ret
+:
  push  bc
  inc   de
  ld    b,a
  ld    a,(de)
  inc   de
  ld    c,a
  ;B=Tile #
  ;C=ATtr
  ld    a,(de)	;X
  inc   de
  inc   hl
  ldd   (hl),a
  ld    a,(de)	;Y
  dec   de
  ldi   (hl),a
  inc   hl
  ld    a,b
  ldi   (hl),a	;Tile #
  ld    a,c
  ;or    PALETTE_RED
  ldi   (hl),a	;Attr

  ld    a,(de)	;X
  add   8
  inc   de
  inc   hl
  ldd   (hl),a
  ld    a,(de)	;Y
  ldi   (hl),a
  inc   hl
  ld    a,b
  inc   a
  inc   a
  ldi   (hl),a	;Tile #
  ld    a,c
  ;or    PALETTE_RED
  ldi   (hl),a	;Attr
  inc   de
  pop   bc
  jr    --
