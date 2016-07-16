;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

.STRUCT AASPR
TILE DB
ATTR DB
XPOS DB
YPOS DB
.ENDST

.STRUCT DEBRIS
ACTIVE DB
XPOS DB
YPOS DB
XSPD DB
YSPD DB
.ENDST

.ENUM $C000 EXPORT
A_REG DB
FRAME DB
RAND8 DB
GOTVBL DB
VBL_HANDLER DW
PREVJP DB
JOYP_ACTIVE DB          ;Rising edges
JOYP_CURRENT DB         ;Continuous presses
JOYP_LAST DB
WAVE_START DB		;Title screen waves and ingame DXCP
GBCOLOR DB

SFX_PLAYING DB
SFX_DELTA DB
SFX_PTR DW

PALSPR DS 32*2
PALBG DS 32*2

MAP_W DB
MAP_FIRST DB
FADER DB		;Fade animator

CURSOR_X DB
CURSOR_Y DB

RLI DS 3		;JP xx xx

;Logos

LOGOS_TIMER DB

;Intro

INTRO_STEP DB
INTRO_TIMER DB

ISWORD1_X DB
ISWORD2_X DB
ISWORD_Y DB

BKG_X DB
BKG_Y DB
WIN_X DB
WIN_Y DB

;Menu

MCURSOR_PSEL DB		;1P/2P selection
MCURSOR_SSEL DB		;Special skill selection
MCURSOR_LINE DB         ;Line of menu

;Game

GAME_MODE DB		;bit0:Linked bit1:Story/3lives
GAME_LIVES DB		;Remaining lives
PAUSE_FLAG DB
B_COUNTER DB		;Frame counter to know how long player's pressing on B
SHIELD_UP DB
CURSOR_MODE DB		;Horizontal / Vertical
LEVEL DB		;0~4

P_CORRECTED DB          ;Flag to know if the panel has been corrected in a correction pass or not
P_CORRPASS DB           ;Correction pass iteration counter to avoid getting stuck in panel gen

FALLEN DB		;Flag to know if gravity made blocks fall or not
MATCHED DB		;Flag to know if checkmatch marked some blocks as deletable
CANSOLVE DB		;Flag to know if current panel is solvable or not

SOLUTION_X DB
SOLUTION_Y DB
SOLUTION_MODE DB

NEED_CHECKMATCH DB

FLIP_MODE DB		;0:H 1:V
FLIP_FLAGS DB		;0:nothing, 1:flipping, 2:check matches, 3:apply gravity
FLIP_TOSET DB		;Flag to know if last flip was useless (cancel) or not (for flipanim)
FLIP_AT DB              ;A icon tile #
FLIP_AI DB              ;A icon icon #
FLIP_AP DB		;A icon CGB palette
FLIP_BT DB
FLIP_BI DB
FLIP_BP DB
FLIP_X DB               ;X of cursor when flipped, in icons
FLIP_Y DB               ;Y "
FLIP_PADDR DW           ;Address of flip in PANEL array
FLIP_VADDR DW		;Address of flip in VRAM (BG)
FLIP_ANIM DB            ;Animator (0~15)

POP_X DB		;Position of pop bubble in pixels
POP_Y DB
POP_GFX DB		;Pop tile index
POP_ANIM DB		;Animator for pop sprites (scroll up, widen)

ANIM_SHAKE DB
HPBAR_REFRESH DB	;bit 0: refresh enemy, bit1: refresh player
SHIELD_REFRESH DB	;Shield icons need refresh flag

SCORE DS 3		;Total score

SCOREEN DS 3		;Enemy score
SCOREBONUS DS 3

TIME_SEC DB		;Total time
TIME_FRAME DB
TIME_MIN DB

TIMEEN_SEC DW      	;Enemy time

PLAYER_HP DB
PLAYER_SS DB		;Special skill number
PLAYER_DIZZY DB         ;Dizzy timer (drunk)
PLAYER_BLINK DB		;Blink timer
PLAYER_SH1 DB		;First shield type
PLAYER_SH2 DB		;Second shield type
PLAYER_USEPOTION DB	;Link mode potion flag to up HP on enemy's side
HAS_SPECIAL DB		;Flag to know if player disposes of special attack or not
PLAYERATK_FORCE DB
PLAYERATK_TOSEND DB
HAMMER_MODE DB
HAMMER_COUNTER DB	;Hammer use counter

AFIFO_GET DB
AFIFO_PUT DB

ENEMY_HP DB
ENEMY_DIZZY DB		;Dizzy timer
ENEMY_BLINK DB		;Blink timer
ENEMY_SH DB		;Only for 2p mode
ENEMYATK_ANIM DB	;Animator for enemy attack
ENEMYATK_LVLMIN DB
ENEMYATK_LVLAMP DB
ENEMYATK_LVLWARN DB
ENEMYATK_TIMER DB	;Delay in frames before next enemy attack
ENEMYATK_WARNTIMER DB
ENEMYATK_FORCE DB

ENEMYGFX_IDLE DW
ENEMYGFX_ATK DW
ENEMYGFX_DEAD DW

;AttackAnimator

AA_SPR INSTANCEOF AASPR 16

AA_E_PTR DW
AA_E_RUN DB
AA_E_WAIT DB
AA_E_LOOP DB

AA_P_PTR DW
AA_P_RUN DB
AA_P_WAIT DB
AA_P_LOOP DB

;Link mode

LINK_HANDLER DW
LINK_RX DB
LINK_STATE DB
LINK_TIMEOUT DB
LINK_ISMASTER DB
LINK_FIELD DB
LINK_HPBUFFER DB
LINK_SENDDEAD DB
LINK_SENDBOMB DB
LINK_IGNOREPAUSE DB		;Kludge to avoid ping-pong pause enable/disable in 2P
LINK_QUIT DB

;Bomb debris

DEBRIS_SPR INSTANCEOF DEBRIS 4
DEBRIS_TIMER DB

;Game over

GAMEOVER_TIMER DB
GAMEOVER_CALL DW
EDEATH_TIMER DB

;Credits

CREDS_I DB
CREDS_TIMER DB

.ENDE

.DEFINE ATTACK_FIFO $DE00	;Don't move ! Length=32 (16* 2 bytes)
.DEFINE PANEL $DE80             ;Can move, but be careful @ "PANEL" and "$80" everywhere
.DEFINE OAMCOPY $DF00           ;$DF00~$DF9F for DMA OAM copy
