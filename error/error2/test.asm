.data

data0: .space 4

data1: .space 4

data2: .space 4


.text

ori $31, $0, 0x3000
lui $0, 9141
ori $0, $0, 45150
lui $1, 63509
ori $1, $1, 39894
lui $2, 59598
ori $2, $2, 19888
lui $3, 60905
ori $3, $3, 28128
lui $4, 45223
ori $4, $4, 16468
lui $5, 22855
ori $5, $5, 50438
lui $6, 38883
ori $6, $6, 33453
lui $7, 48886
ori $7, $7, 28015
lui $8, 22084
ori $8, $8, 51538
lui $9, 27518
ori $9, $9, 36274
lui $10, 33848
ori $10, $10, 4718
lui $11, 46213
ori $11, $11, 16808
lui $12, 24838
ori $12, $12, 22707
lui $13, 13525
ori $13, $13, 32522
label0:
lui $14, 18679
label6:
ori $14, $14, 5768
lui $15, 19939
ori $15, $15, 52904
lui $16, 17978
ori $16, $16, 49092
lui $17, 16074
ori $17, $17, 62216
lui $18, 48747
ori $18, $18, 9415
lui $19, 53855
ori $19, $19, 64681
sw $10, data0
sw $16, data1
sw $19, data2
divu $14,$6
sra $15,$8,23
or $19,$10,$5
nor $16,$15,$3
lui $1,39948
nor $18,$19,$12
mult $13,$6
andi $3,$3,3
sb $12,data1($3)
or $13,$14,$14
div $19,$9
andi $15,$15,3
sb $0,data0($15)
nor $2,$19,$4
srav $14,$8,$31
or $1,$10,$0
and $14,$3,$14
andi $11,$11,3
lb $14,data2($11)
sllv $0,$5,$12
andi $6,$6,3
sb $12,data2($6)
xori $2,$0,20804
sll $18,$19,14
divu $4,$18
addi $14,$0,58078
subu $19,$19,$7
ori $3,$8,49217
sll $12,$16,13
sltiu $11,$17,30252
andi $17,$17,3
lb $17,data0($17)
andi $4,$4,2
lh $3,data0($4)
srlv $0,$31,$19
subu $15,$19,$31
nor $4,$15,$4
subu $7,$9,$3
addi $2,$6,54787
andi $10,$10,2
sh $0,data2($10)
mult $15,$10
and $12,$11,$16
andi $3,$3,2
lhu $11,data0($3)
andi $7,$7,3
lbu $13,data1($7)
srav $4,$17,$15
and $11,$5,$17
srl $19,$14,16
sltu $18,$11,$15
mult $5,$6
andi $13,$13,3
lb $0,data0($13)
label5:
xori $11,$16,38396
slti $4,$0,6438
xori $9,$12,45239
divu $7,$9
mtlo $3
sltu $13,$5,$8
beq $18,$5,label2
andi $4,$14,13495
label4:
sub $10,$9,$14
mtlo $6
multu $14,$15
mfhi $6
sll $17,$2,18
bltz $16,label6
addu $4,$12,$7
divu $16,$3
sltiu $1,$0,11354
sll $8,$15,30
sub $9,$11,$11
mthi $3
label1:
addi $16,$31,47969
subu $4,$6,$11
nor $5,$13,$9
srav $4,$17,$12
addiu $17,$1,27848
mflo $11
nor $7,$13,$31
div $8,$5
slt $10,$10,$1
addiu $7,$15,53847
sltu $9,$15,$16
bne $31,$12,label2
label2:
mfhi $17
andi $14,$14,2
lhu $3,data2($14)
subu $11,$13,$18
bgtz $6,label2
addu $9,$5,$12
bgtz $12,label5
srl $16,$12,0
srlv $18,$15,$9
nor $2,$12,$8
sra $14,$16,8
beq $17,$19,label2
andi $18,$18,2
lhu $6,data1($18)
bgez $11,label1
label3:
addiu $13,$18,63116
andi $2,$2,2
lhu $11,data2($2)
jal label1
slt $8,$4,$17
bne $12,$31,label4
mthi $19
lw $9,data0
jal label6
andi $10,$10,2
lhu $4,data2($10)
jr $ra
sra $5,$8,18
ori $v0, $0, 10
syscall