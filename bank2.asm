#TODO POPRAVIT' PADDINGI

asect 0x00
create:
ldi r0, 0xC0
ld r0, r0
if
	tst r0
is ne #--> is/stays z 0x0B
	ldi r0, 0xD9
	ldi r1, 0xFF
	st r0, r1
fi
ldi r0, 0x78
ld r0, r0
ldi r1, 0x01

if
	cmp r0, r1
is z #--> is/stays ne 0x23
	
fi

if
cmp r0, r1
is gt #--> is/stays le 0x2E
	
fi

if
	cmp r0, r1
is lt #--> is/stays ge 0x41
	jsr line_hor
fi

ldi r0, 0x78
ld r0, r0

#обновление типа фигуры
if
	tst r0
is z #--> is/stays ne 0x48
ldi r0, 0x00
else
dec r0
and r0, r0
fi

ldi r3, 0x78
st r3, r0

br 0xEF

asect 0x30
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

asect 0x60
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

asect 0x70
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

asect 0x83
line_vert:
ldi r0, 0x70
ld r0, r0
ldi r2, 0xaf
ldi r3, 0x71
ld r3, r3
add r3, r2
st r3, r0
inc r3
st r3, r0
inc r3
st r3, r0
inc r3
st r3, r0
rts

asect 0x94
zig_hor:

asect 0xA0
zig_vert:


asect 0xed
br 0x30

asect 0xef
br 0x00

end
