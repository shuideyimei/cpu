.data

data0: .space 4

data1: .space 4

data2: .space 4


.text

ori $31, $0, 0x3000
lui $0, 15720
ori $0, $0, 6435
lui $1, 17778
ori $1, $1, 21145
lui $2, 16207
ori $2, $2, 29858
lui $3, 44663
ori $3, $3, 27585
lui $4, 40789
ori $4, $4, 39360
lui $5, 14312
ori $5, $5, 40758
label3:
lui $6, 61929
ori $6, $6, 56840
lui $7, 61964
ori $7, $7, 46591
lui $8, 33457
ori $8, $8, 37846
lui $9, 33234
ori $9, $9, 12005
lui $10, 32968
ori $10, $10, 9881
lui $11, 31240
ori $11, $11, 54159
lui $12, 36568
ori $12, $12, 17423
lui $13, 18504
ori $13, $13, 11559
lui $14, 1652
ori $14, $14, 41457
lui $15, 58038
ori $15, $15, 8843
lui $16, 2370
ori $16, $16, 26205
lui $17, 7202
ori $17, $17, 12682
lui $18, 55352
ori $18, $18, 34223
lui $19, 62605
ori $19, $19, 8001
sw $8, data0
sw $2, data1
sw $13, data2
addu $4,$8,$2
mflo $7
addiu $0,$19,24895
addi $2,$18,35474
ori $8,$14,1794
label5:
mtlo $19
sra $5,$9,18
mthi $13
label0:
add $15,$11,$5
srlv $19,$19,$8
srav $5,$12,$8
subu $0,$16,$9
andi $1,$1,3
lbu $17,data1($1)
addi $11,$3,54139
slt $7,$11,$17
srl $3,$0,2
addiu $10,$6,42273
sw $7,data2
mflo $5
sllv $8,$6,$0
andi $19,$19,3
sb $7,data2($19)
or $13,$3,$14
sltiu $4,$19,1086
srlv $2,$9,$17
sra $4,$15,12
ori $19,$0,48636
label1:
slti $6,$19,-19962
andi $13,$13,3
lbu $12,data1($13)
srlv $19,$4,$6
lw $11,data0
add $10,$18,$5
sllv $15,$31,$6
sltiu $19,$12,2052
andi $12,$12,2
lhu $17,data1($12)
addi $4,$13,48770
div $19,$18
div $12,$5
andi $1,$1,3
lb $5,data1($1)
sw $1,data1
srav $10,$18,$11
div $10,$12
blez $19,label1
andi $5,$5,3
lb $15,data2($5)
or $14,$15,$3
srlv $3,$9,$4
sra $18,$6,3
div $5,$6
bgez $2,label3
sltu $18,$19,$31
mtlo $9
nor $2,$13,$13
label6:
j label3
addu $13,$10,$16
srav $18,$8,$4
bgez $12,label0
sw $17,data0
bgez $13,label0
mfhi $14
jal label1
andi $9,$9,2
lh $17,data0($9)
add $0,$16,$9
sub $0,$15,$10
add $6,$0,$19
add $3,$8,$15
xor $4,$16,$12
bltz $3,label3
ori $6,$3,55790
lw $3,data0
xor $2,$1,$5
j label2
sub $12,$17,$4
jal label4
mthi $11
j label6
srl $8,$13,29
sll $11,$0,9
bne $9,$16,label5
andi $13,$13,3
lb $2,data1($13)
andi $17,$17,3
lb $11,data1($17)
mult $9,$16
xori $13,$15,28160
mflo $4
andi $5,$11,39369
sub $7,$2,$13
label2:
label4:
andi $7,$7,3
sb $15,data1($7)
srlv $1,$19,$4
sllv $12,$17,$0
srav $2,$0,$0
srlv $1,$19,$17
sll $9,$5,29
sllv $0,$31,$11
andi $12,$12,2
lh $19,data2($12)
addu $18,$16,$4
mtlo $3
sltiu $3,$31,10393
div $8,$14
slt $17,$4,$12
andi $11,$11,3
lbu $12,data0($11)
addi $0,$0,38773
divu $0,$2
ori $v0, $0, 10
syscall