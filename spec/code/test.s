;; Test source

	; Start address
	.org $C000

COLOURS	= $FB

	; Set screen and border colours
Start	lda #<Colours
	sta COLOURS
	lda #>Colours
	sta COLOURS + 1

	bcs +
	ldy #1
-	lda (COLOURS),y
	sta $D020,y
	dey
	bpl -
+	rts

	lda #0
	.repeat 10, i
	sta $0400 + i
	.endrep

	; Multiple statements per line
Multi:	nop : bit $ea : rts ; Comment

	; Line continuations
	lda \
	<Colours\
,x
	rts

	; Colour table
Colours	.byte 10, 2

	; Some text
Text:	.text "some \"text; with\" semicolon inside quotes; and out" ; and a comment

	;.text "unterminated quote
