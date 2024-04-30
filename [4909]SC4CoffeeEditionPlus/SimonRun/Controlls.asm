lorom

;org $80FFDC 					;Can't overwrite header?

;	db $da,$fc,$25,$03		;Konami brand?


;;;;;;;;;;;;;;;;;;;;
;Don't Move TabInto;
;;;;;;;;;;;;;;;;;;;;;

;org $00FF6A		;FreeSpace Potion
;org $9FF3C5		;Free Space Last Bank



;;;;;;;;;;;;;;;;;;
;SimonRun TabIntoCode;
;;;;;;;;;;;;;;;;;;;

;ORG	 $00810E		;Make ButtonDefault R > X	
;	db $40

;ReplaceJSL after moving routines
org $00a2cd
	JSL DontMovePatch


;Walk
	;WalkSpeedRight Constant
		org $00a664		
		LDA #$0001
		
	;WalkSpeedRightSub Constant
		org $00a65e		
		;LDA #$4000
		JSL SpeedGainRight
		NOP
		NOP

	;WalkSpeedLeft Constant
		org $00a67d		
		LDA #$fffe
		
	;WalkSpeedLeftSub Constant
		org $00a677		
		;LDA #$c000
		JSL SpeedGainLeft
		NOP
		NOP



;Stair
	;StairSpeedSubRight Constant
		org $00a8c1		
		;LDA #$c000
		JSL SpeedGainStairsRight
		NOP
		NOP
	;StairSpeedRight Constant
		org $00a8c7		
		LDA #$0000
	;StairSpeedSubLeft Constant
		org $00a89f		
		;LDA #$4000
		LDA #$ffff					;Shifted ConstantStairSpeed before don't move so it works!
		STA $055A
	;StairSpeedLeft Constant
		org $00a8a5		
		JSL SpeedGainStairsLeft
		NOP
		NOP


;Jump
	;JumpSpeed Right
		org $00a90f		
		LDA #$0001
	
	;JumpSpeedSub Right
		org $00a915		
		;LDA #$4000
		JSL JumpSpeedGainRight
		NOP
		NOP
		
	;Max Jump speed Right??
		org $00a90a		
		SBC #$0001
	

	;JumpSpeed Left
		org $00a940		
		LDA #$fffe
	
	;JumpSpeedSub Left
		org $00a946		
		;LDA #$c000
		JSL JumpSpeedGainLeft
		NOP
		NOP
		
	;Max Jump speed Left??
		org $00a93b		
		SBC #$fffe


	;Jump Hight/Strength
		org $00a39e		
		;LDA #$fffb
		JSL JumpGain
		NOP
		NOP


;SubWeapons
	
	;Cross
		;RightThrow
		org $00bc68
		JSL PowerCrossThrowRight ;STA $1a,x Needed for JSL
			;Left
			org $00bcdc
			LDA #$fffe
			
			
			;LeftSub
			org $00bcd7
			LDA #$0000
			
			
			;Right
			org $019241
			db $02,$00
			
			
			;RightSub
			org $01923d
			db $00,$00
			
			
		;LeftThrow	
			;Left
			org $019243
			db $fe,$ff
		
		
			;LeftSub
			org $01923f
			db $00,$00
		
		
			;Right
			org $00bcf6
			LDA #$0002
	
			;RightSub
			org $00bcf1
			LDA #$0000
	;Axe
		;AxeSound
		;org $00bab7  
		;AxeSpeed
		org $00baf6
		;LDA #$fff8
		JSL PowerAxeThrow 
		NOP 				;Shift because of JSL
		;AxeSpeedSub
		org $00bafb
		LDA #$0000
		
		
	;Gravity?? 00=instandFall +HollyW
		org $00bb2a
		SBC #$0008
		
		
		
	;HolyWater
	
		;HolyWSpeed
		org $00bba6
		;LDA #$fffc
		JSL PowerHolyThrow  ;sta $1e,x
		NOP 				;Shift because of JSL
		
		;HolyWSpeedSub
		org $00bbab
		LDA #$0000

	
	;Dagger
		;DisableSpeedUsed
		org $00ba8f
		;db $ea,$ea,$ea,$ea,$ea
		
		;DaggerSpeedRight
		org $0191fd
		db $06,$00
		
		;DaggerSpeedLeft
		org $0191ff
		db $fa,$ff
		

;;;;;;;;;;;;;;;;;;;;	
;Don't Move Routine;
;;;;;;;;;;;;;;;;;;;;;

;org $00fed6
org $86FD74

DontMovePatch:
	JSR DontMoveOnStairs
	JSL $00a694			;ReplacedJSL at $00a2cd
	RTL

DontMoveOnStairs:
	LDA $20				;check if L is pressed
	BIT #$0020
	BEQ $09
	STZ.W $055a
	STZ.W $0558
	STZ.W $0562
	RTS


;;;;;;;;;;;;;;;;;;
;SimonRun Routine;
;;;;;;;;;;;;;;;;;;;

CheckButtonR:	
	LDA $20		;check if R is pressed go fast if yes
	BIT #$0010					
	RTS	

CheckButtonA:
	LDA $20		;check if A is pressed go fast if yes
	BIT #$0080					
	RTS	
	
SpeedGainRight:
	JSR CheckButtonA
	BNE $07
	LDA #$4000
	STA.W $0558
	RTL
	INC $0562		;increase Speed Animation ;KeyFrames f-16 27-2f 
	LDA $0558		;increase Speed Gaining Speed is broken. It would need to reset speed on inkstand turnarounds.
	;CMP #$c000
	;BEQ $06
	;ADC #$1000
	;STA.W $0558
	LDA #$c000
	STA.W $0558
	RTL
SpeedGainLeft:
	JSR CheckButtonA
	BNE $07
	LDA #$c000
	STA.W $0558
	RTL
	INC $0562		;increase Speed Animation
	;LDA $0558		;increase Speed Instand turnarounds need speed reset.. also feels bad. Probably would need more physics added to it.
	;CMP #$4000
	;BEQ $06
	;SBC #$1000
	;STA.W $0558
	LDA #$4000
	STA.W $0558
	RTL


SpeedGainStairsRight:
	JSR CheckButtonA
	BNE $0a
	LDA #$c000
	STA.W $0558
	JSR DontMoveOnStairs
	RTL
	INC $0562		;increase Speed Animation ;KeyFrames f-16 27-2f 
	LDA #$f000
	STA.W $0558
	JSR DontMoveOnStairs
	RTL
SpeedGainStairsLeft:
	JSR CheckButtonA
	BNE $0a
	LDA #$4000
	STA.W $0558
	JSR DontMoveOnStairs
	RTL
	INC $0562		;increase Speed Animation
	LDA #$1000
	STA.W $0558
	JSR DontMoveOnStairs
	RTL

JumpGain:
	JSR CheckButtonA
	BEQ $07		;Branch to SlowSpeed
	LDA #$fffa
	STA.W $055E
	RTL
	LDA #$fffb
	STA.W $055E
	RTL

JumpSpeedGainRight:
	JSR CheckButtonA
	BEQ $07		;Branch to SlowSpeed
	LDA #$a000
	STA.W $0558
	RTL
	LDA #$4000
	STA.W $0558
	RTL
JumpSpeedGainLeft:
	JSR CheckButtonA
	BEQ $07		;Branch to SlowSpeed
	LDA #$6000
	STA.W $0558
	RTL
	LDA #$c000
	STA.W $0558
	RTL
	
	
	
PowerCrossThrowRight:
	LDA $0544		;Checking what direction you are facing
	CMP #$4000
	BEQ $13
	JSR CheckButtonA
	BEQ $06		;Branch to SlowSpeed
	LDA #$0003
	STA $1a,x
	RTL
	LDA #$0002
	STA $1a,x
	RTL
PowerCrossThrowLeft:
	JSR CheckButtonA
	BEQ $06		;Branch to SlowSpeed
	LDA #$fffd
	STA $1a,x
	RTL
	LDA #$fffe
	STA $1a,x
	RTL
	
PowerHolyThrow:
	JSR CheckButtonA
	BEQ $06		;Branch to SlowSpeed
	LDA #$fffa
	STA $1e,x
	RTL
	LDA #$fffc
	STA $1e,x
	RTL
	
PowerAxeThrow:
	JSR CheckButtonA
	BEQ $06		;Branch to SlowSpeed
	LDA #$fff6
	STA $1e,x
	RTL
	LDA #$fffa
	STA $1e,x
	RTL
	

