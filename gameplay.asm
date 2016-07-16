;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;Score defs

  .DEFINE SCORE_SHIELD 30		;See MOD_* (Max multiplier) - Never go above 255 !
  .DEFINE SCORE_PUNCH 20
  .DEFINE SCORE_SWORD 40
  .DEFINE SCORE_SCOURGE 60
  .DEFINE SCORE_POTION 70
  .DEFINE SCORE_POISON 60
  .DEFINE SCORE_BOMB 0
  .DEFINE SCORE_SSKILL 50
  .DEFINE SCORE_USESHIELD 30

;Normal shield is damage/2, +2 is damage/4, +3 is damage/8

  .DEFINE DAMAGE_PUNCH		3	;See MOD_* (Max multiplier) - Never go above 255 !
  .DEFINE DAMAGE_SWORD		5
  .DEFINE DAMAGE_SCOURGE	10
  .DEFINE DAMAGE_BOMB		5
  .DEFINE DAMAGE_HAMMER		10

  .DEFINE MOD_NOTHING	1		;Damage multiply values
  .DEFINE MOD_2		2               ;4 icons
  .DEFINE MOD_3		3               ;5 icons
  .DEFINE MOD_H		1		;Horizontal line (was 2)

  .DEFINE HEAL_VALUE		80	;Heal value for player between enemies
  .DEFINE MAX_HAMMERS		3	;Number of hammer uses
  .DEFINE SHIELD_UP_DELAY	20	;Time to press B to raise shield
  .DEFINE BLINK_TIME		50      ;Esthetic
  .DEFINE IMMINENT_DEATH	32	;Level of enemy hp at which to start immdeath animation
  .DEFINE DXCP_ATTACK		120     ;8s beer attack
  .DEFINE DXCP_BEER		90      ;6s beer match
  .DEFINE POTION_VALUE		18
  .DEFINE SHAKE_DURATION 	50	;Regen/start shake
  .DEFINE SHAKEB_DURATION	10	;Bomb shake

