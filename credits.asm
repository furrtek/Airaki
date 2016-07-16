;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

  .DEFINE T_C_ALPHA	0

credits_setup:

  di
  call	 screen_off

  call   clearbkg
  call   clearsprites

  ld     hl,(:tiles_alpha*$4000)+tiles_alpha
  ld     de,$8000+(T_C_ALPHA*16)
  call   loadtiles_auto

  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  ld     hl,pal_credits_bg
  ld     b,2*4*2
  xor    a
  call   loadbgpal
  ld     hl,$9800
  ld     bc,$2020
  xor    a
  call   settilepal
+:

  xor    a
  ld     (CREDS_I),a
  ld     a,1
  ld     (CREDS_TIMER),a
  ld     a,255-144
  ld     (BKG_Y),a

  ld     hl,VBL_HANDLER
  ld     de,credits_vbl
  ld     (hl),e
  inc    hl
  ld     (hl),d

  ld     de,RLI_null
  call   load_RLI

  ld     a,%11100100            ;BG palette
  ldh    ($47),a
  ld     a,%11100100            ;SPR0 palette
  ldh    ($48),a
  ld     a,%10010111            ;Display on, BG on, sprites on 8x16, window off
  ldh    ($40),a
  ld     a,%00000001            ;Vblank only
  ldh    ($FF),a

  xor    a
  ldh    ($0F),a
  ei

  ret


credits_vbl:
  ld     a,(FRAME)
  and    1
  ld     a,(CREDS_TIMER)
  jr     nz,+++
  ld     a,(CREDS_TIMER)
  dec    a
  jr     nz,+++
  ld     hl,$9800+(32*4)
  ld     bc,32*10
  call   clear_w
  ld     hl,$9800+(32*4)
  ld     bc,$2010
  xor    a
  call   settilepal

  ld     hl,credits_list
  ld     a,(CREDS_I)
  sla    a
  rst    0
  inc    hl
  ld     h,(hl)
  ld     l,a
  
  ld     a,l
  or     h
  jp     z,menu_setup
  
  push   hl

  ld     a,(hl)
  inc    hl
  ld     h,(hl)
  ld     l,a

  ld     a,(GBCOLOR)
  or     a
  jr     z,+
  push   hl
  ld     a,l
  and    $E0
  ld     l,a
  ld     bc,$2001
  ld     a,1
  call   settilepal
  pop    hl
+:

  pop    de
  inc    de
  inc    de

  ld     b,32
  call   maptext
  
  ld     a,(CREDS_I)
  inc    a
  ld     (CREDS_I),a
  ld     a,120
+++:
  ld     (CREDS_TIMER),a
  ret
  
;Offset BGY
;Map text
;Scroll up (in)
;Wait
;Scroll up (out)
;Next line...

credits_list:
  .dw creds_0
  .dw creds_1
  .dw creds_2
  .dw creds_3
  .dw creds_4
  .dw creds_5
  .dw 0

creds_0:
.dw $9800+(32*8)+7
.db "AIRAKI!",$FF
creds_1:
.dw $9800+(32*8)+1
.db "CODE & GRAPHICS:",$FE
.db "           FURRTEK",$FF
creds_2:
.dw $9800+(32*8)+1
.db "LABEL ART:",$FE
.db "           ROBOTWO",$FF
creds_3:
.dw $9800+(32*8)+1
.db "INTRO FANFARE:",$FE
.db "        JANKENPOPP",$FF
creds_4:
.dw $9800+(32*6)+1
.db "THANKS:",$FE
.db "              DYAK",$FE
.db "       KITSCH-BENT",$FE
.db "       VILLE HELIN",$FE
.db "   YARONET MEMBERS",$FF
creds_5:
.dw $9800+(32*8)+4
.db "THANK YOU",$FE
.db " FOR PLAYING",$FF
