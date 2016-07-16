;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;AAnimator documentation:
;Sprites 0~7 are for enemy hits player, 8~15 for player hits enemy
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
;04: Link MotionLUT to sprite
;	## sprid (0~15)
;	## lut size
;	#### address of lut
;05: Run motionLUT(s)
;	## speed (NOT IMPLEMENTED, DO NOT USE !)
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

aae_lut:
  .dw aae_punch
  .dw aae_sword
  .dw aae_scourge
  .dw aae_beer
  .dw aae_hammer

aae_hammer:
  .db 1,0
  .dw (:tiles_aa_hammer1*$4000)+tiles_aa_hammer1
  .db 1,4
  .dw (:tiles_aa_hammer2*$4000)+tiles_aa_hammer2
  .db 1,8
  .dw (:tiles_aa_hit*$4000)+tiles_aa_hit
  
  .db 2,8,0,PALETTE_BOMB,158,45
-:
  .db 6,8,-2,0
  .db 9,1
  .db 7,6
  .dw -
  .db 2,8,4,PALETTE_BOMB,142,45
  .db 9,4
  .db 2,9,8,PALETTE_BOMB,134,52
  .db 11
  .dw sfxdata_hit
  .db 9,4
  .db 8,9

  .db 2,8,0,PALETTE_BOMB,158,55
-:
  .db 6,8,-2,0
  .db 9,1
  .db 7,6
  .dw -
  .db 2,8,4,PALETTE_BOMB,142,55
  .db 9,4
  .db 2,9,8,PALETTE_BOMB,134,62
  .db 11
  .dw sfxdata_hit
  .db 9,4
  .db 8,9

  .db 8,8

  .db 10
  .dw setdamage
  .db 0

aae_beer:
  .db 1,0
  .dw (:tiles_aa_beer*$4000)+tiles_aa_beer
  
  .db 11
  .dw sfxdata_beerfall

  .db 2,8,0,PALETTE_BEER,136,25
-:
  .db 6,8,0,1
  .db 9,1
  .db 7,4
  .dw -
-:
  .db 6,8,0,2
  .db 9,1
  .db 7,6
  .dw -
  .db 3,8,124,45
-:
  .db 6,8,0,1
  .db 9,1
  .db 7,4
  .dw -
-:
  .db 6,8,0,2
  .db 9,1
  .db 7,6
  .dw -
  .db 3,8,148,45
-:
  .db 6,8,0,1
  .db 9,1
  .db 7,4
  .dw -
-:
  .db 6,8,0,2
  .db 9,1
  .db 7,6
  .dw -

  .db 8,8

  .db 10
  .dw enemy_dizzy
  .db 0

aae_scourge:
  .db 1,0
  .dw (:tiles_aa_fist*$4000)+tiles_aa_scourgeh
  .db 1,8
  .dw (:tiles_aa_fist*$4000)+tiles_aa_scourge
  .db 1,12
  .dw (:tiles_aa_hit*$4000)+tiles_aa_hit

  .db 2,8,8,PALETTE_BOMB,136,70+9
  .db 2,9,0,PALETTE_BOMB,136,76
  .db 2,10,4,PALETTE_BOMB,136,76+16

-:
  .db 6,8,-3,-3
  .db 6,9,-1,-1
  .db 6,10,-1,-1
  .db 9,1
  .db 7,4
  .dw -
  .db 11
  .dw sfxdata_hit
  .db 2,11,12,PALETTE_BOMB,126,58
  .db 9,4
  .db 8,11
-:
  .db 6,8,3,-3
  .db 6,9,1,-1
  .db 6,10,1,-1
  .db 9,1
  .db 7,4
  .dw -
  .db 11
  .dw sfxdata_hit
  .db 2,11,12,PALETTE_BOMB,136,42
  .db 9,4
  .db 8,11
-:
  .db 6,8,3,3
  .db 6,9,1,1
  .db 6,10,1,1
  .db 9,1
  .db 7,4
  .dw -
  .db 11
  .dw sfxdata_hit
  .db 2,11,12,PALETTE_BOMB,146,58
  .db 9,4
  .db 8,11
-:
  .db 6,8,-3,3
  .db 6,9,-1,1
  .db 6,10,-1,1
  .db 9,1
  .db 7,4
  .dw -

  .db 8,8
  .db 8,9
  .db 8,10

  .db 10
  .dw setdamage
  .db 0

aae_sword:
  .db 1,0
  .dw (:tiles_aa_fist*$4000)+tiles_aa_sword
  .db 1,8
  .dw (:tiles_aa_hit*$4000)+tiles_aa_hit
  .db 2,8,0,PALETTE_BOMB,148,60
  .db 2,9,4,PALETTE_BOMB,148,60+16
  .db 11
  .dw sfxdata_sword
-:
  .db 6,8,253,254
  .db 6,9,253,254
  .db 9,1
  .db 7,7
  .dw -

  .db 3,8,124,60
  .db 3,9,124,60+16
  .db 11
  .dw sfxdata_sword
-:
  .db 6,8,3,254
  .db 6,9,3,254
  .db 9,1
  .db 7,7
  .dw -
  
  .db 3,8,136,78
  .db 3,9,136,78+16
-:
  .db 6,8,0,255
  .db 6,9,0,255
  .db 9,1
  .db 7,4
  .dw -
  
  .db 11
  .dw sfxdata_sword
-:
  .db 6,8,0,253
  .db 6,9,0,253
  .db 9,1
  .db 7,7
  .dw -

  .db 11
  .dw sfxdata_hit
  .db 8,8
  .db 8,9
  .db 10
  .dw setdamage
  .db 0

aae_punch:
  .db 1,0
  .dw (:tiles_aa_fist*$4000)+tiles_aa_fist
  .db 1,4
  .dw (:tiles_aa_hit*$4000)+tiles_aa_hit

  .db 2,8,0,PALETTE_BOMB,162,50
-:
  .db 6,8,253,0
  .db 9,1
  .db 7,6
  .dw -
  .db 11
  .dw sfxdata_hit
  .db 2,8,4,PALETTE_BOMB,136,50
  .db 9,4
  
  .db 2,8,0,PALETTE_BOMB,156,56
-:
  .db 6,8,253,0
  .db 9,1
  .db 7,6
  .dw -
  .db 11
  .dw sfxdata_hit
  .db 2,8,4,PALETTE_BOMB,130,56
  .db 9,4
  
  .db 2,8,0,PALETTE_BOMB,168,62
-:
  .db 6,8,253,0
  .db 9,1
  .db 7,6
  .dw -
  .db 11
  .dw sfxdata_hit
  .db 2,8,4,PALETTE_BOMB,142,62
  .db 9,4

  .db 8,8

  .db 10
  .dw setdamage

  .db 0


aap_beer:
  .db 1,0
  .dw (:tiles_aa_beer*$4000)+tiles_aa_beer
  
  .db 11
  .dw sfxdata_beerfall

  .db 2,0,0,PALETTE_BEER,136,90
-:
  .db 6,0,0,1
  .db 9,1
  .db 7,4
  .dw -
-:
  .db 6,0,0,2
  .db 9,1
  .db 7,6
  .dw -
  .db 3,0,124,110
-:
  .db 6,0,0,1
  .db 9,1
  .db 7,4
  .dw -
-:
  .db 6,0,0,2
  .db 9,1
  .db 7,6
  .dw -
  .db 3,0,148,110
-:
  .db 6,0,0,1
  .db 9,1
  .db 7,4
  .dw -
-:
  .db 6,0,0,2
  .db 9,1
  .db 7,6
  .dw -

  .db 8,0
  
  .db 10
  .dw init_dxcp_attack
  .db 0

aap_slash:
  .db 1,0
  .dw (:tiles_aa_slash*$4000)+tiles_aa_slash
  
  .db 2,0,0,PALETTE_RED,140,84
  .db 2,1,4,PALETTE_RED,156,84
  .db 2,2,8,PALETTE_RED,140,100
  .db 2,3,12,PALETTE_RED,156,100

  .db 9,40

  .db 11
  .dw sfxdata_slash

-:
  .db 6,0,255,1
  .db 6,1,255,1
  .db 6,2,255,1
  .db 6,3,255,1
  .db 9,1
  .db 7,5
  .dw -
  
-:
  .db 6,0,254,2
  .db 6,1,254,2
  .db 6,2,254,2
  .db 6,3,254,2
  .db 9,1
  .db 7,5
  .dw -

  .db 8,0
  .db 8,1
  .db 8,2
  .db 8,3
  
  .db 11
  .dw sfxdata_hit

  .db 10
  .dw getdamage

  .db 0
