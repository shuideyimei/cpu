# Test program for syscall instruction
# Tests syscall 1 (print integer) and syscall 10 (exit)

.text
main:
    # Test syscall 1: Print integer
    # Set $v0 = 1 (print integer)
    ori $v0, $0, 1
    # Set $a0 = 42 (value to print)
    ori $a0, $0, 42
    syscall
    
    # Test syscall 10: Exit program
    # Set $v0 = 10 (exit)
    ori $v0, $0, 10
    syscall

