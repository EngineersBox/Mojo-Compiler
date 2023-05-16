	.data
	.balign 8
L.0:	.asciz	"Number is: %d\n"
	.text
PrintInt:
	pushq %rbp
	movq %rsp,%rbp
L.4:
	leaq L.0(%rip),%rax
	movq %rax,%rdi
	movabsq $42,t.1
	movq t.1,%rsi
	call _printf
#	returnSink
	popq %rbp
	ret
L.1:
	call badSub
	.globl _main
	.text
_main:
	pushq %rbp
	movq %rsp,%rbp
L.5:
	call PrintInt
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.2:	.asciz	"Attempt to use a null pointer"
	.text
badPtr:
	pushq %rbp
	movq %rsp,%rbp
L.6:
	leaq L.2(%rip),%rax
	movq %rax,%rdi
	call _puts
	movabsq $1,t.3
	movq t.3,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
	.data
	.balign 8
L.3:	.asciz	"Subscript out of bounds"
	.text
badSub:
	pushq %rbp
	movq %rsp,%rbp
L.7:
	leaq L.3(%rip),%rax
	movq %rax,%rdi
	call _puts
	movabsq $1,t.5
	movq t.5,%rdi
	call _exit
#	returnSink
	popq %rbp
	ret
