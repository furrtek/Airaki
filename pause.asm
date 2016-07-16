;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

enterpause:
  ld     a,1
  ld     (PAUSE_FLAG),a
  ld     a,(PLAYER_DIZZY)
  or     a
  jr     z,+
  ldh    a,($FF)
  and    %11111101		;Disable dxcp
  ldh    ($FF),a
+:
  ld     (LINK_IGNOREPAUSE),a
  ld     hl,sfxdata_menu
  call   sfx_play
  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear
  ld     hl,$9800
  ld     bc,32*32
  call   clear_w
  ld     hl,$9800+(32*8)+4
  ld     de,text_pause
  ld     b,T_ALPHA-96
  call   maptext
  ld     a,PALETTE_RED
  ld     hl,$9800+(32*8)+4
  ld     bc,$0601
  call   settilepal
  xor    a
  ldh    ($42),a 	;Scroll X
  ldh    ($43),a	;Scroll Y
  ret

exitpause:
  xor    a
  ld     (PAUSE_FLAG),a
  inc    a
  ld     (LINK_IGNOREPAUSE),a
  ld     a,(PLAYER_DIZZY)
  or     a
  jr     z,+
  ldh    a,($FF)
  or     %00000010		;Re-enable dxcp
  ldh    ($FF),a
+:
  ld     hl,PANEL
  ld     b,7*9
-:
  ld     a,(hl)
  or     $80		;Refresh flag
  ldi    (hl),a
  dec    b
  jr     nz,-
  call   drawpanel
  ret
