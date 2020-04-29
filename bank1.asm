asect 0xe0
	IOReg: # Gives the address 0xf3 the symbolic name IOReg
	
asect 0xf0
	stack:
	
asect 0x70
	x:
	dc 0x00

asect 0x71
	y:
	dc 0x00
	
asect 0xef
br 0x14

asect 0xed
br 0x46

# d - screen
# a - temp
# b - figure
# c - legacy figures
asect 0x00
start:
ldi r0, 0x70
ldi r1, 0b00010000
st r0, r1
ldi r0, 0x71
ldi r1, 0
st r0, r1

ldi r0, 0b11111111
ldi r2, 0xd8
st r2, r0
ldi r2, 0xc8
st r2, r0

br 0xef

ldi r0, 0xb0
ldi r1, 0xc0
ldi r2, 0xd0
jsr merge

ldi r0, IOReg
ldi r3, 3

readkbd:
ldi r0, IOReg

do

if
tst r3
is z
then
	#shift matrix
	push r0
	ldi r0, 0xa8
	ldi r1, 0xb7
	ldi r3, 8
	while
		tst r3
	stays gt
		ld r1, r2
		st r0, r2
		dec r0
		dec r1
		dec r3
		and r0, r0
	wend
	
	jsr collision
	if
		tst r3
	is nz
	then
		ldi r0, 0xb0
		ldi r1, 0xc0
		ldi r2, 0xc0
		jsr merge
		
		br 0xed
		
		ldi r0, 0xc0
		ldi r1, 0xd0
		jsr memcpy
		ldi r0, 0x90
		ldi r1, 0xb0
		jsr memcpy
		pop r0
		br start
	else
		
		ldi r0, 0xa0
		ldi r1, 0xc0
		ldi r2, 0xd0
		jsr merge
		
		#accept shift
		ldi r0, 0xa0
		ldi r1, 0xb0
		jsr memcpy

	fi
	
	ldi r3, 3
	pop r0
fi

dec r3
and r0, r0

ld r0,r1
tst r1
until pl

push r0
ldi r0, 0xb0

ldi r2, 1
if
	cmp r1, r2
is gt
then
#---
else
	ldi r2, 8
	while
		tst r2
	stays gt
		ld r0, r3
		if
			tst r1
		is z
		then
			shla r3
		else
			shra r3
		fi
		st r0, r3
		dec r2
		inc r0
		and r0, r0
	wend
fi

pop r0


br readkbd # go back to the start of the keyboard read loop

# puts smth in r3. If r3>0 => collision happend
collision:
	ldi r3, 0
	ldi r0, 0xa0
	ldi r1, 0xc0
	ldi r2, 9
	while
		tst r2
	stays gt
		push r0
		push r1
		ld r0, r0
		ld r1, r1
		and r0, r1
		or r1, r3
		pop r1
		pop r0
		dec r2
		inc r0
		inc r1
		and r0, r0
	wend
	
rts
#merges r0 and r1 and puts it in d0 aka r2
merge:
ldi r3, 9
while
			tst r3
		stays gt
			push r0
			push r1
			ld r0, r0
			ld r1, r1
			or r0, r1
			st r2, r1
			pop r0
			pop r1
			inc r0
			inc r1
			inc r2
			dec r3
			and r0, r0
		wend
rts

#copies 8 bytes from r0 to r1
memcpy:
		ldi r2, 9
		while
			tst r2
		stays gt
			ld r0, r3
			st r1, r3
			inc r0
			inc r1
			dec r2
			and r0, r0
		wend
rts
end