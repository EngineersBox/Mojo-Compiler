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
	movabsq $64,%rax
	movq %rax,%rdi
	call _malloc
	movq %rax,%rdi
	movq $8,%rsi
	xorq %rdx,%rdx
	cmpq %rsi,%rdx
	jge L.4
L.3:
	movq %rdi,%rcx
	movq %rdx,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	movq %rdx,%rax
	addq $1,%rax
	movq %rax,%rdx
	cmpq %rsi,%rdx
	jl L.3
L.4:
	movq %rdi,0(%rbx)
#	movq %rbx,%rbx
	xorq %rax,%rax
	cmpq %rax,%rbx
	je L.1
L.5:
	movabsq $64,%rax
	movq %rax,%rdi
	call _malloc
	movq %rax,%rdi
	movq $8,%rsi
	xorq %rdx,%rdx
	cmpq %rsi,%rdx
	jge L.7
L.6:
	movq %rdi,%rcx
	movq %rdx,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	movq %rdx,%rax
	addq $1,%rax
	movq %rax,%rdx
	cmpq %rsi,%rdx
	jl L.6
L.7:
	movq %rdi,8(%rbx)
#	movq %rbx,%rbx
	xorq %rax,%rax
	cmpq %rax,%rbx
	je L.1
L.8:
	movabsq $120,%rax
	movq %rax,%rdi
	call _malloc
	movq %rax,%rdi
	movabsq $8,%rax
#	movq %rax,%rax
	addq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	movq %rax,%rsi
	xorq %rdx,%rdx
	cmpq %rsi,%rdx
	jge L.10
L.9:
	movq %rdi,%rcx
	movq %rdx,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	movq %rdx,%rax
	addq $1,%rax
	movq %rax,%rdx
	cmpq %rsi,%rdx
	jl L.9
L.10:
	movq %rdi,16(%rbx)
#	movq %rbx,%rbx
	xorq %rax,%rax
	cmpq %rax,%rbx
	je L.1
L.11:
	movabsq $120,%rax
	movq %rax,%rdi
	call _malloc
	movq %rax,%rdi
	movabsq $8,%rax
#	movq %rax,%rax
	addq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	movq %rax,%rsi
	xorq %rdx,%rdx
	cmpq %rsi,%rdx
	jge L.13
L.12:
	movq %rdi,%rcx
	movq %rdx,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	movq %rdx,%rax
	addq $1,%rax
	movq %rax,%rdx
	cmpq %rsi,%rdx
	jl L.12
L.13:
	movq %rdi,24(%rbx)
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
	movq %r15, -40(%rbp)
	movq %r14, -32(%rbp)
	movq %r13, -24(%rbp)
	movq %r12, -16(%rbp)
	movq %rbx, -8(%rbp)
	movq %rdi,%r14
	movq %rsi,%r13
L.65:
	movabsq $8,%rax
	cmpq %rax,%r13
	je L.15
L.16:
	xorq %r15,%r15
	movq $7,%rbx
	movq $1,%r12
L.18:
#	movq %r15,%r15
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.26:
	movq 0(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.27:
#	movq %rcx,%rcx
	movq %r15,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq 0(%rcx),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.24
L.22:
	movq %r15,%rax
	addq %r12,%rax
	movq %rax,%r15
L.19:
	cmpq %rbx,%r15
	jle L.18
L.20:
L.17:
	jmp L.14
L.15:
	movq %r14,%rdi
	call Queens.Print
	jmp L.17
L.24:
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.28:
	movq 16(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.29:
#	movq %rcx,%rcx
	movq %r15,%rax
	addq %r13,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq 0(%rcx),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	jne L.22
L.23:
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.30:
	movq 24(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.31:
	movq %rcx,%rdx
	movq %r15,%rcx
	movabsq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	addq %rax,%rcx
	movq %rcx,%rax
	subq %r13,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq 0(%rdx),%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	jne L.22
L.21:
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.32:
	movq 0(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.33:
#	movq %rcx,%rcx
	movq %r15,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $1,0(%rcx)
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.35:
	movq 16(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.36:
#	movq %rcx,%rcx
	movq %r15,%rax
	addq %r13,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $1,0(%rcx)
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.37:
	movq 24(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.38:
	movq %rcx,%rdx
	movq %r15,%rcx
	movabsq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	addq %rax,%rcx
	movq %rcx,%rax
	subq %r13,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq $1,0(%rdx)
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.39:
	movq 8(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.40:
#	movq %rcx,%rcx
	movq %r13,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq %r15,0(%rcx)
	movq -8(%r14),%rax
	movq 8(%rax),%rcx
	movq %r14,%rdi
	movq %r13,%rax
	addq $1,%rax
	movq %rax,%rsi
	call *%rcx
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.41:
	movq 0(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.42:
#	movq %rcx,%rcx
	movq %r15,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.43:
	movq 16(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.44:
#	movq %rcx,%rcx
	movq %r15,%rax
	addq %r13,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq $0,0(%rcx)
	movq %r14,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.45:
	movq 24(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.25
L.46:
	movq %rcx,%rdx
	movq %r15,%rcx
	movabsq $8,%rax
#	movq %rax,%rax
	subq $1,%rax
	addq %rax,%rcx
	movq %rcx,%rax
	subq %r13,%rax
#	movq %rax,%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq $0,0(%rdx)
	jmp L.22
L.14:
#	returnSink
	movq -8(%rbp),%rbx
	movq -16(%rbp),%r12
	movq -24(%rbp),%r13
	movq -32(%rbp),%r14
	movq -40(%rbp),%r15
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
	movq %rdi,%rax
	movq %rax,-16(%rbp)
L.66:
	xorq %r12,%r12
	movq $7,%rax
	movq %rax,-8(%rbp)
	movq $1,%rbx
L.48:
#	movq %r12,%r12
	xorq %r15,%r15
	movq $7,%r13
	movq $1,%r14
L.51:
#	movq %r15,%r15
	movabsq $32,%rax
	movq %rax,%rdi
	call _putchar
	movq -16(%rbp),%rax
#	movq %rax,%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.58
L.59:
	movq 8(%rcx),%rax
	movq %rax,%rcx
	xorq %rax,%rax
	cmpq %rax,%rcx
	je L.58
L.60:
#	movq %rcx,%rcx
	movq %r12,%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq 0(%rcx),%rax
	cmpq %r15,%rax
	je L.55
L.56:
	movabsq $46,%rax
	movq %rax,%rdi
	call _putchar
L.57:
	movq %r15,%rax
	addq %r14,%rax
	movq %rax,%r15
L.52:
	cmpq %r13,%r15
	jle L.51
L.53:
	movabsq $10,%rax
	movq %rax,%rdi
	call _putchar
	movq %r12,%rax
	addq %rbx,%rax
	movq %rax,%r12
L.49:
	movq -8(%rbp),%rax
#	movq %rax,%rax
	cmpq %rax,%r12
	jle L.48
L.50:
	movabsq $10,%rax
	movq %rax,%rdi
	call _putchar
	jmp L.47
L.55:
	movabsq $81,%rax
	movq %rax,%rdi
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
	movabsq $40,%rax
	movq %rax,%rdi
	call _malloc
	movq %rax,%rbx
	movq %rbx,%rax
	addq $8,%rax
	movq %rax,%rbx
	leaq Queens.Queens(%rip),%rax
	movq %rax,-8(%rbx)
	movq $0,0(%rbx)
	movq $0,8(%rbx)
	movq $0,16(%rbx)
	movq $0,24(%rbx)
#	movq %rbx,%rbx
	movq -8(%rbx),%rax
	movq 0(%rax),%rax
	movq %rbx,%rdi
	call *%rax
	movq %rax,%rcx
	movq -8(%rcx),%rax
	movq 8(%rax),%rbx
	movq %rcx,%rdi
	xorq %rax,%rax
	movq %rax,%rsi
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
	leaq L.62(%rip),%rax
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
L.63:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.70:
	leaq L.63(%rip),%rax
	movq %rax,%rdi
	call _puts
	movabsq $1,%rax
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
