.data

data0: .space 4

data1: .space 4

data2: .space 4


.text

ori $31, $0, 0x3000
lui $0, 29985
ori $0, $0, 18832
lui $1, 19369
ori $1, $1, 61921
lui $2, 49565
ori $2, $2, 58068
lui $3, 32910
label1:
ori $3, $3, 52542
lui $4, 14351
ori $4, $4, 23560
lui $5, 57012
ori $5, $5, 46491
lui $6, 40771
ori $6, $6, 25161
lui $7, 3987
ori $7, $7, 43884
lui $8, 13993
ori $8, $8, 15872
lui $9, 36389
ori $9, $9, 42161
lui $10, 46939
ori $10, $10, 61969
lui $11, 47451
ori $11, $11, 40358
lui $12, 28280
ori $12, $12, 31018
lui $13, 6887
ori $13, $13, 2650
lui $14, 59772
ori $14, $14, 51574
lui $15, 46178
ori $15, $15, 26565
lui $16, 25596
ori $16, $16, 62182
lui $17, 35488
ori $17, $17, 57825
lui $18, 33369
ori $18, $18, 49783
lui $19, 7072
ori $19, $19, 20571
label4:
sw $13, data0
sw $31, data1
sw $15, data2
mflo $18
div $16,$18
mtlo $3
add $0,$10,$15
multu $15,$3
sll $11,$9,27
subu $11,$31,$3
xor $13,$0,$12
xori $13,$3,43499
sw $7,data1
nor $14,$10,$5
mtlo $14
andi $12,$12,2
sh $19,data2($12)
srav $11,$18,$11
slt $3,$14,$7
slt $18,$1,$4
and $13,$10,$7
andi $6,$6,3
lbu $4,data0($6)
xori $16,$15,3206
addiu $4,$5,39118
srav $2,$10,$19
srav $14,$5,$14
sll $15,$12,10
mfhi $15
sw $18,data0
label5:
sll $13,$11,17
sltu $4,$19,$2
addi $9,$1,59077
xori $13,$12,30955
andi $1,$1,2
lh $12,data2($1)
ori $16,$13,14636
ori $5,$17,53884
mflo $5
andi $9,$9,3
lbu $1,data2($9)
andi $5,$5,2
lh $16,data1($5)
addi $6,$13,20158
slt $3,$10,$5
add $15,$18,$1
div $1,$4
sllv $18,$9,$0
andi $4,$14,40784
and $19,$5,$9
divu $19,$3
xor $18,$11,$4
ori $17,$8,10998
j label0
mfhi $1
sltiu $17,$3,2048
sllv $9,$18,$1
mfhi $6
xor $11,$31,$4
and $4,$19,$5
label0:
andi $8,$6,3932
lw $16,data1
sltu $2,$6,$3
mthi $11
bgez $8,label1
sltiu $8,$31,17853
mfhi $16
srav $8,$6,$31
ori $13,$14,3530
j label4
nor $1,$14,$18
multu $8,$8
sra $2,$13,6
j label4
lui $11,4696
sllv $2,$0,$5
bgez $3,label2
andi $3,$3,3
lb $9,data0($3)
lui $8,4281
addi $19,$18,34124
lw $18,data2
label6:
divu $8,$3
mult $17,$10
andi $5,$5,3
sb $12,data1($5)
srlv $6,$13,$16
jr $ra
xori $16,$12,2255
beq $5,$17,label0
sltiu $12,$8,20195
div $5,$11
mult $13,$19
lui $10,9239
andi $3,$3,2
lh $17,data0($3)
mtlo $3
mflo $3
slti $10,$4,-18484
andi $18,$18,56223
label3:
sltu $12,$31,$15
srlv $15,$9,$8
srav $10,$1,$0
slt $0,$11,$19
andi $11,$11,3
lbu $7,data2($11)
blez $6,label4
andi $2,$2,2
sh $7,data0($2)
label2:
mthi $5
addi $9,$12,38484
div $12,$5
ori $18,$7,639
ori $v0, $0, 10
syscall