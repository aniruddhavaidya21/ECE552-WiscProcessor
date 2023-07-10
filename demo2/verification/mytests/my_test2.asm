// jal_3.asm
	jal 8  // Expected no halt after this.
	nop
	nop
	nop
	halt
	nop    // PC should change for nop
	nop
	jal -8 // Finally, expected halt after this.
