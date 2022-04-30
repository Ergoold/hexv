	.equ	d,	-1		# current digit
	.equ	mem,	16		# local memory size

	.text
	.globl	print
	.type	print,	@function
print:	pushq	%rbp			# save caller base pointer
	movq	%rsp,	%rbp		# establish our base pointer
	subq	$mem,	%rsp		# alloc local memory

	cmpb	$0x20,	%dil		# if
	jl	dot			# !(arg < space)
	cmpb	$0x7e,	%dil		# if
	jg	dot			# !(arg > tilde)

	movb	%dil,	%al		# return arg
	jmp	end

dot:	movb	$0x2e,	%al		# return '.'
end:	leave				# free local memory
	ret				# back to caller
