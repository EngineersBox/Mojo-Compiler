	.text
CallStmt:
	pushq %rbp
	movq %rsp,%rbp
L.2:
	call _f
#	returnSink
	popq %rbp
	ret
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.3:
	call CallStmt
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
