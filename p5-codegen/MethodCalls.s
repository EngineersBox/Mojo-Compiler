	.data
	.balign 8
MethodCalls.A:
	.quad badPtr
	.data
	.balign 8
MethodCalls.AB:
	.quad badPtr
	.quad badPtr
	.data
	.balign 8
MethodCalls.T1:
	.quad badPtr
	.quad MethodCalls.Pab
	.data
	.balign 8
MethodCalls.T2:
	.quad MethodCalls.Pa
	.data
	.balign 8
MethodCalls.T3:
	.quad badPtr
	.quad MethodCalls.Pa
	.text
MethodCalls:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	movq %r15, -40(%rbp)
	movq %r14, -32(%rbp)
	movq %r13, -24(%rbp)
	movq %r12, -16(%rbp)
	movq %rbx, -8(%rbp)
L.2:
	xorq %rsi,%rsi
	movq %rsi,%r15
	xorq %rdx,%rdx
	movq %rdx,%r14
	xorq %rcx,%rcx
	movq %rcx,%r13
	xorq %rbx,%rbx
	movq %rbx,%r12
	xorq %rax,%rax
	movq %rax,%rbx
	movq %rax,-8(%r15)
	movq %rax,0(%rax)
	movq %r15,%rdi
	call *%rax
	leaq MethodCalls.A(%rip),%rax
	movq %rax,0(%rax)
	movq %r15,%rdi
	call *%rax
	movq %rax,-8(%r14)
	movq %rax,8(%rax)
	movq %r14,%rdi
	call *%rax
	leaq MethodCalls.AB(%rip),%rax
	movq %rax,8(%rax)
	movq %r14,%rdi
	call *%rax
	movq %rax,-8(%r13)
	movq %rax,8(%rax)
	movq %r13,%rdi
	call *%rax
	leaq MethodCalls.T1(%rip),%rax
	movq %rax,8(%rax)
	movq %r13,%rdi
	call *%rax
	movq %rax,-8(%r12)
	movq %rax,0(%rax)
	movq %r12,%rdi
	call *%rax
	leaq MethodCalls.T2(%rip),%rax
	movq %rax,0(%rax)
	movq %r12,%rdi
	call *%rax
	movq %rax,-8(%rbx)
	movq %rax,8(%rax)
	movq %rbx,%rdi
	call *%rax
	leaq MethodCalls.T3(%rip),%rax
	movq %rax,8(%rax)
	movq %rbx,%rdi
	call *%rax
#	returnSink
	movq -8(%rbp),%rbx
	movq -16(%rbp),%r12
	movq -24(%rbp),%r13
	movq -32(%rbp),%r14
	movq -40(%rbp),%r15
	addq $48,%rsp
	popq %rbp
	ret
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.3:
	call MethodCalls
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.0:	.asciz	"Attempt to use a null pointer"
	.text
badPtr:
	pushq %rbp
	movq %rsp,%rbp
L.4:
	leaq L.0(%rip),%rax
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
L.1:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.5:
	leaq L.1(%rip),%rax
	movq %rax,%rdi
	call _puts
	mov %rax, 1
	movq %rax,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
