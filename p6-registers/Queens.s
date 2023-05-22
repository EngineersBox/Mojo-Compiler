	.data
	.balign 8
Queens.Queens:
	.quad Queens.Init
	.quad Queens.Solve
	.text
Queens.Init:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movq %rbx, -8(%rbp)
	movq %rdi,%rbx
L.64:
#	movq %rbx,%rbx
	xorq %rax,%rax
	cmpq %rax,%rbx
	je L.1
L.2:
	movabsq $64,%rdi
#	movq %rdi,%rdi
	call _malloc
#	movq %rax,%rax
	movq $8,%rdi
	xorq %rcx,%rcx
	cmpq %rdi,%rcx
	jge L.4
L.3:
	movq %rax,%rsi
	movq %rcx,%rdx
	shlq $3,%rdx
	addq %rdx,%rsi
	movq $0,0(%rsi)
#	movq %rcx,%rcx
	addq $1,%rcx
#	movq %rcx,%rcx
	cmpq %rdi,%rcx
	jl L.3
L.4:
	movq %rax,0(%rbx)
#	movq %rbx,%rbx
	xorq %rax,%rax
	cmpq %rax,%rbx
	je L.1
L.5:
	movabsq $64,%rdi
#	movq %rdi,%rdi
	call _malloc
#	movq %rax,%rax
	movq $8,%rdi
	xorq %rcx,%rcx
	cmpq %rdi,%rcx
	jge L.7
L.6:
	movq %rax,%rsi
	movq %rcx,%rdx
	shlq $3,%rdx
	addq %rdx,%rsi
	movq $0,0(%rsi)
#	movq %rcx,%rcx
	addq $1,%rcx
#	movq %rcx,%rcx
	cmpq %rdi,%rcx
	jl L.6
L.7:
	movq %rax,8(%rbx)
#	movq %rbx,%rbx
	xorq %rax,%rax
	cmpq %rax,%rbx
	je L.1
L.8:
	movabsq $120,%rdi
#	movq %rdi,%rdi
	call _malloc
#	movq %rax,%rax
	movabsq $8,%rcx
#	movq %rcx,%rcx
	addq $8,%rcx
#	movq %rcx,%rcx
	subq $1,%rcx
#	movq %rcx,%rcx
	xorq %rdx,%rdx
	cmpq %rcx,%rdx
	jge L.10
L.9:
	movq %rax,%rdi
	movq %rdx,%rsi
	shlq $3,%rsi
	addq %rsi,%rdi
	movq $0,0(%rdi)
#	movq %rdx,%rdx
	addq $1,%rdx
#	movq %rdx,%rdx
	cmpq %rcx,%rdx
	jl L.9
L.10:
	movq %rax,16(%rbx)
#	movq %rbx,%rbx
	xorq %rax,%rax
	cmpq %rax,%rbx
	je L.1
L.11:
	movabsq $120,%rdi
#	movq %rdi,%rdi
	call _malloc
#	movq %rax,%rax
	movabsq $8,%rcx
#	movq %rcx,%rcx
	addq $8,%rcx
#	movq %rcx,%rcx
	subq $1,%rcx
#	movq %rcx,%rcx
	xorq %rdx,%rdx
	cmpq %rcx,%rdx
	jge L.13
L.12:
	movq %rax,%rdi
	movq %rdx,%rsi
	shlq $3,%rsi
	addq %rsi,%rdi
	movq $0,0(%rdi)
#	movq %rdx,%rdx
	addq $1,%rdx
#	movq %rdx,%rdx
	cmpq %rcx,%rdx
	jl L.12
L.13:
	movq %rax,24(%rbx)
	movq %rbx,%rax
L.0:
#	returnSink
	movq -8(%rbp),%rbx
	addq $16,%rsp
	popq %rbp
	ret
L.1:
	call badPtr
	.text
Queens.Solve:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	movq %r15, -48(%rbp)
	movq %r14, -40(%rbp)
	movq %r13, -32(%rbp)
	movq %r12, -24(%rbp)
	movq %rbx, -16(%rbp)
	movq %rdi,%r12
	movq %rsi,%rbx
L.65:
	movabsq $8,%rax
	cmpq %rax,%rbx
	je L.15
L.16:
	xorq %r14,%r14
	movq $7,%rax
	movq %rax,-8(%rbp)
	movq $1,%r13
L.18:
	movq %r14,%r15
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.26:
	movq 0(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.27:
#	movq %rax,%rax
	movq %r15,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq 0(%rax),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.24
L.22:
#	movq %r14,%r14
	addq %r13,%r14
#	movq %r14,%r14
L.19:
	movq -8(%rbp),%rax
#	movq %rax,%rax
	cmpq %rax,%r14
	jle L.18
L.20:
L.17:
	jmp L.14
L.15:
	movq %r12,%rdi
	call Queens.Print
	jmp L.17
L.24:
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.28:
	movq 16(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.29:
#	movq %rax,%rax
	movq %r15,%rcx
	addq %rbx,%rcx
#	movq %rcx,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq 0(%rax),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	jne L.22
L.23:
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.30:
	movq 24(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.31:
#	movq %rax,%rax
	movq %r15,%rcx
	movabsq $8,%rdx
#	movq %rdx,%rdx
	subq $1,%rdx
	addq %rdx,%rcx
#	movq %rcx,%rcx
	subq %rbx,%rcx
#	movq %rcx,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq 0(%rax),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	jne L.22
L.21:
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.32:
	movq 0(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.33:
#	movq %rax,%rax
	movq %r15,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq $1,0(%rax)
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.35:
	movq 16(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.36:
#	movq %rax,%rax
	movq %r15,%rcx
	addq %rbx,%rcx
#	movq %rcx,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq $1,0(%rax)
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.37:
	movq 24(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.38:
#	movq %rax,%rax
	movq %r15,%rcx
	movabsq $8,%rdx
#	movq %rdx,%rdx
	subq $1,%rdx
	addq %rdx,%rcx
#	movq %rcx,%rcx
	subq %rbx,%rcx
#	movq %rcx,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq $1,0(%rax)
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.39:
	movq 8(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.40:
#	movq %rax,%rax
	movq %rbx,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq %r15,0(%rax)
	movq -8(%r12),%rax
	movq 8(%rax),%rax
	movq %r12,%rdi
	movq %rbx,%rsi
	addq $1,%rsi
#	movq %rsi,%rsi
	call *%rax
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.41:
	movq 0(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.42:
#	movq %rax,%rax
	movq %r15,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq $0,0(%rax)
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.43:
	movq 16(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.44:
#	movq %rax,%rax
	movq %r15,%rcx
	addq %rbx,%rcx
#	movq %rcx,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq $0,0(%rax)
#	movq %r12,%r12
	xorq %rax,%rax
	cmpq %rax,%r12
	je L.25
L.45:
	movq 24(%r12),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.25
L.46:
#	movq %rax,%rax
#	movq %r15,%r15
	movabsq $8,%rcx
#	movq %rcx,%rcx
	subq $1,%rcx
	addq %rcx,%r15
#	movq %r15,%r15
	subq %rbx,%r15
#	movq %r15,%r15
	shlq $3,%r15
	addq %r15,%rax
	movq $0,0(%rax)
	jmp L.22
L.14:
#	returnSink
	movq -16(%rbp),%rbx
	movq -24(%rbp),%r12
	movq -32(%rbp),%r13
	movq -40(%rbp),%r14
	movq -48(%rbp),%r15
	addq $48,%rsp
	popq %rbp
	ret
L.25:
	call badPtr
L.34:
	call badSub
	.text
Queens.Print:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	movq %r15, -56(%rbp)
	movq %r14, -48(%rbp)
	movq %r13, -40(%rbp)
	movq %r12, -32(%rbp)
	movq %rbx, -24(%rbp)
#	movq %rdi,%rdi
	movq %rdi,-16(%rbp)
L.66:
	xorq %rbx,%rbx
	movq $7,%rax
	movq %rax,-8(%rbp)
	movq $1,%r12
L.48:
#	movq %rbx,%rbx
	xorq %r13,%r13
	movq $7,%r14
	movq $1,%r15
L.51:
#	movq %r13,%r13
	movabsq $32,%rdi
#	movq %rdi,%rdi
	call _putchar
	movq -16(%rbp),%rax
#	movq %rax,%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.58
L.59:
	movq 8(%rax),%rax
#	movq %rax,%rax
	xorq %rcx,%rcx
	cmpq %rcx,%rax
	je L.58
L.60:
#	movq %rax,%rax
	movq %rbx,%rcx
	shlq $3,%rcx
	addq %rcx,%rax
	movq 0(%rax),%rax
	cmpq %r13,%rax
	je L.55
L.56:
	movabsq $46,%rdi
#	movq %rdi,%rdi
	call _putchar
L.57:
#	movq %r13,%r13
	addq %r15,%r13
#	movq %r13,%r13
L.52:
	cmpq %r14,%r13
	jle L.51
L.53:
	movabsq $10,%rdi
#	movq %rdi,%rdi
	call _putchar
#	movq %rbx,%rbx
	addq %r12,%rbx
#	movq %rbx,%rbx
L.49:
	movq -8(%rbp),%rax
#	movq %rax,%rax
	cmpq %rax,%rbx
	jle L.48
L.50:
	movabsq $10,%rdi
#	movq %rdi,%rdi
	call _putchar
	jmp L.47
L.55:
	movabsq $81,%rdi
#	movq %rdi,%rdi
	call _putchar
	jmp L.57
L.47:
#	returnSink
	movq -24(%rbp),%rbx
	movq -32(%rbp),%r12
	movq -40(%rbp),%r13
	movq -48(%rbp),%r14
	movq -56(%rbp),%r15
	addq $64,%rsp
	popq %rbp
	ret
L.58:
	call badPtr
L.54:
	call badSub
	.text
Queens:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movq %rbx, -8(%rbp)
L.67:
	movabsq $40,%rdi
#	movq %rdi,%rdi
	call _malloc
#	movq %rax,%rax
#	movq %rax,%rax
	addq $8,%rax
#	movq %rax,%rax
	leaq Queens.Queens(%rip),%rbx
	movq %rbx,-8(%rax)
	movq $0,0(%rax)
	movq $0,8(%rax)
	movq $0,16(%rax)
	movq $0,24(%rax)
#	movq %rax,%rax
	movq -8(%rax),%rbx
	movq 0(%rbx),%rbx
	movq %rax,%rdi
	call *%rbx
#	movq %rax,%rax
	movq -8(%rax),%rbx
	movq 8(%rbx),%rbx
	movq %rax,%rdi
	xorq %rsi,%rsi
#	movq %rsi,%rsi
	call *%rbx
#	returnSink
	movq -8(%rbp),%rbx
	addq $16,%rsp
	popq %rbp
	ret
L.61:
	call badSub
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.68:
	call Queens
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.62:	.asciz	"Attempt to use a null pointer"
	.text
badPtr:
	pushq %rbp
	movq %rsp,%rbp
L.69:
	leaq L.62(%rip),%rdi
#	movq %rdi,%rdi
	call _puts
	movabsq $1,%rdi
#	movq %rdi,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.63:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.70:
	leaq L.63(%rip),%rdi
#	movq %rdi,%rdi
	call _puts
	movabsq $1,%rdi
#	movq %rdi,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
