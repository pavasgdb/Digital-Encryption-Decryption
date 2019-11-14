# Digital-Encryption-Decryption
Design	a	system	 for	encrypting/decrypting	 text	 files.	The	system	would	operate	in	
two	 modes	 (selectable	 by	 a	 switch)	 – encrypt	 and	 decrypt.	 The	 files	 are	 to	 be	
read/written	 using	 previously	 designed	 serial	 receiver/transmitter.	 Sequences	 of	
operations	in	the	two	modes	would	be	as	follows.
In	 encrypt	 mode: read	 a	 plain	 text	 file into	 memory,	 perform	 encryption, write	
encrypted	text	into	a	file.
In	decrypt	mode:	read encrypted	text	 from	a	file into	memory,	perform	decryption	
to	get	back	plain	text,	write	plain	text	into	a	file.
Stream cipher technique is used.
The bit file is also present in the repo for directly installing the system in the FPGA board.
Slide switches ( 0 to 7 ) have been used for specifying the public encryption key.
Slide switches ( 15 and 16 ) are used for selecting mode.
Push buttons have been used for reset and tranmitting the data.
