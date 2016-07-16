;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

;Each bit pair = movement (0~3 pixels), inverted LSB/MSB to simplify reading code (See tablemkr)
lut_logos:
  .db $50,$65,$A6,$AA,$EB,$FB,$FF,$FF,$FF,$FF,$EF,$AE,$9E,$9A,$55,$45,$41,$40,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$44,$55,$66,$AA,$AE,$EF,$FF,$FF,$FF,$BE
lut_icharsa:
  .db $64,$96,$65,$59,$55,$55,$51,$14,$11,$04
lut_icharsb:
  .db $00,$00,$11,$44,$51,$54,$45,$55,$15,$55

;A is bit-pair index in HL LUT
getbitlut:
  ld     b,a
  srl    a
  srl    a			;/4 (2bit to byte magnitude)
  rst    0
  ld     c,a
  ld     a,b
  and    3
  jr     z,+
-:
  srl    c
  srl    c
  dec    a
  jr     nz,-
+:
  ld     a,c
  and    3
  ret
