	.data
	.balign 8
QueensStatic.row:
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.data
	.balign 8
QueensStatic.col:
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.data
	.balign 8
QueensStatic.diag1:
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.data
	.balign 8
QueensStatic.diag2:
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.text
QueensStatic.Solve:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	movq %r14, -32(%rbp)
	movq %r13, -24(%rbp)
	movq %r12, -16(%rbp)
	movq %rbx, -8(%rbp)
	movq %rdi,%rbx
L.26:
	movabsq $8,%rax
	cmpq %rax,%rbx
	je L.1
L.2:
	xorq %r14,%r14
	movq $7,%r12
	movq $1,%r13
L.4:
#	movq %r14,%r14
	leaq QueensStatic.row(%rip),%rax
	movq %rax,%rcx
	movq %r14,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq 0(%rcx),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.10
L.8:
	movq %r14,%rax
	addq %r13,%rax
	movq %rax,%r14
L.5:
	cmpq %r12,%r14
	jle L.4
L.6:
L.3:
	jmp L.0
L.1:
	call QueensStatic.Print
	jmp L.3
L.10:
	leaq QueensStatic.diag1(%rip),%rax
	movq %rax,%rcx
	movq %r14,%rax
	addq %rbx,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq 0(%rcx),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	jne L.8
L.9:
	leaq QueensStatic.diag2(%rip),%rax
	movq %rax,%rdx
	movq %r14,%rcx
	movabsq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	addq %rax,%rcx
	movq %rcx,%rax
	subq %rbx,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq 0(%rdx),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	jne L.8
L.7:
	leaq QueensStatic.row(%rip),%rax
	movq %rax,%rcx
	movq %r14,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $1,0(%rcx)
	leaq QueensStatic.diag1(%rip),%rax
	movq %rax,%rcx
	movq %r14,%rax
	addq %rbx,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $1,0(%rcx)
	leaq QueensStatic.diag2(%rip),%rax
	movq %rax,%rdx
	movq %r14,%rcx
	movabsq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	addq %rax,%rcx
	movq %rcx,%rax
	subq %rbx,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq $1,0(%rdx)
	leaq QueensStatic.col(%rip),%rax
	movq %rax,%rcx
	movq %rbx,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq %r14,0(%rcx)
	movq %rbx,%rax
	addq $1,%rax
	movq %rax,%rdi
	call QueensStatic.Solve
	leaq QueensStatic.row(%rip),%rax
	movq %rax,%rcx
	movq %r14,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	leaq QueensStatic.diag1(%rip),%rax
	movq %rax,%rcx
	movq %r14,%rax
	addq %rbx,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	leaq QueensStatic.diag2(%rip),%rax
	movq %rax,%rdx
	movq %r14,%rcx
	movabsq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	addq %rax,%rcx
	movq %rcx,%rax
	subq %rbx,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq $0,0(%rdx)
	jmp L.8
L.0:
#	returnSink
	movq -8(%rbp),%rbx
	movq -16(%rbp),%r12
	movq -24(%rbp),%r13
	movq -32(%rbp),%r14
	addq $32,%rsp
	popq %rbp
	ret
L.11:
	call badSub
	.text
QueensStatic.Print:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	movq %r15, -48(%rbp)
	movq %r14, -40(%rbp)
	movq %r13, -32(%rbp)
	movq %r12, -24(%rbp)
	movq %rbx, -16(%rbp)
L.27:
	xorq %r15,%r15
	movq $7,%rax
	movq %rax,-8(%rbp)
	movq $1,%rbx
L.13:
#	movq %r15,%r15
	xorq %r12,%r12
	movq $7,%r13
	movq $1,%r14
L.16:
#	movq %r12,%r12
	movabsq $32,%rax
	movq %rax,%rdi
	call _putchar
	leaq QueensStatic.col(%rip),%rax
	movq %rax,%rcx
	movq %r15,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq 0(%rcx),%rax
	cmpq %r12,%rax
	je L.20
L.21:
	movabsq $46,%rax
	movq %rax,%rdi
	call _putchar
L.22:
	movq %r12,%rax
	addq %r14,%rax
	movq %rax,%r12
L.17:
	cmpq %r13,%r12
	jle L.16
L.18:
	movabsq $10,%rax
	movq %rax,%rdi
	call _putchar
	movq %r15,%rax
	addq %rbx,%rax
	movq %rax,%r15
L.14:
	movq -8(%rbp),%rax
#	movq %rax,%rax
	cmpq %rax,%r15
	jle L.13
L.15:
	movabsq $10,%rax
	movq %rax,%rdi
	call _putchar
	jmp L.12
L.20:
	movabsq $81,%rax
	movq %rax,%rdi
	call _putchar
	jmp L.22
L.12:
#	returnSink
	movq -16(%rbp),%rbx
	movq -24(%rbp),%r12
	movq -32(%rbp),%r13
	movq -40(%rbp),%r14
	movq -48(%rbp),%r15
	addq $48,%rsp
	popq %rbp
	ret
L.19:
	call badSub
	.text
QueensStatic:
	pushq %rbp
	movq %rsp,%rbp
L.28:
	xorq %rax,%rax
	movq %rax,%rdi
	call QueensStatic.Solve
#	returnSink
	popq %rbp
	ret
L.23:
	call badSub
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.29:
	call QueensStatic
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.24:	.asciz	"Attempt to use a null pointer"
	.text
badPtr:
	pushq %rbp
	movq %rsp,%rbp
L.30:
	leaq L.24(%rip),%rax
	movq %rax,%rdi
	call _puts
	movabsq $1,%rax
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.25:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.31:
	leaq L.25(%rip),%rax
	movq %rax,%rdi
	call _puts
	movabsq $1,%rax
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
