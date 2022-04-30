	.equ	write,	1		# syscall write

	.equ	out,	1		# stdout

	.equ	d,	-1		# current digit
	.equ	mem,	16		# local memory size

	.section	.rodata
space:	.string	"   "

	.text
	.globl	output
	.type	output,	@function
output:	pushq	%rbp			# save caller base pointer
	movq	%rsp,	%rbp		# establish our base pointer
	subq	$mem,	%rsp		# alloc local memory

	movb	%dil,	d(%rbp)		# d = arg
	shrb	$4,	d(%rbp)		# d >>= 4
	cmpb	$0x0a,	d(%rbp)		# if
	jl	num1			# !(d < 0x0a)
	addb	$0x07,	d(%rbp)		# d += 0x07
num1:	addb	$0x30,	d(%rbp)		# d += 0x30
	pushq	%rdi			# save di
	movl	$write, %eax		# write(
	movl	$out,	%edi		# stdout
	leaq	d(%rbp),%rsi		# &d
	movl	$1,	%edx		# 1
	syscall				# )
	popq	%rdi			# restore rdi

	movb	%dil,	d(%rbp)		# d = arg
	andb	$0x0f,	d(%rbp)		# d &= 0x0f
	cmpb	$0x0a,	d(%rbp)		# if
	jl	num2			# !(d < 0x0a)
	addb	$0x07,	d(%rbp)		# d += 0x07
num2:	addb	$0x30,	d(%rbp)		# d += 0x30
	movl	$write, %eax		# write(
	movl	$out,	%edi		# stdout
	leaq	d(%rbp),%rsi		# &d
	movl	$1,	%edx		# 1
	syscall				# )

end:	movl	$write, %eax		# write(
	movl	$out,	%edi		# stdout
	movq	$space,	%rsi		# &space
	movl	$1,	%edx		# 1
	syscall				# )

	leave				# free local memory
	ret				# back to caller

	.globl	outsp
	.type	outsp,	@function
outsp:	pushq	%rbp			# save caller base pointer
	movq	%rsp,	%rbp		# establish our base pointer

	movl	$write, %eax		# write(
	movl	$out,	%edi		# stdout
	movq	$space,	%rsi		# &space
	movl	$3,	%edx		# 3
	syscall				# )

	leave				# free local memory
	ret				# back to caller
