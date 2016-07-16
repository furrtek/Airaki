;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

pdeath:
  ld     a,(GAME_MODE)
  bit    0,a
  jr     nz,p2pdeath
  di
  ld     hl,GAMEOVER_CALL
  ld     de,goc_p1death
  ld     (hl),e
  inc    hl
  ld     (hl),d
  jr     +

p2edeath:
  di
  ld     a,1
  ld     (LINK_SENDDEAD),a
  ld     (LINK_QUIT),a
  ld     hl,GAMEOVER_CALL
  ld     de,goc_p2edeath
  ld     (hl),e
  inc    hl
  ld     (hl),d
  jr     ++

p2pdeath:
  di
  ld     a,1
  ld     (LINK_QUIT),a
  ld     hl,GAMEOVER_CALL
  ld     de,goc_p2pdeath
  ld     (hl),e
  inc    hl
  ld     (hl),d
+:

  xor    a
  ld     (GAMEOVER_TIMER),a

  ld     hl,VBL_HANDLER
  ld     de,pdeath_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d

  call   dxcp_over

  ld     hl,sfxdata_pdeath
  call   sfx_play

  xor    a
  ldh    ($42),a 	;Scroll X
  ldh    ($43),a	;Scroll Y
  ei
  ret



edeath:
  di

  ld     hl,GAMEOVER_CALL
  ld     de,goc_p1edeath
  ld     (hl),e
  inc    hl
  ld     (hl),d
  
++:

  ld     hl,VBL_HANDLER
  ld     de,edeath_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d

  xor    a
  ld     (EDEATH_TIMER),a
  
  call   dxcp_over

  ld     hl,sfxdata_pdeath
  call   sfx_play

  xor    a
  ldh    ($42),a 	;Scroll X
  ldh    ($43),a	;Scroll Y
  ei
  ret


edeath_vbl:
  call   sfx_update
  call   do_comm
  call   readinput
  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear

  ld     a,(EDEATH_TIMER)
  inc    a
  cp     30
  jr     nz,+
  ld     (EDEATH_TIMER),a

  ld     hl,$9C00+(32*4)+1	;Draw dead enemy :(
  ld     bc,$0404
  ld     a,T_ENEMY
  call   mapinc_w
  ld     hl,ENEMYGFX_DEAD
  call   loadenemy
  ret
+:
  cp     60
  jr     nz,++
  ld     (EDEATH_TIMER),a
  ld     hl,GAMEOVER_CALL
  ld     a,(hl)
  inc    hl
  ld     h,(hl)
  ld     l,a
  call   dojump
  ret
++:
  cp     61
  jr     c,+
  ld     a,(JOYP_ACTIVE)
  bit    3,a
  ret    z
  ld     a,(GAME_MODE)
  or     a
  jp     z,menu_setup
  di
  call   screen_off
  call   clearbkg
  ld     a,%11110111            ;Display on, BG on, sprites on 8x16, window on, tiles at $8000
  ldh    ($40),a
  jp     restart
+:
  ld     (EDEATH_TIMER),a
  ret



pdeath_vbl:
  call   sfx_update
  call   do_comm
  call   readinput
  ld     hl,OAMCOPY
  ld     bc,$A0
  call   clear

  ld     a,(GAMEOVER_TIMER)
  inc    a
  cp     30
  jr     nz,+
  ld     (GAMEOVER_TIMER),a
  ;Draw player
  ld     hl,$9C00+(32*10)+1
  ld     bc,$0404
  ld     a,T_PLAYER
  call   mapinc_w
  ld     de,$8000+(T_PLAYER*16)
  ld     hl,(:tiles_player_d*$4000)+tiles_player_d
  call   loadtiles_auto
  ret
+:
  cp     60
  jr     nz,++
  ld     (GAMEOVER_TIMER),a
  ld     hl,GAMEOVER_CALL
  ld     a,(hl)
  inc    hl
  ld     h,(hl)
  ld     l,a
  call   dojump
  ret
++:
  cp     61
  jr     c,+
  ld     a,(JOYP_ACTIVE)
  bit    3,a
  jp     nz,menu_setup
  ret
+:
  ld     (GAMEOVER_TIMER),a
  ret



goc_p1death:
  ld     hl,$9800
  ld     bc,32*32
  call   clear_w
  ld     hl,$9800+(32*10)+2
  ld     de,text_battleover
  ld     b,T_ALPHA-96
  call   maptext
  ld     a,PALETTE_RED
  ld     hl,$9800+(32*10)+2
  ld     bc,$1006
  call   settilepal
  ret
  
goc_p1edeath:
  xor    a
  ld     (EDEATH_TIMER),a
  ld     hl,$9800
  ld     bc,32*32
  call   clear_w
  ld     hl,$9800+(32*3)+3		;"VICTORY!"
  ld     de,text_victory
  ld     b,T_ALPHA-96
  call   maptext
  ld     a,PALETTE_RED
  ld     hl,$9800
  ld     bc,$2020
  call   settilepal
  ld     hl,VBL_HANDLER
  ld     de,victory_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d
  ret

text_battleover:
  .db "  BATTLE",$FE
  .db "   OVER",$FE,$FE,$FE
  .db "PUSH START",$FF
  
goc_p2pdeath:
  ld     hl,$9800
  ld     bc,32*32
  call   clear_w
  ld     hl,$9800+(32*10)+2
  ld     de,text_2plost
  ld     b,T_ALPHA-96
  call   maptext
  ld     a,PALETTE_RED
  ld     hl,$9800+(32*10)+2
  ld     bc,$1006
  call   settilepal
  ret

text_2plost:
  .db " YOU LOST ",$FE,$FE,$FE
  .db "PUSH START",$FF
  
goc_p2edeath:
  ld     hl,$9800
  ld     bc,32*32
  call   clear_w
  ld     hl,$9800+(32*10)+2
  ld     de,text_2pwin
  ld     b,T_ALPHA-96
  call   maptext
  ld     a,PALETTE_SHIELD
  ld     hl,$9800+(32*10)+2
  ld     bc,$1006
  call   settilepal
  ret
  
text_2pwin:
  .db " YOU WON! ",$FE,$FE,$FE
  .db "PUSH START",$FF
