#TODO POPRAVIT' PADDINGI

asect 0x00
create:
ldi r0, 0x70
ldi r1, 0b00010000
st r0, r1
ldi r0, 0x71
ldi r1, 0
st r0, r1
ldi r0, 0x72
st r0, r1

#ban
ldi r0, 0xC0
ld r0, r0
if
	tst r0
is ne #--> is/stays z 0x0B
	ldi r0, 0xD9
	ldi r1, 0xFF
	st r0, r1
fi




ldi r2, 0
push r2
br wrapper

asect 0x20
wrapper:

ldi r0, 0x78
ld r0, r0
ldi r1, 0x01

ldi r2, 0x72
ld r2, r2
push r2

if
	cmp r0, r1
is z #--> is/stays ne 0x23
	if
		tst r2
	is z
		jsr line_hor
	else
		jsr line_vert
	fi
else
	if
	cmp r0, r1
	is gt #--> is/stays le 0x2E
		jsr square
	else
		if
			cmp r0, r1
		is lt #--> is/stays ge 0x41
			if
				tst r2
			is z
				jsr zig_hor
			else
				jsr zig_vert
			fi
		fi
	fi
fi

pop r2
ldi r3, 0x72
ldi r0, 1
xor r0, r2
st r3, r2

pop r2
if
	tst r2
is z
	br 0xEF
else
	br 0xEB#Tb
fi

asect 0x63
shifter:
ldi r0, 0xC0
ldi r1, 0xC8
while
cmp r1, r0
stays gt #--> is/stays le 0x76
	push r1
	ld r0, r1
	inc r1
	and r1, r1
	if
		tst r1
	is z #--> is/stays ne 0x71
		move r0, r1
		dec r1
		and r1, r1
		ldi r3, 0xC0
		while
			cmp r1, r3
		stays ge #--> is/stays lt 0x71
			push r3
			move r1, r2
			inc r2
			and r2, r2
			ld r1, r3
			st r2, r3
			dec r1
			and r1, r1
			pop r3
		wend
	fi
	inc r0
	and r0, r0
	pop r1
wend
br 0xED

asect 0x8b
square:
ldi r0, 0x70
ld r0, r0
move r0, r1
shra r1
or r1, r0
ldi r2, 0xb0
ldi r3, 0x71
ld r3, r3
add r3, r2
st r2, r0
inc r2
st r2, r0
rts

asect 0x9B
line_hor:
ldi r0, 0x70
ld r0, r0
move r0, r1
shla r1
or r1, r0
shra r1
shra r1
or r1, r0
shra r1
or r1, r0
ldi r2, 0xb0
ldi r3, 0x71
ld r3, r3
add r3, r2
st r2, r0
rts

asect 0xD3
line_vert:
ldi r0, 0x70
ld r0, r0
ldi r2, 0xb0
ldi r3, 0x71
ld r3, r3
add r2, r3
st r3, r0
inc r3
st r3, r0
inc r3
st r3, r0
inc r3
st r3, r0
rts

asect 0xC1
zig_hor:
ldi r0, 0x70
ld r0, r0
move r0, r2
shra r2
or r2, r0
shla r0
ldi r3, 0x71
ld r3, r3
ldi r1, 0xb0
add r1, r3
st r3, r0
inc r3
shra r0
st r3, r0
rts

asect 0xAE
zig_vert:
ldi r0, 0x70
ld r0, r0
ldi r1, 0x71
ld r1, r1
ldi r3, 0xb0
add r1, r3
st r3, r0
inc r3
move r0, r2
shra r2
or r0, r2
st r3, r2
inc r3
shra r0
st r3, r0
rts

#TODO 0xaf

#shifter
asect 0xed
br 0x63

#create
asect 0xef
br 0x00

#wrapper
asect 0xeb
br 0x20

end
