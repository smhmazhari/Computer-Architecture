.global _boot

.text
_boot:
    lw x8,1000(x0)    
    addi x6,x0,4
    loop: slti x7,x6,40
        beq x7,x0,endloop
        lw x9,1000(x6)
    if: slt x1,x9,x8
        beq x1,x0,endif
        add x8,x0,x9
    endif: addi x6,x6,4
    j loop
    endloop:
    lui x10, 3
    jal x11, 2
        
