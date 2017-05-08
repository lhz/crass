;; Test source

	; Start address
	.org $C000

COLOURS	= $FB

	; Set screen and border colours
Start	lda #<Colours
	sta COLOURS
	lda #>Colours
	sta COLOURS + 1

	ldy #1
:	lda (COLOURS),y
	sta $D020,y
	dey
	bpl -
	rts

	; Multiple statements per line
Multi:	nop : bit $ea : rts ; Comment

	; Line continuation
	pha \
	pla \
	rts

	; Colour table
Colours	.byte 10, 2

	; Some text
Text:	.text "some \"text; with\" semicolon inside quotes; and out" ; and a comment
