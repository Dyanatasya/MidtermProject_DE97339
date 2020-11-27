		#include<p18f4550.inc>

loop_cnt	equ 	0x00
loop_cnt1	equ 	0x01
loop_cnt2	equ 	0x02
loop_cnt3	equ		0x03
		
		org 0x00
		goto start
		org 0x08
		retfie
		org 0x18

;---------------delay subroutine for keypad---------------

dup_nop1 macro kk
		variable i
i=0
		while i < kk
		nop
i+=1
		endw
		endm

delay1	movlw D'15'
		movwf loop_cnt2,A
again2	movlw D'180'
		movwf loop_cnt3,A
again3	dup_nop1 D'17'
		decfsz loop_cnt3,F,A
		bra again3
		decfsz loop_cnt2,F,A
		bra again2
		return

;----------------delay subroutine for button---------------

dup_nop macro kk
		variable i
i=0
		while i < kk
		nop
i+=1
		endw
		endm

delay	movlw D'150'
		movwf loop_cnt1,A
again1	movlw D'100'
		movwf loop_cnt,A
again	dup_nop D'50'
		decfsz loop_cnt,F,A
		bra again
		decfsz loop_cnt1,F,A
		bra again1
		return

;-------------------lcd command subroutine for keypad------------

WriteC1	bcf PORTC,4,A ;RS = 0
		bcf PORTC,5,A ;RW = 0
		bsf PORTC,6,A ;E = 1
		call delay1
		bcf PORTC,6,A ;E = 0
		return

;----------------lcd data subroutine for keypad------------------------

WriteD1	bsf PORTC,4,A ;RS = 1
		bcf PORTC,5,A ;RW = 0
		bsf PORTC,6,A ;E = 1
		call delay1
		bcf PORTC,6,A ;E = 0
		return

;----------------LCD configuration for keypad----------------------------

confLC1	clrf TRISC,A 	;makinf trisc as output
		clrf TRISB,A	;making trisb as output
		movlw 0x38		;MATRIX
		movwf PORTB,A
		call WriteC1
		movlw 0x0C		;display on cursor on
		movwf PORTB,A
		call WriteC1
		movlw 0x01		; clear display
		movwf PORTB,A
		call WriteC1

;-------------------lcd command subroutine for button------------

WriteCm	bcf PORTC,4,A ;RS = 0
		bcf PORTC,5,A ;RW = 0
		bsf PORTC,6,A ;E = 1
		call delay
		bcf PORTC,6,A ;E = 0
		return

;----------------lcd data subroutine for button------------------------

WriteDt	bsf PORTC,4,A ;RS = 1
		bcf PORTC,5,A ;RW = 0
		bsf PORTC,6,A ;E = 1
		call delay
		bcf PORTC,6,A ;E = 0
		return

;----------------LCD configuration for button----------------------------

confLCD	clrf TRISC,A 	;makinf trisc as output
		clrf TRISB,A	;making trisb as output
		movlw 0x38		;MATRIX 3 x 7 Matrix
		movwf PORTB,A
		call WriteCm
		movlw 0x0C		;display on cursor oFF
		movwf PORTB,A
		call WriteCm
		movlw 0x01		; clear display
		movwf PORTB,A
		call WriteCm

		return

;----------------Subroutine First Row--------------

StRow	movlw 0x80  ; first row
		movwf PORTB,A
		call WriteCm
		return

;------------------Subroutine Second Row keypad---------

NdRow	movlw 0xC0  ; Second row
		movwf PORTB,A
		call WriteC1
		return

;------------------Subroutine for Space keypad------------------

spacin1	movlw d'32'
		movwf PORTB,A
		call WriteD1
		return

;------------------Subroutine for Space button------------------

spacing	movlw d'32'
		movwf PORTB,A
		call WriteDt
		return

;------------------Subroutine My name---------------

myname	call spacing
		call spacing
		call spacing

		movlw d'68' ; display D
		movwf PORTB,A
		call WriteDt

		movlw d'89' ; display y
		movwf PORTB,A
		call WriteDt

		movlw d'65' ; display A
		movwf PORTB,A
		call WriteDt

		movlw d'78' ; display N
		movwf PORTB,A
		call WriteDt

		movlw d'65' ; display A
		movwf PORTB,A
		call WriteDt

		movlw d'84' ; display T
		movwf PORTB,A
		call WriteDt

		movlw d'65' ; display A
		movwf PORTB,A
		call WriteDt
		
		movlw d'83' ; display S
		movwf PORTB,A
		call WriteDt

		movlw d'89' ; display Y
		movwf PORTB,A
		call WriteDt

		movlw d'65' ; display A
		movwf PORTB,A
		call WriteDt

		movlw 0x01		;CLEAR DISPLAY
		movwf PORTB,A
		call WriteCm

		call spacing
		call spacing
		call spacing

		return

;---------------Subroutine My Id--------------------

MyID	call spacing
		call spacing
		call spacing
		call spacing

		movlw d'68' ; display D
		movwf PORTB,A
		call WriteDt

		movlw d'69' ; display E
		movwf PORTB,A
		call WriteDt

		movlw d'57' ; display 9
		movwf PORTB,A
		call WriteDt

		movlw d'55' ; display 7
		movwf PORTB,A
		call WriteDt

		movlw d'51' ; display 3
		movwf PORTB,A
		call WriteDt

		movlw d'51' ; display 3
		movwf PORTB,A
		call WriteDt

		movlw d'57' ; display 9
		movwf PORTB,A
		call WriteDt

		call spacing
		call spacing
		call spacing
		call spacing

		return

;------------------pushbutton-------------

button	setf TRISC,A ;Making TRISC as input
		call StRow
		
check	call confLCD
		btfss PORTC,0,A
		bra check1
		call myname

check1	call confLCD
		btfss PORTC,1,A
		bra check2
		call MyID

check2	return

;---------------------Making Pin 0,1,2 as input-------------

InKey	bsf TRISD,0,A
		bsf TRISD,1,A
		bsf TRISD,2,A
		bcf TRISD,3,A
		bcf TRISD,4,A
		bcf TRISD,5,A
		bcf TRISD,6,A
		return

;--------------------------Spacing for number--------------------

NeatIt	call spacin1
		call spacin1
		call spacin1
		call spacin1
		call spacin1
		call spacin1
		call spacin1
		return

;--------------------------Numbering 0-9,# and *--------------

num0	call NeatIt
		movlw d'48' ;display 0
		movwf PORTB,A 
		call WriteD1
		call NeatIt
		return

num1	call NeatIt
		movlw d'49' ; display 1
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num2	call NeatIt
		movlw d'50' ; display 2
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num3	call NeatIt
		movlw d'51' ; display 3
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num4	call NeatIt
		movlw d'52' ; display 4
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num5	call NeatIt
		movlw d'53' ; display 5
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num6	call NeatIt
		movlw d'54' ; display 6
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num7	call NeatIt
		movlw d'55' ; display 7
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num8	call NeatIt
		movlw d'56' ; display 8
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

num9	call NeatIt
		movlw d'57' ; display 9
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

numtag	call NeatIt
		movlw d'35' ; display #
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return

numstar	call NeatIt
		movlw d'42' ; display *
		movwf PORTB,A
		call WriteD1
		call NeatIt
		return	


;--------------------------------KEYPAD-----------------------

keypad	call InKey
		call confLCD
		call NdRow

		bsf PORTD,6,A	
		btfsc PORTD,1,A 
		call num0		; display 0

		bcf PORTD,6,A
		bsf PORTD,3,A
		btfsc PORTD,2,A 
		call num1		; display 1

		btfsc PORTD,1,A 
		call num2		; display 2

		btfsc PORTD,0,A 
		call num3		; display 3
	
		bcf PORTD,3,A
		bsf PORTD,4,A
		btfsc PORTD,2,A 
		call num4

		btfsc PORTD,1,A 
		call num5

		btfsc PORTD,0,A 
		call num6

		bcf PORTD,4,A
		bsf PORTD,5,A	
		btfsc PORTD,2,A 
		call num7

		btfsc PORTD,1,A 
		call num8

		btfsc PORTD,0,A 
		call num9

		bcf PORTD,5,A
		bsf PORTD,6,A	;send #
		btfsc PORTD,0,A 
		call numtag

		btfsc PORTD,2,A 
		call numstar

		return

;--------------------Configuring TRISC for main program---------

free	bsf TRISC,0,A ; pin 0 of TRIS input
		bsf TRISC,1,A ; pin 1 of TRIS input	
		bcf TRISC,2,A ; pin 2 of Tris output
		bcf TRISC,3,A ; pin 3 of Tris output
		bcf TRISC,4,A ; pin 4 of Tris output
		bcf TRISC,5,A ; pin 5 of Tris output
		bcf TRISC,6,A ; pin 6 of Tris output
		return

;---------------------START THE PROGRAM HERE-------------------

start	clrf TRISB,A
		call free
		call confLCD			
exam	call keypad
		call button
		bra exam
		end