.data

data0: .space 4

data1: .space 4

data2: .space 4


.text

ori $31, $0, 0x3000
lui $0, 30550
ori $0, $0, 61142
lui $1, 55957
ori $1, $1, 37334
lui $2, 27165
ori $2, $2, 36194
lui $3, 4483
ori $3, $3, 64125
lui $4, 22274
ori $4, $4, 47504
label4:
lui $5, 32589
ori $5, $5, 43016
lui $6, 33846
ori $6, $6, 22843
lui $7, 5146
ori $7, $7, 19750
lui $8, 36621
ori $8, $8, 11568
lui $9, 24761
ori $9, $9, 43459
lui $10, 29574
ori $10, $10, 59967
lui $11, 21558
ori $11, $11, 37795
lui $12, 1681
ori $12, $12, 30509
lui $13, 64857
ori $13, $13, 36633
lui $14, 5076
ori $14, $14, 36813
lui $15, 34093
ori $15, $15, 6366
lui $16, 33621
ori $16, $16, 7045
lui $17, 31385
ori $17, $17, 60282
lui $18, 60441
ori $18, $18, 17050
lui $19, 45131
ori $19, $19, 32875
sw $19, data0
sw $13, data1
sw $2, data2
label3:
or $11,$7,$1
mthi $15
andi $7,$7,2
lhu $14,data2($7)
andi $6,$6,3
lbu $7,data1($6)
andi $5,$5,3
lb $12,data1($5)
label5:
xori $10,$0,24970
mthi $16
sra $3,$4,17
sw $17,data0
andi $14,$14,2
sh $4,data1($14)
label6:
addu $14,$16,$18
nor $5,$9,$11
sub $7,$5,$1
sll $2,$4,12
sllv $8,$12,$15
slt $3,$10,$6
sltu $0,$12,$3
xori $5,$5,32159
mthi $14
srl $7,$18,25
slt $5,$17,$16
srlv $9,$17,$4
lw $0,data1
subu $12,$18,$9
div $12,$8
sllv $1,$6,$8
mthi $12
lw $17,data2
add $17,$16,$14
mthi $4
lui $18,45096
mtlo $13
ori $18,$5,51292
andi $15,$15,2
sh $3,data2($15)
sltiu $13,$31,20223
sra $13,$6,1
and $16,$15,$18
srav $0,$5,$16
or $2,$14,$14
slti $12,$11,4391
bne $2,$31,label6
srlv $0,$6,$15
bgtz $10,label6
label2:
andi $19,$19,2
lh $10,data1($19)
andi $10,$10,3
sb $3,data2($10)
bgez $2,label0
sltu $19,$3,$6
lw $2,data2
andi $2,$2,3
sb $13,data2($2)
andi $5,$5,2
lhu $19,data2($5)
mult $12,$11
and $0,$15,$19
srl $0,$13,24
andi $19,$19,3
lb $5,data2($19)
slt $18,$18,$7
xori $13,$10,60858
srav $6,$31,$10
ori $18,$9,1761
bgez $14,label4
mtlo $6
subu $10,$17,$18
label0:
or $5,$9,$5
and $11,$5,$7
andi $18,$18,2
lhu $11,data0($18)
label1:
mthi $5
xori $11,$13,25148
addi $19,$9,39433
subu $11,$12,$16
blez $12,label0
add $14,$15,$11
multu $2,$0
andi $1,$1,3
lb $3,data0($1)
andi $4,$4,3
lb $15,data0($4)
blez $13,label4
addiu $8,$12,36064
andi $16,$16,2
lh $17,data0($16)
and $2,$10,$31
mtlo $14
andi $5,$5,3
sb $7,data1($5)
andi $18,$13,30672
blez $7,label2
srl $8,$11,28
andi $16,$16,2
lhu $6,data0($16)
div $18,$17
mfhi $3
bgtz $15,label4
addiu $1,$12,65396
addu $8,$5,$11
lui $12,3693
jal label5
div $19,$9
andi $16,$16,3
lb $3,data0($16)
srlv $9,$19,$19
slti $3,$12,3074
andi $0,$0,2
lh $19,data2($0)
mtlo $5
divu $7,$7
beq $8,$18,label5
or $4,$3,$9
div $13,$1
ori $v0, $0, 10
syscall