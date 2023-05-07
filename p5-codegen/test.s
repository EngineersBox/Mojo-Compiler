	.data
	.balign 8
L.1:	.asciz	"A: %d\n"
	.data
	.balign 8
L.2:	.asciz	"B: %d\n"
	.data
	.balign 8
L.3:	.asciz	"C: %d\n"
	.data
	.balign 8
L.4:	.asciz	"F: %d\n"
	.data
	.balign 8
L.5:	.asciz	"G: %d\n"
	.text
test:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	movq %r14, -32(%rbp)
	movq %r13, -24(%rbp)
	movq %r12, -16(%rbp)
	movq %rbx, -8(%rbp)
L.8:
	movq $120,%rcx
	movq $240,%r14
	movq %r14,%rax
	addq %rcx,%rax
	movq %rax,%r13
	movq %r14,%rax
	addq $1,%rax
	movq %rax,%r12
	movq %r12,%rax
	cqo
	idivq %rcx
#	movq %rax,%rax
	movq %rax,%rbx
	leaq L.1(%rip),%rax
	movq %rax,%rdi
	movq %rcx,%rsi
	call _printf
	leaq L.2(%rip),%rax
	movq %rax,%rdi
	movq %r14,%rsi
	call _printf
	leaq L.3(%rip),%rax
	movq %rax,%rdi
	movq %r13,%rsi
	call _printf
	leaq L.4(%rip),%rax
	movq %rax,%rdi
	movq %r12,%rsi
	call _printf
	leaq L.5(%rip),%rax
	movq %rax,%rdi
	movq %rbx,%rsi
	call _printf
#	returnSink
	movq -8(%rbp),%rbx
	movq -16(%rbp),%r12
	movq -24(%rbp),%r13
	movq -32(%rbp),%r14
	addq $32,%rsp
	popq %rbp
	ret
L.0:
	call badSub
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.9:
	call test
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.6:	.asciz	"Attempt to use a null pointer"
	.text
badPtr:
	pushq %rbp
	movq %rsp,%rbp
L.10:
	leaq L.6(%rip),%rax
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
L.7:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.11:
	leaq L.7(%rip),%rax
	movq %rax,%rdi
	call _puts
	movq $1,%rax
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
