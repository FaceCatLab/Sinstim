In this folder we store Cogent 2000 functions wich have been replaced
in Cogent 2007. We keep them for backward compatibility.

  In the "NotUsed" sub-folder, we store Cogent 2000 functions wich are
thought simply unusefull for us. We keep them only "just in case".


List of replaced function:


	Function		    Replaced by
	--------		    -----------

	clearpict		    clearbuffer
	config_cogent		integrated in 'startcogent'
	config_device		now a sub-function in 'startcogent'
	config_cogent		now included in 'startcogent'
	config_keyboard		now a sub-function in 'startcogent'
	config_device		now a sub-function in 'startcogent'
	config_mouse		now a sub-function in 'startcogent'
	config_serial		now a sub-function in 'startcogent'
	config_sound		opensound
	help_cogent		    cogenthelp
	loadpict		    loadimage + storeimage
	loadsound		    now included in 'storesound' (todo: make a new loadsound to load wav into matrix)
	preparepict		    storeimage
	preparestring		drawtext
	preparepuretone		storetuut
	preparesound		storesound
	settextstyle		<function still to be written>
	start_cogent		startcogent (original start_cogent is now a sub-function)
	stop_cogent		    stopcogent
	time			    time (rewritten)
	wait			    wait (rewritten)
	waitkeydown         waitkeydown (rewritten)
	waitkeyup           waitkeyup (rewritten)
	waituntil		    waituntil (rewritten)

	logstring		    needed by start_cogent and stop_cogent