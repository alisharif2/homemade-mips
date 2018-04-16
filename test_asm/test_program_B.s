# Extrenous Looping
# r31: 0x16
# r30: 0xF
# r29: 0x0
# r28: 0xF
# r27: 0x0
# r26: 0x0
# r25: 0x0
# r24: 0x0
# r23: 0x0
# r22: 0x0
# r21: 0x0
# r19: 0x0
# r18: 0x0
# r17: 0x0
# r16: 0x0
# r15: 0x0
# r14: 0x0
# r13: 0x0
# r12: 0x0
# r11: 0x0
# r10: 0x0
# r9:  0x0
# r8:  0x25
# r7:  0x25
# r6:  0x0
# r5:  0x0
# r4:  0x20
# r3:  0x10
# r2:  0x100
# r1:  0x100
# r0:  0x0

start: beq $1, $2, main
beq $2, $0, main
add $3, $2, $1
jal end
j end
j terminate
main: addi $1, $0, 15
addi $2, $0, 16
j start
end: addi $31, $31, 1
jr $31
terminate: addi $30, $0, 15
