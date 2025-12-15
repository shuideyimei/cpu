.data

data0: .space 4

data1: .space 4

data2: .space 4


.text

ori $31, $0, 0x3000
lui $0, 56825
ori $0, $0, 54021
lui $1, 20129
ori $1, $1, 25122
lui $2, 3239
ori $2, $2, 37791
lui $3, 7797
ori $3, $3, 28810
lui $4, 42502
ori $4, $4, 21248
lui $5, 62883
ori $5, $5, 54691
lui $6, 4705
ori $6, $6, 62177
lui $7, 5235
ori $7, $7, 9815
lui $8, 34894
ori $8, $8, 25266
lui $9, 26471
ori $9, $9, 24971
lui $10, 65407
ori $10, $10, 55521
lui $11, 37472
ori $11, $11, 25755
lui $12, 55283
ori $12, $12, 5278
lui $13, 29385
ori $13, $13, 39327
lui $14, 65432
ori $14, $14, 14952
lui $15, 61332
ori $15, $15, 45547
lui $16, 51708
ori $16, $16, 16580
lui $17, 34783
ori $17, $17, 3824
lui $18, 51308
ori $18, $18, 2789
lui $19, 3206
ori $19, $19, 65410
sw $15, data0
sw $12, data1
label5:
sw $12, data2
srlv $15,$19,$17
and $1,$15,$5
subu $14,$5,$12
nor $10,$17,$16
lw $17,data0
multu $18,$18
andi $7,$7,2
lh $16,data2($7)
xori $9,$12,51139
srlv $14,$19,$9
nor $9,$5,$0
lw $2,data1
srl $4,$2,5
sra $16,$4,29
or $13,$11,$6
mtlo $19
div $10,$6
divu $6,$18
xori $7,$3,56225
and $10,$19,$12
lui $8,1066
sw $0,data1
div $0,$13
xori $5,$5,7412
ori $4,$6,55136
label4:
lui $8,22805
divu $3,$9
srlv $4,$9,$17
mtlo $7
sllv $19,$19,$15
andi $1,$1,3
lbu $17,data0($1)
label6:
mult $31,$7
sra $2,$7,16
divu $11,$12
addu $6,$15,$9
xori $10,$4,15862
add $5,$12,$16
addiu $12,$1,39766
mflo $7
label0:
or $19,$11,$8
srlv $6,$11,$13
slt $6,$18,$14
andi $13,$19,22465
sllv $16,$6,$19
div $19,$5
mtlo $11
divu $12,$5
xor $0,$18,$16
srl $18,$19,15
andi $15,$15,3
lbu $4,data1($15)
div $19,$1
or $10,$15,$10
bne $12,$9,label3
ori $14,$4,54540
sub $6,$12,$7
j label2
andi $2,$2,3
lb $2,data1($2)
nor $3,$4,$8
divu $3,$12
divu $31,$5
multu $16,$11
bltz $3,label1
mflo $9
sll $2,$15,29
sra $16,$13,11
mflo $18
jr $ra
srlv $14,$11,$15
subu $10,$14,$19
andi $8,$8,3
lb $7,data0($8)
sub $9,$19,$13
addu $4,$5,$5
lw $0,data1
mtlo $17
mtlo $12
label3:
andi $12,$12,2
lh $12,data1($12)
sllv $15,$7,$13
lw $3,data1
andi $1,$1,3
sb $17,data2($1)
div $2,$0
xor $10,$12,$18
j label2
lui $8,64825
andi $14,$14,3
lb $13,data2($14)
srav $7,$13,$2
subu $18,$7,$9
mthi $10
jal label6
sra $13,$17,29
mflo $8
label1:
sra $4,$14,23
nor $10,$6,$13
andi $8,$17,1542
addu $15,$9,$6
label2:
mflo $10
mtlo $19
or $15,$31,$17
lui $6,20356
div $2,$19
and $9,$0,$2
bgtz $9,label0
ori $v0, $0, 10
syscall