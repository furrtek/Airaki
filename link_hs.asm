;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

linkh_wm:
  ;See if we got MC
  ld     a,(LINK_RX)
  cp     LINK_MASTERID
  jr     z,+
  ld     a,LINK_HANDSHAKE
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  ret
+:
  ;Yes: become slave
  xor    a
  ld     (LINK_TIMEOUT),a
  ld     (LINK_ISMASTER),a
  ld     hl,LINK_HANDLER
  ld     de,linkh_slave
  ld     (hl),e
  inc    hl
  ld     (hl),d
  ld     a,$13
  ldh    ($01),a
  ld     a,$80
  ldh    ($02),a
  jp     game_setup
  
linkh_masterhs:
  ld     a,(LINK_RX)
  cp     LINK_HANDSHAKE
  ret    nz
  xor    a
  ld     (LINK_TIMEOUT),a
  ld     hl,LINK_HANDLER
  ld     de,linkh_master
  ld     (hl),e
  inc    hl
  ld     (hl),d
  jp     game_setup

link_vbl:
  call   sfx_update
  
  ld     a,(LINK_STATE)
  ld     hl,linkvbl_jt
  rst    $30

  ld     a,(LINK_TIMEOUT)
  inc    a
  ld     (LINK_TIMEOUT),a
  cp     LINKTIMEOUT_DURATION
  ret    nz
  ld     a,(LINK_STATE)
  ld     hl,linktimeout_jt
  rst    $30
  ei
  ret

linktimeout_jt:
  .dw    linktimeout_0	;Become master (search for master)
  .dw    linktimeout_1  ;Ignore (wait for slave)
  .dw    linktimeout_1  ;Ignore (wait for game quit after link error)

linktimeout_0:
  ;Become master
  ld     hl,LINK_HANDLER
  ld     de,linkh_masterhs
  ld     (hl),e
  inc    hl
  ld     (hl),d
  xor    a
  ld     (LINK_TIMEOUT),a
  ld     a,1
  ld     (LINK_ISMASTER),a		;Become master
  ld     (LINK_STATE),a
  ret

linktimeout_1:
  ret

linkvbl_jt:
  .dw    linkvbl_0      ;Listen for MC
  .dw    linkvbl_1	;Broadcast MC, quit on B press
  .dw    linkvbl_2      ;Wait for button press (quit error)

linkvbl_0:
  ld     a,$80
  ldh    ($02),a
  ret

linkvbl_1:
  call   readinput
  ld     a,(JOYP_ACTIVE)	;B: Go back to menu
  and    2
  call   nz,menu_setup

  ld     a,LINK_MASTERID
  ldh    ($01),a
  ld     a,$81
  ldh    ($02),a
  ret

linkvbl_2:
  call   readinput
  ld     a,(JOYP_ACTIVE)	;Go back to menu
  and    $F
  jp     nz,menu_setup
  ret
