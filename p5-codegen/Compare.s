	.text
Compare.LT:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movq %rbx, -8(%rbp)
	movq %rdi,%rcx
	movq %rsi,%rbx
L.14:
	xorq %rax,%rax
#	movq %rax,%rax
	cmpq %rcx,%rbx
	jl L.1
L.2:
#	movq %rax,%rax
	jmp L.0
L.1:
	mov %rax, 1
#	movq %rax,%rax
	jmp L.2
L.0:
#	returnSink
	movq -8(%rbp),%rbx
	addq $16,%rsp
	popq %rbp
	ret
	.text
Compare.LE:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movq %rbx, -8(%rbp)
	movq %rdi,%rcx
	movq %rsi,%rbx
L.15:
	xorq %rax,%rax
#	movq %rax,%rax
	cmpq %rcx,%rbx
	jle L.4
L.5:
#	movq %rax,%rax
	jmp L.3
L.4:
	mov %rax, 1
#	movq %rax,%rax
	jmp L.5
L.3:
#	returnSink
	movq -8(%rbp),%rbx
	addq $16,%rsp
	popq %rbp
	ret
	.text
Compare.GT:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movq %rbx, -8(%rbp)
	movq %rdi,%rcx
	movq %rsi,%rbx
L.16:
	xorq %rax,%rax
#	movq %rax,%rax
	cmpq %rcx,%rbx
	jg L.7
L.8:
#	movq %rax,%rax
	jmp L.6
L.7:
	mov %rax, 1
#	movq %rax,%rax
	jmp L.8
L.6:
#	returnSink
	movq -8(%rbp),%rbx
	addq $16,%rsp
	popq %rbp
	ret
	.text
Compare.GE:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movq %rbx, -8(%rbp)
	movq %rdi,%rcx
	movq %rsi,%rbx
L.17:
	xorq %rax,%rax
#	movq %rax,%rax
	cmpq %rcx,%rbx
	jge L.10
L.11:
#	movq %rax,%rax
	jmp L.9
L.10:
	mov %rax, 1
#	movq %rax,%rax
	jmp L.11
L.9:
#	returnSink
	movq -8(%rbp),%rbx
	addq $16,%rsp
	popq %rbp
	ret
	.text
Compare:
	pushq %rbp
	movq %rsp,%rbp
#	returnSink
	popq %rbp
	ret
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.18:
	call Compare
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.12:	.asciz	"Attempt to use a null pointer"
	.text
badPtr:
	pushq %rbp
	movq %rsp,%rbp
L.19:
	leaq L.12(%rip),%rax
	movq %rax,%rdi
	call _puts
	mov %rax, 1
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.13:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.20:
	leaq L.13(%rip),%rax
	movq %rax,%rdi
	call _puts
	mov %rax, 1
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
