;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;Add new attack in FIFO
addattack:
  ld     h,>ATTACK_FIFO		;MSB
  ld     a,(AFIFO_PUT)
  ld     l,a
  ld     (hl),b			;Type
  inc    l
  ld     (hl),c                 ;Mod value
  inc    l
  ld     a,l
  and    $1E
  ld     (AFIFO_PUT),a
  ret

processfifo:
  ld     a,(AFIFO_GET)
  ld     hl,AFIFO_PUT
  cp     (hl)
  ret    z			;Put pointer = Get pointer, no need to process new attacks
  ;Process attack
  ld     h,>ATTACK_FIFO		;MSB
  ld     l,a
  ld     b,(hl)			;Attack type
  inc    l
  ld     e,(hl)			;Mod value
  inc    l
  ld     a,l
  and    $1E
  ld     (AFIFO_GET),a
  ld     a,b
  ld     hl,damage_lut
  rst    0
  ld     h,a
  call   mul8_8			;HL = E*H = Mod value * damage
  ld     a,l
  ld     (PLAYERATK_FORCE),a
  ld     a,b
  ld     hl,aae_lut		;In aanimations.asm
  sla    a
  rst    0
  ld     e,a
  inc    hl
  ld     a,(hl)
  ld     d,a
  call   aa_init_player
  ;Send attack for 2P mode
  ld     b,1			;Regular attack (slashes)
  ld     a,(PLAYERATK_FORCE)
  or     a
  jr     nz,+
  inc    b			;Force = 0, so it's a beer
+:
  ld     a,b
  ld     (PLAYERATK_TOSEND),a
  ret

damage_lut:
  .db DAMAGE_PUNCH
  .db DAMAGE_SWORD
  .db DAMAGE_SCOURGE
  .db 0				;Beer attack
  .db DAMAGE_HAMMER

setdamage:
  ld     a,(GAME_MODE)
  bit    0,a
  jr     z,setdamage_1p
  jr     setdamage_2p

setdamage_1p:
  ld     hl,sfxdata_hit
  call   sfx_play
  ld     a,(PLAYERATK_FORCE)
  ld     b,a
  ld     a,(ENEMY_HP)
  cp     b
  jr     nc,+			;FORCE >= HP : Enemy survives
  ;Enemy killed
  jp     edeath
+:
  sub    b
  ld     (ENEMY_HP),a
  ld     a,BLINK_TIME
  ld     (ENEMY_BLINK),a
  ld     hl,HPBAR_REFRESH
  set    0,(hl)
  ret
  
setdamage_2p:
  ld     a,(PLAYERATK_FORCE)
  ld     c,a
  ld     a,(ENEMY_SH)		;Does he have a shield ?
  or     a
  jr     z,+
-:
  srl    c			;Divide damage by shield strength
  dec    a
  jr     nz,-
  xor    a
  ld     (ENEMY_SH),a
+:
  ld     a,(ENEMY_HP)
  cp     c
  jr     nc,+			;FORCE >= HP : Enemy survives
  jp     p2edeath
+:
  sub    c
  ld     (ENEMY_HP),a
  ld     a,BLINK_TIME
  ld     (ENEMY_BLINK),a
  ld     hl,HPBAR_REFRESH
  set    0,(hl)
  ret
