#####################################################################
#
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Yashank Bhola, 1006927408, bholayas, yashank.bhola@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1
# - Milestone 2
# - Milestone 3 
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Double Jump:               Press w two times
# 2. Moving objects:            Enemy Moving
# 3. Health:                    Player's health reduces when enemy hits)
# 4. Fail condition:            when health drops to 0
# 5. Win condition:             when coins collected == 3/ Level == 3
# 6. Different levels:          3 levels
# 7. Pick-up effects:           As level increases player's health increases by 2
#
# Link to video demonstration for final submission:
# - https://www.youtube.com/watch?v=ktZVBSqN9Fs
#
# Are you OK with us sharing the video with people outside course staff?
# - yes https://github.com/yashankxy/Assembly-Game
#
# Any additional information that the TA needs to know:
# - TODO: 
#
#####################################################################

# DONE
    # Different Level                               (2)
        # Level 2
        # Level 3  
    # Double Jump                                   (1)
    # Enemy Moving (objects)                        (2)
        # Enemy Falling from right to Left
    # Health                                        (2)
        # Switch color of the player to Red
    # Press p to restart
    # Press q to quit
    # Win condition                                 (1)
        # Draw You Won
    # Fail condition                                (1)
        # Draw Game Over
    # Start Menu            
        # Press p to start the game



#########################################################################
#                            DEFINE CONSTANTS                           #
#########################################################################

# Screen Display ____________________________________________________
    # Address --> address(x,y) = (y*64+ x) * 4
        # w = 64
        # h = 64   
    .eqv    BASE_ADDRESS        0x10008000  
    .eqv    END_ADDRESS         0x1000C000  
    .eqv    NEXT_ROW            256

    .eqv    PLAYER_INIT_ADDR    0x1000B80C                  # BASE + (64*56 + 3)*4
    .eqv    PLAYER_AREA         1300                        # (64*5 + 5)*4
    .eqv    PLAYER_LAST         13324                       # (64*52 +3)*4
    
    .eqv	DISPLAY_FIRE        4172    					# (64*16 + 15)*4 
    .eqv	DISPLAY_START       14140    					# (64*36 + 5)*4 

    .eqv	DISPLAY_YOUWON      4116    					# (64*16 + 5)*4 = 4116
    .eqv	DISPLAY_GAMEOVER    4116    					# (64*16 + 5)*4 = 4116
    
    # Colors
    .eqv    BLACK               0x000000
    .eqv    WHITE               0xffffff
    .eqv    YELLOW              0xf29200
    .eqv    ORANGE              0xf26200
    .eqv    RED_P               0xa63126
    .eqv    BLUE_NIGHT          0x061c31
    .eqv    DARK_GREEN          0x69a387
    .eqv    BLUE                0x2391ff
    .eqv    DARK_BLUE           0x0d3965
    .eqv    GREEN               0x1ed760
    .eqv    PURPLE              0xb006f0
    .eqv    RED                 0xda4032
    .eqv    BROWN               0x372c14
# ___________________________________________________________________

# Player Input ______________________________________________________
    .eqv	KEY_EVNT	0xFFFF0000	# keystroke event logger
    .eqv	KEY_W	    0x00000077	# hex value for ASCII code 'w'  // jumping
    .eqv	KEY_A	    0x00000061	# hex value for ASCII code 'a'  // Left
    .eqv	KEY_S	    0x00000073	# hex value for ASCII code 's'  // Right    
    .eqv	KEY_D	    0x00000064	# hex value for ASCII code 'd'  // down
    .eqv	KEY_E	    0x00000065	# hex value for ASCII code 'e'  // Starting the game
    .eqv	KEY_P	    0x00000070	# hex value for ASCII code 'p'  // Restart
    .eqv	KEY_Q	    0x00000071	# hex value for ASCII code 'q'  // Exit
# ___________________________________________________________________

# Player ____________________________________________________________
# ___________________________________________________________________

# BRICKS ____________________________________________________________
    .eqv	LEVEL1_BRICKS  		28				# 7 Bricks
    .eqv	LEVEL2_BRICKS  		40				# 10 Bricks
    .eqv	LEVEL3_BRICKS  		64				# 16 Bricks
# ___________________________________________________________________

# COINS _____________________________________________________________
    .eqv	NUM_COINS		    4				# 1 coins (1*4)
    .eqv	NUM_COINS_2		    4				# 1 coins (1*4)
    .eqv	NUM_COINS_3		    4				# 1 coins (1*4)
# ___________________________________________________________________

# Enemy _____________________________________________________________
    .eqv	NUM_MAGMA	        12				# 3 magma (3*4)
    .eqv	NUM_MAGMA_2		    16				# 4 magma (4*4)
    .eqv	NUM_MAGMA_3		    20				# 5 magma (5*4)
# ___________________________________________________________________





#########################################################################
#                            VARIABLES                                  #
#########################################################################
.data
    level1_bricks_loc:              .word          1100, 1200, 1300, 2447, 2464, 3108, 3124             # Array 
    level1_bricks_addr:             .space         LEVEL1_BRICKS                                        # Array 
    level2_bricks_loc:              .word          2408, 2400, 1900, 3108, 3148, 1100, 1100, 3100, 2900, 3124             # Array 
    level2_bricks_addr:             .space         LEVEL2_BRICKS                                        # Array 
    level3_bricks_loc:              .word          1100, 1200, 1300, 2447, 2456, 3108, 3116, 3124, 2032, 2040, 2060, 2124, 2670, 2678, 2680, 1000                # Array 
    level3_bricks_addr:             .space         LEVEL3_BRICKS                                        # Array 
    
    magma:                          .space         NUM_MAGMA                                            # Array
    magma_2:                        .space         NUM_MAGMA_2                                          # Array
    magma_3:                        .space         NUM_MAGMA_3                                          # Array
    
    level1_coin_loc:                .word          1250                                                 # Array 
    coin:                           .space         NUM_COINS                                            # Array
    level2_coin_loc:                .word          1688                                                 # Array 
    coin_2:                         .space         NUM_COINS_2                                          # Array
    level3_coin_loc:                .word          516                                                 # Array 
    coin_3:                         .space         NUM_COINS_3                                          # Array


.text
.globl main
#########################################################################
#                            MAIN                                       #
#########################################################################
# ________________________________________________________________________
main:    
    # -----------------------------
    # Color screen
    # -----------------------------
    li $a0, BASE_ADDRESS
    li $a1, END_ADDRESS
    li $a2, -NEXT_ROW
    jal color_scrn
    
    # -----------------------------
    # Draw Start menu: Splash screen
    # -----------------------------
    jal draw_startmenu
    # test
        # jal draw_you_won
        # jal draw_game_over

    # -----------------------------
    # Sleep
    # -----------------------------
    li $v0 32
	li $a0 2000
	syscall

    # Wait for player to start the game 
    main_start:
    li $a0, KEY_EVNT
    lw $t0, 4($a0)
    bne $t0, KEY_E, main_start


    # -----------------------------
    # Color screen
    # -----------------------------
    li $a0, BASE_ADDRESS
    li $a1, END_ADDRESS
    li $a2, -NEXT_ROW
    jal color_scrn


    # +++++++++++++++++++++++++++++
    # $s0 = OLD Player location
    # $s1 = UPDATED Player location
    # $s2 = LEVELS              --> 0 = Level 1, 1 = Level 2, 2 = Level 3     
    # $s3 = Jumps remaining,    --> 2, 1, 0 Jumps
    # $s4 = Falling             --> 1 stop, 0 fall
    # $s5 = Health              --> 10, .... 4 (100%), 3 (75%), 2 (50%), 1 (25%), 0 (0%)
    # $s6 = Coins               --> 1 - Level 1 -> 3 - Level 2 -> 6 - Level 5
    # $s7 = 
    # +++++++++++++++++++++++++++++

    # ===== Global Variables ======
        li $s0, END_ADDRESS
        li $s1, PLAYER_INIT_ADDR
        li $s2, 0
        li $s3, 2
        li $s4, 0 
        li $s5, 10 
        li $s6, 0 
    # =============================
    
    jal init_magma
    # _______________________________________________________
    main_loop:
        # IF Health == 0 -->Exit
        beq $s5, 0, game_over


        #* Level 1
            # If $s2 == 0 && $s6 == 1 {Move to level 2}
            bne $s2, 0, ml_continue
            bne $s6, 1, ml_continue
            addi $s2, $s2, 1
            addi $s5, $s5, 2
            li $s0, END_ADDRESS
            li $s1, PLAYER_INIT_ADDR
            li $a0, BASE_ADDRESS
            li $a1, END_ADDRESS
            li $a2, -NEXT_ROW
            jal color_scrn
            jal init_magma
            jal init_coins
        
        #* Level 2
        # If $s2 == 1 && $s6 == 2 {Move to level 3}
        ml_continue:
            bne $s2, 1, ml_continue1
            bne $s6, 2, ml_continue1
            addi $s2, $s2, 1    # Level Up
            addi $s5, $s5, 2    # Increase health
            li $s0, END_ADDRESS
            li $s1, PLAYER_INIT_ADDR
            li $a0, BASE_ADDRESS
            li $a1, END_ADDRESS
            li $a2, -NEXT_ROW
            jal color_scrn
            jal init_magma
            jal init_coins

        #* Level 3
        # If $s2 == 2 && $s6 == 3 {Move to You Won screen}
        ml_continue1:
            bne $s2, 2, ml_continue2
            bne $s6, 3, ml_continue2
            # Draw You won screen
            jal draw_you_won
            li	$v0, 32
            li	$a0, 2000
            syscall
            j main

        
        # Continue
        
        ml_continue2:
        # KeyPressed 
        li $a0, KEY_EVNT
        lw $t9, 0($a0)
        bne $t9, 1, main_redraw
        jal key_Pressed
        main_redraw:
            # _______________________________
            # Redraw 
                # Enemy
                jal move_magma
                
                # Bricks
                jal init_bricks

                # Coins
                jal init_coins
                
            # _______________________________
            
            # _______________________________
            # Sleep
                li	$v0, 32
                li	$a0, 20
                syscall
            # _______________________________
            
            # _______________________________
            # Check for Collisions 
                # Brick
                jal brick_collision
                # Collect coins
                jal coins_collision
                # Magma
                jal magma_collision
            # _______________________________

            # _______________________________
            # Gravity
                falling:
                    li $t3, END_ADDRESS
                    addi $t3, $t3, -PLAYER_AREA
                    addi $t3, $t3, -NEXT_ROW    # Keeping player on screen
                    addi $t3, $t3, -NEXT_ROW    # Keeping player on platform
                    addi $t3, $t3, -NEXT_ROW
                    bgt $s1, $t3, falling_exit
                    # Check if Collision Brick Present
                    beq $s4, 1, falling_exit
                    # Sleep
                    li	$v0, 32
                    li	$a0, 40
                    syscall


                    addi $t3, $t3, NEXT_ROW    # Keeping player on platform
                    addi $t3, $t3, NEXT_ROW
                    addi $s1, $s1, NEXT_ROW                 # Move down
                    j mr_continue
                    falling_exit:
                        li $s3, 2              # Reset Jumps
            # _______________________________

            # _______________________________
            # MOVING: Update game
                # Erase objects from old position
                mr_continue:
                    beq $s0, $s1, mr_loop_redraw
                    move $a0, $s0
                    move $a1, $s0
                    addi $a1, $a1, PLAYER_AREA
                    li $a2, -20
                    jal color_scrn
            # _______________________________

            # _______________________________
            # Redraw
                mr_loop_redraw:
                    # PLAYER
                    move $a0, $s1
                    # li $a0, BASE_ADDRESS
                    # add $a0, $a0, $s1
                    jal draw_Player
                    move $s0, $s1       # Save last address of player
                    
                    # Level
                    li $a0, END_ADDRESS
                    jal draw_platform

                # Coins/Keys
            # _______________________________

            j main_loop
    # _______________________________________________________

    game_over:
        jal draw_game_over
        li	$v0, 32
        li	$a0, 2000
        syscall
        j main


    main_end: 
        li $v0, 10                  # Exit the program
        syscall
# ________________________________________________________________________


#########################################################################
#                            Helper Functions                           #
#########################################################################


# Control Player ====================================================
    # $a0 = KEY_EVNT
    key_Pressed:
        # Local Variables
            li $t1, NEXT_ROW
            li $t2, BASE_ADDRESS
            li $t3, END_ADDRESS
            addi $t2, $t2, NEXT_ROW
            addi $t3, $t3, -PLAYER_AREA
            addi $t3, $t3, -NEXT_ROW    # Keeping player on screen

        lw $t0, 4($a0)

        beq $t0, KEY_W, jump
        beq $t0, KEY_A, left
        beq $t0, KEY_S, down
        beq $t0, KEY_D, right
        beq $t0, KEY_P, restart
        beq $t0, KEY_Q, end


        jump:   # MOVING UP
            blt $s1, $t2, key_Pressed_exit          # EDGE CASE
            beq $s3, 0, jump_exit                   # If ($s3 = 0) skip  
                                                    # else jump && $s3-=1
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s1, $s1, -NEXT_ROW                # JUMPING
            addi $s3, $s3, -1                       # $s3-=1

            jump_exit:
                b key_Pressed_exit
        left: 
            div $s1, $t1
            mfhi $t4
            ble $t4, $zero, key_Pressed_exit
            addi $s1, $s1, -4
            b key_Pressed_exit
        down: 
            addi $t3, $t3, -NEXT_ROW    # Keeping player on platform
            addi $t3, $t3, -NEXT_ROW
            bgt $s1, $t3, key_Pressed_exit
            # Check if Collision Brick Present
            beq $s4, 1, key_Pressed_exit

            addi $t3, $t3, NEXT_ROW    # Keeping player on platform
            addi $t3, $t3, NEXT_ROW
            addi $s1, $s1, NEXT_ROW                 # Move down
            b key_Pressed_exit

        right:
            div $s1, $t1
            mfhi $t4
            add $t4, $t4, 36
            beq $t4, $t1, key_Pressed_exit
            addi $s1, $s1, 4
            b key_Pressed_exit

        restart:
            j main
        end:
            j main_end

        key_Pressed_exit:
                jr $ra

# ===================================================================

# Collision =========================================================
    # Collision with Brick
    brick_collision:
                
        # Save the address
        beq $s2, 0, bc_lvl1
        beq $s2, 1, bc_lvl2
        beq $s2, 2, bc_lvl3

        bc_lvl1:
        la $t0, level1_bricks_addr              # Start of Array 
        la $t1, level1_bricks_addr              # End of Array
        addi $t1, $t1, LEVEL1_BRICKS            # End of array
        j bc_continue

        bc_lvl2:
        la $t0, level2_bricks_addr              # Start of Array 
        la $t1, level2_bricks_addr              # End of Array
        addi $t1, $t1, LEVEL2_BRICKS            # End of array
        j bc_continue
        
        bc_lvl3:
        la $t0, level3_bricks_addr              # Start of Array 
        la $t1, level3_bricks_addr              # End of Array
        addi $t1, $t1, LEVEL3_BRICKS            # End of array
        j bc_continue


        bc_continue:
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)

        bc_loop:                        # do {
            lw $t2, 0($t0)                  # $t2 = Position of brick[i]      
            
            # (Calculating) Edges of the brick
                # Find TL and TR of brick
                #TL----------------TR
                ###----------------##
                move $t3, $t2                       # Top Left 
                move $t4, $t2                       # Top Right 
                addi $t4, $t4, 32
                                                # Position 
                move $a0, $t3                                       
                jal position                        # TL    
                move $t3, $v0                           # $t3 = x axis
                move $a0, $t4                       
                jal position                        # TR
                move $t4, $v0                           # $t4 = x axis
                move $t5, $v1                           # $t5 = y axis
            
            # (Calculating) Edges of the Player
                # Find BL and BR of 1 row below the Player
                move $t6, $s1
                addi $t6, $t6, NEXT_ROW
                addi $t6, $t6, NEXT_ROW
                addi $t6, $t6, NEXT_ROW
                addi $t6, $t6, NEXT_ROW
                addi $t6, $t6, NEXT_ROW             # (BL) Row below Player 
                
                move $t7, $t6
                addi $t7, $t7, 20                   # (BR) Row below Player ((width=5) * 4)
                                                # Position
                move $a0, $t6
                jal position                        # BL
                move $t6, $v0                           # $t6 = x axis
                
                move $a0, $t7
                jal position                        # BR
                move $t7, $v0                           # $t7 = x axis
                move $t8, $v1                           # $t8 = y axis

            # Check Collision: 
                # $t3 = Brick TL                    $t5 = Brick y axis
                # $t4 = Brick TR
                # $t6 = Player BL                   $t8 = Player y axis
                # $t7 = Player BR
                bne $t8, $t5, bc_loop_else   #  If $t8 == $t5  ( y axis is the same continue)
                    # if  B-TL <= P-BL <= B-TR
                        blt $t6, $t3, bc_loop_if_else  
                        bgt $t6, $t4, bc_loop_if_else 
                            li $s4, 1               # Falling stop
                            j bc_exit
                    bc_loop_if_else:
                    # if B-TL <= P-BR <= B-TR
                        blt $t7, $t3, bc_loop_else  
                        bgt $t7, $t4, bc_loop_else  
                            li $s4, 1               # Falling stop
                            j bc_exit
                bc_loop_else:
                # else set $s4 = 0
                    li $s4, 0               # Falling start

            bc_loop_continue:
                addi $t0, $t0, 4
                bne $t0, $t1, bc_loop

        bc_exit:
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra


            # check 5 units below the player:
            #     if any of them matches 

            # if (next row of bottom of player == Brick 1st row){
            #     falling = stop = 1
            # }
            # else{
            #     falling = continue
            # }

    
    # Collision with Enemy
    magma_collision:
        beq $s2, 0, mc_lvl1
        beq $s2, 1, mc_lvl2
        beq $s2, 2, mc_lvl3
        
        # IF level == 1
        mc_lvl1:
            la $t0, magma           # Start of array
            la $t1, magma           # End of array
            addi $t1, $t1, NUM_MAGMA
            j mc_continue
        # Else if level == 2 
        mc_lvl2:
            la $t0, magma_2           # Start of array
            la $t1, magma_2           # End of array
            addi $t1, $t1, NUM_MAGMA_2
            j mc_continue
        mc_lvl3:
        # Else if level == 3
            la $t0, magma_3           # Start of array
            la $t1, magma_3           # End of array
            addi $t1, $t1, NUM_MAGMA_3
            j mc_continue

        mc_continue:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        
        mc_loop:                        # do {
            lw $t2, 0($t0)                  # $t2 = Position of brick[i]      
            
            # (Calculating) Edges of the magma
                # Find TL and TR of magma
                #TL-----TR
                #BL-----##
                move $t3, $t2                       # Top Left 
                move $t4, $t2                       # Top Right 
                addi $t4, $t4, 4
                                                # Position 
                move $a0, $t3                                       
                jal position                        # TL    
                move $t3, $v0                           # $t3 = x_0 axis
                
                move $a0, $t4                       
                jal position                        # TR
                move $t4, $v0                           # $t4 = x_1 axis
                move $t5, $v1                           # $t5 = y_0 axis
                
                move $t6, $t3
                addi $t6, $t6, NEXT_ROW
                move $a0, $t6                       
                jal position                        # BL
                move $t6, $v1                           # $t6 = y_1 axis

                move $t7, $s1
                move $a0, $t7
                jal position
                move $t7, $v0           # x_0        
                move $t8, $v1           # y_0


                # Check if y axis of magma matches with player
                    move $t9, $t8
                    addi $t9, $t9, 5       # y_1
                    # Check if $t8 -- $t9 == $t6 || $t8 -- $t9 == $t5
                    # if $t8 <= $t6 <= $t9
                    bgt $t8, $t6, mc_l_cnext     # $t8 > $t6
                    blt $t9, $t6, mc_l_cnext     # $t9 < $t6
                    
                    mc_l_cnext:
                        # if $t8 <= $t5 <= $t9
                        bgt $t8, $t5, mc_l_nw_y     # $t8 > $t5
                        blt $t9, $t5, mc_l_nw_y     # $t9 < $t5

                        # Check if x axis matches with magma
                            move $t9, $t7
                            addi $t9, $t9, 5       # x_1
                            # check if $t7 -- $t9 == $t4 || $t7 -- $t9 == $t3
                            # if $t7 <= $t4 <= $t9
                            bgt $t7, $t4, mc_l_cnext1     # $t7 > $t4
                            blt $t9, $t4, mc_l_cnext1     # $t9 < $t4
                            
                            mc_l_cnext1:
                                # if $t7 <= $t3 <= $t9
                                bgt $t7, $t3, mc_l_nw_y     # $t7 > $t3
                                blt $t9, $t3, mc_l_nw_y     # $t9 < $t3
                                move $a0, $s1
                                addi $s5, $s5, -1
                                jal draw_damage
                                j mc_exit

                mc_l_nw_y:
                    addi $t0, $t0, 4
                    bne $t0, $t1, mc_loop
        mc_exit:
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra



    # Collision with Coins
    coins_collision:
        beq $s2, 0, cc_lvl1
        beq $s2, 1, cc_lvl2
        beq $s2, 2, cc_lvl3
        
        # IF level == 1
        cc_lvl1:
            la $t0, coin              # Start of Array 
            la $t1, coin              # End of Array
            addi $t1, $t1, NUM_COINS            # End of array
            j cc_continue
        # Else if level == 2 
        cc_lvl2:
            la $t0, coin_2              # Start of Array 
            la $t1, coin_2              # End of Array
            addi $t1, $t1, NUM_COINS_2            # End of array
            j cc_continue
        cc_lvl3:
        # Else if level == 3
            la $t0, coin_3              # Start of Array 
            la $t1, coin_3            # End of Array
            addi $t1, $t1, NUM_COINS_3            # End of array
            # la $t2, level3_coin_loc
            j cc_continue

        cc_continue:        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        
        cc_loop:                        # do {
            lw $t2, 0($t0)                  # $t2 = Position of brick[i]      
            
            # (Calculating) Edges of the Coin
                # Find TL and TR of Coin
                #TL-----TR
                #BL-----##
                move $t3, $t2               # Top Left
                move $t4, $t2           
                addi $t4, $t4, 8            # Top Right

                move $a0, $t3
                jal position
                move $t3, $v0               # x_0 axis

                move $a0, $t4
                jal position
                move $t4, $v0               # x_1 axis
                move $t5, $v1               # y_0 axis


                move $t6, $t3
                addi $t6, $t6, NEXT_ROW
                addi $t6, $t6, NEXT_ROW
                addi $t6, $t6, NEXT_ROW
                addi $t6, $t6, NEXT_ROW
                move $a0, $t6                       
                jal position                        # BL
                move $t6, $v1                           # $t6 = y_1 axis

                move $t7, $s1
                move $a0, $t7
                jal position
                move $t7, $v0           # x_0        
                move $t8, $v1           # y_0


            # Check if y axis of coin matches with player
                move $t9, $t8
                addi $t9, $t9, 5       # y_1
                # Check if $t8 -- $t9 == $t6 || $t8 -- $t9 == $t5
                # if $t8 <= $t6 <= $t9
                bgt $t8, $t6, cc_l_cnext     # $t8 > $t6
                blt $t9, $t6, cc_l_cnext     # $t9 < $t6
                
                cc_l_cnext:
                    # if $t8 <= $t5 <= $t9
                    bgt $t8, $t5, cc_l_nw_y     # $t8 > $t5
                    blt $t9, $t5, cc_l_nw_y     # $t9 < $t5

                    # Check if x axis matches with magma
                        move $t9, $t7
                        addi $t9, $t9, 5       # x_1
                        # check if $t7 -- $t9 == $t4 || $t7 -- $t9 == $t3
                        # if $t7 <= $t4 <= $t9
                        bgt $t7, $t4, cc_l_cnext1     # $t7 > $t4
                        blt $t9, $t4, cc_l_cnext1     # $t9 < $t4
                        
                        cc_l_cnext1:
                            # if $t7 <= $t3 <= $t9
                            bgt $t7, $t3, cc_l_nw_y     # $t7 > $t3
                            blt $t9, $t3, cc_l_nw_y     # $t9 < $t3
                            move $a0, $s1
                            addi $s6, $s6, 1
                            # jal Draw green
                            j cc_exit

            cc_l_nw_y:
                addi $t0, $t0, 4
                bne $t0, $t1, cc_loop
        cc_exit:
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra

    #-----------------------
    position:
        # $a0 = Address in Hex
            # $v0 = x-axis
            # $v1 = y-axis
        addi $a0, $a0, -BASE_ADDRESS    # Subtract the base address
        li $a1, NEXT_ROW                
        div $a0, $a1                    # Divide 
        mfhi $v0                            # x-axis
        mflo $v1                            # y-axis
        jr $ra                          # Exit 
    #-----------------------
# ===================================================================

# Paint ============================================================= 

    ###################  LEVEL  #####################
    #     ____________64____________
    #    |                          |
    #    |                          |
    #    |              ______      |
    #    |                          |
    #   64        ____             64
    #    |                          |
    #    | __^__                    |
    #    |                          |
    #    |____________64____________|
    ##################################################

    # Color  screen 
        # a0$ = FIRST address
        # a1$ = LAST address
        # a2$ = -Width 
    color_scrn:
            li $t0, BLUE_NIGHT                          # Save COLOUR
            li $t1, 0
            
            color_BOX_LOOP:                        
                bge $a0, $a1, color_scrn_LOOP_END   # while (FIRST != LAST){
                    beq $t1, $a2, move_next_row             # while (Not end of row)
                        sw $t0, 0($a0)                      #   Edit Color of Unit  
                        addi $a0, $a0, 4                    #   increment $a0 by 4
                        addi $t1, $t1, -4                   #   decrement $t1 by 4
                    j color_BOX_LOOP                   # }

            move_next_row:
                add $a0, $a0, $t1
                addi $a0, $a0, NEXT_ROW
                li $t1, 0
                j color_BOX_LOOP 

            color_scrn_LOOP_END:
                jr $ra                              # return 

    # Draw Player 
        # $a0 = Address (Last address)
        # $a2 = COLOR 
    draw_Player:

        li $t3, BLUE
        li $t2, DARK_BLUE
        li $t1, RED_P
  

        ble $s5, 3, dp_h1
        blt $s5, 5, dp_h2
        blt $s5, 7, dp_h3
        
        # If Health >= 7 
            sw $t3, 4($a0)
            sw $t3, 8($a0)
            sw $t3, 12($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t3, 0($a0)
            sw $t3, 16($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t3, 0($a0)
            sw $t3, 8($a0)
            sw $t3, 16($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down

            sw $t3, 0($a0)
            sw $t3, 16($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t3, 4($a0)
            sw $t3, 8($a0)
            sw $t3, 12($a0)

            j dp_exit
        # If Health < 7
        dp_h3:
            sw $t3, 4($a0)
            sw $t3, 8($a0)
            sw $t2, 12($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 0($a0)
            sw $t3, 16($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 0($a0)
            sw $t3, 8($a0)         
            sw $t1, 16($a0)          # red
            addi $a0, $a0, NEXT_ROW        # Move One row down

            sw $t2, 0($a0)
            sw $t3, 16($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 4($a0)
            sw $t1, 8($a0)          # Red
            sw $t3, 12($a0)
            j dp_exit
        # If Health < 5
        dp_h2:
            sw $t1, 4($a0)          # Red
            sw $t3, 8($a0)  
            sw $t1, 12($a0)         # Red
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 0($a0)
            sw $t3, 16($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 0($a0)
            sw $t3, 8($a0)         
            sw $t1, 16($a0)          # red
            addi $a0, $a0, NEXT_ROW        # Move One row down

            sw $t2, 0($a0)
            sw $t1, 16($a0)         # Red
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 4($a0)
            sw $t1, 8($a0)          # Red
            sw $t2, 12($a0)         
            j dp_exit
        # If Health <= 3
        dp_h1:
            sw $t1, 4($a0)          # Red
            sw $t2, 8($a0)  
            sw $t1, 12($a0)         # Red
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 0($a0)
            sw $t1, 16($a0)
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 0($a0)
            sw $t1, 8($a0)         
            sw $t1, 16($a0)         # Red
            addi $a0, $a0, NEXT_ROW        # Move One row down

            sw $t2, 0($a0)
            sw $t1, 16($a0)         # Red
            addi $a0, $a0, NEXT_ROW        # Move One row down
            
            sw $t2, 4($a0)
            sw $t1, 8($a0)          # Red
            sw $t1, 12($a0)         # Red

        dp_exit:
            jr $ra
    
    draw_damage:
        li $t9, ORANGE

        sw $t9, 4($a0)
        sw $t9, 8($a0)
        # sw $t9, 12($a0)
        addi $a0, $a0, NEXT_ROW        # Move One row down
        
        # sw $t9, 0($a0)
        sw $t9, 16($a0)
        addi $a0, $a0, NEXT_ROW        # Move One row down
        
        sw $t9, 0($a0)
        # sw $t9, 8($a0)
        # sw $t9, 16($a0)
        addi $a0, $a0, NEXT_ROW        # Move One row down

        # sw $t9, 0($a0)
        sw $t9, 16($a0)
        addi $a0, $a0, NEXT_ROW        # Move One row down
        
        # sw $t9, 4($a0)
        sw $t9, 8($a0)
        # sw $t9, 12($a0)
        
		jr	$ra


    # Draw all the Platforms (wrt level)
    draw_platform:
        addi $t0, $t0, 0        # Level 1
        addi $t1, $t1, 1        # Level 2
        addi $t2, $t2, 2        # Level 3
    
        
        beq $s2, $t0, ip_LEVEL_1
        beq $s2, $t1, ip_LEVEL_2
        beq $s2, $t2, ip_LEVEL_3

        ip_LEVEL_1:
            li $t9, BROWN
            li $t8, 0
            li $t7, 3
            

            addi $a0, $a0, -NEXT_ROW        # Move One row up
            ip_entire_row:
                sw	$t9, 0($a0)
                sw	$t9, 4($a0)
                sw	$t9, 8($a0)
                sw	$t9, 12($a0)
                sw	$t9, 16($a0)
                sw	$t9, 20($a0)     
                sw	$t9, 24($a0)     
                sw	$t9, 28($a0)     
                sw	$t9, 32($a0)     
                sw	$t9, 36($a0)     
                sw	$t9, 40($a0)     
                sw	$t9, 44($a0)     
                sw	$t9, 48($a0)     
                sw	$t9, 52($a0)     
                sw	$t9, 56($a0)     
                sw	$t9, 60($a0)     
                sw	$t9, 64($a0)     
                sw	$t9, 68($a0)     
                sw	$t9, 72($a0)     
                sw	$t9, 76($a0)     
                sw	$t9, 80($a0)     
                sw	$t9, 84($a0)     
                sw	$t9, 88($a0)     
                sw	$t9, 92($a0)     
                sw	$t9, 96($a0)     
                sw	$t9, 100($a0)     
                sw	$t9, 104($a0)     
                sw	$t9, 108($a0)     
                sw	$t9, 112($a0)     
                sw	$t9, 116($a0)     
                sw	$t9, 120($a0)     
                sw	$t9, 124($a0)     
                sw	$t9, 128($a0)     
                sw	$t9, 132($a0)     
                sw	$t9, 136($a0)     
                sw	$t9, 140($a0)     
                sw	$t9, 144($a0)     
                sw	$t9, 148($a0)     
                sw	$t9, 152($a0)     
                sw	$t9, 156($a0)     
                sw	$t9, 160($a0)     
                sw	$t9, 164($a0)     
                sw	$t9, 168($a0)     
                sw	$t9, 172($a0)     
                sw	$t9, 176($a0)     
                sw	$t9, 180($a0)     
                sw	$t9, 184($a0)     
                sw	$t9, 188($a0)     
                sw	$t9, 192($a0)     
                sw	$t9, 196($a0)     
                sw	$t9, 200($a0)     
                sw	$t9, 204($a0)
                sw	$t9, 208($a0)
                sw	$t9, 212($a0)
                sw	$t9, 216($a0)
                sw	$t9, 220($a0)     
                sw	$t9, 224($a0)     
                sw	$t9, 228($a0)     
                sw	$t9, 232($a0)     
                sw	$t9, 236($a0)     
                sw	$t9, 240($a0)     
                sw	$t9, 244($a0)     
                sw	$t9, 248($a0)     
                sw	$t9, 252($a0)     
                sw	$t9, 256($a0) 
            
            addi $a0, $a0, -NEXT_ROW        # Move One row up
            addi $t8, $t8, 1
            bne $t8, $t7, ip_entire_row 
            
            jr $ra

        
        ip_LEVEL_2:
            jr $ra
        
        ip_LEVEL_3:
            jr $ra

    # Draw Bricks
    draw_brick:
            li $t9, BROWN

            sw $t9, 0($a0)  
            sw $t9, 4($a0) 
            sw $t9, 8($a0) 
            sw $t9, 12($a0) 
            sw $t9, 16($a0) 
            sw $t9, 20($a0) 
            sw $t9, 24($a0) 
            sw $t9, 28($a0) 
            sw $t9, 32($a0) 
            addi $a0, $a0, NEXT_ROW
            sw $t9, 0($a0) 
            sw $t9, 4($a0) 
            sw $t9, 8($a0) 
            sw $t9, 12($a0) 
            sw $t9, 16($a0) 
            sw $t9, 20($a0) 
            sw $t9, 24($a0) 
            sw $t9, 28($a0) 
            sw $t9, 32($a0) 
            jr $ra

    # Draw Magma
    draw_magma:
        li $t9, RED
        sw $t9, 0($a0)
        sw $t9, 4($a0)
        addi $a0, $a0, NEXT_ROW
        sw $t9, 0($a0)
        sw $t9, 4($a0)
        jr $ra
    # Draw Coin
    draw_coin:
        li $t9, YELLOW
        sw $t9, 0($a0)
        sw $t9, 4($a0)
        sw $t9, 8($a0)
        addi $a0, $a0, NEXT_ROW
        sw $t9, 0($a0)
        sw $t9, 4($a0)
        sw $t9, 8($a0)
        addi $a0, $a0, NEXT_ROW
        sw $t9, 4($a0)
        addi $a0, $a0, NEXT_ROW
        sw $t9, 4($a0)
        addi $a0, $a0, NEXT_ROW
        sw $t9, 4($a0)
        sw $t9, 8($a0)
        jr $ra

    # Draw Game Over, you won and Start
        # When health == 0
            # draw GAME OVER
        draw_game_over:
            li $t0, RED
            addi $sp, $sp, -4
            sw $ra, 0($sp)

            # Draw Game Over
            # DISPLAY G
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                jal write_G
            # DISPLAY A
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 24
                jal write_A
            # DISPLAY M
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 48
                jal write_M
            # DISPLAY E
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 72
                jal write_E1

            # DISPLAY O
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 108
                jal write_O
            # DISPLAY V
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 128
                jal write_V
            # DISPLAY E
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 152
                jal write_E1
            # DISPLAY R
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 176
                jal write_R1

            lw $ra, 0($sp)		
            addi $sp, $sp, 4
            jr $ra
        # When level == 4
            # draw YOU WON
        draw_you_won:
            li $t0, WHITE
            addi $sp, $sp, -4
            sw $ra, 0($sp)

            # Draw You Won
            # DISPLAY Y
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                jal write_Y
            # DISPLAY O
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 20
                jal write_O
            # DISPLAY U
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 40
                jal write_U
                
            # DISPLAY W
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 64
                jal write_W
            # DISPLAY O
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 88
                jal write_O
            # DISPLAY N
                li $a1, DISPLAY_YOUWON
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 108
                jal write_N

            # Draw SCORE: HEALTH


            lw $ra, 0($sp)		
            addi $sp, $sp, 4
            jr $ra
        # Start
            # PLATFORM 
            #       FIRE 
        draw_startmenu:
            li $t0, WHITE
            addi $sp, $sp, -4
            sw $ra, 0($sp)
            # Display FIRE 
                # DISPLAY F
                li $a1, DISPLAY_FIRE
                addi $a1, $a1, BASE_ADDRESS
                jal write_F
                # DISPLAY I
                li $a1, DISPLAY_FIRE
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 24
                jal write_I
                # DISPLAY R
                li $a1, DISPLAY_FIRE
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 48
                jal write_R
                # DISPLAY E
                li $a1, DISPLAY_FIRE
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 72
                jal write_E


            # Display E to Start 
            
                # DISPLAY E
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                jal write_E2

                # DISPLAY T
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 24
                jal write_t
                # DISPLAY O
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 40
                jal write_o

                # DISPLAY S
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 64
                jal write_s
                # DISPLAY T
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 80
                jal write_t
                # DISPLAY A
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 96
                jal write_a
                # DISPLAY R
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 112
                jal write_r
                # DISPLAY T
                li $a1, DISPLAY_START
                addi $a1, $a1, BASE_ADDRESS
                addi $a1, $a1, 128
                jal write_t


            # Draw player and platform
            li $a0, PLAYER_INIT_ADDR
            li $s5, 10
            jal draw_Player

            li $a0, END_ADDRESS
            jal draw_platform

            lw $ra, 0($sp)		
            addi $sp, $sp, 4

            jr $ra	

        # Display letters
        write_G:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            jr $ra

        write_A:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)

            jr $ra

        write_M:
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 8($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)

            jr $ra
        write_E1:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            jr $ra
        write_E2:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            # sw $a0, 16($a1)
            
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            # sw $a0, 16($a1)

            jr $ra
        write_R1:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            

            jr $ra

        write_V:
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)

            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)

            jr $ra


        write_Y:
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)

            jr $ra
        write_O:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            
            jr $ra
        write_U:
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            
            jr $ra

        write_W:
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 8($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            
            jr $ra
        write_N:
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 8($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)

            jr $ra


        write_o:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 8($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 8($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 8($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            
            jr $ra
        write_p:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)
            
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 16($a1)
            sw $a0, 8($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 4($a1)
            # sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 12($a1)
            # sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # sw $a0, 16($a1)
            
            jr $ra
        write_s:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)
            
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)

            # addi $a1, $a1, NEXT_ROW
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            # sw $a0, 16($a1)
            sw $a0, 8($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)

            jr $ra


        write_t:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)
            
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0,8($a1)

            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 4($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 4($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 4($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 4($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 4($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 4($a1)

            jr $ra

        write_a:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 16($a1)
            sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 16($a1)
            sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 16($a1)
            sw $a0, 8($a1)

            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)

            jr $ra
        write_r:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)
            
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # # sw $a0, 16($a1)
            # sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 16($a1)
            sw $a0, 8($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            # sw $a0, 12($a1)
            # sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            # sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            # sw $a0, 12($a1)
            sw $a0, 8($a1)
            # addi $a1, $a1, NEXT_ROW
            # sw $a0, 0($a1)
            # sw $a0, 16($a1)
            

            jr $ra
        write_R:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 12($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 16($a1)
            

            jr $ra

        
        write_F:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)

            
            jr $ra

        write_I:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 8($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 8($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            jr $ra
        write_E:
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)

            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            addi $a1, $a1, NEXT_ROW
            sw $a0, 0($a1)
            sw $a0, 4($a1)
            sw $a0, 8($a1)
            sw $a0, 12($a1)
            sw $a0, 16($a1)


            jr $ra
# ===================================================================

# Initialize ========================================================
    init_bricks:
        # Save the address
        beq $s2, 0, ib_lvl1
        beq $s2, 1, ib_lvl2
        beq $s2, 2, ib_lvl3

        ib_lvl1:
        la $t0, level1_bricks_addr              # Start of Array 
        la $t1, level1_bricks_addr              # End of Array
        addi $t1, $t1, LEVEL1_BRICKS            # End of array
        la $t2, level1_bricks_loc
        j ib_continue

        ib_lvl2:
        la $t0, level2_bricks_addr              # Start of Array 
        la $t1, level2_bricks_addr              # End of Array
        addi $t1, $t1, LEVEL2_BRICKS            # End of array
        la $t2, level2_bricks_loc
        j ib_continue
        
        ib_lvl3:
        la $t0, level3_bricks_addr              # Start of Array 
        la $t1, level3_bricks_addr              # End of Array
        addi $t1, $t1, LEVEL3_BRICKS            # End of array
        la $t2, level3_bricks_loc
        j ib_continue


        ib_continue:
        addi $sp, $sp, -8           # Allocating space for $ra and $t0
        sw $ra, 4($sp)              # Pushing $ra
        
        ib_loop:                                # do{
            lw $a0, 0($t2)                          # load the location to place brick 
            sll	$a0, $a0, 2     						
            addi	$a0, $a0, BASE_ADDRESS			# Address 	
            sw	$a0, 0($t0)			                # Saving address in Array
            jal	draw_brick                          # Draw brick
            addi	$t0, $t0, 4                     # Increment
            addi	$t2, $t2, 4                     # Increment
            beq	$t0, $t1, ib_loop_exit				
            j ib_loop                           # } while(Start != End of array)
        ib_loop_exit:
            lw	$ra, 4($sp)		
            addi	$sp, $sp, 8
            jr	$ra							

    init_magma:
    
        beq $s2, 0, im_lvl1
        beq $s2, 1, im_lvl2
        beq $s2, 2, im_lvl3
        
        # IF level == 1
        im_lvl1:
            la $t0, magma           # Start of array
            la $t1, magma           # End of array
            addi $t1, $t1, NUM_MAGMA
            j im_continue
        # Else if level == 2 
        im_lvl2:
            la $t0, magma_2           # Start of array
            la $t1, magma_2           # End of array
            addi $t1, $t1, NUM_MAGMA_2
            j im_continue
        im_lvl3:
        # Else if level == 3
            la $t0, magma_3           # Start of array
            la $t1, magma_3           # End of array
            addi $t1, $t1, NUM_MAGMA_3
            j im_continue

        im_continue:
        addi $sp, $sp, -8
        sw $ra, 4($sp)

        im_loop:                                        # do{
            li $v0, 42
            li $a0, 0
            li $a1, 4000
            syscall
            # lw $a0, 0($t2)                          # load the location to place brick 
            sll	$a0, $a0, 2     						
            addi	$a0, $a0, BASE_ADDRESS			# Address 	
            sw	$a0, 0($t0)			                # Saving address in Array
            jal	draw_magma                          # Draw magma
            addi	$t0, $t0, 4                     # Increment
            # addi	$t2, $t2, 4                     # Increment
            beq	$t0, $t1, im_loop_exit				
            j im_loop                           # } while(Start != End of array)
        
        im_loop_exit:
            lw	$ra, 4($sp)		
            addi	$sp, $sp, 8
            jr	$ra							



    init_coins:
        beq $s2, 0, ic_lvl1
        beq $s2, 1, ic_lvl2
        beq $s2, 2, ic_lvl3
        
        # IF level == 1
        ic_lvl1:
            la $t0, coin              # Start of Array 
            la $t1, coin              # End of Array
            addi $t1, $t1, NUM_COINS            # End of array
            la $t2, level1_coin_loc
            j ic_continue
        # Else if level == 2 
        ic_lvl2:
            la $t0, coin_2              # Start of Array 
            la $t1, coin_2              # End of Array
            addi $t1, $t1, NUM_COINS_2            # End of array
            la $t2, level2_coin_loc
            j ic_continue
        ic_lvl3:
        # Else if level == 3
            la $t0, coin_3              # Start of Array 
            la $t1, coin_3            # End of Array
            addi $t1, $t1, NUM_COINS_3            # End of array
            la $t2, level3_coin_loc

            j ic_continue

        ic_continue:        
        addi $sp, $sp, -8           # Allocating space for $ra and $t0
        sw $ra, 4($sp)              # Pushing $ra
        
        # IF coin == 1
            # Skip
        # bge $s6, 1, ic_loop_exit

        ic_loop:                                # do{
            lw $a0, 0($t2)                          # load the location to place brick 
            sll	$a0, $a0, 2     						
            addi	$a0, $a0, BASE_ADDRESS			# Address 	
            sw	$a0, 0($t0)			                # Saving address in Array
            jal	draw_coin                          # Draw brick
            addi	$t0, $t0, 4                     # Increment
            addi	$t2, $t2, 4                     # Increment
            beq	$t0, $t1, ic_loop_exit				
            j ic_loop                           # } while(Start != End of array)
      		
        ic_loop_exit:
            lw	$ra, 4($sp)		
            addi	$sp, $sp, 8
            jr	$ra							


    move_magma:
        beq $s2, 0, mm_lvl1
        beq $s2, 1, mm_lvl2
        beq $s2, 2, mm_lvl3
        
        # IF level == 1
        mm_lvl1:
            la $t0, magma           # Start of array
            la $t1, magma           # End of array
            addi $t1, $t1, NUM_MAGMA
            j mm_continue
        # Else if level == 2 
        mm_lvl2:
            la $t0, magma_2           # Start of array
            la $t1, magma_2           # End of array
            addi $t1, $t1, NUM_MAGMA_2
            j mm_continue
        mm_lvl3:
        # Else if level == 3
            la $t0, magma_3           # Start of array
            la $t1, magma_3           # End of array
            addi $t1, $t1, NUM_MAGMA_3
            j mm_continue

        mm_continue:
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)

        mm_loop:
            lw $t2, 0($t0)                  # $t2 = magma[i]

            move $a0, $t2
            move $a1, $a0
            addi $a1, $a1, 520              # (64*2 + 2) *4
            li $t8, END_ADDRESS

            blt $a1, $t8, mm_loop_color     
            li $a1, END_ADDRESS

            mm_loop_color:
                li $a2, -8                  # 4*2 = 8 width

                addi $sp, $sp, -12           # save variables
                sw	$t0, 0($sp)
				sw	$t1, 4($sp)
				sw	$t2, 8($sp)

                jal color_scrn
                # move $a0, $s1
                # jal draw_Player

                lw	$t0, 0($sp)             # Restore variables
				lw	$t1, 4($sp)
				lw	$t2, 8($sp)
                addi $sp, $sp, 12
                
                li $t8, NEXT_ROW
                div $t2, $t8
                mfhi $t8
                beq $t8 $zero, mm_loop_color_find
                addi $t2, $t2, -4

            mm_loop_color_again:
                move $a0, $t2
                jal draw_magma
                sw $t2, 0($t0)      # Change the address
                addi $t0, $t0, 4

                beq $t0, $t1, mm_loop_exit
                j mm_loop
            mm_loop_color_find:
                li $v0, 42
                li $a0, 0
                li $a1, 30
                syscall

                addi $a0, $a0, 1
                li $t8, NEXT_ROW
                mult $t8, $a0
                mflo $t8
                addi $t8, $t8, -4
                addi $t8, $t8, BASE_ADDRESS
                move $t2, $t8
                j mm_loop_color_again
            mm_loop_exit:
                lw $ra, 0($sp)
                addi $sp, $sp, 4
                jr $ra


# ===================================================================



