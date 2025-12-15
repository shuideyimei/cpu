.data

data0: .space 4

data1: .space 4

data2: .space 4


.text

ori $31, $0, 0x3000
lui $0, 39524
ori $0, $0, 46061
lui $1, 27526
ori $1, $1, 48475
lui $2, 25562
ori $2, $2, 158
lui $3, 64141
ori $3, $3, 31408
lui $4, 2298
ori $4, $4, 39915
lui $5, 46173
ori $5, $5, 31899
label5:
lui $6, 30811
ori $6, $6, 31880
lui $7, 3080
ori $7, $7, 56299
lui $8, 28394
ori $8, $8, 31645
lui $9, 49535
ori $9, $9, 56773
lui $10, 2777
ori $10, $10, 13103
lui $11, 40402
ori $11, $11, 56688
lui $12, 9590
ori $12, $12, 36232
lui $13, 49528
ori $13, $13, 4880
lui $14, 57489
ori $14, $14, 5064
lui $15, 14368
ori $15, $15, 30390
lui $16, 32912
ori $16, $16, 44325
lui $17, 61630
ori $17, $17, 47835
lui $18, 22660
ori $18, $18, 53438
lui $19, 26762
ori $19, $19, 11917
sw $0, data0
sw $17, data1
sw $11, data2
addu $6,$6,$16
divu $12,$2
sltu $8,$10,$0
mfhi $10
addi $13,$12,24928
andi $13,$13,2
sh $5,data1($13)
addi $12,$19,19296
xor $16,$9,$19
andi $15,$15,2
sh $8,data0($15)
subu $19,$19,$4
sub $18,$17,$8
addi $16,$9,31894
div $9,$6
subu $13,$31,$2
xor $19,$31,$7
lw $6,data1
sltu $4,$14,$15
sltu $13,$0,$19
srlv $12,$9,$0
andi $13,$0,19376
divu $14,$2
lw $6,data0
slt $11,$6,$3
multu $7,$3
mthi $14
slti $6,$16,7528
slti $12,$9,2250
mthi $18
srl $18,$0,11
label1:
mtlo $2
lw $4,data2
addiu $10,$14,3052
lui $13,17599
addiu $7,$12,2960
divu $16,$0
nor $11,$7,$13
div $10,$14
label3:
multu $19,$4
addi $14,$12,40680
srav $7,$4,$1
andi $8,$8,2
sh $8,data1($8)
multu $9,$19
andi $4,$4,2
lh $16,data1($4)
bgtz $5,label1
mtlo $17
slti $5,$9,6348
sra $1,$15,26
mthi $11
blez $31,label2
srav $16,$7,$11
bgez $7,label1
mflo $15
sra $0,$19,26
and $14,$4,$6
label4:
andi $7,$7,3
sb $11,data1($7)
slt $0,$8,$2
jr $ra
srlv $19,$1,$3
multu $4,$15
multu $6,$0
andi $19,$15,48028
srlv $8,$0,$19
or $11,$9,$9
label0:
addu $16,$7,$16
andi $2,$2,2
lhu $10,data1($2)
j label5
andi $13,$19,19747
addi $14,$13,18510
xor $5,$31,$16
label2:
bgez $10,label4
nor $3,$16,$8
mflo $19
srlv $1,$13,$17
mfhi $5
xori $5,$13,21143
andi $15,$15,2
lh $18,data0($15)
bltz $11,label1
andi $17,$17,3
sb $12,data1($17)
label6:
andi $6,$6,3
lb $3,data2($6)
lw $7,data1
srl $15,$31,23
and $8,$18,$2
multu $0,$2
beq $3,$8,label1
andi $15,$15,3
sb $3,data1($15)
j label1
xori $2,$0,11921
ori $12,$14,26089
addiu $15,$1,55500
subu $16,$19,$14
mtlo $16
or $19,$2,$5
and $4,$2,$18
jr $ra
mthi $3
andi $18,$18,3
sb $13,data2($18)
xor $15,$7,$11
andi $16,$16,2
lhu $12,data2($16)
mfhi $18
andi $2,$2,2
sh $12,data1($2)
ori $v0, $0, 10
syscall