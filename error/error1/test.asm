.data

data0: .space 4

data1: .space 4

data2: .space 4


.text

ori $31, $0, 0x3000
lui $0, 50586
ori $0, $0, 22042
lui $1, 53540
label0:
ori $1, $1, 17422
lui $2, 62381
ori $2, $2, 12163
lui $3, 60682
ori $3, $3, 64156
lui $4, 24699
ori $4, $4, 5170
lui $5, 59150
ori $5, $5, 28272
lui $6, 41877
ori $6, $6, 62394
lui $7, 55102
ori $7, $7, 38643
lui $8, 64167
ori $8, $8, 10608
lui $9, 17083
ori $9, $9, 21024
lui $10, 65056
ori $10, $10, 35242
lui $11, 26969
label3:
ori $11, $11, 45448
lui $12, 53112
ori $12, $12, 45700
lui $13, 11163
ori $13, $13, 13358
label5:
lui $14, 37884
ori $14, $14, 4234
lui $15, 13246
ori $15, $15, 1107
lui $16, 18240
ori $16, $16, 58981
lui $17, 28143
ori $17, $17, 16097
lui $18, 1231
ori $18, $18, 16457
lui $19, 61221
ori $19, $19, 64713
sw $4, data0
label1:
sw $17, data1
sw $9, data2
addiu $5,$3,14124
xor $9,$2,$12
addu $2,$6,$7
addiu $13,$4,50464
divu $12,$7
andi $13,$13,3
lb $17,data2($13)
addu $19,$14,$14
and $15,$16,$13
mfhi $4
addiu $12,$10,295
sra $13,$1,6
xor $1,$9,$3
and $12,$11,$4
andi $2,$2,2
lh $14,data1($2)
andi $9,$12,48277
or $19,$17,$2
andi $15,$4,42340
andi $5,$1,16093
andi $3,$3,3
sb $16,data0($3)
xori $13,$19,65006
andi $0,$0,3
sb $3,data2($0)
ori $2,$14,46299
sllv $12,$18,$0
srl $10,$2,19
srav $11,$10,$5
mthi $19
add $11,$4,$9
srl $18,$16,4
sw $15,data1
andi $19,$19,2
lh $11,data0($19)
andi $13,$13,2
lhu $5,data1($13)
sub $7,$4,$1
or $15,$31,$0
sra $13,$12,0
label2:
srav $10,$31,$31
andi $18,$4,13158
mflo $17
slti $15,$8,23741
andi $16,$16,3
lbu $9,data0($16)
and $7,$10,$10
sll $19,$15,21
lw $15,data0
addi $5,$18,26574
andi $5,$5,2
sh $4,data2($5)
label4:
lw $4,data1
blez $4,label4
multu $9,$11
srl $10,$9,6
mflo $9
mult $1,$0
mflo $9
andi $3,$8,46925
bltz $10,label0
andi $14,$16,60624
subu $9,$8,$17
sub $4,$3,$10
slti $15,$1,-2002
xor $16,$13,$1
andi $11,$11,3
lbu $15,data2($11)
or $2,$10,$19
andi $1,$17,7712
mult $6,$16
jal label5
sll $4,$8,2
slti $16,$8,9989
addi $5,$5,14669
multu $13,$4
mult $10,$12
label6:
srlv $9,$31,$9
j label3
addiu $8,$3,56037
andi $2,$2,2
lh $5,data1($2)
blez $7,label5
andi $18,$18,3
lb $19,data0($18)
mfhi $4
ori $7,$18,8833
andi $18,$18,2
lhu $19,data1($18)
addiu $13,$4,52972
sltiu $6,$5,20820
jal label0
subu $10,$4,$3
slt $14,$4,$7
addu $7,$18,$6
blez $12,label0
andi $2,$2,2
lhu $6,data2($2)
bgez $10,label6
lui $2,36553
mtlo $19
andi $0,$0,2
lh $9,data2($0)
or $10,$11,$18
blez $14,label6
srav $13,$2,$16
lui $19,35724
sra $19,$1,9
subu $0,$6,$15
sltu $3,$17,$4
addiu $6,$19,54408
lw $6,data2
sltiu $12,$10,10414
lui $19,54115
ori $v0, $0, 10
syscall