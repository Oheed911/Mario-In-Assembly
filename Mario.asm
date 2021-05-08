.model small 
.stack 100h
.data

;Variables for egg of Monster	
	anda_xcor dw 0
	anda_ycor dw 80
	anda_bool dw 0

	anda_xcor2 dw 0
	anda_ycor2 dw 80
	anda_bool2 dw 0
	
;Monster Variables	
	monster_xcor dw 20
    monster_ycor dw 80
    monster_width dw 25
    monster_height dw 17
    monster_count dw 2
    green db 2d
    yellow db 14d
    white db 15d

;LEVEL Variable for Levels    
	level dw 1

	; GENERAL COORDINATES Used In Function
	xcor dw 0
	ycor dw 0
	widt dw 0
	height dw 0
	co db 0
	; COORDINATES FOR MARIO
	; FACE
	face_color db 9
	face_xcor dw 30
	face_ycor dw 435
	face_height dw 15 
	face_width dw 15
	; NECK
	neck_color db 7
	neck_xcor dw 35
	neck_ycor dw 440
	neck_height dw 5
	neck_width dw 5
	; BODY
	body_color db 5
	body_xcor dw 25
	body_ycor dw 465
	body_height dw 25
	body_width dw 25
	; RIGHT LEG
	right_leg_color db 3
	right_leg_xcor dw 40
	right_leg_ycor dw 480
	right_leg_height dw 15
	right_leg_width dw 5
	; LEFT LEG
	left_leg_color db 3
	left_leg_xcor dw 30
	left_leg_ycor dw 480
	left_leg_height dw 15
	left_leg_width dw 5
	; RIGHT ARM
	right_arm_color db 14
	right_arm_xcor dw 50
	right_arm_ycor dw 440
	dummy2 dw 455
	; LEFT ARM
	left_arm_color db 14
	left_arm_xcor dw 25
	left_arm_ycor dw 440
	dummy1 dw 455
	counting dw 6
	monster_booling dw 0
	alien_booling dw 0



	;Coordinates for Castle
	Castle_xcor dw 0
	Castle_ycor dw 0 ; from uptil to this variable
	check_x dw 10	
	checkD db 0
	uptil_y dw 0 ;start of y axis
	

	;Variables for alien
	start_x_cor dw 190
	start_y_cor dw 462
	start_height dw 1
	start_widt dw 30
	alien_count dw 10
	alien_count2 dw 7

	;StartMenu Variables
	select_xcor dw 0
	select_ycor dw 0
	select_widt dw 0
	select_height dw 0
	check1 db 0
	co_L db 0
	num db 0
	x db 0
	y db 0
	alpha db 0
	endG db 0
	menu_bool dw 0

	black db 0
	brown db 6h
	grey db 7h
	;Variable that count the number of the lives
	count_lives dw 3

	;Collison bool
	aliencolission_bool dw 0
	monstercolission_bool dw 0

	;Score Varibales
	score dw 0
	score_bool1 dw 0
	score_bool2 dw 0
	score_bool3 dw 0

	store db 30 dup('$')

.code
start:
	mov ax,@data
	mov ds,ax

	

;Selecting the screen
	mov ah,0
	mov al,12h
	int 10h

	;Printing Super Mario
	call AlphaPrint
	mov co_L,14

	call DrawSelect
	call DrawSuper
	call startmenu

	cmp endG,1
	je exit_game

	;Name of the user

	;INPUT User NAME
	call EnterUserName
	
	; Drawing the Background of the super mario
	mov al,11
    mov check_x,640
    mov uptil_y,480
    mov Castle_ycor,0
    mov Castle_xcor,0
   	call Walls_Nodes


ReturnedFromMovement:

	;If level is one
	.if level==1
			call DrawObjects
			call DrawCoins
			call DrawMario
			;Movement code
			call Printlives
			call PrintScores
			call Movement_code
			jmp ReturnedFromMovement	

	.elseif level==2
		restartLevel2:
		mov ah,0
		mov al,12h
		int 10h

		mov score_bool1, 0
		mov score_bool2, 0
		mov score_bool3, 0

		mov al,11

    	mov check_x,640
    	mov uptil_y,480

    	mov Castle_ycor,0
    	mov Castle_xcor,0
   		call Walls_Nodes
   		call Printlives
   		call PrintScores
		call setMarioCordinates
		call DrawObjects
		call DrawCoins
		call DrawMario
		call Draw_Alien
		;Movement code
		call Movement_code
		.if aliencolission_bool==1 && count_lives!=0
				mov aliencolission_bool,0
				jmp restartLevel2
			.elseif count_lives==0 
					call LostPrompt
					jmp exit_game
		.else
		jmp ReturnedFromMovement
		.endif	


	.elseif level==3
	restartLevel3:	
		mov ah,0
		mov al,12h
		int 10h

		mov score_bool1, 0
		mov score_bool2, 0
		mov score_bool3, 0

		mov al,11

    	mov check_x,640
    	mov uptil_y,480

    	mov Castle_ycor,0
    	mov Castle_xcor,0
   		call Walls_Nodes

   		call Printlives
   		call PrintScores
		call setMarioCordinates
		call DrawObjects
		call DrawCoins
		call DrawMario
		;Now drawing the castle

		mov check_x,10
    	mov uptil_y,0
    	mov Castle_ycor,0
    	mov Castle_xcor,0
    	call DrawCastle


		call Draw_Alien
		call DrawMonster
		;Movement code
		call Movement_code

			.if aliencolission_bool==1  && count_lives!=0
					mov aliencolission_bool,0
					jmp restartLevel3
			.elseif monstercolission_bool==1  && count_lives!=0
					mov monstercolission_bool,0
					jmp restartLevel3
			.elseif count_lives==0
					call LostPrompt
					jmp exit_game	
			.endif
	.endif

;Exiting game 
exit_game:
	mov ah,4ch
	int 21h






;User Name Input Proc
EnterUserName proc
	mov ah,0
	mov al,12h
	int 10h
	
	mov x, 30
	mov y, 10
	mov alpha, 69
	call DrawCharacter

	inc x
	mov alpha, 110
	call DrawCharacter

	inc x
	mov alpha, 116
	call DrawCharacter

	inc x
	mov alpha, 101
	call DrawCharacter
	
	inc x
	mov alpha, 114
	call DrawCharacter

	inc x

	inc x
	mov alpha, 121
	call DrawCharacter
	
	inc x
	mov alpha, 111
	call DrawCharacter

	inc x
	mov alpha, 117
	call DrawCharacter
	
	inc x
	mov alpha, 114
	call DrawCharacter

	inc x

	inc x
	mov alpha, 110
	call DrawCharacter
	
	inc x
	mov alpha, 97
	call DrawCharacter

	inc x
	mov alpha, 109
	call DrawCharacter
	
	inc x
	mov alpha, 101
	call DrawCharacter

	inc x
	mov alpha, 58
	call DrawCharacter

	inc x
	mov alpha, 32
	call DrawCharacter
	
	inc x
	mov alpha, 32
	call DrawCharacter

	inc x
	
	mov si, 0
	NameInput:
		mov ah, 01h
		int 21h
		mov store[si], al
		cmp al, 13
		je ExitNameInput
		inc si
		jmp NameInput
ExitNameInput:
ret
EnterUserName endp


;PRint Number of lives 
Printlives proc


mov x,1
mov y,1
mov alpha,76
call Drawcharacter

inc x
mov alpha,73
call Drawcharacter
inc x
mov alpha,86
call Drawcharacter
inc x
mov alpha,69
call Drawcharacter
inc x
mov alpha,83
call Drawcharacter

inc x
mov alpha,58
call Drawcharacter
inc x
mov alpha,32
call Drawcharacter

inc x
mov dh,0
mov dx,count_lives
add dl,48
mov alpha,dl
call Drawcharacter


ret
Printlives endp


;Printing scores 
PrintScores proc

mov x,150
mov y,1
mov alpha,83
call Drawcharacter

inc x
mov alpha,67
call Drawcharacter

inc x
mov alpha,79
call Drawcharacter
inc x
mov alpha,82
call Drawcharacter

inc x
mov alpha,69
call Drawcharacter

inc x
mov alpha,58
call Drawcharacter
inc x
mov alpha,32
call Drawcharacter

inc x
mov dh,0
mov dx,score
add dl,48
mov alpha,dl
call Drawcharacter
ret 
PrintScores endp

;Drawing Coins

DrawCoins proc
		mov co,14
		
		mov xcor,145	
		mov ycor,435	
		mov height,20
		mov widt, 10
		call DrawRectangle

		mov xcor,295	
		mov ycor,415
		mov height,20
		mov widt, 10
		call DrawRectangle	

		.IF level == 1 || level == 2
			mov xcor,445	
			mov ycor,400
			mov height,20
			mov widt, 10
			call DrawRectangle
		.ENDIF

	ret
DrawCoins endp

;Removing Coins
removeCoin1 proc
		mov co, 11
		mov xcor,145	
		mov ycor,435	
		mov height,20
		mov widt, 10
		call DrawRectangle

	ret
removeCoin1 endp

removeCoin2 proc
		mov co, 11
		mov xcor,295	
		mov ycor,415
		mov height,20
		mov widt, 10
		call DrawRectangle

	ret
removeCoin2 endp

removeCoin3 proc
		mov co, 11
		mov xcor,445	
		mov ycor,400
		mov height,20
		mov widt, 10
		call DrawRectangle

	ret
removeCoin3 endp


;Setting the coordinates of the mario
setMarioCordinates proc
; FACE
	mov face_color,9
	mov face_xcor,30
	mov face_ycor,435
	mov face_height, 15
	mov face_width,15
	; NECK
	mov neck_color,7
	mov neck_xcor , 35
	mov neck_ycor , 440
	mov neck_height , 5
	mov neck_width , 5
	; BODY
    mov	body_color,5
    mov	body_xcor , 25
    mov	body_ycor , 465
    mov	body_height , 25
    mov	body_width , 25
	; RIGHT LEG
	mov	right_leg_color,3
	mov right_leg_xcor , 40
	mov right_leg_ycor , 480
	mov right_leg_height , 15
	mov	right_leg_width , 5
	; LEFT LEG
	mov left_leg_color , 3
	mov left_leg_xcor , 30
	mov left_leg_ycor , 480
	mov left_leg_height , 15
	mov left_leg_width , 5
	; RIGHT ARM
	mov right_arm_color , 14
	mov right_arm_xcor , 50
	mov right_arm_ycor , 440
	mov dummy2 , 455
	; LEFT ARM
	mov left_arm_color,14
	mov left_arm_xcor , 25
	mov left_arm_ycor , 440
	mov dummy1 , 455

ret
setMarioCordinates endp


;Start menu Drawing
startmenu proc

	mov ah,0Ch
	mov al,0
	int 21h
	In_Key:
		
		mov ah,0
		int 16h
		cmp ah,1ch
		je Enter_key 

		cmp ah, 48h
		je up_

		cmp ah, 50h
		je down_

		

		jmp In_Key	


		Enter_Key:
			.IF menu_bool == 0
				jmp StartGame
			.ELSE
				jmp EndGame
			.ENDIF
		up_:
			
			mov co_L,0
			mov select_ycor,80
			call DrawSelect
			mov co_L,14
			mov select_ycor, 0
			call DrawSelect
			mov ah,0ch
			mov al,0
			int 21h
			mov menu_bool,0
			jmp In_Key


		down_:
			mov co_L,0
			mov select_ycor,0
			call DrawSelect
			mov co_L,14
			mov select_ycor, 80
			call DrawSelect
			mov ah,0ch
			mov al,0
			int 21h
			mov menu_bool,1
			jmp In_key

	
	StartGame:
		mov endG,0
		jmp ExitGame
	EndGame:
	mov endG,1

	ExitGame:
	mov ah,0
	mov al,12h
	int 10h
ret
startmenu endp

;Right motion procedure

Right_Motion proc

		call DrawMario2
		add face_xcor,5
		add neck_xcor,5	
		add body_xcor,5
		add right_arm_xcor,5
		add left_arm_xcor,5
		add right_leg_xcor,5
		add left_leg_xcor,5
		call DrawMario


	ret
Right_Motion endp

;Left Motion PRocedure
Left_Motion proc

		call DrawMario2
		sub face_xcor,5
		sub neck_xcor,5	
		sub body_xcor,5
		sub right_arm_xcor,5
		sub left_arm_xcor,5
		sub right_leg_xcor,5
		sub left_leg_xcor,5
		call DrawMario

ret
Left_Motion endp
		
;Movement of the mario code
Movement_code proc

;Label for the input key
Input_Key:

			;if level is 3 then it will draw the Monster
			.IF level==3
	
			        .IF monster_booling == 0
			            .IF monster_xcor != 550
				            mov white,11d
				            mov yellow,11d
				            mov green,11d
				            call delay
				            call DrawMonster
				            add monster_xcor,10
				            mov monster_ycor,80
				            mov white,15d
				            mov yellow,14d
				            mov green,2d

				            call anda
				            call anda2


				            call DrawMonster
			        	.ELSEIF monster_xcor == 550
			        		mov monster_booling,1
			        	.ENDIF

			        .ELSEIF monster_booling == 1
			        	.IF monster_xcor != 20
				            mov white,11d
				            mov yellow,11d
				            mov green,11d
				            call delay
				            call DrawMonster
				            sub monster_xcor,10
				            mov monster_ycor,80
				            mov white,15d
				            mov yellow,14d
				            mov green,2d

				            call anda
				            call anda2

				            call DrawMonster
				        .ELSEIF monster_xcor == 20
				        	mov monster_booling,0
				        .ENDIF
				    .ENDIF
			.ENDIF

	.IF score_bool1 == 0
		.IF body_xcor >= 115 && body_xcor <= 160  
			.IF body_ycor >= 405 && body_ycor <= 435
				call removeCoin1
				mov score_bool1, 1
				add score, 1
				call PrintScores
				cmp score_bool1, 1
				je didThat1
			.ENDIF
		.ENDIF  
	.ENDIF

	didThat1:

	.IF score_bool2 == 0
		.IF body_xcor >= 270 && body_xcor <= 310 
			.IF body_ycor >= 390 && body_ycor <= 415
				call removeCoin2
				mov score_bool2, 1
				add score, 1
				call PrintScores
				cmp score_bool2, 1
				je didThat2
			.ENDIF
		.ENDIF  
	.ENDIF

	didThat2:

	.IF level == 1 || level == 2
		.IF score_bool3 == 0
			.IF body_xcor >=415 && body_xcor <= 460 
				.IF body_ycor >= 370 && body_ycor <= 420
					call removeCoin3
					mov score_bool3, 1
					add score, 1
				
					call PrintScores
					cmp score_bool3, 1
					je didThat3
				.ENDIF
			.ENDIF  
		.ENDIF
	.ENDIF

	didThat3:		


		.IF level == 2 || level == 3

				.IF alien_booling == 0
					.IF start_x_cor != 260
						mov brown,11d
						mov grey,11d
						mov black,11d
						call delay
						call Draw_Alien
						add start_x_cor,5
						mov start_y_cor,462
						mov black,0
						mov brown,6h
						mov grey,7h
						call Draw_Alien
					.ELSEIF start_x_cor == 260
						mov alien_booling,1
					.ENDIF
				.ELSEIF alien_booling == 1
					.IF start_x_cor != 190
						mov brown,11d
						mov grey,11d
						mov black,11d
						call delay
						call Draw_Alien
						sub start_x_cor,5
						mov start_y_cor,462
						mov black,0
						mov brown,6h
						mov grey,7h
						call Draw_Alien
					.ELSEIF start_x_cor == 190
						mov alien_booling,0
					.ENDIF
				.ENDIF
		.ENDIF

		.IF level == 2 || level == 3
			call AlienCollision
			.IF aliencolission_bool==1
				jmp Exit_movement
			.Endif	

			.IF level==3
				call MonsterEggCollision 
				.if monstercolission_bool==1
					jmp Exit_Movement
				.endif	
			.endif
		.ENDIF
		;Monster Collision
	

				
		


		.IF right_arm_xcor == 600 && level == 1 
			inc level
			jmp Exit_Movement
		.elseIF right_arm_xcor == 600 && level == 2
			inc level
			jmp Exit_Movement	
		.ELSEIF right_Arm_xcor == 450 && level == 3
			mov level,0
			call YouWon
			jmp Exit_Movement
		.ENDIF
		
		mov ah,01
		int 16h
		cmp ah,48h
		je up_cond

		cmp ah,4Dh
		je right_cond

		cmp ah,4Bh
		je left_cond


		jmp no_cond
		up_cond:
			.IF left_leg_ycor == 480
				jmp Up_Movement
			
			.ELSEIF left_leg_ycor == 450
				jmp Up_Movement
            .ELSEIF left_leg_ycor == 430
                jmp Up_Movement
            .ELSEIF left_leg_ycor == 430
                jmp Up_Movement
			.ELSE
				mov ah,0Ch
				mov al,0
				int 21h
				jmp no_cond
			.ENDIF



		left_cond:
			jmp Left_Movement




		right_cond:
			jmp Right_Movement


			

		no_cond:
			.IF right_arm_xcor >= 110 && left_arm_xcor <= 180
				cmp right_leg_ycor,450
				jb Down_Movement
				jmp Input_Key

			.ELSEIF right_arm_xcor >= 260 && left_arm_xcor <= 340
				cmp right_leg_ycor,430
				jb Down_Movement
				jmp Input_Key
			
			.ELSEIF right_arm_xcor >= 410 && left_arm_xcor <= 480
				.if level==1 || level==2
					cmp right_leg_ycor,430
					jb Down_Movement
					jmp Input_Key
				.elseif level==3
					cmp left_leg_ycor,480
					jb Down_Movement
					jmp Input_Key
				.endif	
						
			.ELSE
				
				cmp left_leg_ycor,480
				jb Down_Movement
			.ENDIF
			jmp Input_Key



	Up_Movement:
	
		call DrawMario2
		sub dummy1,150
		sub dummy2,150
		sub face_ycor,150
		sub neck_ycor,150
		sub body_ycor,150
		sub right_arm_ycor,150
		sub left_arm_ycor,150
		sub right_leg_ycor,150
		sub left_leg_ycor,150
		mov ah,0Ch
		mov al,0
		int 21h
		jmp Input_Key


	Down_Movement:
		cmp left_leg_ycor,480
		jb Down_Movement1
		jmp again

		Down_Movement1:
			call DrawMario2
			add dummy1,2
			add dummy2,2
			add face_ycor,2
			add neck_ycor,2
			add body_ycor,2
			add right_arm_ycor,2
			add left_arm_ycor,2
			add right_leg_ycor,2
			add left_leg_ycor,2
			call DrawMario

		again:
			jmp Input_Key	

	
	

		
	Right_Movement:


		.IF right_leg_ycor != 480
			.IF right_arm_xcor >= 110 && left_arm_xcor <= 180
				.IF right_leg_ycor > 450
					jmp no_cond
				.ELSE
					call Right_Motion
					jmp end_Right_Movement
				.ENDIF
			.ELSEIF right_arm_xcor >= 260 && left_arm_xcor <= 320
				.IF right_leg_ycor>430
					jmp no_cond
				.ELSE
                    call Right_Motion
					jmp end_Right_Movement
				.ENDIF
			.ELSEIF right_arm_xcor >= 410 && left_arm_xcor <= 480
                .IF right_leg_ycor > 430
                    jmp no_cond
                .ELSE
                    call Right_Motion
                    jmp end_Right_Movement
                .ENDIF
			.ELSE
				call Right_Motion
				jmp end_Right_Movement

			.ENDIF

		.ENDIF




		.IF level == 1 || level == 2
			.IF right_arm_xcor < 110 || right_arm_xcor > 180 && right_arm_xcor < 260 || right_arm_xcor > 330 && right_arm_xcor < 410 || right_arm_xcor >= 480

				call Right_Motion
				jmp end_Right_Movement

			.ENDIF
		.ELSEIF level == 3
			.IF right_arm_xcor < 110 || right_arm_xcor > 180 && right_arm_xcor < 260 || right_arm_xcor > 330
				call Right_Motion
				jmp end_Right_Movement

			.ENDIF
		.ENDIF


		end_Right_Movement:
			mov ah,0Ch
			mov al,0
			int 21h

			jmp Input_Key







	Left_Movement:


		.IF right_leg_ycor != 480
			.IF right_arm_xcor >= 110 && left_arm_xcor <= 185

                .IF left_leg_ycor > 450
				    jmp no_cond
                .ELSE
                    call Left_Motion
				    jmp end_Left_Movement
                .ENDIF
                

			.ELSEIF right_arm_xcor >= 260 && left_arm_xcor <= 340

                .IF left_leg_ycor > 430
                    jmp no_cond
                .ELSE
				    call Left_Motion
				    jmp end_Left_Movement
                .ENDIF

			.ELSEIF right_arm_xcor >= 410 && left_arm_xcor <= 480

                .IF left_leg_ycor > 430
                   jmp no_cond
                .ELSE
				    call Left_Motion
				    jmp end_Left_Movement
                .ENDIF
			.ELSE
				call Left_Motion
				jmp end_Left_Movement

			.ENDIF

		.ENDIF




		.IF level == 1 || level == 2
			.IF left_arm_xcor < 110 || left_arm_xcor > 190 && left_arm_xcor < 260 || left_arm_xcor > 340 && left_arm_xcor < 410 || left_arm_xcor > 480
				call Left_Motion
				jmp end_Left_Movement

			.ENDIF
		.ELSEIF level == 3

			.IF left_arm_xcor < 110 || left_arm_xcor > 190 && left_arm_xcor < 260 || left_arm_xcor > 340
				call Left_Motion
				jmp end_Left_Movement

			.ENDIF
		.ENDIF


		end_Left_Movement:
			mov ah,0Ch
			mov al,0
			int 21h

			jmp Input_Key

Exit_Movement:

ret
Movement_code endp







	
	
	
	DrawRectangle proc

		mov ax,0
		mov bx,0
		mov dx,0
		mov cx,0

        mov cx,xcor
        add cx,widt
        mov dx,ycor
        loop0:
                push cx
                label1:
                    cmp cx,xcor
                    je label2
                    mov ah,0Ch
                    mov al,co
                    int 10h
                    dec cx
                    jmp label1
        label2:
            pop cx
            dec dx
            dec Height
            cmp Height,0
            jne loop0
            ret
            DrawRectangle endp


    Draw_Alien proc 

			mov ax,0
			mov bx,0
			mov cx,0
			mov dx,0
			mov alien_count,10
			mov alien_count2,7


			; DRAWING UPPER BODY
			mov ax,start_x_cor
			mov bx,start_y_cor
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,brown
			mov co,al
			call drawRectangle


			; ITERATION 1
			mov ax,start_x_cor
			add ax,1
			mov bx,start_y_cor
			sub bx,1
			mov cx,start_height
			mov dx,start_widt
			sub dx,2

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 2
			mov ax,start_x_cor
			add ax,2
			mov bx,start_y_cor
			sub bx,2
			mov cx,start_height
			mov dx,start_widt
			sub dx,4

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 3
			mov ax,start_x_cor
			add ax,3
			mov bx,start_y_cor
			sub bx,3
			mov cx,start_height
			mov dx,start_widt
			sub dx,6

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 4
			mov ax,start_x_cor
			add ax,4
			mov bx,start_y_cor
			sub bx,4
			mov cx,start_height
			mov dx,start_widt
			sub dx,8

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 5
			mov ax,start_x_cor
			add ax,5
			mov bx,start_y_cor
			sub bx,5
			mov cx,start_height
			mov dx,start_widt
			sub dx,10

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 6
			mov ax,start_x_cor
			add ax,6
			mov bx,start_y_cor
			sub bx,6
			mov cx,start_height
			mov dx,start_widt
			sub dx,12

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 7
			mov ax,start_x_cor
			add ax,7
			mov bx,start_y_cor
			sub bx,7
			mov cx,start_height
			mov dx,start_widt
			sub dx,14

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 8
			mov ax,start_x_cor
			add ax,8
			mov bx,start_y_cor
			sub bx,8
			mov cx,start_height
			mov dx,start_widt
			sub dx,16

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle

			; ITERATION 9
			mov ax,start_x_cor
			add ax,9
			mov bx,start_y_cor
			sub bx,9
			mov cx,start_height
			mov dx,start_widt
			sub dx,18

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 10
			mov ax,start_x_cor
			add ax,10
			mov bx,start_y_cor
			sub bx,10
			mov cx,start_height
			mov dx,start_widt
			sub dx,20

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle



			; DRAWING LOWER BODY
			; ITERATION 1
			mov ax,start_x_cor
			mov bx,start_y_cor
			add bx,1
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle



			; ITERATION 2
			mov ax,start_x_cor
			mov bx,start_y_cor
			add bx,2
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; ITERATION 3
			mov ax,start_x_cor
			mov bx,start_y_cor
			add bx,3
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle



			; ITERATION 4
			mov ax,start_x_cor
			mov bx,start_y_cor
			add bx,4
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle



			; ITERATION 5
			mov ax,start_x_cor
			mov bx,start_y_cor
			add bx,5
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle



			; ITERATION 6
			mov ax,start_x_cor
			mov bx,start_y_cor
			add bx,6
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle



			; ITERATION 7
			mov ax,start_x_cor
			mov bx,start_y_cor
			add bx,7
			mov cx,start_height
			mov dx,start_widt

			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			call drawRectangle


			; DRAWING EYES
			; LEFT EYE
			mov ax,start_x_cor
			mov bx,start_y_cor
			mov cx,4
			mov dx,5
			add ax,7
			sub bx,2
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,black
			mov co,al
			call DrawRectangle


			; RIGHT EYE
			mov ax,start_x_cor
			mov bx,start_y_cor
			mov cx,4
			mov dx,5
			add ax,17
			sub bx,2
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,black
			mov co,al
			call DrawRectangle

			; DRAWING FEET
			; LEFT FOOT
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,2
			add bx,11
			mov cx,2
			mov dx,5
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle



			; ITERATION 1
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,2
			add bx,13
			mov cx,2
			mov dx,5
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle



			; ITERATION 2
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,2
			add bx,15
			mov cx,2
			mov dx,5
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle


			; ITERATION 3
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,2
			add bx,17
			mov cx,2
			mov dx,5
			add dx,2
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle




			; RIGHT FOOT
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,22
			add bx,11
			mov cx,2
			mov dx,5
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle

			


			; ITERATION 1
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,22
			add bx,13
			mov cx,2
			mov dx,5
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle



			; ITERATION 2
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,22
			add bx,15
			mov cx,2
			mov dx,5
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle




			; ITERATION 3
			mov ax,start_x_cor
			mov bx,start_y_cor
			add ax,20
			add bx,17
			mov cx,2
			mov dx,5
			add dx,2
			mov xcor,ax
			mov ycor,bx
			mov height,cx
			mov widt,dx
			mov ah,0
			mov al,grey
			mov co,al
			call DrawRectangle



			ret
			Draw_Alien endp




	DrawObjects proc
	.IF level == 1 || level ==2
	; Drawflag 
		mov xcor,495
		mov ycor,155
		mov widt,120
		mov height,70
		mov co,15

		call DrawRectangle

		mov xcor,495
		mov ycor,155
		mov widt,120
		mov height,10
		mov co,0

		call DrawRectangle

		mov xcor,495
		mov ycor,135
		mov widt,120
		mov height,10


		call DrawRectangle

		mov xcor,495
		mov ycor,115
		mov widt,120
		mov height,10
		

		call DrawRectangle

		mov xcor,495
		mov ycor,95
		mov widt,120
		mov height,10

		call DrawRectangle

		mov xcor,620
		mov ycor,479
		mov widt,10
		mov height,400
		mov co,08

		call DrawRectangle
	.ENDIF


	;DrawHurdle 1
		; BOTTOM PART
		mov xcor,140	;xcor 140,160
		mov ycor,480	;ycor 460
		mov height,20
		mov widt,20
		mov co,12
		call DrawRectangle


		; TOP PART
		mov xcor,130	;ycor=450
		mov ycor,465	;xcor 130,170 
		mov height,15
		mov widt,40
		mov co,12
		call DrawRectangle


	;DrawHurdle 2

		; BOTTOM PART 
		mov xcor,290	;xcor 290,20
		mov ycor,480	;ycor 250
		mov height,30
		mov widt,20
		mov co,12
		call DrawRectangle


		; TOP PART
		mov xcor,280	;xcor 280,320
		mov ycor,450	;ycor 435
		mov height,15
		mov widt,40
		mov co,12
		call DrawRectangle


	;DrawHurdle 3
	.IF level != 3
		; BOTTOM PART
		mov xcor,440	;xcor 440,460
		mov ycor,480	;ycor 440
		mov height,40
		mov widt,20
		mov co,12
		call DrawRectangle


		; TOP PART
		mov xcor,430	;xcor 430,470
		mov ycor,445	;ycor 430
		mov height,15
		mov widt,40
		mov co,12
		call DrawRectangle
	.ENDIF

	ret
    DrawObjects endp


	DrawMario proc
	;Draw Mario
		
		; Right Arm
		mov ax,right_arm_xcor
		mov bx,right_arm_ycor
		mov dh,0
		mov dl,right_arm_color

		mov xcor,ax
		mov ycor,bx
		mov co,dl
		call DrawRightArm


		; Left Arm
		mov ax,left_arm_xcor
		mov bx,left_arm_ycor
		mov dh,0
		mov dl,left_arm_color
		
		mov xcor,ax
		mov ycor,bx
		mov co,dl
		call DrawLeftArm




		; Left leg
		mov ax,left_leg_xcor
		mov bx,left_leg_ycor
		mov cx,left_leg_height
		mov dx,left_leg_width
		mov xcor, ax
		mov ycor,bx
		mov height,cx
		mov widt,dx

		mov dh,0
		mov dl,left_leg_color
		mov co,dl
		call DrawRectangle

		; right leg
		mov ax,right_leg_xcor
		mov bx,right_leg_ycor
		mov cx,right_leg_height
		mov dx,right_leg_width
		mov xcor, ax
		mov ycor,bx
		mov height,cx
		mov widt,dx

		mov dh,0
		mov dl,right_leg_color
		mov co,dl
		call DrawRectangle

		; Body
		mov ax,body_xcor
		mov bx,body_ycor
		mov cx,body_height
		mov dx,body_width

		mov xcor, ax
		mov ycor,bx
		mov height,cx
		mov widt,dx


		mov dh,0
		mov dl,body_color
		mov co,dl
		call DrawRectangle


		; neck
		mov ax,neck_xcor
		mov bx,neck_ycor
		mov cx,neck_height
		mov dx,neck_width

		mov xcor, ax
		mov ycor,bx
		mov height,cx
		mov widt,dx
		
		mov dh,0
		mov dl,neck_color
		mov co,dl
		call DrawRectangle

		; Face


		mov ax,face_xcor
		mov bx,face_ycor
		mov cx,face_height
		mov dx,face_width
		


		mov xcor, ax
		mov ycor,bx
		mov height,cx
		mov widt,dx

		mov dh,0
		mov dl,face_color
		mov co,dl
		call DrawRectangle


	ret
    DrawMario endp


	DrawMario2 proc
		mov face_color,11
		mov neck_color,11
		mov body_color,11
		mov right_arm_color,11
		mov left_leg_color,11
		mov right_leg_color,11
		mov left_arm_color,11
		call DrawMario
		mov face_color,9
		mov neck_color,7
		mov body_color,5
		mov right_arm_color,14
		mov left_leg_color,3
		mov right_leg_color,3
		mov left_arm_color,14
	ret
    DrawMario2 endp


	DrawRightArm proc uses ax bx cx dx
		mov ax,0
		mov bx,0
		mov cx,0
		mov dx,0
			
	
		mov height,5
		mov cx,xcor
        loop0:
			mov dx,ycor
			add dx,height
            label1:
        		cmp dx,ycor
                je label2
                mov ah,0Ch
                mov al,co
                int 10h
                dec dx
                jmp label1
        	label2:
				inc ycor
				inc cx
				mov ax,dummy2
				cmp ycor,ax
				je end_loop
				jmp loop0


		end_loop:
            ret
            DrawRightArm endp



	DrawLeftArm proc uses ax bx cx dx
		mov ax,0
		mov bx,0
		mov cx,0
		mov dx,0
		

		mov height,5
		mov cx,xcor
        loop0:
			mov dx,ycor
			add dx,height
            label1:
        		cmp dx,ycor
                je label2
                mov ah,0Ch
                mov al,co
                int 10h
                dec dx
                jmp label1
        	label2:
				inc ycor
				dec cx
				mov ax, dummy1
				cmp ycor,ax
				je end_loop
				jmp loop0


		end_loop:
            ret
    DrawLeftArm endp

;proc For Castle and Screen Background
Walls_NODES proc uses ax bx cx dx
    mov cx,Castle_xcor
StartCastle:

    mov dx,uptil_y
    DrawLine:
        dec dx
        mov ah,0ch
        int 10h
    cmp Castle_ycor,dx
    jne Drawline
        add cx,1
        dec check_x
        cmp check_x,0
jne StartCastle

    

ret
Walls_Nodes endp

;Drawing Super mario on start mario screen
DrawSuper proc

	mov co,3
	mov xcor,80	
	mov ycor,40	
	mov height,5
	mov widt,40
	call DrawRectangle

	mov xcor,80	
	mov ycor,60	
	mov height,20
	mov widt,5
	call DrawRectangle

	mov xcor,80	
	mov ycor,60	
	mov height,5
	mov widt,40
	call DrawRectangle

	mov xcor,115	
	mov ycor,80	
	mov height,20
	mov widt,5
	call DrawRectangle

	mov xcor,80	
	mov ycor,80	
	mov height,5
	mov widt,40
	call DrawRectangle


;2
	mov co, 14

	mov xcor,160
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

	mov xcor,135	
	mov ycor,80	
	mov height,5
	mov widt,25
	call DrawRectangle

	mov xcor,135	
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

;3
	mov co, 4	

	mov xcor,180
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

	mov xcor,180	
	mov ycor,40	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,205
	mov ycor,60	
	mov height,20
	mov widt,5
	call DrawRectangle

	mov xcor,180	
	mov ycor,60	
	mov height,5
	mov widt,30
	call DrawRectangle
;4
	mov co, 2

	mov xcor,225
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

	mov xcor,225	
	mov ycor,40	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,225	
	mov ycor,60	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,225	
	mov ycor,80	
	mov height,5
	mov widt,30
	call DrawRectangle
;5
	mov co, 14
	
	mov xcor,275
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle
	
	mov xcor,275	
	mov ycor,40	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,300
	mov ycor,60	
	mov height,20
	mov widt,5
	call DrawRectangle

	mov xcor,275	
	mov ycor,60	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov num ,10
	mov xcor,275
	mov ycor,60
A:
	add xcor,2	
	add ycor,2	
	mov height,5
	mov widt,6
	dec num
	call DrawRectangle
	cmp num, 0
	je B
	jmp A
B:

; MARIO

;6
	mov co, 4

	mov xcor,340
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

	mov num ,10
	mov xcor,340
	mov ycor,40
D:
	add xcor,2	
	add ycor,2	
	mov height,5
	mov widt,6
	dec num
	call DrawRectangle
	cmp num, 0
	je E
	jmp D
E:

	mov num ,10
	mov xcor,360
	mov ycor,60
F:
	add xcor,2	
	sub ycor,2	
	mov height,5
	mov widt,6
	dec num
	call DrawRectangle
	cmp num, 0
	je G
	jmp F
G:

	mov xcor,380
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle
;7
	mov co, 2

	mov xcor,400
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

	mov xcor,400	
	mov ycor,40	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,400	
	mov ycor,60	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,430
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

;8
	mov co, 14
	
	mov xcor,450
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle
	
	mov xcor,450	
	mov ycor,40	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,475
	mov ycor,60	
	mov height,20
	mov widt,5
	call DrawRectangle

	mov xcor,450	
	mov ycor,60	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov num ,10
	mov xcor,450
	mov ycor,60
H:
	add xcor,2	
	add ycor,2	
	mov height,5
	mov widt,6
	dec num
	call DrawRectangle
	cmp num, 0
	je I
	jmp H
I:

;9
	mov co, 3
	mov xcor,510
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

	mov xcor,497	
	mov ycor,40	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,497	
	mov ycor,80	
	mov height,5
	mov widt,30
	call DrawRectangle

;10
	mov co, 2
	mov xcor,545
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle

	mov xcor,545	
	mov ycor,40	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov xcor,545
	mov ycor,80	
	mov height,5
	mov widt,30
	call DrawRectangle

	mov co, 2
	mov xcor,570
	mov ycor,80	
	mov height,45
	mov widt,5
	call DrawRectangle	

ret
DrawSuper endp

DrawSelect proc
	
	
	
	mov bx, 0

	;DrawSelect

	mov select_xcor, 235
	mov bx, select_xcor
	mov xcor, bx	

	add select_ycor, 185
	mov bx, select_ycor
	mov ycor, bx
	
	mov select_height, 5
	mov bx, select_height
	mov height, bx

	mov select_widt, 135
	mov bx, select_widt
	mov widt, bx

	mov bl,co_L
	mov co, bl
	call DrawRectangle

	ret
DrawSelect endp	

AlphaPrint proc

	mov x, 30
	mov y, 10
	mov alpha, 83
	call DrawCharacter

	inc x
	mov alpha, 116
	call DrawCharacter

	inc x
	mov alpha, 97
	call DrawCharacter

	inc x
	mov alpha, 114
	call DrawCharacter
	
	inc x
	mov alpha, 116
	call DrawCharacter

	inc x
	
	inc x
	mov alpha, 97
	call DrawCharacter

	inc x
	
	inc x
	mov alpha, 110
	call DrawCharacter

	inc x
	mov alpha, 101
	call DrawCharacter
	
	inc x
	mov alpha, 119
	call DrawCharacter

	inc x

	inc x
	mov alpha, 103
	call DrawCharacter

	inc x
	mov alpha, 97
	call DrawCharacter

	inc x
	mov alpha, 109
	call DrawCharacter
	
	inc x
	mov alpha, 101
	call DrawCharacter


	mov x, 35
	mov y, 15
	
	mov alpha, 69
	call DrawCharacter

	inc x
	mov alpha, 120
	call DrawCharacter

	inc x
	mov alpha, 105
	call DrawCharacter
	
	inc x
	mov alpha, 116
	call DrawCharacter
	
	ret

AlphaPrint endp
DrawCharacter proc
	mov ah,02
	mov dl,x	;x cor
	mov dh,y	;y cor
	int 10h

	mov ah,09
	mov bh,0
	mov bl,3
	mov al,alpha
	mov cx,1
	int 10h

	ret
	DrawCharacter endp






		


	delay proc


		push ax
		push bx
		push cx
		push dx

		mov cx,250
		mydelay:
		mov bx,250
		mydelay1:
			dec bx
			jnz mydelay1
			loop mydelay
			pop dx
			pop cx
			pop bx
			pop ax

	ret
	delay endp


	DrawMonster proc uses ax bx cx dx


    mov monster_count,2
    ; FACE RECTANGLE
    mov ax,monster_xcor
    mov bx,monster_ycor
    mov cx,monster_width
    mov dx,monster_height

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle

    ; STRIP 1 UPOVE FACE
    mov ax,monster_xcor
    add ax,2
    mov bx,monster_ycor
    sub bx,17
    mov cx,monster_width
    sub cx,5
    mov dx,monster_height
    sub dx,13
    
    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle

        ; STRIP 2 ABOVE FACE
        mov ax,monster_xcor
        add ax,2
        mov bx,monster_ycor
        sub bx,20
        mov cx,monster_width
        sub cx,5
        mov dx,monster_height
        sub dx,13

        mov xcor,ax
        mov ycor,bx
        mov widt,cx
        mov Height,dx
            mov ah,0
            mov al,green
            mov co,al

        call DrawRectangle



        ; STRIP 2 ABOVE FACE
        mov ax,monster_xcor
        add ax,2
        mov bx,monster_ycor
        sub bx,24
        mov cx,monster_width
        sub cx,5
        mov dx,monster_height
        sub dx,13

        mov xcor,ax
        mov ycor,bx
        mov widt,cx
        mov Height,dx

        mov ah,0
        mov al,green
        mov co,al

        call DrawRectangle

    ; DRAWING NOSE & MOUTH
    mov ax,monster_xcor
    sub ax,7
    mov bx,monster_ycor
    sub bx,6
    mov cx,monster_width
    sub cx,18
    mov dx,monster_height
    sub dx,7

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle


    ; DRAWING EYES PART 1
    mov ax,monster_xcor 
    mov bx,monster_ycor
    sub bx,8
    mov cx,monster_width
    sub cx,18
    mov dx,monster_height
    sub dx,14      

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle


    ; DRAWING EYES PART 2
    mov ax,monster_xcor
    add ax,4
    mov bx,monster_ycor
    sub bx,8
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,4      

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle
    
    

    ; DRAWING TEETH
    mov ax,monster_xcor
    sub ax,5
    mov bx,monster_ycor
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,10

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle

    ; DRAWING TEETH 1
    mov ax,monster_xcor
    add ax,2
    mov bx,monster_ycor
    sub bx,2
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle

    ; DRAWING TEETH 2
    mov ax,monster_xcor
    add ax,9       
    mov bx,monster_ycor
    sub bx,2
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle




    ; DRAWING LOWER LONG RECTANGLE
    mov ax,monster_xcor
    add ax,10
    mov bx,monster_ycor
    add bx,10
    mov cx,monster_width
    add cx,20
    mov dx,monster_height
    sub dx,5

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle
    
    ; DRAWING ABOVE LINE 1
    mov ax,monster_xcor
    add ax,25
    mov bx,monster_ycor
    mov cx,monster_width
    add cx,5
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle


    ; DRAWING ABOVE LINE 2
    mov ax,monster_xcor
    add ax,25
    mov bx,monster_ycor
    sub bx,5
    mov cx,monster_width
    add cx,1
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle


    ; DRAWING ABOVE LINE 3
    mov ax,monster_xcor
    add ax,25
    mov bx,monster_ycor
    sub bx,8
    mov cx,monster_width
    sub cx,5
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle


    ; DRAWING VERTICAL LONG RECTANGLE 1
    mov ax,monster_xcor
    add ax,45
    mov bx,monster_ycor
    add bx,50
    mov cx,monster_width
    sub cx,15
    mov dx,monster_height
    add dx,30

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle

    ; DRAWING VERTICAL LONG RECTANGLE 2
    mov ax,monster_xcor
    add ax,55
    mov bx,monster_ycor
    add bx,50
    mov cx,monster_width
    sub cx,20
    mov dx,monster_height
    add dx,25

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle


    ; DRAWING BIG RECTANGLE LEFT OF VERTICAL 1
    mov ax,monster_xcor
    add ax,25
    mov bx,monster_ycor
    add bx,50
    mov cx,monster_width
    add cx,5
    mov dx,monster_height
    add dx,25

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle


    ; DRAWING HORIZONTAL 1
    mov ax,monster_xcor
    add ax,15
    mov bx,monster_ycor
    add bx,15
    mov cx,monster_width
    sub cx,15
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle


    ; DRAWING HORIZONTAL 2
    mov ax,monster_xcor
    add ax,17
    mov bx,monster_ycor
    add bx,20
    mov cx,monster_width
    sub cx,17
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,green
mov co,al
    call DrawRectangle

    ; DRAWING LOWER MOUTH SQUARE 0 TEETH
    mov ax,monster_xcor
    add ax,1
    mov bx,monster_ycor
    add bx,12
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle


    ; DRAWING LOWER MOUTH SQUARE 0
    mov ax,monster_xcor
    add ax,5
    mov bx,monster_ycor
    add bx,14
    mov cx,monster_width
    sub cx,20
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle


    ; DRAWING LOWER MOUTH SQUARE 1
    mov ax,monster_xcor
    add ax,8
    mov bx,monster_ycor
    add bx,12
    mov cx,monster_width
    sub cx,20
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle


    ; DRAWING LOWER MOUTH SQUARE 2
    mov ax,monster_xcor
    add ax,10
    mov bx,monster_ycor
    add bx,10
    mov cx,monster_width
    sub cx,20
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle


    ; DRAWING LOWER MOUTH SQUARE 3
    mov ax,monster_xcor
    add ax,12
    mov bx,monster_ycor
    add bx,7
    mov cx,monster_width
    sub cx,20
    mov dx,monster_height
    sub dx,12

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle


    ; DRAWING LONG ABOVE SQUARES
    mov ax,monster_xcor
    add ax,16
    mov bx,monster_ycor
    add bx,7
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,2

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle


    ; DRAWING NOSE & MOUTH 2
    mov ax,monster_xcor
    mov bx,monster_ycor
    sub bx,5
    mov cx,monster_width
    sub cx,8
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle




    ; DRAWING HAIR PART 1
    mov ax,monster_xcor
    add ax,15
    mov bx,monster_ycor
    sub bx,22
    mov cx,monster_width
    sub cx,18  
    mov dx,monster_height
    sub dx,10
    
    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle


    ; DRAWING HAIR PART 2
    mov ax,monster_xcor
    add ax,17
    mov bx,monster_ycor
    sub bx,28
    mov cx,monster_width
    sub cx,15  
    mov dx,monster_height
    sub dx,12
    
    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,yellow
mov co,al
    call DrawRectangle



    ; DRAWING LONG ABOVE SQUARES
    mov ax,monster_xcor
    add ax,26
    mov bx,monster_ycor
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,5

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle


    ; LEFT TO PREVIOUS
    mov ax,monster_xcor
    add ax,24
    mov bx,monster_ycor
    add bx,2
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle


    ; LEFT TO PREVIOUS
    mov ax,monster_xcor
    add ax,20
    mov bx,monster_ycor
    add bx,4
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
mov al,white
mov co,al
    call DrawRectangle


    ; STARIGHT LINE VERTICAL
    mov ax,monster_xcor
    add ax,20
    mov bx,monster_ycor
    add bx,15
    mov cx,monster_width
    sub cx,23
    mov dx,monster_height
    sub dx,5

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; STARIGHT LINE HORIZONTAL
    mov ax,monster_xcor
    add ax,20
    mov bx,monster_ycor
    add bx,15
    mov cx,monster_width
    sub cx,16
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; STARIGHT LINE VERTICAL
    mov ax,monster_xcor
    add ax,27
    mov bx,monster_ycor
    add bx,25
    mov cx,monster_width
    sub cx,23
    mov dx,monster_height
    sub dx,5

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL
    mov ax,monster_xcor
    add ax,27
    mov bx,monster_ycor
    add bx,25
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL
    mov ax,monster_xcor
    add ax,29
    mov bx,monster_ycor
    add bx,27
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE VERTICAL
    mov ax,monster_xcor
    add ax,33
    mov bx,monster_ycor
    add bx,32
    mov cx,monster_width
    sub cx,23
    mov dx,monster_height
    sub dx,12  

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; STARIGHT LINE HORIZONTAL 1
    mov ax,monster_xcor
    add ax,33
    mov bx,monster_ycor
    add bx,34
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,15

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL 2
    mov ax,monster_xcor
    add ax,36
    mov bx,monster_ycor
    add bx,36
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,15

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL 3
    mov ax,monster_xcor
    add ax,39
    mov bx,monster_ycor
    add bx,38
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,15

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL 4
    mov ax,monster_xcor
    add ax,42
    mov bx,monster_ycor
    add bx,40
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,15

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL 5
    mov ax,monster_xcor
    add ax,45
    mov bx,monster_ycor
    add bx,42
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,15

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL 6
    mov ax,monster_xcor
    add ax,48
    mov bx,monster_ycor
    add bx,44
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,15

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL 7
    mov ax,monster_xcor
    add ax,51
    mov bx,monster_ycor
    add bx,46
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,15

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle

    ; STARIGHT LINE HORIZONTAL 8
    mov ax,monster_xcor
    add ax,54
    mov bx,monster_ycor
    add bx,50
    mov cx,monster_width
    sub cx,15
    mov dx,monster_height
    sub dx,11

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle



    ; SPOT 1
    ; WHITE
    mov ax,monster_xcor
    add ax,42
    mov bx,monster_ycor
    add bx,30
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle



    ; SPOT 1
    ; YELLOW
    mov ax,monster_xcor
    add ax,42
    mov bx,monster_ycor
    add bx,33
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle




    ; SPOT 2
    ; WHITE
    mov ax,monster_xcor
    add ax,55
    mov bx,monster_ycor
    add bx,24
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; WHITE
    mov ax,monster_xcor
    add ax,55
    mov bx,monster_ycor
    add bx,27
    mov cx,monster_width
    sub cx,17
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle



    ; SPOT 2
    ; YELLOW
    mov ax,monster_xcor
    add ax,55
    mov bx,monster_ycor
    add bx,30
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle



    ; SPOT 3
    ; WHITE
    mov ax,monster_xcor
    add ax,35
    mov bx,monster_ycor
    add bx,21
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; YELLOW
    mov ax,monster_xcor
    add ax,35
    mov bx,monster_ycor
    add bx,24
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle



    ; SPOT 4
    ; YELLOW
    mov ax,monster_xcor
    add ax,27
    mov bx,monster_ycor
    add bx,18
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle



    ; WHITE
    mov ax,monster_xcor
    add ax,47
    mov bx,monster_ycor
    add bx,18
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; WHITE
    mov ax,monster_xcor
    add ax,47
    mov bx,monster_ycor
    add bx,21
    mov cx,monster_width
    sub cx,17
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; YELLOW
    mov ax,monster_xcor
    add ax,47
    mov bx,monster_ycor
    add bx,24
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle


    ; SPOT 5
    ; YELLOW
    mov ax,monster_xcor
    add ax,17
    mov bx,monster_ycor
    add bx,11
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle



    ; WHITE
    mov ax,monster_xcor
    add ax,37
    mov bx,monster_ycor
    add bx,11
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; WHITE
    mov ax,monster_xcor
    add ax,37
    mov bx,monster_ycor
    add bx,14
    mov cx,monster_width
    sub cx,17
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; YELLOW
    mov ax,monster_xcor
    add ax,37
    mov bx,monster_ycor
    add bx,14
    mov cx,monster_width
    sub cx,21
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle
    
    

    ; SPOT 6
    ; WHITE
    mov ax,monster_xcor
    add ax,42
    mov bx,monster_ycor
    add bx,2
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle



    ; YELLOW
    mov ax,monster_xcor
    add ax,42
    mov bx,monster_ycor
    add bx,5
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle


    ; SPOT 7
    ; WHITE
    mov ax,monster_xcor
    add ax,35
    mov bx,monster_ycor
    sub bx,4
    mov cx,monster_width
    sub cx,19
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; YELLOW
    mov ax,monster_xcor
    add ax,35
    mov bx,monster_ycor
    sub bx,1
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle




    ; HAND PART 1
    mov ax,monster_xcor
    add ax,12
    mov bx,monster_ycor
    add bx,30
    mov cx,monster_width
    sub cx,12
    mov dx,monster_height
    sub dx,10

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle



    ; HAND PART 2
    mov ax,monster_xcor
    add ax,12
    mov bx,monster_ycor
    add bx,32
    mov cx,monster_width
    sub cx,18
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle


    ; NAIL PART 1
    mov ax,monster_xcor
    add ax,9
    mov bx,monster_ycor
    add bx,32
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; NAIL PART 2
    mov ax,monster_xcor
    add ax,9
    mov bx,monster_ycor
    add bx,26
    mov cx,monster_width
    sub cx,22
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; FOOT HORIZONTAL LINE ABOVE FOOT
    mov ax,monster_xcor
    add ax,31
    mov bx,monster_ycor
    add bx,45
    mov cx,monster_width
    sub cx,10
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle



    ; FOOT BIG PART
    mov ax,monster_xcor
    add ax,25
    mov bx,monster_ycor
    add bx,52
    mov cx,monster_width
    add cx,4
    mov dx,monster_height
    sub dx,10

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle


    ; FOOT LONG PART
    mov ax,monster_xcor
    add ax,25
    mov bx,monster_ycor
    add bx,55
    mov cx,monster_width
    add cx,8
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,yellow
	mov co,al
    call DrawRectangle


    ; FOOT NAIL LEFT
    ; BELOW LINE PART 1
    mov ax,monster_xcor
    add ax,20
    mov bx,monster_ycor
    add bx,60
    mov cx,monster_width
    sub cx,10
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle



    ; BELOW LINE PART 2
    mov ax,monster_xcor
    add ax,20
    mov bx,monster_ycor
    add bx,55
    mov cx,monster_width
    sub cx,10
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; ABOVE LINE
    mov ax,monster_xcor
    add ax,25
    mov bx,monster_ycor
    add bx,60
    mov cx,monster_width
    sub cx,15
    mov dx,monster_height
    sub dx,10

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle



    ; FOOT NAIL RIGHT
    ; BELOW LINE PART 1
    mov ax,monster_xcor
    add ax,40
    mov bx,monster_ycor
    add bx,60
    mov cx,monster_width
    sub cx,10
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle



    ; BELOW LINE PART 2
    mov ax,monster_xcor
    add ax,40
    mov bx,monster_ycor
    add bx,55
    mov cx,monster_width
    sub cx,10
    mov dx,monster_height
    sub dx,14

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


    ; ABOVE LINE
    mov ax,monster_xcor
    add ax,45
    mov bx,monster_ycor
    add bx,60
    mov cx,monster_width
    sub cx,15
    mov dx,monster_height
    sub dx,10

    mov xcor,ax
    mov ycor,bx
    mov widt,cx
    mov Height,dx
    mov ah,0
	mov al,white
	mov co,al
    call DrawRectangle


ret
DrawMonster endp


	AlienCollision proc uses ax bx cx dx
		mov ax,start_y_cor
		mov bx,ax
		add bx,start_height
		mov cx,start_x_cor
		mov dx,cx
		add dx,start_widt
		.IF right_leg_ycor >= ax && face_ycor <= bx
			.IF right_arm_xcor == cx || left_arm_xcor == dx || right_arm_xcor == dx || left_arm_xcor == cx
				dec count_lives
				.if level==2
					mov score,3
				.endif	
				.if level==3 && score==6
					mov score,6	
				.endif	
				mov aliencolission_bool,1
				jmp Endaliencolission
			.ENDIF
		.ENDIF
	Endaliencolission:	
	ret
	AlienCollision endp


MonsterEggCollision proc uses ax bx cx dx

	mov cx,face_ycor
	mov dx,cx
	sub dx,15
	.IF anda_ycor2 >= dx && anda_ycor2 <= cx
			mov ax,140
			mov bx,ax
			add bx,15
			mov cx,left_arm_xcor
			sub cx,20
			mov dx,right_arm_xcor
			add dx,20

			.IF ax >= cx && bx <= dx
				dec count_lives
				.if level==3 && score==3
					mov score,6
				.endif	
				mov monstercolission_bool,1
				jmp EndMonsterColission
			.ENDIF
	.ENDIF




	mov cx,face_ycor
	mov dx,cx
	sub dx,15
	.IF anda_ycor >= dx && anda_ycor <= cx

			mov ax,290
			mov bx,ax
			add bx,15
			mov cx,left_arm_xcor
			sub cx,20
			mov dx,right_arm_xcor
			add dx,20
			.IF ax >= cx && bx <= dx
				dec count_lives
				mov monstercolission_bool,1
				jmp EndMonsterColission
			.ENDIF
	.ENDIF
EndMonsterColission:
ret
MonsterEggCollision endp



DrawCastle proc


    mov ax,0
    mov bx,0
    mov cx,0
    mov dx,0


     mov al,7h
    mov Castle_xcor,465
    mov Castle_ycor,400
    mov uptil_y,480
    ;now drawing the castel
    call Walls_Nodes
    mov cx,16
    Draw_Walls:
        .if checkD==0
            mov check_x,10
            mov al,7h
            add Castle_ycor,10
            add Castle_xcor,10
            call Walls_Nodes 
            mov checkD,1
        .elseif checkD==1 
            mov check_x,10
             mov al,7h
            add Castle_xcor,10
            mov Castle_ycor,400
            call Walls_Nodes
            mov checkD,0
        .endif    
    loop Draw_Walls

    ;now Drawing the Minarets
    mov al,8
    mov check_x,10
    mov uptil_y,410
    mov Castle_xcor,475
    mov Castle_ycor,350
    call Walls_Nodes
    mov al,8
    mov check_x,10
    mov uptil_y,400
    mov Castle_xcor,485
    mov Castle_ycor,350
    call Walls_Nodes
    mov al,8
    mov check_x,10
    mov uptil_y,410
    mov Castle_xcor,495
    mov Castle_ycor,350
    call Walls_Nodes

    ;2nd Minaret
    mov al,8
    mov check_x,10
    mov uptil_y,410
    mov Castle_xcor,535
    mov Castle_ycor,320
    call Walls_Nodes
    mov al,8
    mov check_x,10
    mov uptil_y,400
    mov Castle_xcor,545
    mov Castle_ycor,320
    call Walls_Nodes
    mov al,8
    mov check_x,10
    mov uptil_y,410
    mov Castle_xcor,555
    mov Castle_ycor,320
    call Walls_Nodes

    ;3rd minaret
    mov al,8
    mov check_x,10

    mov uptil_y,410
    mov Castle_xcor,595
    mov Castle_ycor,350
    call Walls_Nodes
    mov al,8
    mov check_x,10
    mov uptil_y,400
    mov Castle_xcor,605
    mov Castle_ycor,350
    call Walls_Nodes
    mov al,8
    mov check_x,10
    mov uptil_y,410
    mov Castle_xcor,615
    mov Castle_ycor,350
    call Walls_Nodes

    ;now the First Dome
    mov cx,17
    mov al,4h
    mov check_x,1
    mov uptil_y,350
    mov Castle_xcor,472
    mov Castle_ycor,348
    call Walls_Nodes
    DrawDomeleft:
        mov al,4h
        mov check_x,1
        mov uptil_y,350
        inc Castle_xcor
        sub Castle_ycor,2
        call Walls_Nodes
   loop DrawDomeleft

    mov cx,17
    mov al,4h
    mov check_x,1
    mov uptil_y,350
    mov Castle_xcor,489
    mov Castle_ycor,314
    call Walls_Nodes
    DrawDomeright:
        mov al,4h
        mov check_x,1
        mov uptil_y,350
        inc Castle_xcor
        add Castle_ycor,2
        call Walls_Nodes
   loop DrawDomeright
;Pole on the First minaret
; POLe of the flag

    mov al,8
    mov check_x,2
    mov uptil_y,315
    mov Castle_xcor,488
    mov Castle_ycor,280
    call Walls_Nodes

;Now the Flag on the 2nd pole
mov al,4
    mov cx,15
    mov check_x,1
    mov Castle_xcor,489
    mov Castle_ycor,280
    mov uptil_y,295
    call Walls_Nodes
    DrawFlag1st:
        mov check_x,1
        mov uptil_y,295
        inc Castle_xcor
        mov Castle_ycor,280
        call Walls_Nodes
      loop DrawFlag1st 
     


;Now the 2nd Dome
    mov cx,17
    mov al,4h
    mov check_x,1
    mov uptil_y,320
    mov Castle_xcor,532
    mov Castle_ycor,318
    call Walls_Nodes
   DrawDomeleft2:
        mov al,4h
        mov check_x,1
        mov uptil_y,320
        inc Castle_xcor
       sub Castle_ycor,2
        call Walls_Nodes
   loop DrawDomeleft2
    mov cx,17
    mov al,4h
    mov check_x,1
    mov uptil_y,320
    mov Castle_xcor,549
    mov Castle_ycor,284
    call Walls_Nodes
    DrawDomeright2:
        mov al,4h
        mov check_x,1
        mov uptil_y,320
        inc Castle_xcor
        add Castle_ycor,2
        call Walls_Nodes
   loop DrawDomeright2

; POLe of the flag

    mov al,8
    mov check_x,2
    mov uptil_y,286
    mov Castle_xcor,548
    mov Castle_ycor,260
    call Walls_Nodes

;Now the Flag on the 2nd pole

    mov al,4
    mov cx,15
    mov check_x,1
    mov Castle_xcor,549
    mov Castle_ycor,260
    mov uptil_y,275
    call Walls_Nodes
    DrawFlag2nd:
        mov check_x,1
        mov uptil_y,275
        inc Castle_xcor
        mov Castle_ycor,260
        mov uptil_y,275
        call Walls_Nodes
      loop DrawFlag2nd  



   ;Now the third Dome

    mov cx,17
    mov al,4h
    mov check_x,1
    mov uptil_y,350
    mov Castle_xcor,592
    mov Castle_ycor,348
    call Walls_Nodes
    DrawDomeleft3:
        mov al,4h
        mov check_x,1
        mov uptil_y,350
        inc Castle_xcor
        sub Castle_ycor,2
        call Walls_Nodes
   loop DrawDomeleft3

    mov cx,17
    mov al,4h
    mov check_x,1
    mov uptil_y,350
    mov Castle_xcor,609
    mov Castle_ycor,314
    call Walls_Nodes
    DrawDomeright3:
        mov al,4h
        mov check_x,1
        mov uptil_y,350
        inc Castle_xcor
        add Castle_ycor,2
        call Walls_Nodes
   loop DrawDomeright3
;Pole on the 3rd minaret
; POLe of the flag

    mov al,8
    mov check_x,2
    mov uptil_y,314
    mov Castle_xcor,609
    mov Castle_ycor,280
    call Walls_Nodes

;Now the Flag on the 2nd pole
mov al,4
    mov cx,15
    mov check_x,1
    mov Castle_xcor,609
    mov Castle_ycor,280
    mov uptil_y,295
    call Walls_Nodes
    DrawFlag3rd:
        mov check_x,1
        mov uptil_y,295
        inc Castle_xcor
        mov Castle_ycor,280
        call Walls_Nodes
      loop DrawFlag3rd  
   

   ;Now the main Gate for the Castle

   mov cx,20
   mov al,6
   mov check_x,1
   mov Castle_xcor,530
   mov uptil_y,480
   mov Castle_ycor,460
   call Walls_Nodes
   DrawMainGateLeft:
        mov check_x,1
        inc Castle_xcor
        mov uptil_y,480
        dec Castle_ycor
        call Walls_Nodes
    loop DrawMainGateLeft

    ;Now the Right side of the Gate
    mov cx,20
   mov al,06h
   mov check_x,1
   mov Castle_xcor,550
   mov uptil_y,480
   mov Castle_ycor,440
   call Walls_Nodes
   DrawMainGateR:
        mov al,6h 
        mov check_x,1
        inc Castle_xcor
        mov uptil_y,480
        inc Castle_ycor
        call Walls_Nodes
    loop DrawMainGateR

    mov al,08h
    mov check_x,3
    mov Castle_xcor,560
    mov Castle_ycor,465
    mov uptil_y,470
    call Walls_Nodes

;Now the First Window  On the minaret
    mov al,14d
    mov check_x,10
    mov Castle_xcor,485
    mov uptil_y,380
    mov Castle_ycor,370
    call Walls_Nodes

    ;Window on the 2nd Minaret

    mov al,14d
    mov check_x,10
    mov Castle_xcor,545
    mov uptil_y,360
    mov Castle_ycor,350
    call Walls_Nodes
    ;3rd window
    mov al,14d
    mov check_x,10
    mov Castle_xcor,605
    mov uptil_y,380
    mov Castle_ycor,370
    call Walls_Nodes

    ;Now drawing the flags



endi:
ret
DrawCastle endp


anda proc
	 .IF anda_ycor == 400 && anda_bool == 1
		mov bx,anda_ycor
		mov ycor,bx
		mov xcor,290
		mov widt,15
		mov Height,15
		mov co,11d
		call DrawRectangle
	 	mov anda_ycor,80
		mov anda_bool,0
	.ENDIF



	.IF monster_xcor == 290 && anda_bool == 0
		mov xcor,290
		mov bx,anda_ycor
		mov ycor, bx
		mov widt,15
		mov Height,15
		mov co,12d
		call DrawRectangle
		mov anda_bool,1
	.ENDIF

	.IF anda_bool == 1 && anda_ycor < 410
		mov bx,anda_ycor
		mov ycor,bx
		mov xcor,290
		mov widt,15
		mov Height,15
		mov co,11d
		call DrawRectangle
		add anda_ycor,20
		mov bx,anda_ycor
		mov ycor,bx
		mov xcor,290
		mov widt,15
		mov Height,15
		mov co,12d
		call DrawRectangle

	.ENDIF

	ret
anda endp



	anda2 proc
	 .IF anda_ycor2 == 400 && anda_bool2 == 1
		mov bx,anda_ycor2
		mov ycor,bx
		mov xcor,140
		mov widt,15
		mov Height,15
		mov co,11d
		call DrawRectangle
	 	mov anda_ycor2,80
		mov anda_bool2,0
	.ENDIF



	.IF monster_xcor == 140 && anda_bool2 == 0
		mov xcor,140
		mov bx,anda_ycor2
		mov ycor, bx
		mov widt,15
		mov Height,15
		mov co,12d
		call DrawRectangle
		mov anda_bool2,1
	.ENDIF

	.IF anda_bool2 == 1 && anda_ycor2 < 410
		mov bx,anda_ycor2
		mov ycor,bx
		mov xcor,140
		mov widt,15
		mov Height,15
		mov co,11d
		call DrawRectangle
		add anda_ycor2,20
		mov bx,anda_ycor2
		mov ycor,bx
		mov xcor,140
		mov widt,15
		mov Height,15
		mov co,12d
		call DrawRectangle

	.ENDIF

	ret
	anda2 endp

;Code to Draw You Won On screen



YouWon proc
	
	mov ah,0
	mov al,12h
	int 10h
	
;1
	mov co, 2

	mov num ,15
	mov xcor,200
	mov ycor,130

FirstWon:
	add xcor,2	
	add ycor,2	
	mov height,8
	mov widt,8
	dec num
	call DrawRectangle
	cmp num, 0
	je FirstWon1
	jmp FirstWon

FirstWon1:

	mov num ,15
	mov xcor,230
	mov ycor,160
FirstWon2:
	add xcor,2	
	sub ycor,2	
	mov height,8
	mov widt,8
	dec num
	call DrawRectangle
	cmp num, 0
	je FirstWon3
	jmp FirstWon2
FirstWon3:

	mov xcor,230
	mov ycor,200	
	mov height,45
	mov widt,10
	call DrawRectangle

;2
	mov co, 4

	mov xcor,300
	mov ycor,200	
	mov height,70
	mov widt,10
	call DrawRectangle

	mov xcor,300	
	mov ycor,130
	mov height,10
	mov widt,50
	call DrawRectangle

	mov xcor,340
	mov ycor,200	
	mov height,80
	mov widt,10
	call DrawRectangle

	mov xcor,300
	mov ycor,200	
	mov height,10
	mov widt,50
	call DrawRectangle


;3
	mov co, 5

	mov xcor,385
	mov ycor,200	
	mov height,80
	mov widt,10
	call DrawRectangle
	
	mov xcor,430
	mov ycor,200	
	mov height,80
	mov widt,10
	call DrawRectangle

	mov xcor,385
	mov ycor,200	
	mov height,10
	mov widt,50
	call DrawRectangle

;4
	mov co, 14

	mov xcor,210
	mov ycor,300	
	mov height,65
	mov widt,10
	call DrawRectangle

	mov num ,12
	mov xcor,215
	mov ycor,300
F:
	add xcor,2	
	sub ycor,2	
	mov height,8
	mov widt,8
	dec num
	call DrawRectangle
	cmp num, 0
	je G
	jmp F
G:
	
	mov num ,12
	mov xcor,240
	mov ycor,275
FirstWon4:
	add xcor,2	
	add ycor,2	
	mov height,8
	mov widt,8
	dec num
	call DrawRectangle
	cmp num, 0
	je FirstWon5
	jmp FirstWon4
FirstWon5:

	mov xcor,270
	mov ycor,300	
	mov height,65
	mov widt,10
	call DrawRectangle
	
;5
	mov co, 12

	mov xcor,300
	mov ycor,300	
	mov height,65
	mov widt,10
	call DrawRectangle

	mov xcor,300	
	mov ycor,240
	mov height,10
	mov widt,50
	call DrawRectangle

	mov xcor,340
	mov ycor,300	
	mov height,65
	mov widt,10
	call DrawRectangle

	mov xcor,300
	mov ycor,300	
	mov height,10
	mov widt,50
	call DrawRectangle

;6
	mov co, 6	

	mov xcor,370
	mov ycor,300	
	mov height,70
	mov widt,10
	call DrawRectangle

	mov num ,32
	mov xcor,370
	mov ycor,235
FirstWon6:
	add xcor,2	
	add ycor,2	
	mov height,8
	mov widt,8
	dec num
	call DrawRectangle
	cmp num, 0
	je FirstWon7
	jmp FirstWon6
FirstWon7:

	mov xcor,435
	mov ycor,300	
	mov height,70
	mov widt,10
	call DrawRectangle

	ret
YouWon endp

LostPrompt proc
	
	mov ah,0
	mov al,12h
	int 10h
	
;1
	mov co, 2

	mov num ,15
	mov xcor,200
	mov ycor,130
LostP1:
	add xcor,2	
	add ycor,2	
	mov height,8
	mov widt,8
	dec num
	call DrawRectangle
	cmp num, 0
	je LostP2
	jmp LostP1
LostP2:

	mov num ,15
	mov xcor,230
	mov ycor,160
LostP3:
	add xcor,2	
	sub ycor,2	
	mov height,8
	mov widt,8
	dec num
	call DrawRectangle
	cmp num, 0
	je LostP4
	jmp LostP3
LostP4:

	mov xcor,230
	mov ycor,200	
	mov height,45
	mov widt,10
	call DrawRectangle

;2
	mov co, 4

	mov xcor,300
	mov ycor,200	
	mov height,70
	mov widt,10
	call DrawRectangle

	mov xcor,300	
	mov ycor,130
	mov height,10
	mov widt,50
	call DrawRectangle

	mov xcor,340
	mov ycor,200	
	mov height,80
	mov widt,10
	call DrawRectangle

	mov xcor,300
	mov ycor,200	
	mov height,10
	mov widt,50
	call DrawRectangle


;3
	mov co, 5

	mov xcor,385
	mov ycor,200	
	mov height,80
	mov widt,10
	call DrawRectangle
	
	mov xcor,430
	mov ycor,200	
	mov height,80
	mov widt,10
	call DrawRectangle

	mov xcor,385
	mov ycor,200	
	mov height,10
	mov widt,50
	call DrawRectangle
;4

	mov co, 14

	mov xcor,200
	mov ycor,310	
	mov height,70
	mov widt,10
	call DrawRectangle

	mov xcor,200	
	mov ycor,310
	mov height,10
	mov widt,50
	call DrawRectangle
;5	

	mov co, 9

	mov xcor,270
	mov ycor,310	
	mov height,70
	mov widt,10
	call DrawRectangle

	mov xcor,270	
	mov ycor,250
	mov height,10
	mov widt,50
	call DrawRectangle

	mov xcor,310
	mov ycor,310	
	mov height,70
	mov widt,10
	call DrawRectangle

	mov xcor,270
	mov ycor,310	
	mov height,10
	mov widt,50
	call DrawRectangle

;6
	mov co, 3

	mov xcor,345	
	mov ycor,250
	mov height,10
	mov widt,50
	call DrawRectangle

	mov xcor,345
	mov ycor,280	
	mov height,35
	mov widt,10
	call DrawRectangle

	mov xcor,345	
	mov ycor,280
	mov height,10
	mov widt,50
	call DrawRectangle

	mov xcor,390
	mov ycor,310	
	mov height,40
	mov widt,10
	call DrawRectangle

	mov xcor,345	
	mov ycor,310
	mov height,10
	mov widt,50
	call DrawRectangle
	
;7
	mov co, 8

	mov xcor,440
	mov ycor,310	
	mov height,70
	mov widt,10
	call DrawRectangle

	mov xcor,415	
	mov ycor,250
	mov height,10
	mov widt,60
	call DrawRectangle


ret
LostPrompt endp
end start
