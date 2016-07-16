;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

drawpanel:
  ; Draw icons which need refresh
  ld     c,9
  ld     de,PANEL
  ld     hl,$9800
--:
  ld     b,7
-:
  ld     a,(de)
  bit    7,a
  jr     z,+
  ;Need refresh
  res    7,a
  ld     (de),a			;Clear refresh flag
  bit    5,a
  jr     z,++			;Empty flag: clear icon
  push   bc
  push   hl
  ld     bc,2
  call   clear_w
  ld     bc,32-2
  add    hl,bc
  ld     bc,2
  call   clear_w
  pop    hl
  pop    bc
  jr     +
++:
  call   mapicon_w		;Normal icon
+:
  inc    hl
  inc    hl
  inc    e
  dec    b
  jr     nz,-
  push   de
  ld     de,50
  add    hl,de
  pop    de
  dec    c
  jr     nz,--
  ret

mapicon_w:
  push   de
  push   bc
  ld     b,a
  ldh    a,($FF)
  push   af
  push   hl
  xor    a
  ldh    ($FF),a
  ld     a,b
  and    $F
  sla    a
  sla    a			; *4 tiles/icon
  add    T_ICONS
  call   wait_write
  ldi    (hl),a		;0
  inc    a
  inc    a
  ld     (hl),a         ;2
  dec	 a
  ld     de,32-1
  add    hl,de
  call   wait_write
  ldi    (hl),a		;1
  inc    a
  inc    a
  ld     (hl),a		;3

  ld     a,(GBCOLOR)
  or     a
  jr     z,+	;DMG
  ;Palette attributes
  ld     a,1
  ldh    ($4F),a
  ld     a,b
  cp     8
  jr     c,++
  xor    a
  jr     +++
++:
  ld     hl,pal_icon_lut
  rst    0
+++:
  pop    hl
  push   hl

  call   wait_write
  ldi    (hl),a
  ld     (hl),a
  ld     de,32-1
  add    hl,de
  call   wait_write
  ldi    (hl),a
  ldi    (hl),a

  xor    a
  ldh    ($4F),a

+:
  pop    hl
  pop    af
  ldh    ($FF),a
  pop    bc
  pop    de
  ret


drawhpbar:
  ld     b,a
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     a,b
  ld     b,T_HPBAR
  call   wait_write
  ld     (hl),b		;"HP" tile
  inc    hl
  ld     b,a
  ld     c,4		;Total length of bar
  cp     $FF
  jr     z,drawfullbar
  or     a
  jr     z,++		;Zero
  ;Full tiles
-:
  cp     64
  jr     c,+
  ld     b,T_HPBARF	;Full
  call   wait_write
  ld     (hl),b
  inc    hl
  dec    c
  sub    64
  jr     -
+:
  or     a
  jr     z,++		;No semi-full tile
  ;Semi-full tile
  srl    a
  srl    a
  srl    a
  add    T_HPBARE
  call   wait_write
  ldi    (hl),a
  dec    c
++:
  ld     a,c
  or     a
  jr     z,+		;Bar drawn
  ld     a,T_HPBARE	;Empty
-:
  ;Empty tiles
  call   wait_write
  ldi    (hl),a
  dec    c
  jr     nz,-
+:
  pop    af
  ldh    ($FF),a
  ret

drawfullbar:
  ;Full tiles
-:
  ld     a,T_HPBARF	;Full
  call   wait_write
  ldi    (hl),a
  dec    c
  jr     nz,-
  pop    af
  ldh    ($FF),a
  ret
  
drawlives:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     a,(GAME_LIVES)
  dec    a
  or     a
  jr     z,+
  ld     b,a
  ld     hl,$9C00+(15*32)+1
-:
  call   wait_write
  ld     a,T_HEARTH
  ldi    (hl),a
  dec    b
  jr     nz,-
+:
  pop    af
  ldh    ($FF),a
  ret
  
drawsskill:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     a,(HAS_SPECIAL)
  ld     b,a
  ld     a,(FRAME)
  swap   a
  rlca
  and    1
  and    b
  ld     c,T_SSI
  or     a
  jr     nz,+
  ld     c,0
+:
  ld     hl,$9C00+(14*32)+5
  call   wait_write
  ld     (hl),c
  pop    af
  ldh    ($FF),a
  ret
  
drawshields:
  ldh    a,($FF)
  push   af
  xor    a
  ldh    ($FF),a
  ld     hl,$9C00+(32*16)+1
  ld     bc,4
  call   clear_w
  ld     hl,$9C00+(32*17)+1
  ld     bc,4
  call   clear_w
  ld     a,(PLAYER_SH1)
  or     a
  jr     z,+
  dec    a
  sla    a		;*6
  ld     b,a
  sla    a
  add    b
  ld     hl,(:map_shield1*$4000)+map_shield1
  rst    0
  ld     a,T_SHIELD
  ld     de,$9C00+(32*16)+3
  call   map
  ld     a,(PLAYER_SH2)
  or     a
  jr     z,+
  dec    a
  sla    a		;*6
  ld     b,a
  sla    a
  add    b
  ld     hl,(:map_shield1*$4000)+map_shield1
  rst    0
  ld     a,T_SHIELD
  ld     de,$9C00+(32*16)+1
  call   map
+:
  xor    a
  ld     (SHIELD_REFRESH),a
  pop    af
  ldh    ($FF),a
  ret


renderdizzy:
  ld     a,(FRAME)
  bit    3,a
  ld     b,%01000000
  jr     z,+
  ld     b,%00000000
+:

  ld     c,86
  ld     a,(PLAYER_DIZZY)
  or     a
  call   nz,renderdizzyspr

  ld     c,38
  ld     a,(ENEMY_DIZZY)
  or     a
  call   nz,renderdizzyspr
  ret

renderdizzyspr:
  ld     a,c
  ldi    (hl),a
  ld     a,136
  ldi    (hl),a
  ld     a,T_DIZZY
  ldi    (hl),a
  ld     a,b
  or     PALETTE_DIZZY
  ldi    (hl),a

  ld     a,c
  ldi    (hl),a
  ld     a,144
  ldi    (hl),a
  ld     a,T_DIZZY+2
  ldi    (hl),a
  ld     a,b
  or     PALETTE_DIZZY
  ldi    (hl),a
  ret

renderimmdeath:
  ld     a,(FRAME)
  bit    2,a
  ld     b,%00100000
  ld     d,T_IMMDEATH+2
  ld     e,T_IMMDEATH
  jr     z,+
  ld     b,%00000000
  ld     d,T_IMMDEATH
  ld     e,T_IMMDEATH+2
+:

  ld     a,34
  ldi    (hl),a
  ld     a,136
  ldi    (hl),a
  ld     a,d
  ldi    (hl),a
  ld     a,b
  or     PALETTE_IMMDEATH
  ldi    (hl),a

  ld     a,34
  ldi    (hl),a
  ld     a,144
  ldi    (hl),a
  ld     a,e
  ldi    (hl),a
  ld     a,b
  or     PALETTE_IMMDEATH
  ldi    (hl),a

  ret


renderdebris:
  ld     b,4
  ld     de,DEBRIS_SPR
-:
  ld     a,(de)		;ACTIVE
  inc    de
  or     a
  jr     nz,+
  inc    de
  inc    de
  inc    de
  inc    de
  jr     ++
+:
  inc    de
  ld     a,(de)
  srl    a		;7.1 to 8
  ldi    (hl),a
  dec    de
  ld     a,(de)
  srl    a		;7.1 to 8
  ldi    (hl),a
  inc    de
  inc    de
  inc    de
  inc    de
  ld     a,T_ICONS+8
  ldi    (hl),a
  ld     a,PALETTE_DEBRIS
  ldi    (hl),a
++:
  dec    b
  jr     nz,-
  ret

loadicons:
  ld     hl,(:tiles_icons*$4000)+tiles_icons
  ld     de,$8000+(T_ICONS*16)
  call   loadtiles_auto
  ret
  
loadplayer:
  ld     de,$8000+(T_PLAYER*16)
  ld     a,(SHIELD_UP)
  or     a
  jr     nz,+
  ld     hl,(:tiles_player_i*$4000)+tiles_player_i
  call   loadtiles_auto
  ret
+:
  ld     hl,(:tiles_player_s*$4000)+tiles_player_s
  call   loadtiles_auto
  ret
  
loadenemy:
  ldi    a,(hl)
  ld     h,(hl)
  ld     l,a
  ld     de,$8000+(T_ENEMY*16)
  call   loadtiles_auto
  ret
