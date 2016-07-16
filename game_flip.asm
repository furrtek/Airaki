;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

makeflip:
  ld     a,(FLIP_TOSET)		;Was user-initiated flip ? Keep FLIP_MODE as is, if so
  cp     1
  jr     nz,+
  ;No
  ld     a,(CURSOR_MODE)
  ld     (FLIP_MODE),a		;Save to allow player to change mode before flip is finished
+:

  ld     a,(CURSOR_X)
  ld     (FLIP_X),a
  ld     a,(CURSOR_Y)
  ld     (FLIP_Y),a

  ld     a,(CURSOR_Y)		;Get PANEL address for cursor position
  ld     b,a
  sla    a
  sla    a
  sla    a
  sub    b			;*7
  ld     b,a
  ld     a,(CURSOR_X)
  add    b
  ld     hl,PANEL
  rst    0
  ;Get A icon number
  cp     BOMB_ICON
  jp     z,bombexplode
  ld     (FLIP_AI),a
  sla    a
  sla    a			;*4 tiles/icon
  add    T_ICONS
  ld     (FLIP_AT),a
  ld     a,l
  ld     (FLIP_PADDR),a		;(FLIP_PADDR)=HL
  ld     a,h
  ld     (FLIP_PADDR+1),a

  ld     a,(CURSOR_MODE)	;Scraps A, get it back later in HL
  or     a
  jr     nz,+
  ;Horizontal
  ;Get B icon number
  inc    hl
  ld     a,(hl)
  cp     BOMB_ICON
  jr     nz,++
  ld     a,(CURSOR_X)
  inc    a
  ld     (FLIP_X),a
  jp     bombexplode
++:
  ld     (FLIP_BI),a
  sla    a
  sla    a			;*4 tiles/icon
  add    T_ICONS
  ld     (FLIP_BT),a
  jr     ++
+:
  ;Vertical
  ;Get B icon number
  ld     a,l
  add    7
  ld     l,a
  ld     a,(hl)
  cp     BOMB_ICON
  jr     nz,+
  ;Bomb is in pair, adjust Y position of bomb
  ld     a,(CURSOR_Y)
  inc    a
  ld     (FLIP_Y),a
  jp     bombexplode
+:
  ld     (FLIP_BI),a
  sla    a
  sla    a			;*4 tiles/icon
  add    T_ICONS
  ld     (FLIP_BT),a
++:

  ld     a,(CURSOR_X)
  ld     b,a
  ld     a,(CURSOR_Y)

  ld     h,a
  ld     e,32*2
  call   mul8_8
  sla    b
  ld     d,0
  ld     e,b
  add    hl,de
  ld     de,$9800
  add    hl,de

  ld     a,l
  ld     (FLIP_VADDR),a
  ld     a,h
  ld     (FLIP_VADDR+1),a
  
  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  ld     hl,pal_icon_lut
  ld     a,(FLIP_AI)
  rst    0
  ld     (FLIP_AP),a
  ld     hl,pal_icon_lut
  ld     a,(FLIP_BI)
  rst    0
  ld     (FLIP_BP),a
+:

  xor    a
  ld     (FLIP_ANIM),a
  ld     a,(FLIP_TOSET)
  ld     (FLIP_FLAGS),a
  
  ld     hl,sfxdata_flip
  call   sfx_play
  ret


animflip:
  ld     a,(FLIP_ANIM)
  inc    a
  cp     16
  jr     nz,+
  ; Done flipping, write new icons into panel if matched, re-flip if not

  ld     hl,FLIP_PADDR
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a

  ld     a,(FLIP_MODE)
  or     a
  jr     nz,++
  ;H
  ld     a,(FLIP_BI)
  or     $80		;Refresh flag
  ldi    (hl),a
  ld     a,(FLIP_AI)
  or     $80		;Refresh flag
  ld     (hl),a
  jr     +++
++:
  ;V
  ld     a,(FLIP_BI)
  or     $80		;Refresh flag
  ldi    (hl),a
  ld     a,l
  add    7-1
  ld     l,a
  ld     a,(FLIP_AI)
  or     $80		;Refresh flag
  ld     (hl),a
  jr     +++

+++:
  ld     a,(FLIP_FLAGS)		;Was a re-flip to cancel ?
  cp     6
  ld     a,0			;Yes: give back control to player
  jr     z,++
  ld     a,2			;No: check for matches
++:
  ld     (FLIP_FLAGS),a
  ret

+:
  ;Animate
  ld     (FLIP_ANIM),a
  dec    a
  dec    a
  ret    nz
  ; Clear original icons on BG right after creating flip sprites (FLIP_ANIM=2) avoids flickering
  ld     hl,FLIP_VADDR
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a
  ld     bc,2
  call   clear_w		;A icon top
  ld     de,32-2
  add    hl,de
  ld     bc,2
  call   clear_w		;A icon bot

  ld     a,(FLIP_MODE)
  or     a
  jr     nz,+
  ;H B icon
  ld     de,-32
  add    hl,de
  ld     bc,2
  call   clear_w		;Top
  ld     de,32-2
  add    hl,de
  ld     bc,2
  call   clear_w		;Bot
  ret
+:
  ;V B icon
  ld     de,32-2
  add    hl,de
  ld     bc,2
  call   clear_w		;Top
  ld     de,32-2
  add    hl,de
  ld     bc,2
  call   clear_w		;Bot
  ret


renderflip:
  ld     a,(FLIP_MODE)
  or     a
  jr     nz,+
  ;H A icon
  ld     a,(FLIP_Y)
  swap   a
  add    16
  ldi    (hl),a
  ld     a,(FLIP_X)
  swap   a
  add    8
  ld     b,a
  ld     a,(FLIP_ANIM)
  add    b
  ldi    (hl),a
  ld     a,(FLIP_AT)
  ldi    (hl),a
  ld     a,(FLIP_AP)
  ldi    (hl),a
  
  ld     a,(FLIP_Y)
  swap   a
  add    16
  ldi    (hl),a
  ld     a,(FLIP_ANIM)
  add    b
  add    8
  ldi    (hl),a
  ld     a,(FLIP_AT)
  add    2
  ldi    (hl),a
  ld     a,(FLIP_AP)
  ldi    (hl),a
  
  ;H B icon
  ld     a,(FLIP_Y)
  swap   a
  add    16
  ldi    (hl),a
  ld     a,(FLIP_ANIM)
  ld     b,a
  ld     a,(FLIP_X)
  swap   a
  add    8+16
  sub    b
  ldi    (hl),a
  ld     a,(FLIP_BT)
  ldi    (hl),a
  ld     a,(FLIP_BP)
  ldi    (hl),a

  ld     a,(FLIP_Y)
  swap   a
  add    16
  ldi    (hl),a
  ld     a,(FLIP_ANIM)
  ld     b,a
  ld     a,(FLIP_X)
  swap   a
  add    8+24
  sub    b
  ldi    (hl),a
  ld     a,(FLIP_BT)
  add    2
  ldi    (hl),a
  ld     a,(FLIP_BP)
  ldi    (hl),a
  ret

+:
  ld     a,(FLIP_ANIM)
  ld     b,a

  ;H A icon
  ld     a,(FLIP_Y)
  swap   a
  add    16
  add    b
  ldi    (hl),a
  ld     a,(FLIP_X)
  swap   a
  add    8
  ldi    (hl),a
  ld     a,(FLIP_AT)
  ldi    (hl),a
  ld     a,(FLIP_AP)
  ldi    (hl),a
  
  ld     a,(FLIP_Y)
  swap   a
  add    16
  add    b
  ldi    (hl),a
  ld     a,(FLIP_X)
  swap   a
  add    8+8
  ldi    (hl),a
  ld     a,(FLIP_AT)
  add    2
  ldi    (hl),a
  ld     a,(FLIP_AP)
  ldi    (hl),a
  

  ;H B icon
  ld     a,(FLIP_Y)
  swap   a
  add    16+16
  sub    b
  ldi    (hl),a
  ld     a,(FLIP_X)
  swap   a
  add    8
  ldi    (hl),a
  ld     a,(FLIP_BT)
  ldi    (hl),a
  ld     a,(FLIP_BP)
  ldi    (hl),a

  ld     a,(FLIP_Y)
  swap   a
  add    16+16
  sub    b
  ldi    (hl),a
  ld     a,(FLIP_X)
  swap   a
  add    16
  ldi    (hl),a
  ld     a,(FLIP_BT)
  add    2
  ldi    (hl),a
  ld     a,(FLIP_BP)
  ldi    (hl),a
  ret
