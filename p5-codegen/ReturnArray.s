	.text
ReturnArray.foo:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	movq %r12, -40(%rbp)
	movq %rdi,-8(%rbp)
L.10:
	movq $3,%rsi
	xorq %rdx,%rdx
	cmpq %rsi,%rdx
	jge L.2
L.1:
	movq %rdx,%rax
	shlq $3,%rax
#	movq %rax,%rax
	addq %rbp,%rax
	movq $0,-32(%rax)
	movq %rdx,%rax
	addq $1,%rax
	movq %rax,%rdx
	cmpq %rsi,%rdx
	jl L.1
L.2:
	xorq %rcx,%rcx
	movq $2,%rsi
	movq $1,%rdx
L.3:
#	movq %rcx,%rcx
	movq %rcx,%rax
	shlq $3,%rax
#	movq %rax,%rax
	addq $-32,%rax
#	movq %rax,%rax
	addq %rbp,%rax
	movq %rcx,0(%rax)
	movq %rdx,%rax
	addq %rcx,%rax
	movq %rax,%rcx
L.4:
	cmpq %rsi,%rcx
	jle L.3
L.5:
	movq -8(%rbp),%rax
	movq %rax,%r12
	movq %r12,%rdi
	movq %rbp,%rax
	addq $-32,%rax
	movq %rax,%rsi
	movq $24,%rax
	movq %rax,%rdx
	call _memmove
	movq %r12,%rax
L.0:
#	returnSink
	movq -40(%rbp),%r12
	addq $48,%rsp
	popq %rbp
	ret
L.6:
	call badSub
	.text
ReturnArray:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
L.11:
	movq %rbp,%rax
	addq $-48,%rax
	movq %rax,%rdi
	call ReturnArray.foo
	movq %rax,%rcx
	movq %rbp,%rax
	addq $-24,%rax
	movq %rax,%rdi
	movq %rcx,%rsi
	movq $24,%rax
	movq %rax,%rdx
	call _memmove
	movq -24(%rbp),%rax
#	movq %rax,%rax
	addq $48,%rax
	movq %rax,%rdi
	call _putchar
	movq $10,%rax
	movq %rax,%rdi
	call _putchar
	movq -16(%rbp),%rax
#	movq %rax,%rax
	addq $48,%rax
	movq %rax,%rdi
	call _putchar
	movq $10,%rax
	movq %rax,%rdi
	call _putchar
	movq -8(%rbp),%rax
#	movq %rax,%rax
	addq $48,%rax
	movq %rax,%rdi
	call _putchar
	movq $10,%rax
	movq %rax,%rdi
	call _putchar
#	returnSink
	addq $48,%rsp
	popq %rbp
	ret
L.7:
	call badSub
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.12:
	call ReturnArray
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.8:	.asciz	"Attempt to use a null pointer"
	.text
badPtr:
	pushq %rbp
	movq %rsp,%rbp
L.13:
	leaq L.8(%rip),%rax
	movq %rax,%rdi
	call _puts
	movq $1,%rax
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.9:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.14:
	leaq L.9(%rip),%rax
	movq %rax,%rdi
	call _puts
	movq $1,%rax
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
