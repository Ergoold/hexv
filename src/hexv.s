	.equ	read,	0		# syscall read
	.equ	write,	1		# syscall write
	.equ	exit,	60		# syscall exit

	.equ	in,	0		# stdin
	.equ	out,	1		# output

	.equ	r,	-16		# the row
	.equ	i,	-24		# index in row
	.equ	s,	-28		# eof status
	.equ	c,	-29		# current char
	.equ	mem,	32		# local memory size

	.section	.rodata
tab:	.string	"\t"
endl:	.string "\n"

	.text
	.globl	_start
_start:	pushq	%rbp			# save caller base pointer
	movq	%rsp,	%rbp		# establish our base pointer
	subq	$mem,	%rsp		# alloc local memory

row:	movq	$0x10,	i(%rbp)		# i = 16

cell:	movl	$read,	%eax		# read(
	movl	$in,	%edi		# stdin
	leaq	c(%rbp),%rsi		# &c
	movl	$1,	%edx		# 1
	syscall				# )

	movl	%eax,	s(%rbp)		# put result in s
	cmpl	$0,	%eax		# if (res <= 0)
	jle	ecell			# break

	movb	c(%rbp),%dil		# c |>
	call	output			# output

	movb	c(%rbp),%dil		# c |>
	call	print			# print; result stored in al
	movq	i(%rbp),%rbx		# put i in rbx
	negq	%rbx			# negate rbx
	movb	%al,	(%rbp,%rbx,1)	# *(rbp - i) = c

	decq	i(%rbp)			# i--
	jz	endr
	jmp	cell

ecell:	call	outsp			# outsp()
	movb	$0x20,	%al		# put space in al
	movq	i(%rbp),%rbx		# put i in rbx
	negq	%rbx			# negate rbx
	movb	%al,	(%rbp,%rbx,1)	# *(rbp - i) = space

	decq	i(%rbp)			# i--
	jz	endr
	jmp	ecell

endr:	movl	$write,	%eax		# write(
	movl	$out,	%edi		# stdin
	movq	$tab,	%rsi		# &tab
	movl	$1,	%edx		# 1
	syscall				# )

	movl	$write,	%eax		# write(
	movl	$out,	%edi		# stdin
	leaq	r(%rbp),%rsi		# rbp
	movl	$16,	%edx		# 16
	syscall				# )

	movl	$write,	%eax		# write(
	movl	$out,	%edi		# stdin
	movq	$endl,	%rsi		# &endl
	movl	$1,	%edx		# 1
	syscall				# )

	cmpl	$0,	s(%rbp)		# if feof(stdin)
	jle	end			# break
	jmp	row

end:	leave				# free local memory
	movl	$exit,	%eax		# exit(
	movl	$0,	%edi		# 0
	syscall				# )
