function [v,vstr] = glabversion(type)
% GLABVERSION  G-Lab version number, and version infos.
%
%                _______________________________________________
%               |                                               |
%               |                  G - L  A  B                  |
%               |              Graphics Laboratory              |
%               |_______________________________________________|
%
%
% 1.0   19/11/2007  First exp. Bruno
% -----
% 1.1   29/11       Exp. Joystick Michael. Create this function (COGENTVERSION).
% -----
% 1.2   11/12		Exp. HalfFaces (Bruno) <bug!: startcogent crashes at 2d call>
% 1.2.1 08/01/2008	startcogent: see file. Add logstring.m for Cogent2000 compatibility.
% 1.2.2 24/01		startcogent: isFullScreen -> Screen.
% -----
% 1.3   30/01		Exp. Arnaud/Emeline. 
%                   SOUND: opensound, storesound, storetuut.
%					SERIAL: openserialport, closeserialport. 
%					PARALLEL: No more open in startcogent. <!!! Incompatible with v1.2 !!!>
% 					PATH: startcogent sets path at startup. Needs delpath & getsubdirlist (Bentools)
%					Version: startcogent: disp. version ; cogentversion: check version.
% 1.3.1  04/03		loadimage: give directory as argument. 'Grayscale' mode
% 1.3.2  05/03		KEYBOARD: Fix readkey (Cogent2000): suppr. log in file & display in Command window.
%					startcogent: Disp. "Type 'cogenthelp'..." ; Check screen resolution.
%					loadimage: Fix Grayscale mode: use rgb2gray.
% -----
% 1.4    10/03		Exp. Arnaud/Emeline (2d part; changed to fix logkey bug -- see v1.3.2)
%					HELP: cogentdoc, modif. cogenthelp, startcogent: create cogentdoc.txt.
%						Suppr. unused m-files, or rename to m~. Some doc. fixes.
%					startcogent: Define global var. in workspace. (to ensure they'll be saved).
%					Fix COGENT_MESURED_SCREEN_FREQUENCY --> *_MEASURED_*
% 1.4.1  11/03		KEYBOARD: getkeymap, key; readkeys: v2.0 is to slow, v1.0.1: change doc.
% -----
% 1.5    01/04!		SCREEN FREQUENCY: Display warning/error inside Cogent; Check for config. changes;
%                   Check for synchronization problems (fix mirror display in EEG lab).
%                   OPENDISPLAY, OPENKEYBOARD <bug, fixed 16/04>.
%					NO DISPLAY MODE: startcogent none; Suppr. cogent.display field (!).
%                   displaymessage, displaywarning, displayerror.
%                   starttime.
%                   stopcogent: clean.
%                   MOUSE: setmouse, getmouse ; fix waitmouseclick ; startcogent: remove mouse init.
%                   setdraw
%					clearbuffer: fix pen color bug.
%                   Path check: rewrite totally. delpath 2.0.
% 1.5.0.1 03/04		Delete putimage & checkscreenfreq (both obsoletes).
% 1.5.1	  16/04		Fix openkeyboard. cdcog. time(0). config_sound -> Replaced.
%					<TODO: Verify measurescreenfreq !!!>
% 1.5.2   21/05		Add "<cogentroot>\Cogent2000\Obsolete-Replaced" to path for backward compatibility.
% 1.5.3   22/05		<MAJOR BUG !!! See 1.5.5>
%					Add "<cogentroot>\PsychToolBox" to path.
%					WAIT: 'wait' function uses PsychToolBox' WaitSec (no buzzy wait).
%					KEYBOARD: getkeyevents, peekkeyevents, clearkeyevents, waitkeysequence ; key: support cell
% 1.5.4   30/05		displaybuffer: Suppr. 'dontclear' option did not work.
%                   drawline: new function. drawshape: clean. drawsquare: cosmetic.
%					setdraw: new function ; getdraw: modif. getscreenres: add "[x0,y0,x1,y1] = getscreenres" syntax.
% 1.5.5   02/07		MAJOR FIX !!! (from 1.5.3) Fix times in displaybuffer().
% 1.5.6   17/09		"Cogent*\Legacy" folder.
%                   startcogent: Default first arg. = 0
%					'storeimage' --> 'drawimage' (+ Legacy\storeimage) <reverted in 2.0-alpha1>
%                   DRAW: drawsquare --> drawsquare + drawrect
% 1.5.7   25/09		New files: setupcogent, drawcross
%					Modif. files: drawline
%					setupcogent: backport from v2-alpha (with modif.!).
%					drawcross, drawline: Fix line width.
% -----
% 1.6     25/09		COGENT2000 v1.25 -> 1.28 / COGENTGRAPHICS v1.24 -> 1.28.
% 					New fun: setlibrary, getlibrary. Modif fun: setupcogent. Path has totaly changed.
%					KEYBOARD: Use PTB functions (KbCheck, Screen).
%					New fun: checkkeydown.
%					ALPHA BLENDING: <Performance issue: TO SLOW!> Modif fun: copybuffer.
%					draw* functions: syntax revisions.
%                   stopcogent: suppress log closing (obsolete).
%                   getframedur: fix "getframedur('r')".
%                   Gamma: Include in toolbox, in Lib\Gamma.
% 1.6.1   30/09     FIX INSTALL & LIBRARY CHOICES. FIX COGENT 1.28. FIX VISTA!
%                   Fix 1.28: 
%                   - startcogent: openkeyboard after opendisplay.
%                   - setlibrary, openkeyboard: Suppr. change lib from Cog-1.28 to PTB (bug was specific to Cheops).
%                   - setupcogent: Always use m-files of 1.25.
%                   Fix MATLAB 7.5:
%                   - setupcogent: path2rc -> savepath.
%                   Fix case PTB not installed: Standalone use of keyboard (but not Screen!):
%                   - setupcogent: Fix Lib\PTB path.
%                   - Lib\PTB: Add KbName, Is*, streq ; Remove Screen.*.
%                   Fix install:
%                   - setupcogent: setupcogent(vstr) ; Check bentools is in path, add it if possible ; 
%                     Disp cogent version ; setupcogent.m v1.6.1 == setupcogent.m v2-alpha-3.
%                   DRAW*: Finalise syntax and documentation. <to be continued in 1.6.2>
%                   - Modif fun: drawround, drawsquare, drawrect, drawshape, drawline, getdraw, setdraw.
%                   - drawshape: Add 'Line' shape ; Systematic use of getdraw/setdraw.
%                   - drawround/drawshape: Fix hollow circle draw.
%                   Fix. startup: opendisplay: don't display 3 freq.
% 1.6.1.1           Minor doc. fixes. <bug: 4 digit version # not supported!>
% 1.6.2    03/10    PRIORITY FIX: Priority was raised by startcogent after opendisplay
%                                 ==> display testing was made at normal priority.
%                   - setpriority: Add 'OPTIMAL' priority.
%                   - getpriority: New fun. (+ New global var.)
%                   - opendisplay: raise priority to "optimal".
%                   - opensound: lower priority to "normal". (Modif fun: stopcogent)
%                   Fix startup:
%                   - Fix setupcogent: cd to work; setupcogent.m v1.6.2 == setupcogent.m v2-alpha-4
%                   - startcogent: Fix command syntax ; Fix display infos at the end.
%                   Fix cogenthelp.
%                   Change fun names: 
%                   - cogentdoc -> cogentmanual. (Modif fun: cogenthelp)
%                   - waitsynch -> waitsynch + waitbetweendisplays <todo: Chose between the two.>
%                   DRAW*: Fix definitive syntax + doc. ; Draw hollow square/rect frames.
%                   - Modif fun: drawshape, drawsquare, drawrect, drawround.
%                   - drawline: Fix missing LineWidth arg. ; drawshape('Line'): Fix multiple lines.
%                   SOUND: Review.
%                   - Modif fun: opensound, storesound, storetuut.
%                   - Cog2000 -> Cog2007: playsound, waitsound.
%                   - Delete fun: loadsound (now included in storesound), storepuretone.
%======================================================================
% 2.0     18/09		PSYCHTOOLBOX
% 2-alpha0		    From 1.5.6. Backports to 1.5.7. <Abandonned.>
% 2-alpha1          From 1.6.0
%                   New fun: startpsych, gettext, settext
%                   Modif fun: startcogent, setupcogent, setlibrary, opendisplay, stopcogent
%                      and lots of other !!!
%                   Renamed fun: drawimage -> storeimage (revert from 1.5.6).
% 2-alpha2          Hardware test LLN.
%                   New fun: makesinusoid (unfinished), testanimation.
%                   opendisplay: Fix screen # bug. Fix 'DisplayRect'.
%                   displaybufer: PTB: fix time, CG: suppress "floor" <!>
%                   setupcogent: fix: add stopcogent at the beginning.
%                   stopcogent: make it robust to version change.
% 2-alpha3          Port 1.6.1 (exept *draw* files):
%                   - Replaced file/folder (2-alpha2 -> 1.6.1): setupcogent, Lib\PTB
%                   - Modif. files: startcogent, opendisplay, openkeyboard.
% 2-alpha4          Port 1.6.1 (*draw* files):
%                   - Replaced files: drawshape, getdraw, setdraw, drawround, drawsquare, drawrect, drawline.
%                   Port 1.6.2:
%                   - setupcogent.m v1.6.2 == setupcogent.m v2-alpha-4
%                   - Other shared functions: setpriority, getpriority, cogentmanual, cogenthelp,
%                     opensound, storesound, storetuut, playsound, waitsound, waitbetweendisplays.
%                   - Common modif in: startcogent, opendisplay, stopcogent.
%                   DRAW*: Port drawshape on PTB.
%                   - New fun: xy2ij.
%                   - Modif draw* fun from 1.6.2: drawshape, drawline.
%                   - drawshape('BinaryMatrix'): unfinished.
% 2-alpha5          New fun: convertcoord, backgroundalpha, showimage.
%                   Modif fun: copybuffer, drawshape, iscog (returns v2). 
%                   Port fun on PTB: buffersize, waitsynch (!).
%                   Port 1.6.2: getdraw, setdraw <Where forgotten!>
%                   Moved fun: fitrange: From Cogent2007 -> BenTools.
%                   Fix fun: 
%                   - opendisplay: fix isTexture: logical. Fix alpha: now always initialized.
%                   - storeimage: fix cell arg.
%                   - deletebuffer
%                   - chekkeydown: minor fix (fix ';' + fix doc).
%                   - drawtext: See below.
%                   - gettext
%                   - measurescreenfreq: Fix cgflip case ; ...
%                   - clearcogent
%                   Delete files: cgloadlib124.dll, *.asv.
%                   Change global var.: 
%                   - background: Modif files: clearbuffer, cogentglobal displaybuffer getdraw newbuffer opendisplay setbackground setdraw waitscreen
%                   TEXT: Create a draft buffer ; Fix text position
%                   - Modif fun: opendisplay, drawtext, set-text, gettext.
%                   - Fix FonColor setting (alpha value was missing).
%                   FIX COGENT, STARTGLAB: 
%                   - startglab: New fun
%                   - startcogent: Fixed. Now only a wrapper for startglab.
%                   TIME/WAIT: <MAJOR FIXES!!!> <todo: backport maj fix on 1.6.3>
%                   - waitsynch, time, wait: Port on PTB.
%                   - waitsynch: Fix use global var. to know time of last display. <MAJOR FIX!>
%                   - waitsynch(t,unit)
%                   - waitframe: Cog2000 -> Cog2007.
%                   - Suppr. waitbetweendisplays
%                   - setlibrary: Suppr. 'Time' module. Time use now main lib for consistency.
%                   MEASURE FREQ.: <MAJOR FIX.!>
%                   - opendisplay: Recompute freq. if screen changes. <MAJOR FIX!>
%                   - measurescreenfreq: Port on PTB.
% 2-alpha6          measurescreenfreq, opendisplay: <todo: port on 1.6.3>
%                   - Test1: Default NumTestFrames: 300 -> 1000. 
%                   - Test2: Fix.
%                   - Test2-3: Display results.
%                   stopcogent: 
%                   - Make robust in case of startglab crash: Suppr. "if COGENT_IS_RUNNING" test.
%                   - Suppr. COGENT_BUFFERS.Sizes (never used elsewhere).
%                   *buffer: newbuffer: Fix global var ; deletebuffer: Fix multiple buffers.
%                   IMAGE:
%                   - samesize(...,'VH')
%                   - sameluminance: New fun.
%                   - backgroundmask(C)
%                   - scrambleimage: New fun.
%                   stdrgb: New fun.
%                   iscog, isptb: Fix.
%                   displayanimation: Fix doc. ; Fix input Args; setpriority OPTIMAL ; clear at end.
%                   copybuffer: Fix b0, b1 args ; Fix Alpha.
%                   stopcogent -> stopglab. stopcogent moved in Legacy.
%                   displaybuffer: Optimize: add "Screen('DrawingFinished')".
%                   GAMMA: ...
% 2-alpha7          Tests in EEG lab.
% 2-alpha8          sendparallelbyte: fix case port not open.  <todo: port on 1.6.3>
%                   waitsynch: waitsynch(0) ; Fix lib check.
%                   DISPLAYANIMATION:
%                   - Finish doc.
%                   - Rewrite 'Send' option.
%                   - Add 'Draw' option.
%                   - rtdisplay* -> moved to Legacy.
%                   - drawshape: All draw code here. (Code moved from drawcross to drawshape.)
%                   - 'AxesRotation', 'Orientation'
%                   ABORT: Modif. files: displaybuffer, waitframe, displayanimation
%                   openkeyboard: fix: blank -> zeros.
%                   stdrgb, samesize: Fix logicals.
%                   changebackground: New fun.
% 2-alpha9          Tests in EEG lab.
%                   displayanimation: Optim Fix!
%                   stopglab: Fix: close offscreen win/tex first.
% 2-alpha10         startglab: stopglab <- stopcogent
%                   \Legacy: Fix: All files (3) where missing in alpha9 (!?) ; + Add startpsych.
%                   \test: New sub-folder.
%                   backgroundmask:
%                   - Fix: RGBA ; Case bgcolor not given.
%                   - Add internal comments
%                   - Dilate bg
%                   - Fix case of uniform image
%                   samesize: 
%                   - Add syntax:  samesize(...,VH,mn,RoundTo)
%                   - Suppr. syntax:  samesize(I1,I2,...)  For simplicity and consistency with other same*
%                   opendisplay: default # test frames: 1000 -> 800.
%                   sinewave: Change args order <!>: "Duration": 3d arg. -> 1st arg ; Fix case nargin < 4.
%                   buffersize, displayanimation: Fix NaN arg.
% G-LAB ------------
% 2-beta0   12/12   CHANGE NAME !!! COGENT2007 -> GLAB
%                   See beta0_changelog.txt
%                   Fix glabversion: rewrite all. (Fix >3 element version # ; Fix consisteny check.)
%                   setupglab: Modif. setupglab(v). Not backward compatible with older version (!).
%                   Add \Tests dir.
%                   Doc changes: getscreenfreq, iscog, openkeyboard, setlibrary, wait*, opendisplay, open*port.
% 2-beta1           opendisplay: test freq: error -> warning.
%                   startglab, opendisplay: modif display in command window.
%                   sinewave: Fix Slopes.
%                   displayanimation: Splash.
%                   backgroundmask: Change arg order (arg2 <-> arg3).
%                   setgamma: Fix case GLab not started.
% 2-beta2           Beta test EEG + First exp.!!!
%                   displayanimation: Fix // events <major fix!>
%                   setgamma: Fix call before startglab
%                   backgroundmask: Fix color images <major fix!>
%                   convertcoord2: Optim convertcood. 19.6 ms -> 17.5 ms. Usefull?
% 2-beta3           multiplealpha: New fun.
%                   displayanimation: Get Keyboard option.
% 2-beta4 Jan 2009  Fix startcogent/startpsych without args.
%                   loadimage: Fix indexed images (256 colors) <still bug>: New fun: indexed2truecolor.
%                   opendisplay: fix syntax error.
%                   KEYBOARD: 
%                   - Fix opendisplay/openkeyboard chick and egg problem (startglab, openkeyboard, opendisplay, displaymessage).
%                   - Rewrite Cog2000 fun: waitkeydown, waitkeyup.
%                   - Fix: getkeycode.
%                   - New: getkeynumber.
%                   - Doc.: Finish doc. on several keyb. functions.
%                   opendisplay: return err.; fix startglab.
%                   install.txt
% 2-beta5           Fix install.txt: PTB still needed !
%                   displayanimation: Fix "Durations" spelling bug.
%                   Blank Buffer: opendisplay, setbackground, gbb (new fun). <TOD: Revert! clearbuffer(0) is enough.>
%                   setupglab: Fix remove previous versions from path.
%                   loadimage: Fix 2-beta4 (indexed images).
%                   indexed2truecolor: Fix for Matlab 6.5.
% 2-beta5a          Fix openparallelport('in').
% 2-beta6  March    PARALLEL PORT: Multiple ports + Port polling <not finished>.
%                   - Rewrite: openparallelport, closeparallelport, sendparallelbyte.
%                   - New: getparallelport, setparallelport, pollparallelport <not finished>.
%                   drawshape, drawtext: Check b (buffer) exists.
%                   drawshape: Fix current buffer (obsolete global var.)
%                   drawpolygon: New fun + modifs in drawshape.
%                   opendisplay: cosmetic.
%           June    getkeycode([]) returns now keyNumber=[] + fix waitkeydown ; waitkeydown: fix ';' bug.
%                   loadimage: Fix 'grayscale' mode in recursive call.
%                   drawshape: fix polygon on PTB.
%                   displayanimation: 
%                   - Suppr. X, Y input arg no more optional. B can be a scalar.
%                   - XAlign, YAlign optional args.
%                   - 'Scale' option.
%                   - 'Priority' option.
%                   - Fix case no ALPHA or no THETA.
%                   startpsych: <MAJOR FIX!> CogInput v1.28 unstable without CG display: Select PTB as default kb lib.
%                   opendisplay: Lower default # frames for test if windowed.
%                   buffersize: support array as input. <28 Jul: Fix optim pb with NaN.>
%                   setlibrary: - Don't stop glab anymore.
%                               - <!> Fix Cog 1.28 issue: PTB default keyboard library for Matlab 7.5/Cog1.28 <!> <Reverted v2-beta8>
% 2-beta7  July     KEYBOARD: 
%                   - Replace legacy key function by gekeynumber/getkeyname. This fix CogInput crash on Matlab 7.5.
%                     modif. files: displaywarning, displayerror, displaymessage, waitkeysequence, displayanimation.
%                     key: Add warning.
%                   - openkeyboard: - Fix: replace all NaNs by 0s in key # table, because NaNs cannot be converted to logical.
%                                   - Fix 2d key number for keys 16 (Shift) and 17 (Control) in PTB.
%                   - getkeycode: - Change output args: [keyCode,keyNumber] -> [keyCode,keyCode2,keyNumber,keyNumber2]
%                                 - Fix bug when input arg was a cell array.
%                   - getkeynumber: - Change ouput arg.: keyNumber -> [keyNumber,keyNumber2]
%                                   - Case when keyNumber argument is not a number.
%                   - getallkeynumbers: New function.
%                   - getkeyname: Support array as input.
%                   - displaymessage: - Fix bug with Cog as kb lib.
%                                     - Accept also key names & codes as arg. 
%                                     - Suppr. multiple key, to simplify code.
%           Aug     - openkeyboard: - Fix i error in last rows of 'COG' and 'PTB' matrices ; rewrite i update more robustly.
%                                   - Add F1 to F12 keys.
% 2-beta8   Sep/Oct Path: Add /Lib/PTB/PtbReplacement and /Lib/Gama ; modif setupglab  <Change Path!> 
%                   MOUSE: PORT ON PTB
%                   - setmouse, getmouse, waitmouseclick: port on PTB. <TODO: Fix coord on setmouse !!!>
%                   - setmouse, getmouse: Deprecate syntax using 'xy'. <!> <revert that ?>
%                   - PTB functions GetMouse & SetMouse replaced by PtbGetMouse & PtbSetMouse (to fix homonymy pb)
%                   getscreenfreq: Fix case GLab never started; Add 'nominal' option (PTB only. <todo: add CG support>
%                   drawpolygon, drawshape: Add drawpolygon(b,XY,XYXYXY,RGB) syntax, doc. only. <TODO: implement it!>
%                   send//byte: Parallel port not open: error -> warning.
%                   findmissedframes: new fun.
%                   LIB DEFAULTS: <!>
%                   - <!> setlibrary: Default kb lib for Matlab 7.5: Cog  <Revert v2-beta6>
%                   - <!> iscog, isptb: Fix case GLab not started: Default lib is Cog on Windows / PTB on others.
%                   displayanimation v2.2: 
%                   - line 277 remove 'getlibrary' let there for debug purpose.
%                   - 'Isochronous' option. <Bugs. Fixed in beta9>
%                   - <!> FrameErr becomes now a 1xN vector (instead of a scalar).
%                   getkeycode: fix missing ";" line 88
%           14/10   Deployed in CODE with SinStim 1.4 (never used).
% 2-beta9   Oct     PARALLEL PORT:
%                   - Optimization! (See http://psychtoolbox.org/wikka.php?wakka=FaqTTLTrigger) <TODO: test it!>
%                   - getparallelbyte: finish it.
%                   - setparallelbyte: fit range 0-255.
%                   glabreplace: new fun. Doesn't work.
%                   displayanimation: <Fix beta8>
%                   - non-isochronous case was broken.
%                   - fix ischronous mode: "j>N" bug 
%                   - 'FrameErrorEvent' option.
%                   preparesinanimation: 
%                   - use randpattern instead of randele.
%                   - add 'Phases' output arg.
%                   playsound: Suppr. checksound <todo: verif this !>
%                   showbuffers: Rewrite totally. <TODO: Fix waitkeydown on PTB !!!>
%                   drawshape: Fix PTB "draw on buffer other than 0" bug
%                   PHOTODIODE:
%                   - openphotodiode, setphotodiodevalue, closephotodiode: new funs
%                   - displaybuffer <!>, glabglobal, stopglab, displayanimation: modif.
%                   - <todo: auto switch off>
%                   getscreenxlim, getscreenylim: new fun.
%            Nov    displayanimation
%                   - Fix AxesRotation (broken in Oct)
%                   - Fix Scale        (broken in Oct)
%            4 Nov  Used in SinStim 1.5.1 (CODE)
%            5 Nov  Used in pilotess (Sylvie)
%           10 Nov  Used in SinStim 1.5.2 (CODE)
%                   displayanimation: 
%                   - Store all time vars in GLAB_FUNCTIONS.DisplayAnimation
%                   - Workaround "negtimes" bug <uneffective, definitive fix in beta10>
% 2-beta10  Nov     SERIAL PORT:
%                   - sendserialbytes: fix syntax bug
%                   - sendserialbytes: convert arg to double
%                   - openserialport: suppress GLab started condition.
%                   Optimization: replace convertcoord by convertcoord2
%                   stopglab: Add closeeyelink. <reverted>
%                   KEYBOARD:
%                   - Optimize getkeycode. <backported to 2-beta9 in CODE lab>
%                   TIME: <TODO: Rewrite this at the starttrial/displaybuffer/waitsynch/stoptrial level.>
%                   - startglab: Synchronize timers
%                   - displayanimation: Rewrite Workaround "negtimes" bug (v2-beta9/10nov)
%         10 Dec    Used in SinStim 1.6 (CODE)
% 2-beta11  Dec     EYELINK:
%                   - eyelink dir with new *eyelink* funs.
%                   - setupglab: Add eyelink dir.
%                   - glabglobal: Add GLAB_EYELINK.
%                   - closeglab: Add closeeyelink.
%                   - starttrial (see below): send synctime message.
%                   TRIAL:
%                   - starttrial, stopttrial, drawtarget
%                   - displaybuffer: modif. 
%                   PARALLELPORT:
%                   - setparallelbit: new fun
%                   opendisplay: Fix message when screen freq changes <TODO: fix this case!>
%         Jan 2010  TIME/TRIAL:
%                   - startglab: Fix timers synchro failure on some hardware: add a timeout of 2s.
%                   - displaybuffer(b,DUR); Doc: add Example.
%                   - starttrial, stoptrial: continue.
%                   - findmissedframes: 3 arg syntax. <todo: finish function>
%                   IMAGES:
%                   - loadimage: More options. Doc: add "See also".
%                   - resizeimage: New fun.
%                   - storeimage: Check display is open.
% 2-beta12  12 Jan  VERSION #: NEW VERSION # CONVENTION: Odd # are dvpt versions, even # are production versions.
%                   Used on Caroline's PC.
%       12a 20 Jan  Used on BUCKINGHAM. <sub-version # 'a' given retroactively, in 12b>
%                   DISPLAYANIMATION: Fix synchronous mode <!!!> <unfinished>
% 2-beta13          <fork: from 2-beta12a>
%                   starttime: Delete fun.
%                   measurescreenfreq -> sub-function in opendisplay
%                   SPLASH: opendisplay: Splash 'Graphics Lab'. + Fix font size on PTB.
%                   TRIALS: 
%                   - savetrials: new fun <unfinished>
%                   - replace GLAB_TRIAL.Current* -> GLAB_TRIAL.i*
%                   - stoptrial: was mistakenly in "eyeview" folder.
%                   - displaybuffer: error message if called w/o Dur argument during a trial.
%                                    <todo: What about e.g.: displaybuffer; waitkeydown ???>
%                   waitsynch: 
%                   - Fix 'frame' arg.
%                   - Units: rewrite code to clean it
%                   - fix % bug
%                  <todo: displaybuffer: add unit arg.>
% 2-beta12b 27 Jan  VERSION #: 
%                   - glabversion, setupglab: Add subversion <!>  <todo: bug check version #s consistency>
%                   - glabversion('str')  <better for fw compat.>
%                   DISPLAYANIMATION v2.7: 
%                   - Fix isochronous mode <!!!> and add STATS
%                     * Suppress backward compat. GLab v2-beta9-10nov/Sinstim 1.5.x
%                     * Suppress workaround "negtimes" bug (actually isochronous bug)
%                     * Move error messages from Sinstim 1.6.2.
%                     * Make the function verbose
%                     * Export "stats" variable to ws
%                   - Check all warnings in Matlab7.5 editor.
%                   displaymessage: Add TimeOut optional arg.
%                   waitkeydown: 
%                   - Fix 'lib' arg. doc.; duration -> timeout
%                   - Fix case 3 input args.
% 2-beta14          <end fork: Merge beta12b and beta13>
%                   waitsynch: Fix beta13
%           1 Feb   Used on BUCKINGHAM.
%                   round2freqdivisor: Fix missing 2d arg in doc.
%                   DISPLAYANIMATION: v2.7.1
%          12 Feb   Used on BRAGELONNE.
% 2-beta15  3 Feb to ...        
%                   TRIALS:
%                   - Change PERDISPLAY sub-fields names
%                   - starttrial, stoptrial, savettrials: fix and finish saving.
%                   glabcheck: new fun.
%                   PHOTODIODE:
%                   - Field 'isOpen' -> 'Locations'
%                   - Support rect instead of square for PSB
%                   PSB:
%                   - PSB folder
%                   - openpsb, closepsb, psb_*: new funs
%                   - glabglobal: update
%                   - psbblueblanking -> psb_fullblanking
%                   TDT:
%                   - TDT folder
%                   - tdt_* funs
%                   isopen: new fun
% 2-beta16 12 Feb   Used on GALILEO.
%          23 Feb   Hack: com4 -> com3 (Matlab 6.5 only)    
% 2-beta17          gettrials: was in wrong dir. + fix ";" bug.
%                   PSB: move CDM20600.exe from Glab*/Lib/PSB to GLab/PSB <todo: auto install>
%                   COGENT 1.29 <!!!>
%                   - Add v1.29 ; Becomes default in Matlab 7.5+ <!!!>
%                   SERIAL PORT:
%                   - Add GLab*/serial folder. Move all files into it.
%                   - Add MATLAB library <!>
%                   - setlibrary/getlibrary: updtate ; add Matlab version ; fix case n version #
%                   - readserialbytes: Suppress function <!>
%                   LIBRARIES:
%                   - glabglobal: add GLAB_LIBRARIES.
%                   - setlibrary/getlibrary: add MATLAB lib for serial port.
%                   - setlibrary/getlibrary: add Matlab version ; fix case n version # ; 
%                   - getlibrary: Fix current version display in command window.
%                   LINUX: 
%                   - Update/fix funs: setupglab, setlibrary, getlibrary, setpriority, startglab, 
%                     iscog, displayanimation, openparallelport, sendparallelbyte
%                   - setupglab: Replace "cd(<matlab>/work)" by "cd .."
%                   - <Fix PTB !> 
%                     KbName('UnifyKeyNames') sends a warning:
%                     "WARNING! Remapping of Linux/X11 keycodes to unified keynames not yet complete!!"
%                     KbName, line 798, 807-816: Add TRY statement to fix KbName('UnifyKeyNames') on azerty kb on Linux  
%                     Not enough: I still have bugs in subsenquent code in openkeyboard
%                     -> openkeyboard: Don't use KbName('UnifyKeyNames') on Linux!
%                   - openkeyboard: Strange bug line 135: "chars = ',;:=��^$)<�';" 1 char was missing!
%                   - openkeyboard: Hard-coded modifs in PtbNames.
%                   - openkeyboard: Add TRY statement for 'Shift' and 'control'. <TODO: Suppress generic names>
%                   - openkeyboard: Suppress 'PrintScreen'
%                   - GLab-2*/Lib/ -> GLab-2*/lib/ ; modif setupglab (25/03)
%                   BATCH MODE: 
%                   - displaymessage: Default timeout 10 sec (for stability: avoid to be stuck).
%                   DISPLAYANIMATION: 
%                   - Fix thresh for missed frames warning.
%                   - Add matlab version in 'stats'.
%                   - Modif for test purpose: display priority <TODO: revert it!>
%                   openglabfolder: new fun.
%         -12 mar   setpriority: : Fix buf with cogstd (broken in beta17); Display priority change.
%                   getpriority: Fix realtime case under PTB. <TODO: review getpriority !!! Record priority in displayanimation>
%         -18 mar    displayanimation: Log: minor fixes.
%                   showimagediff: new fun.
%                   INFO:
%                   - dispinfo: New fun.
%                   - Add messages/Replace disp by dispinfo, in: starglab, setupglab, stopglab, openparallelport, setpriority
%                   - setpriority: add '-silent' option.
%         -24 mar   TRAJECTORIES:
%                   - display*: Fix 'tolwin' option doc.
%                   - prepare*/display*: Use '-optionname' convention: 'tolwin' -> '-tolwin' 
%                   - prepare*/display*: '-sound': New option.
%                   - display*: Fix case no tol. win.
%                   - prepare*: Fix Examples in doc.
%                   - prepare*: Fix -tolwin option doc: remove obsolete isWin arg.
%                   - prepare*: Fix 'Phase' arg. case (lower(Phase) at wrong position)
%                   - prepare*: 'none' -> ''
%                   - <TODO:> Change arg order, see humanlab2_demo_beta18alpha
%                   drawround, drawsquare, drawrect: Fix LineWidth doc.
%                   getframdur: Add 'nominal' option. Fix doc. getscreenfreq: cosmetic changes.
%                   isopen: Add 'glab'.
%                   SOUND:
%                   - opensound: Suppr. check GLab open. <reverted>
%                   - opensound: Info.
%                   - storewhitenoise: New fun.
%                   - <TODO!> storewhitenoise, storetuut: Add amplitude arg.
%                   BACKGROUND:
%                   - setbackground: Add setbackground(buffer)
%                   - opendisplay, clearbuffer: modifs
%                   - <TODO:> BlankBuffer is not used: replace by DrawBuffer, replace 0 by DrawBuffer value
% 2-beta18 29 mar   Marcus
%                   displaytrajectory: Fix case several traj.
% 2-beta19 01 Apr :-)
%                   setupglab: Fix 2-beta17: Fix no cd->work, case 1 input arg..
%                   TRAJECTORIES:
%                   - prepare*/display*: version 2 <!!!>
%          15 Apr   DISP INFO:
%                   - dispinfo: Mod. doc.
%                   - Add dispinfo to: openeyelink, checkeyelink, opentdt, startglab, openkeyboard, 
%                     opendisplay, stopglab, 28apr: checkerrors
%                   EYELINK:
%                   - Port on Matlab 6.5. Works only on bt 0.10.4.16. (<!> Suppr. warnings: see openeyelink)
%                   - calibrateeylink/EyelinkDoTrackerSetup_Modified: Fix: EyelinkClearCalDisplay not more used.
%                   - isopen: Add isopen('eyelink')
%                   - calibrateeyelink -> calibeyelink
%                   - calibeyelink: sub_EyelinkDoTrackerSetup
%               <!> SETUPGLAB:
%                   - Always run setupbentools
%                   - Try to run SetupPsychtoolbox if PTB not already installed.
%                   - Check bentools version. <UPDATE BT VERSION # ON NEXT GLAB VERSIONS !!!>
%                   TRIAL EVENTS:
%                   - helper_perframeevents: New helper fun.
%                   - displaybuffer: big modifs
%                   - waitframe: use helper_perframeevents
%                   - waitsynch: always use waitframe
%                   - starttrials: init // out vars
%                   displaybuffer: Delete 'dontclear' option commented code.
%                   isopen: Add 'parallelport'.
% 2-beta20  29 Apr  Labo TMS.
% 2-beta21  04 May  EYELINK:
%                   - geteyelinkfile: script -> function (why was it a script?) ; input args
%                   - geteyelinkfile: 'active.edf': default in <glabroot>/tmp
%                   - sendeyelinksync: add disp time.
%                   deg2pix: Fix case WidthCM not set.
%                   TRAJECTORIES:
%                   - preparetrajectory: Rewrite options with findoptions <BT v0.10.5>
%                   - preparetrajectory: Fix example (was totally obsolete).
%                   - preparetrajectory, displaytrajectory: Phase -> Movement
%�                  TRIALS:
%                   - stoptrial: Fix case expected duration = inf.
%                   waitsound: comment line 27: error(checksound)
%          /26 may  PSB:
%                   - COM# becomes an argument: openpsb('COM#').
%                   - Code moved in new helper fun.: psb_sendserialbytes, psb_getserialbytes.
%          /31 may  savetrials: moved from "toolbox+" to "toolbox+\GLab-2-beta21"
%          /01 jun  TRAJECTORIES:
%                   - displaytrajectory: Eyelink support.
%                   EYELINK 3.10:
%                   - openeyelink: Record Eyelink version.
%                   - checkeyelink: Fix "record flag inversion" bug in Eyelink CL 3.10 (Marcus') <!>
%                   - checkeyelink: Fix case unknown arg.
%                   - calibeyelink: Make it verbose. /02jun: Dipslay key shortcuts doc from manual p.29.
%                   - calibeyelink: open Eyelink if required.
%          /02 jun  - checkeyelink: Fix IP in error message.
%                   - checkeyelink('isconfigured'): returns -1 when ipconfig returns "Media disconnected".
%                   - Cosmetic: replace "Eyelink" -> "EyeLink".
%                   - geteyelinkfile: Fix EyeLink 3.10 bug: Eyelink('ReceiveFile') returns 0 instead of file size.
%                   - starttrial, stoptrial: remove start-, stopeyelinkrecording. Now record is started at
%                     block start <!!!>. starttrial: replace by a checkeyelink('isrecording').
%                   - calibeyelink: Update bg color + fix fg color.
%                   -> <todo: calibeyelink: replace KbCheck by waitkeydown to avoid Matlab crash after>
%                   - start-, stopeyelinkrecording -> start-, stopeyelinkrecord.
%                   openpsb: Execute only if GLAB_PSB not empty.
%                   dispinfo: moved from GLab -> bentools ; setupbentools updated <!>.
%          /08 jun  savetrials4eyeview: Save first all vars for safety, then append EV vars in the same file.
%          /10 jun  (geteyelinkfile: Check EL status. <Reverted: opneeyelink needs display open.>)
%                   closeeyelink: executes geteyelinkfile before closing link.
%                   geteyelinkfile: verbose.
%                   savetrials4eyeview: - Fix doc. - Try to fix "Error using ==> psychhid" bug (???).
%                                       - Rplace *.g4e -> *.gdf.
%                   starglab: display title.
%                   edf2asc.m: New file. Still empty.
%          /11      CM/DEG:
%                   - dispscreenresolutions: New fun
%                   - startglab: runs stopglab only if not GLAB_IS_RUNNING <!!!>
%                   - setscreensizecm, getscreensizecm: New fun.
%                   - opendisplay: uses getscreensizecm to setup GLAB_DISPLAY.ScreenSize_cm.
%                   - setscreenwidthcm, getscreenwidthcm: obsolete -> /Legacy <!> NB: only used on joystick_erwan#.
%                   - deg2pix, pix2deg: <TODO: case GLab not started> 
%                   - isopen('display'): fix test.
%                   - stopglab: resets GLAB_DISPLAY.ScreenSize_cm = []; <TODO: what appens if pix2deg used after stopglab ???>
%                   TRAJECTORIES -> FRAME SEQUENCES:
%                   - prepareframeseq: New fun. <todo>
%                   HARDWARE:
%                   - config file is always: "X:\glab-hardware.conf", where X: is the drive where GLab is installed.
%                   - setharware: New fun
%                   STATUS:
%                   - Suppr GLAB_FIRST_START_DONE (not used).
%                   - <TODO> opendisplay: replace persistent 'Old' by GLAB_DISPLAY.OLD
%                   - <TODO> setdisplay: New fun.
%                   - <TODO> GLAB_IS_RUNNING -> GLAB_STATUS.isStarted (! if tests: use isopen !!!)
%                   - <todo> GLAB_DEBUG -> GLAB_STATUS.DEBUG
%          /14-18   editglabversion: New fun.
%                   SAVETRIALS4EYEVIEW: 
%                   - to 1.0
%                   - <TODO> Implement varargin
%                   - <TODO> get .edf file
%                   CM/DEG:
%                   - setviewingdistancecm, getviewingdistance: New funs.
%                   - deg2pix, pix2deg: manage viewing distance.
%                   - opendisplay: First run: setviewingdistancecm(57);
%                   clearglab: Add dispinfo.
%                   EYELINK:
%                   - openeyelink, opendisplay: The second to be run sets the display resolution on the EL system.
%                   - edf2asc.m: 
%                     -- Write function. 
%                     -- Exec dir is: "X:\glab\lib\" <!!>
%                     -- Temp dir is: "X:\glab\tmp\" <!!>
%                     -- <TODO: Move output file to original EDF file's dir>
%                     -- <TODO: Check options in read_data_eyelink>
%                   startglab, opendisplay, stopglab: Review verbosity.
%                   startglab: Moved setpriority to the end.
%                   startglab: Fix timers synchronization: use tic & toc and not time() to check timeout.
%                   startglab: Add timer drift test at the end. <TODO: does not work. Move test to stopglab.>
%                   DIRS:
%                   - New folder : "demos\" ; Update setupglab. (+ change ordes of dirs in setupglab)
%                   - Put inside, changing names: humanlab2_demo_* -> marcuslab_demo_*
%                   - "Legacy\" -> "legacy\"
%                   getscreensizecm: Add a programmer note about units (cm vs mm).
%                   opendisplay: GLAB_DISPLAY.isAplha -> .isAplhaMode4CG (not yet used <!>)
%                   getscreenres, +opendisplay: Fix case after stopglab. <medium bug!>
%                   cdglab: cdglab(subdir)
%           /21-22  TRAJECTORIES/FRAMESEQ:
%                   - prepareframeseq: Implement input arg order modification. 
%                   - marcuslab_demo_beta21.
%           /23     drawhshape: Fix 'polygon'.
%                   DRAW:
%                   - drawshape('polygon',b,XYXYXY,RGB): Fix.
%                   - drawshape('polygon',b,XY,XYXYXY,RGB): Implement.
%                   - drawshape('polygon',...) : Fix LineWidth (bug only on PTB, because hollow polygons not supported on Cogent).
%                   - draw: New fun. drawshape -> draw. Modif: Modify RGB arg order. <!!!> Rewrite all <!!!> <ALPHA>
%                   - other draw* (except drawtext): deprecated <!?!?>
%                   getbeamposition: New fun.
%                   copybuffer: 'Option' -> '-option'.
%           /28-29  TRIAL / EVENTS:
%                   - helper_dispevent: New fun.
%                   - displaybuffer, sendparallelbyte: dispinfo -> helper_dispevent.
%                   - setpriority: Minor modif dispinfo.
%                   - helper_dispevent, startglab, stoglab: doDisplayTimes=1: print after trial, doDisplayTimes=2: print during trial,
%                   - stoptrial: Wait last event <Major fix!>
%                   stopglab: setgamma(1) <TODO: Redo that properly.> ; Suppr GLAB_TRIAL = [];
%                   starttrial, startglab: Fix trial # after crash.
%                   stoptrial: Fix case aborted.
%                   iscog: Fix case bug. <TODO: Check case in setlibrary>
%            /30    glabhelper_* : checkerror, helper_perframeevent, helper_dispevent, glabcheck -> glabhelper_*
%                   glabtmp: New fun. <TODO: Use it everywhere!>
%                   glabreplace: Fix it.
%                   stoptrial: Fix isWaitingFirstFrame.
%                   TRIAL:
%                   - waitsynch, displaybuffer: Implement:  displaybuffer(b); waitsynch(dur);  <!!>
%                   - waitframe: Fix PTB case.  <Major fix !!>
% 2-beta22  01 Jul  x setupglab: Update bentools version required.
%                   x Run glabmanual.
%                   x Delete *trajectory.
%                   x Delete legacy\rtdisplaysprites, legacy\rtdisplaybuffers.
%                   x Delete *.m~
%                   o Empty \log.
% 2-beta23  09 Jul  storeimage: Add PTB doc.
%                   displayanimation: fix ";" bug.
%                   isopen, glabhelper_check: Optimization <!>: Don't use glabglobal.
%                   storeimage: Optimize: 4ms -> 1ms on CHEOPS.
%          /12      STARTGLAB: -KEEP OPTION
%                   - startglab, stopglab, clearglab: '-keep' option.
%                   - startglab: Moved disp info and stop glab code after global vars are defined.
%                   - opendisplay: Fix "startpsych(n)" syntax.
%                   TARGETS & FRAMESEQ:
%                   - drawtarget: Replace drawshape by draw. <!>
%                   - prepareframeseq: Invert Color and Size args order (for consistency with draw). <!>
%                   - prepareframeseq: Fix last_x, last_y in 'gap' case.
%                   - drawtarget: Replace target tag by target # <!>
%                   - drawtarget: Add b arg. (for consistency with draw). <!>
%                   o <TODO!> drawtarget(i,...) -> draw(...,'-target',i)
%                   - displayframeseq: Fix movement = ''
%                   displaybuffer: Suppr. disp. events when duration = 1 frame.
%                   DRAW:
%                   - draw('arrow'): Implement.
%                   - draw: Fix Theta.
%                   o draw('polygon'): Fix Theta/LineWidth.
%                   MOUSE:
%                   - PtbGetMouse: Fix doc.
%                   - opendisplay: Record MouseOnset4PTB. <!>
%                   - opendisplay: Call setmouse to put cursor out of display.
%                   - getmouse: Rewrite PSB case (big simplification).
%                   - setmouse: Review totally PTB part (was totally buggy).
%          /13      FILTER:
%                   - filterbuffer: New fun. 
%                   - copybuffer(...,'-filter',kernel): New option.
%                   - optimize!
%                   - opendisplay: Initialize OpenGL. <!>
%                   - glab*/lib/PTB/PtbModified/LoadGLSLProgramFromFiles: Modified PTB function <!!!>
%                   - setupglab: Add "glab*/lib/PTB/PtbModified/" dir.
%                   - opendisplay: use to load shaders <!!>
%                   o <TODO> filterbuffer: inchannels & outchannels as args. Inversion ?!?
%                   o <TODO> Optimize: Prepare filter in advance.
%                   stoptrial: fix case no // out.
%          /14-16   - oneframe: New fun. Easier to use than getframedur. (Returns always something.)
%                   FRAMESEQ:
%                   - displayframeseq: Use starttrial(nFrames);
%                   - prepareframeseq: error if unknown shape.
%                   - frameseq: Change name <!!>: prepareframeseq -> frameseq 
%                   - frameseq: getframedur('nominal') -> oneframe. Seems to fix major bug when frq measure error.
%                   - displayframeseq: Use starttrial(nFrames);
%                   - prepareframeseq: error if unknown shape.
%                   - frameseq: Change name <!!>: prepareframeseq -> frameseq 
%                   - frameseq: getframedur('nominal') -> oneframe. Seems to fix major bug when frq measure error.
%                   displayanimation: disp -> dispinfo
%                   sg: New fun.
%                   STARTUP:
%                   - startglab: Dissable JIT accel in M7.5. <MAJOR OPTIMIZATION !!!>
%                   - startglab: Store random seed in global var.
%                   - startglab: GLAB_STATUS.wasStarted replaces GLAB_FIRST_START_DONE, suppressed in v2-beta21.
%                   - setupglab: clear GLab when version change. <Rewrite totally buggy code v2-beta21 !!!> <MAJOR FIX!>
%                   - clearglab: run stopglab inside a TRY, to fix stopping other GLab versions.
%                   - opendisplay: Invert tests 1 and 2. <!!>
%                   - waitframe, opendisplay: Fix Hz err in windowed display. <MAJOR FIX!!!>
%                   - opendisplay: Review dispinfo.
%                   Review to do 2.0 below.
%                   TRIALS:
%                   - trials2block: New fun.
%                   - glabhelper_processtrials: New fun, used by gettrials.
%                   - starttrials: Uncomment fields definitions.
%                   - Change field names: .*Times -> .*TimeStamps  <!!>
%                   - tr.PERDISPLAY.TARGETS.Tag -> tr.TargetNames  <!!>
%                   - starttrials: Add StartDate.
%                   - Add BeforeDisplayTimeStamps, AfterDisplayTimeStamps
%                   o <TODO> Error summary
%                   o <TODO> TARGETS(iTar) -> OBJECTS.(tarName)   !!!
%                   o <TODO> PERDISPLAY -> PERFLIP.(tarName) 
%                   o <TODO> i*, n* -> *Count
%                   o <TODO> starttrial: first arg = cell arr with tar names OR tar#
%                   o <TODO> drawtarget: first arg = tar# OR tar name
%                   ? <TODO> field names: plur -> sing  <???>
%                   stopglab: Fix verbosity.
%                   DRAW:
%                   - Optim: buffersize(b) -> Screen('WindowSize',b)
%                   o <TODO> OPTIMIZE DRAW !!!
%                   editglabversion -> edgv
%                   displaywarning, displayerror: Add beep.
%                   displaymessage: Fix old "Press E to..." bug.
%          /19-23   Count LoCs: 13448.
%                   stopglab: Fix case missing GLABDISPLAY.doKeep field.
%                   onedegree: New fun, unfinished.
%                   EYEVIEW
%                   - savetrials4eyeview: Save offset & gain to convert from EyeLink's coord to cart coord in deg.
%                   - savetrials4eyeview: Open trials in Eyeview.
%                   - savetrials4eyeview: Get EyeLink file.
%                   - savetrials4eyeview: Eyeview events.
%                   - savetrials4eyeview: Fix secondary targets (-> T2h, etc.) & online eye (-> Oh, Ov).
%                   DIRS
%                   - tmp: Use always glabtmp.
%                   - glablog: New fun.
%                   - displayanimation: Use glablog => Log in x:\glab\var\log. Log only if full screen.
%                   isfullscreen: New fun.
%                   EYELINK
%                   o TODO: Eyelink coord: graph -> cart. <???>
%                   - geteyelinkfile: Fix doc.
%                   stopglab: Avoid try statement on one line to avoid annoying warning on M7.5.
%                   filterbuffer: Change nrinputchannels, nroututchannels. <Seems ~= on DARTAGNAN & CHEOPS !!> <TODO: become arg.>
%                   FIX PTB: EXPCreateStatic2DConvolutionShader, line 132: Fix ";". <FIX PTB!>
%                   STARTUP:
%                   - PRIORITY: startglab: Suppr. HIGH priority. <!!!>
%                   - PRIORITY: stoptrial: Set priority NORMAL <!>
%                   - opendisplay: NumFramesForQuickTest = 50;
%                   - opendisplay: Re-invert test 1 & 2 <revert v. /14-16> because message string disappeared.
%                   TRIAL:
%                   - glabhelper_processtrials: Fix case no // out.
%                   - glabhelper_processtrials: Fix case only 1 or 2 frames in trial.
%                   - displaybuffer: warning if Duration argument is missing.
%                   - displaybuffer: Fix displaybuffer(b,dur) doc.
%                   - displaybuffer: Fix Tag arg.
%                   - stoptrial: Fix isParallelOut
%                   - starttrial: Add TargetNames arg.
%                   o TODO: Add SoundOut events.
%                   FRAMESEQ:
%                   - displayframeseq: Record "Movement" as Tag.
%                   - displayframeseq: Fix multi-targets doc.
%                   o displayframeseq: Fix target names.
%                   o TODO: *frameseq: draw order.
%                   OPTIM:
%                   - gcw, opendisplay: Optim gcw: 131 us -> 16 us (on CHEOPS). 
%                   - iscog, isptb, setlibrary: Optim iscog, isptb: 75 us -> 15 us (on CHEOPS).
%                   - convertcoord: Optim convertcoord: 250 us -> 175 us (on CHEOPS).
%          /26-30   TEST on ATHOS setup:
%                   opendisplay: Fix gcw optim.
%                   oneframe: Fix optim.
%                   startglab: Fix order of operations: disp > set lib & path (setupglab!) > global vars.
%                   startrial: Eyelink Add starteyelinkrecord instead of error message.
%                   glabhelper_processtrials: Fix case # trials > 1.
%                   savetrials4eyeview: Fix save version bugs. <!>
%                   savetrials4eyeview: Suppress saving mfile content. (Was not correctly implemented + pb with reading executing mfile)
%                   EYELINK: See help openeyelink.
%                   - geteyelinkfile -> launched by close eyelink
%                   - start-/stopeyelinkrecord: disp info.
%                   - openeyelink: Rewrite Function Overview in doc.
%                   - openeyelink: Add CalibGrid arg and launches calibeyelink (first time only).
%                   - openeyelink: Crash in case of "Error in connecting to the eye tracker".
%                   - openeyelink, calibeyelink, closeeyelink: Fix GLAB_EYELINK.isCalibrated.
%                   - openeyelink: Fix global vars def.
%                   - geteyelinkfile: Fix GLAB_EYELINK.isFile*.
%                   - calibeyelink: Fix case calib aborted: Don't set isCalibrated=1.
%                   - starteyelinkcalib: New fun.
%                   - savetrials4eyeview: Fix deg to pix conversion.
%                   stoptrial: Fix disp info order.
%                   savetrials4eyeview: Fix FILE.Tfrq.
%                   drawtarget, displayframeseq: Fix b arg bug. <!>
%                   opendisplay: def # test frames: 800 -> 600.
%                   EYEVIEW:
%                   - savetrials4eyeview: Fix: remove old .asc file if there is one.
%                   - savetrials4eyeview: Fix gap & rampe events.
%                   - savetrials4eyeview: Add date suffix.
%                   - savetrials4eyeview: Fix gui input. <yet not tested>
%                   - savetrials4eyeview: Fix case M6.5.
%                   marcuslab_demo_beta23 -> frameseq_demo
% 2-beta24          x setupglab: Update bentools version required.
%                   x Run glabmanual.
%                   x Delete *eyelinkrecording.
%                   x Delete *.m~
%                   x Empty \log.
%                   x glabhelper_processtrials: suppr debug mode.
%                   starttrack: New fun.
%          /30 Aug  - openeyelink: Fix missing bg when run befre startglab.
%                   - openeyelink: Fix ";".
%                   - starteyelinkcalib: Finish doc. Add dispinfo.
%                   - openeyelink: Update doc.
%          /02 Sep  - startglab: Fix lib bug (!): invert setupglab & setlibrary(Lib)
%          /03                   + add glabglobal after setupglab <!>
% 2-beta25  09 Sep  PSB: VARIABLE COM#:
%                   - openpsb: New arg: openpsb(#) or openpsb('COM#')
%                   - psb_sendserialcommand, psb_getserialbytes: New funs.
%                   - openpsb, closepsb, psb_fullblanking, psb_getkeydown: Modif to use new funs.
%                     (with an exeption in closepsb (see code).)
%                   PSB: Misc.:
%                   - closepsb: Was in wrong dir.
%                   - openpsb: Check if GLab started and PSB not already open.
%                   - psb_getkeydown: Include modif from 2-beta16/GALILEO.
%                   LIBRARIES (/KEYBOARD):
%                   - getlibrary: Fix no arg case: A non-std char had been replaced by an editor. 
%                   - setlibrary: Fix doc, same pb as above.
%                   - waitkeydown: Fix no arg case over PTB.
%                   - <info> Current kb lib default: setlibrary/startpsych: <not modified, finally> <TODO: Review that>
%                           - Win + Matlab 6.5 + Cog:   Cog
%                           - Win + Matlab 6.5 + PTB:   PTB  <set in startpsych: todo: -> Cog ?>
%                           - Win + Matlab 7.x + Cog:   Cog
%                           - Win + Matlab 7.x + PTB:   PTB
%                           - Unixes:                   PTB
%                   - <TODO: waitkeydown: rewrite using waitframe>
%                   - <TODO: getlibrary: Priority lib setting not used.>
% 2-beta26  13 Sep  Used on PORTHOS.
%          /14      - psb_sendcommand: Add debug mode (disp echo)
%                   - openpsb, psb_getkeydown: Cosmetic modifs.
% 2-beta27  15 Sep  LINUX:
%                   - Fix case in sub-dirs names: /Test -> /test, /Legacy -> /legacy
%                   - startglab: Fix "dt" var not defined: suppr. dt computation on Unix.
%                   - setupglab: Fix glab dir creation: create ~/glab/
%                   - opendisplay: suppr. InitializeMatlabOpenGL and loading of shaders on Linux: it crashed.
%                   - glablog: Fix function's in doc.
%                   - glablog: on Unix, log dir = ~/glab/var/log
%          /22      MACOS X:
%                   - openkeyboard: Fix case of 0 keys (bugged because of'00' and '000').
%                   - openkeyboard: Fix case of 0 backspace and del keys.
%                   - openparallelport: Review dispinfo.
%                   - setpriority: Test Mac code. Add in-code comments. Review dispinfo.
%                   - opendisplay: Priority: "HIGH" -> "OPTIMAL". Check all other functions.
%                   displayanimation: Review dispinfo.
%                   MATLAB 7.6+:
%                   - Test accel off: (OK!) First loop: 15.7ms -> 3.7ms, 2d loop: 30.5ms -> 4.9ms <todo: disp 3d loop ?>
%                   startglab: Add signature.
% 2-beta28  30 Sep  x setupglab: Update bentools version required.
%                   x Run glabmanual.
%                   x "Misc. Documentation" -> "MiscDocumentation"
%                   Test in LLN with Adriano's experiments.
% 2-beta29  08 Oct  openkeyboard: Fix non-ascii char (>127) replaced by '�' by the UNIX Matlab editor (v7.6)
%                   openkeyboard: <hack> Fix 'NumLock' key bug on Stanford's Mac. <!!! Backported on 2-beta28 in Stanford !!!>
%                   wait: Fix case GLab not open: Use PTB by default (because it's not a busy wait).
%                   waitkeydown: Fix case wrong key pressed.
%                   DISPLAY:
%                   - displaybuffer: (PTB + Cog >1.25) Add '-dontclear' option. <!>
%                   LIBRARIES:
%                   - startglab: "startglab('Cog1.2#')" syntax <!>
%                   - startglab: By default, sets now v1.29 as the Cogent version when Cogent is the main lib. <!!!>
%                   - setlibrary: Add internal comments.
% 2-beta30  12 Oct  Used on PORTHOS (Emeline & PA). Used by Henryk.  <startcogent broken in 2-beta29! ; fixed 18 Oct>
%                   glabversion: Fix '�' bug.
%          /15 Oct  iscog, isptb: Fix case G.Lab not started. Cog is default lib on Windows. <!!!>
%          /18 Oct  Fix: startcogent: 'CG' -> 'Cog' <fix 2-beta29>
% 2-beta31  18 Nov  <TODO!> copybufferrect: Fix pos. <TODO!>
%                   clearglab: Add "catch" statement to fix ML 7.5 warning.
% 2-beta32  30 Nov  ERP Lab (SinStim 1.8, Dana)
%       /25-Jan-2011 opensound: Fix it on Matlab 7.5: Comment line 73: " cogcapture('Initialise'); " <does not work!>
% 2-beta33  15 Dec  FOURIER: fouriertransform, fourierinverse: New fun.
%         Jan 2011  gammaexpand, gammacompress: doc+.
%                   stopglab: accel off ; startglab: suppr unused 'isJIT' flag in glabal var.
%                   setupglab: doc+ about disabling Aero in Vista/Win7.
%                   openserialport: Add a todo about PsychSerial from http://psychtoolbox.org/wikka.php?wakka=PlatformDifferences
%                   SOUND: PTB BASIC MODE
%                   - opensound: v2.0 +PTB/basic
%                   - opensound: Fix it on Cog/ML7.5: Comment line 73: " cogcapture('Initialise'); " <Backported on v2-beta32/25-Jan-11>  <does not work!>
%                   - setlibrary: Add 'PTB' as available sound lib.
%                   - startpsych: ...
%                   - startglab: <todo: ...>
%                   - closesound: new fun ; stopglab: code moved to closesound ; Fix rmfield(cogent)
%                   - isopen, glabglobal: update.
%                   - storesound, waitsound: Update v2.0  <Cog broken, fixed 08 Feb>
%                   - playsound -> startsound
%                   - loadsound: new fun
%                   isopen: Moved global statements at head of files ; Add error message for unknown modules.
%                   time: time(0): issue error if GLab is waiting for display duration (fix Henryk bug).
%                   PARALLEL PORT:
%                   - openparallelport: Check daq toolbox is installed.
%          /08 Feb  loadimage: Always verbose when directory as argument (fix possible state bugs).
%                   loadimage: Error when no image found in dir.
%                   SOUND:
%                   - <BUG!> Known bug: non-understood Cogent bug on Matlab 7.5: Add doc about it in opensound. <BUG!> 
%                   - storeimage: Fix storesound (broken Jan 2011). 
%                   - opensound: Always use PTB if GLab not started.  <!!!>
%                   time: Doc: time(0) deprecated. <!>
% 2-beta34          On Anne's Z400. <but not used, see beta36>
%           /Mar    + some misc. doc.
% 2-beta35  17 Mar  DRAW: 
%                   - Draw dots /PTB
%                   - draw('dots') -> draw('squaredots') | draw('rounddots')
%                   SOUND:
%                   - opensound: Fix example in doc.
%                   - opensound: Fix output mode /PTB on Cheops: PsychPortAudio('Open',...) waits scalar 'channels' arg. 
%                   - opensound: Fix input mode /PTB on Cheops: id.
%                   - opensound: Add 'RecordDuration' arg.
%                   .<TODO: Rewrite COgent's preparererecording, recordsound, waitrecord, getrecording.>
%                   - getsoundrecord: New fun. /PTB <TODO: Cog>  <changed name 12 Apr>
%                   - waitsound: Fix /PTB.
%                   calibbrightness: New fun.
%                   drawalpha: New fun <unfinished>
%                   matdraw: New fun <unfinished>
%          /12 Apr  SOUND:
%                   - getsounddata: Change name: getsoundrecord -> getsounddata
%                   - waitsoundtrigger: New fun.
%                   .<TODO: startsound: review doc (update for record, t0= estimate>
%                   - opensound: update doc.
%          /15 Apr  isabort: Check also Esc key's current status <reverted 18Apr>
%          /18 Apr  isabort: Revert modif 15Apr (performance issue)
%                   opendisplay: Commented shader compil. because of crash rashed on Maastricht's PC <!>
%                   opendisplay: setmouse out
%                   stoptrial: Missed frame tolerance: 5 -> 10  <!>
%          /20 Apr  KEYBOARD: openkeyboard, line 344: KeyCodeFilter: 1x255 -> size(keyCode). This fix a bug in checkkeydown/PTB
%                   openparalleport: Suppress dio output if nargout = 0;
% 2-beta36  05 May  Manip RencontreTroisiemeBaffle
%                   setscreensizecm: Cosmetic.
%                   DISPLAY: opendisplay: Fix Maastricht monitor bug: replace Screen('WaitBlanking') by Screen('Flip');
%                   SOUND: mesuresound: New fun. <Name changed in v2-beta37>
%          /11 May  mesuresound: Fix kb lib bug. <todo: Change default to PTB ?>
% 2-beta37  11 May  Change name: mesuresound -> measuresound.
%                   Delete *.asv files.
%                   opendisplay: Fix try-catch warning.
%                   noisyround: New fun.
%                   DIPSPLAY:
%                   * DIPSPLAY/PTB: OPTIMIZATION: SET COORDINATE SYSTEM <!!!> + FIX DRAW3
%                   - setcoordsystem: New fun.
%                   - draw3: Rewrite coord conversions. <TODO: Replace draw with draw3 !!!!>
%                   - draw('dots'): dots: Fix DotType bug.
%                   - isopen: Fix case when PTB window has crashed.
%                   o<todo> copybuffer: does not work for channel a (??)
%                   - test_draw3: New test fun.
%                   - draw3: Fix case nShapes > 1.
%                   - draw, draw3: Change variable name: LineWidth -> penWidth. (getdraw keeps "LineWidth")
%                   - draw3('polygon#'): "theta" arg becomes otional.
%                   - draw3('polygon'): Fix case no "theta" arg.
%                   o draw3: Fix 'cross' (nothing drawed) (Fix 'line' first)
%                   o draw3: Fix polygon# position over PTB.
%                   o<todo> draw3: draw(... <,penWidth>) -> draw(... , '-frame', penWidth)  <?!?!?>
%                   o<todo> storeimage: Use 'floatprecision' <!!!>
%                   - draw -> draw2, draw3 -> draw <!>
%                   - tests\testsyntax_draw: New fun.
%                   * DISPLAY/COG: 
%                   - opendisplay: Update for Cog 1.28+: support non-std resolutions. 
%                                  <TODO: Check before resolutions with Screen('Resolutions')>
%                   - getdraw, setdraw -> Becomes sub-funs of draw3 <!>
%                   * Other:
%                   - iscog: Fix doc.
%                   - getvalidscreenres: New fun. (+ udate gesreenres "See also")  <TODO: Finish other syntaxes>
%                   - opendisplay: Fix "�>". 
%                   - draw: Fix multiple polygons.
%                   - db: New shortcut.
%                   - newbuffer: Error if rgba arg. +clean code.
%                   - opendisplay: window's x0: 100 -> 50.
%                   - showbufferalpha: New fun.
%                   o<todo> storeimage, newbuffer: Review 'floatprecision' <!!!> & 'textureOrientation' args.
%                   o<todo> storeimage: use Screen('PreloadTextures') ???
%                   - setgamma: command syntax.
%                   - displaybuffer: Add pause key: P.
% 2-beta38  31 May  Optokin (Emilie Fischer)
%          /10 Jun  storeimage: Fix float precision bug: suppr; float precision.
% 2-beta39  09 Jun  displayanimation:  Fix: last byte of BytesToSend was not sent. <Backport to 2-beta32/09jun>
%                   REAL-TIME:
%                   - startglab: setpriority HIGH.
%                   - starttrial, stoptrial: feature accel on/off
%                   GRAPHICS:
%                   - storeimage: Fix flot precision bug. 
%                   - storeimage: Now if I is double/single, float precision = 1 (16bits), if I is uint8, float precision = 0
%                   - storeimage, newbuffer, opendisplay, deletebuffer, filterbuffer: Update for float precision.
%                   o<TODO> newbuffer: what about ???
%                   o<TODO> Set float precison as a parameter
%                   DISPLAY: DIRECTX WORKAROUND: Workaround for WaitBlanking (Andrea Conte)
%                   - opendisplay: Add Test 2bis: Add test of VerticalBlankingDirectX (Andrea).
%                   - opendisplay: Fix test 3 message.
%                   - opendisplay: Re-write test results.
%                   - opendisplay: Clean: rename sub-funs.
%                   - Included Andrea's WaitVerticalBlank.
%                   - stopglab: uninit WaitVerticalBlank.
%                   o<TODO> opendisplay: review other warning message.
%                   o<TODO> Modif waitframe, displaybuffer.
%                   MEX:
%                   - New dirs: </mex/, /mex/windows, /mex/multiplatform/, etc...
%                   - setupglab: Compile mex-files with mexall. (Updated BentoolsVersionRequiered.)
%                   - Included VisualStudio 2010 run-time dll in /mex/windows/lib/VirtualStudio2010/
%                   DISPLAY:
%                   - reinitdisplay: New fun.
%                   stoptrial: Fix "??? Reference to non-existent field 'isParallelOut'"
%                   stoptrial: Fix "non-existent field" bugs.
%                   starttrial: InitializeMatlabOpenGL  <TODO: put it in SETGLAB !!!>
% 2-beta40  22 Jun  Used by PA for DotFlocks, on DARTAGNAN.
%                  <?> draw -> draw3, draw_convertcoordversion -> draw <!!!>
%                   x Suppr. fun: getdraw, setdraw <!>
%                   x Suppr. fun: getscreenxlim, getscreenylim. <!> <bug in displaybuffer with photodiode!!>
%                   x Suppr. fun: noisbitround, draw_convertcoord, tests\test_draw3.
%                   x Suppr. DirectXWorkaround\WaitVerticalBlank.dll.
%          /24 Jun  draw: Fix over Cogent (sub-fun name bug).
%                   draw: Implement 'dots' over Cogent (performances are disapointing).
% 2-beta41  27 Jun  DISPLAY: DIRECTX WORKAROUND
%                   - opendisplay: Fix WaitBlanking: Add wait(1). <Was used from in v2-beta23 in waitframe() in windowed mode only.>
%                   - waitframe: Idem: Always use wait(1);
%                   - opendisplay: Finalize tests review + DirectX workaround.
%                   - waitframe: DirectX workaround (case 1).
%                   - displaybuffer: DirectX workaround (case 2).
%                   - opendisplay: Test that "WaitVerticalBlank" does exist; fix case when it doesn't.
%                   Moved fun: findmissedframes -> "/legacy/not used/findmissedframes".
%                   TRIAL/TARGET:
%                   - drawtarget: Doc: update example (was totally obolete). Doc+.
%                   - glabhelper_checkerrors: Fix bug on 1st timestamp.
%                   - Change field name: PERDISPLAY.MissedFrames -> MissedFramesPerDisplay.
%                   glabreplace: Fix spelling bug. Doc+.
%                   GLOBAL VARS: -> GLAB_MODULE
%                   - GLAB_STATUS.* -> GLAB_GENERAL.*, GLAB_DEBUG.doDispEvents - > GLAB_GENERAL.doDispEvents.
%                   - GLAB_IS_RUNNING -> GLAB_GENERAL.isStarted, no more used directly, but trough isopen('glab').
%                   - GLAB_IS_ABORT -> GLAB_GENERAL.isAbort. 
%                   - Suppr. GLAB_CURRENT_PRIORITY.
%                   - sendeyelinksync: Fix error in field name: GLAB_DEBUG.doDispTimes -> doDispEvents.
%                   - GLAB_HARDWARE: Suppr. in getscreensizecm (was not used). Only used in sethardware which is not used. <TODO: sethardware???>
%                   - GLAB_LIBRARIES -> GLAB_GENERAL.LIBRARIES.
%                   - iscog, isptb: Review optim case. Review all code. isptb: Suppress redundant code.
%                   - GLAB_TRIAL -> GLAB_TRIALLOG
%                   - GLAB_BUFFER -> GLAB_DISPLAY.BUFFER.
%                   - Change field name: BUFFERS.CurrentBuffer -> .CurrentBuffer4CG.
%                   - Change field name: GLAB_PARALLELPORT.OptimizationLevel -> .OptimizationMode.
%                   o <TODO> Use .isOpen field on all modules.
%                   PRIORITY:
%                   - getpriority: Simplify code: Always use PTB.
%                   o <TODO> get-, setlibrary, setpriority: Suppress 'Priority' library module.
%                   setupglab: Fix "Don't stay in toolbox directory".
%                   backgroundmask: Doc+.
%                   addbackgroundalpha: New fun.
%                   DIRS:
%                   - ofglab: New fun.  
%                   - cdglab: Sub-sub-dirs as arg. Doc+.
%                   - New dirs: /demos/images, /demos/images/faces.
% 2-beta42  01 Jul  Last version before change dirs. <ERROR THIS IS NOT THE WRIGHT VERSION !!! CHECK THIS !!!>
%          /04 Jul  DISPLAY: DIRECTX WORKAROUND: stopglab: Backport Fix "??? Undefined function or method 'WaitVerticalBlank'" from beta43.
% 2-beta43  01 Jul  CHANGE DIRS !!!
%                   - Moved all m-files in /toolbox/<module>, exepted setupglab and glabversion. <!!!!!>
%                   - ==> Update setupglab: Include automatically in path all sub-dirs in /toolbox (but NOT sub-sub-dirs !!!).
%                   - Suppr funs: preparesinanimation, convertcoord0, displaybuffer_wait, openglabfolder, editglabversion.
%                   - Suppr funs: gbb, gcb (never used).
%                   - Suppr duplicated funs: All *serial* funs where both in /serial and in root !
%                   - Suppr "Copie de *", "Copy of *".
%                   - Changed fun name: setparallelbit -> sendparallelbit.
%                   - Moved fun: noisyround: GLab -> BenTools (because it was the only "tool" in GLab).
%                   o <TODO: Update glabhelp!!>
%                   - cdglab, ofglab: Change behavior: Now cd to <glabroot>/toolbox. Use "cdglab .." to get old behavior. 
%                   opendisplay: Fix error message in case measured freq has changed and new freq is not plausible.
%                   TRIALLOG: MAJOR FIXES.
%                   - glabhelper_dispevent: Doc+. 
%                   - glabhelper_dispevent: Fix case dur = inf.
%                   - displaybuffer: Rewrite "Event to print". Replace "if isopen('glab')" (??) by "if isopen('trial')".
%                   - displaybuffer: Implement case of animations.
%                   - stoptrial: Fix MissedFrames when Dur = 0 or inf.
%                   - glabhelper_dispevent: Change how it's printed.
%                   - starttrial: Declare PERDISPLAY.Tag.
%                   - starttrial, displaybuffer: PERDISPLAY.Tag: 8 columns -> 16 cols.
%                   o <TODO: stoptrial: return time : "t = stoptrial".>
%                   DISPLAY: DIRECTX WORKAROUND: stopglab: Fix "??? Undefined function or method 'WaitVerticalBlank'". <Backported on v2-beta42/04jul>
%                   drawshape, draw2: Add "<obsolete>" tag.
%                   waitsynch: Add "<deprecated>" tag.
%                   backgroundmask: Fix args 2 & 3 (Erode & fill hole) which where inverted.
%                   changebackgroundcolor: Change fun name: changebackground - changebackgroundcolor; <bug!>
%                   o <todo: Review consistency between changebackgroundcolor & addbackgroundalpha.
%                   New demo: demo_fmri. <bug line 8>
%                   DRAW: 
%                   - drawround, drawsquare: Update: drawshape -> draw.
%                   o <TODO: Update other draw* funs.>
% 2-beta44  07 Jul  Erwan.
%                   <bug: starttrial global vars, see below>
% 2-beta45  07 Jul  DIRS:
%                   - New dir: "<glabroot>/var".
%                   - New data file: PTBKeyNames.mat
%                   COGENT: RUN W/O PTB:
%                   - isptbinstalled: New fun.
%                   - Fixes in lot of files.
%                   - Suppr files in "<galabroot>/lib/PTB": KbCheck.m, KbName.m, WaitScs.*
%                   opendisplay: Check if resolution supported by hardware (finish implementation). <commented: bug on dartagnan!>
%                   draw: Change sub-fun name.
%                   waitframe: Fix non-existing field bug, line 39 (don't understand why it happens now ??).
%                   startglab: Fix global var: use glabglobal again. <revert 2-beta41>
%                   PHOTODIODE: Fix bug introduced in v2-beta40 when replacing getscreen?lim funs.
%                   getscreenres: +doc.
%                   TRIALLOG: 
%                   - Fix case 2 anims one after another.
%                   - plottrialdebug: New fun.
%                   - displaybuffer, starttrial: Record also 'CalledDisplayTimeStamp' & 'ReturnedDisplayTimeStamp'
%                   - starttrial: Allocate all vars.
%                   - starttrial: <MAJOR FIX!> Fix row/col inversion in var allocation => increasing comput timebug!!! 
%                   setupglab: glabroot -> sub_glabroot
% 2-beta46  08 Jul  P-A on DARTAGNAN.
% 2-beta47  11 Jul  DIRS:
%                   - setupglab: Fix all dependency bugs. (Used getfiledependencies to be exhaustive.)
%                   MOVIES: (Cogent only)
%                   - loadmovie, playmovie, closemovie: New funs.
%                   - stopglab: Update. <bug>
% 2-beta48  13 Jul  ALex on AMADEO.
%                   displaybuffer: "WaitVerticalBlank wait" -> "WaitVerticalBlank('wait')" to fix syntax err when not in path.
%                   displaybuffer: Comment dt345. <TODO: Review Tag.>
%          /14 Jul  stopglab: Fix bug close movie.
% 2-beta49  14 Jul  DRAW:
%                   - drawrect, drawcross, drawtriangle, drawpolygon, drawline: drawshape -> draw Move RGB arg. <!!>
%                   - drawrect: Review doc. Doc-
%                   - draw: Doc: add arg definitions.
%                   - drawtriangle: Finish it. (Was totally unfunctional.)
%                   - draw: Fix draw('polygon#',RGB,b,XY,D,Theta) (didn't rotate).
%                   TRIALLOG:
%                   - starttrial: Add examples.
%                   - displaybuffer: retest Tag: still to slow after starttrial fix => let it commented.
%                   - starttrial: Comment tag.
%                   - starttrial: Call Screen('PreloadTexture').
%                   - displaymissedframeswarning: New fun.
%                   - glabhelper_checkerrors: Replace: displaywarning -> displaymissedframeswarning.
%                   o <TODO: 
%                   o <TODO: // out: make it optionnal.>
%                   KEYBOARD:
%                   - openkeyboard: Add Lib arg. Rewrite "Inputs args" code.  <BREAK BACKWARD COMPAT.!!!>
%                   - startglab: Call openkeyboard without args.
% 2-beta50  18 Jul  P-A on DARTAGNAN. <same version under version # beta49, & last changelogs missing>
% 2-beta51  19 Jul  PARALLEL PORT:
%                   - sendparallelbyte, sendparallelbit: Improve event info. Doc+.
%                   - sendparallelbyte, sendparallelbit: Suppress Port# arg.
%                   - sendparallelbyte: Add 'duration' arg.
%                   startrial: Fix doc.
%                   TRIALLOG:
%                   - stoptrial: Fix missing last interval.
%                   - displaybuffer: Fix tag max length err msg.
%                   - getdisplaycount, getframecount, getcyclecount: New funs. <TODO: getcyclecount -> getframeestimate ??>
%                   - stoptrial: Fix // port: Reset it to 0.
%                   - starttrial, displaybuffer, stoptrial: Global var: Add field: GLAB_TRIALLOG.PERFRAME.isDisplay
%                   - startrial, displaybuffer, plottrialdebug: Global var: Change field names.
%                   - displaybuffer: Fix triallog global var out of IF test, at the end. <from when dates the bug ??>
%                   - waitintertrial: new fun.
%                   - stoptrial: Add t ouput arg.
%                   glabreplace: Fix v2-beta43: missing '-r' option.
%                   isinside: New fun.
%                   MOUSE:
%                   o <TODO: Change or keep getmouse/geteye syntx ???>
%                   - waitmouseclick: Add 'xy' output arg. <BREAK BACKWARD COMPAT. !!!>. Add 'TimeOut' input arg. Doc+.
%                   - getmouse, waitmouseclick: Test display is open.
%                   opendisplay: Fix ";".
%                   waitsynch: clean debug commented code.
%                   EYELINK:
%                   - Add file: eyelink/EyeLinkDevKit_win32_1.9.214.exe
%                   o <TODO: Auto install EyeLinkDevKit>
%                   - openeyelink, opendisplay, geteye: Fix case: EyeLink -> Eyelink.
%                   HELP: Fix glabhelp.
%                   DIRS & LIBS, COGENT 1.30:
%                   - startglab: Add warning for Cogent + ML 7.1.
%                   - setupglab: Doc+ (see below).
%                   - Add COGENT 1.30 as external lib (!!!) in "TOOLBOX+/Cogent/Cogent2000v1.30"  <!!!!!>
%                   - DELETE COGENT 1.28 <!!>
%                   - getlibrary: Suppr.1.28 from availables.
%                   - setlibrary: Cog 1.30 becomes default. <!!!>
%                   - startglab, line 155: Change default version to 1.30. 
%                   o <TODO: Default Cog version defined both in setlibrary & in startglab, line 155. REVIEW THIS!!!>
%
%                  -> New dir tree:
%
%                       TOOLBOX+                             Can have another name. Cannot have space in the name of parents directories. 
%                       |
%                       +--> PsychToolbox                    Can be elsewhere if already installed. (But cannot have space in the name of parents directories.)
%                       |
%                       +--> Cogent                          Container of Cogent's original folder(s) (one folder per version).
%                       |    |
%                       |    +--> Cogent2000v1.30            Current Cogent version.
%                       |
%                       +--> bentools                        Ben Jacob's personnal collection of utilitary functions.
%                       |
%                       +--> GLab-2-beta52                   GLab. Changing current directory to this one and typing "setupglab" will install the whole stuff.
%
% 2-beta52  22 Jul  Cora USA.
%                   PARALLELPORT: 
%                   - getparallelport -> getparallelportobject.
%                   - getparallelportobject: Review code.
%                   t Test // port funs: ok.
%                   TRIALLOG/PARALLELPORT:
%                   - glabhelper_dispevent: Fix missing field bug when GLab not started. (ex: for use with openparallelport alone.)
%
% 2-beta53  22 Jul  DIRS:
%                   - Add dir: "/toolbox/demos".
%                   - Rename dir: "/demos" -> "/old_demos".
%                   - Moved dir: "/demos/images" -> "/var/images".
%                   - New fun: GLABDIR. Centralize all path information into GLABROOT & GLABDIR! <!!!>
%                   - Suppress funs: glabtmp & glablog -> glabdir('tmp'), glabdir('tlog'). Modif. all other funs.
%                   - setupglab: Doc-.
%          /25 Jul -> ... forgot his name...
%          /25 Jul  TRIALLOG: 
%                   - Fix displaybuffer when no Tag arg.
%                   o <TODO: displaybuffer: Width arg not used !!>
%                   displaybuffer: Doc+: make example executable.
%                   icog: Fix warning "unmatched end" on ML6.5.
%                   setupglab: Suppr <GLabRoot>/demo/
%          /01 Aug  EYELINK EVENTS:
%                   - starteyelinkrecord: Call Eyelink('StartRecording',1,1,1,1), with all samples/events flags enabled.
%                   - waiteyelinkevent: New fun.
%                   - seteyelinksaccades: New fun.
%                   Clean /toolbox/
% 2-beta54  04 Aug  Clean /toolbox/
%                   opendisplay: Fix hardcoded VisualStudio dll dir.
%
%% ===========================================================================
%
% 3-alpha0  04 Aug  GLAB -> COSYGRAPHICS:
%                   
%                     replace -r GLAB_ COSY_
% 
%                     replace -r glabhelp cosyhelp
%                     replace -r glabhelper helper
% 
%                     replace -r GLABHELP COSYHELP
% 
%                     replace -r setupglab setupcosygraphics
%                     replace -r glabversion cosygraphicsversion
%                     replace -r clearglab clearcosygraphics
%                     replace -r glabglobal cosygraphicsglobal
%                     replace -r glabmanual cosygraphicsmanual
%                     replace -r startglab startcosy
%                     replace -r stopglab stopcosygraphics
%                     replace -r glabdir cosygraphicsdir
%                     replace -r glabroot cosygraphicsroot
% 
%                     replace -r glab\ cosygraphics\
%                     replace -r glab/ cosygraphics/
% 
%                     replace -r G-Lab CosyGraphics
%                     replace -r GLab CosyGraphics
%                     replace -r GraphicsLab CosyGraphics
%                     (Copy of... here)
%                     replace -r GLAB COSYGRAPHICS
%
%                     replace('-r', 'isopen(''glab'')', 'isopen(''cosygraphics'')')
%  
%                   o<TODO: Freeze external dir name: "cosygraphics"? "cosy"? "cosydata"? "cosydir"?
%                     --> Review aedf2asc, lines 81 to 88.
%                     --> uisearch <tmp>
%                     --> Review cosygraphicsdir, lines 44, 46, 53.
%                   o<TODO: Update EYEVIEW 0.25 !!!
%                     --> Update savetrials2eyeview, line 203.
%                   o<TODO: Update utils.
%
%                     starteyeview('glab');
%
% 3-alpha1  01 Sep    displayanimation: Write v3.0's changelog.
%                     displayanimation: 'Splash' option: Add DelayBuffer arg <same as in SinStim 1.8.3 sub-fun>
%                     setupcosygraphics: Fix remove v2.
%                     sc -> sg.
%                     Add legacy/stopglab, legacy/glabversion.
%                     draw: Fix sort() bug on Matlab 6.5.
%
%% ===========================================================================
%
% 2-beta55  01 Sep  EYELINK EVENTS:
%                   - geteyelinkevent -> geteyelinkevents.
%                   - geteyelinkevents: Write fun.
%                   - sendeyelinksync -> helper_sendeyelinksync. Doc+. Modif displaybuffer. (tag: "<!v2-beta55>") <ERROR!!>
%                   - waiteyelinkevent: Add chack EyeLink is recording (tag: "<!v2-beta55>")
%                   - geteye: doc+ (internal)
%                   - geteye: Invert s & r arguments.
%                   - sendeyelinkmessage: New fun. 
%                   - eyelinkdemo: New fun (AlexZ)
%                   PATH: setupglab: Remove v3 CosyGraphics. <!!>
%          /09 Sep  EYELINK EVENTS:
%                   - sendeyelinksync <- helper_sendeyelinksync <revert!>
%                   - sendeyelinksync: Add trial #.
%          /12 Sep  - eyelinkdemo: Review ceod (Ben)
%                   - starttrial: Warning message if EL not recording (tag: "<!v2-beta55>")
%                   - starttrial, stoptrial: Send start/stop msg with trial# & timestamp (tag: "<!v2-beta55>")
%                   - openeyelink: Set saccade: moved -> seteyelinksaccade (tag: "<!v2-beta55>")
%                   - seteyelinksaccade: Becomes verbose.
%                   - EyeLink calib over Cogent (Alex): Add 4 Eyelink* funs in /lib/PTB/PtbReplacement <error: should be in PtbModified>
%          /13 Sep  - seteyelinksaccades, stopeyelinkrecord: Fix doc spelling.
%          /15 Sep  - sendeyelinevent: New fun.
%                   - openeyelink: Fix case EL already open. (tag: "<!v2-beta55>")
%                   - closeeyelink: +Verbose. (tag: "<!v2-beta55>")
%                   - openeyelink: Suppr. (comment) calibration. (tag: "<!v2-beta55*>")
%                   - seteyelinksaccades: +Warn in dummy mode.
%
%% ===========================================================================
%
% 3-alpha2  15 Sep  INCLUDE 2-BETA55 <!!!>
%                   -1- Copy eyelink/ folder from v2-beta55
%                   -2- Suppr. helper_sendeyelinksync.m, *.asv, EyelinkBubbleDemo2.m.
%                   -3- Redo replace in eyelink/:
%                     cd eyelink
%                     replace -r GLAB_ COSY_
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\calibeyelink.m : 7 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\checkeyelink.m : 21 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\closeeyelink.m : 6 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\geteye.m : 7 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\geteyelinkevents.m : 3 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\geteyelinkfile.m : 4 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\openeyelink.m : 28 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\sendeyelinksync.m : 5 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\starteyelinkrecord.m : 8 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\stopeyelinkrecord.m : 2 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\waiteyelinkevent.m : 3 change(s)
%                     replace -r glabhelp cosyhelp
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\geteyelinkevents.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\sendeyelinkevent.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\waiteyelinkevent.m : 1 change(s)
%                     replace -r glabhelper helper
%                     replace -r glab cosygraphics
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\edf2asc.m : 17 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\geteyelinkevents.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\geteyelinkfile.m : 2 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\openeyelink.m : 7 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\sendeyelinkevent.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\starteyelinkcalib.m : 2 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\stopeyelinkrecord.m : 4 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\waiteyelinkevent.m : 1 change(s)
%                     replace -r G-Lab CosyGraphics
%                     replace -r GLab CosyGraphics
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\checkeyelink.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\edf2asc.m : 5 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\eyelinkdemo.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\openeyelink.m : 5 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\stopeyelinkrecord.m : 1 change(s)
%                     replace -r GraphicsLab CosyGraphics
%                     replace -r GLAB COSYGRAPHICS
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\starteyelinkcalib.m : 1 change(s)
%                   -3b- Fix -3-:
%                     replace -r cosyhelper_ helper_
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\geteyelinkevents.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\sendeyelinkevent.m : 1 change(s)
%                     D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha2\toolbox\eyelink\waiteyelinkevent.m : 1 change(s)
%                   -4- GLab-2-beta55/lib/PTB/PtbReplacement/Eyelink*.m -> CosyGraphics-3-alpha2/lib/PTB/PtbModified/ 
%                   -5- starttrial, stoptrial: Report manually modif tagged "<!v2-beta55>". (Check with uisearch: no other fun tagged)
%                   COSYMODULES:
%                   - Modules folder names: * -> cosy*  <!!!>, except 'general'. <TODO: general -> cosygeneral !!>
%                   PHOTODIODE:
%                   - setphotodiodevalue: +Doc.
%                   - cosydisplay/drawphotodiodesquare (unfinished fun): Suppr.
%                   DIRS:
%                   - lib/PTB/PtbReplacement/ -> PtbRenamed/
%                   - lib/PTB/PtbLowercased/: New dir. Moved is*.m files into it.
%                   - setupcosygraphics: Update: Add lib/PTB/PtbLowercased/ to path
% 3-alpha3  19 Sep  FILES/DIRS NAMES:
%                   - startcosygraphics, stopcosygraphics -> *cosy
%                     cd D:\MATLAB\TOOLBOX+\CosyGraphics-3-alpha3\TOOLBOX\
%                     replace -r startcosygraphics startcosy
%                     replace -r stopcosygraphics stopcosy
%                     replace -r STARTCOSYGRAPHICS STARTCOSY
%                     replace -r STOPCOSYGRAPHICS STOPCOSY
%                     replace -r clearcosygraphics clearcosy
%                     replace -r CLEARCOSYGRAPHICS CLEARCOSY
%                   - cosygraphicsversion, cosygraphicsdir, cosygraphicsglobal, cosygraphicsmanual -> cosy*
%                     replace -r cosygraphicsversion cosyversion
%                     replace -r cosygraphicsdir cosydir
%                     replace -r COSYGRAPHICSVERSION COSYVERSION
%                     replace -r COSYGRAPHICSDIR COSYDIR
%                     replace -r cosygraphicsglobal cosyglobal
%                     replace -r COSYGRAPHICSGLOBAL COSYGLOBAL
%                     replace -r cosygraphicsmanual cosymanual
%                     replace -r COSYGRAPHICSMANUAL COSYMANUAL
%                   - edgv, sg -> edcv, sc
%                   - cdcglab, ofglab -> cdcosy, ofcosy. (Modif. manually)
%                   - cosygraphicsroot: which('setupcosygraphics') -> which('cosyversion')
%                   - setupcosygraphics: Fix doc bug (due to v3-alpha2 automatic replacement).
%                   - legacy/stopglab: Add obsolescence warning.
%                   - legacy/glabroot: New fun.
%                   - setupcosygraphics: Backward compat with v2 (GLab).
%                   DIRS:
%                   - TOOLBOX/general/cosyhelp -> TOOLBOX/cosyhelp. 
%                   - cosydir: Update (see line above). cosyhelp, glabreplace: [coygraphicsroot '/toolbox'] -> cosydir('toolbox').
%                   - utils/ -> misc/utils/
%                   - draw2: Suppr. 
%                   - setupcosygraphics: +Doc (dir tree).
%                   - TOOLBOX/general/ -> TOOLBOX/cosygeneral/
%                   - cosydir: +Doc.
%                   setupcosygraphics: Update.
%                   setupcosygraphics: Fix spelling bug ("BentoolsVersionRequiered").
%                   sc: +Doc.
%                   t Run sinstim test: ??? Undefined function or method 'glabhelper_checkerrors' for input arguments of type 'char'.
% 3-alpha4  21 Sep  SERIAL PORT: 
%                   - openserialport, getserialbytes, sendserialbytes, waitserialbyte: : 'port' arg can be port name (e.g.: 'COM1').
%                   - openserialport: +Doc. +Verbose.
%                   - openserialport, closeserialport: Add fclose(instrfindall); 
%                   - getserialbytes, sendserialbytes, waitserialbyte: Rewrite doc.
%                   - getserialbytes: Suppr. 2d arg ('bytes') from doc. <??>
%                   - getserialbytes: Change output arg format: Vert num -> horiz chars. <!>
%                   - waitserialbyte: Rewrite input arg handling.
%                   - waitserialbyte: Invert input arg 2 & 3 <!!!>
%                   - sendserialbytes, getserialbytes, waitserialbyte: Optimize input arg management (M6.5/Sesostris: .85ms -> .15 ms)
%                   SETUP: setupcosygraphics fix install of v2.
%                   db -> dib: Change function name (because db was overloading Matlab eponymous fun).
%                   SPRITE ANIMATIONS:
%                   - loadanimatedimage: New fun.
%                   - copybuffer: Mange sprite buffer incremnt.
%                   - displaybuffer: Small fix for anim handles.
%                   EYELINK: 
%                   - sendeyelinksync: Suppr. dispinfo because of performance issue on AMADEO.
%                   - setoffsety: New fun.  
%                   - setcoordsystem: Add offset translation.
%                   - opendisplay: update.
%                   - setoffsety: New fun.
%                   - cosydisplay/opendisplay, cosydisplay/setsystemcoord: Update for offset.
%                   FIX ALPHA2: replace GLAB_ -> COSY_ in cosydisplay/
%                   FILES&DIRS:
%                   - Moved: <cosyroot>/data.mat -> ./cosykeyboard/
%                   26 Sep: installed on AlexZ's win7 laptop.
% 3-alpha5  26 Sep  FILES NAMES:
%                   - setupcosygraphics -> setupcosy. +Fix names in doc (still setupglab). <!!! v3-alpha0 to alpah4 no more supported !!!>
%                     replace -r setupcosygraphics setupcosy
%                     replace -r SETUPCOSYGRAPHICS SETUPCOSY
%                   - cosyversion: Fix sub_cosygraphicsroot(): use mfilename in place of hard-coded fun name.
%                   - <test!> uisearch glab: Found in: sethardware, glabreplace, savetrials4eyeview. <TODO: fix that funs>
%                   startcosy: Suppr. print help about cosymanual.
%                   matdraw: Fix coord (x,y -> i,j).
%                   matdraw: Fix color.
%                   DISPLAY BUFFERS:
%                   - 
%                   - opendisplay, gcw, reinitdisplay:  replace -r BackbufferOfOnscreenWindow Backbuffer
%                   - copybufferthroughmask: New fun.
%                   - getbufferalpha: New fun.
%                   - showbufferalpha: Delete fun.
%                   FILES&DIRS NAMES: 
%                   - cosydir: Update cosydir('demos') and cosydir('images').
%                   - cosyhelpers/ -> helperfunctions/   <bug: cosyhelpers/ not removed! Fixed in alpha6>
%                   - Moved funs: copybuffer, copybufferrect: Fix misplacement in cosyserial/.
%                   - Moved funs: gammaexpand, gammacompress: froma cosydisplay/ -> to cosyimages/
%                   - displaymissedframeswarning -> sub-fun in helper_checkerrors
%                   - getlasttrialmissedframes -> getlasttrialerrors. startcosy: Update.
%                   o<TODO: what about getvalidscreenres ?? (see also dispscreenresolutions)>
%                   - pollparallelport -> startparallelportpolling
%                   HELP:
%                   - cosyhelp: Update.
%                   - Update help of many funs !!!
%                   - statpsych: +help (eindelijk!)
%                   SOUND/PTB: storetuut: Port on PTB.
%                   COSYDEMOS: 
%                   - Lot of stuffs... ;-)
%                   EYELINK: lib/EyelinkDrawCalTarget: Fix AlexZ Cogent port (v2-beta55). <!>
%                   SOUND: playsound: Obsolete tag <TODO: Fix playsound/startsound problem !!!!!>
% 3-alpha6  02 Oct  stopcosy, clearcosy: Fix "try comma" bug: "When the first MATLAB statement that follows the try keyword
%                     consists of just a single term (e.g., A as opposed to A+B) occurring on the same line as the try, then 
%                     that statement and the try keyword should be separated by a comma."
%                   DIRS: 
%                   - cosydir: Default arg = 'toolbox'.
%                   - Fix v3-alpha5: Delete cosyhelpers/ <!>
%                   HELP:
%                   - Change help of many funs.
%                   - open* funs: Add module definition.
%                   <tmp> opendisplay: Commented line #673 <tmp!>
%                   helper_dispevent: ptb disp: 7.1f -> 7.2f
%                   TRIAL: 
%                   - opendisplay: Uncomment Tag log.
%                   - plottrialdebug: +legend.
%                   GLOBAL VARS: startcosy: Suppr. eval cosyglobal in ws. <!!!>
%                   copybufferthroughmask: Fix missing last arg.
%                   cosyversion: Add check v exists.
% 3-beta0  03 Oct   cosyversion: Add TODO 3.0 below.
%                   DISPLAY+EYELINK: GAZE CONTINGENT:
%                   - copybuffer_troughmask: Delete it.
%                   - storealphamask: New fun.
%                   opendisplay: Window offset (PTB) becomes param at top of code.
%                   opendisplay: Fix line 135
%                   opendisplay: revert v3-alpha6 comment.
%                   COSYDEMOS:
%                   - Lot of changes!
%          /04 Oct  displaybuffer: Fix photodiode.
% 3-beta1  05 Oct   HELP:
%                   - Add cosymodules.m files.
%                   - cosydisplay: Add {fast}/{slow} tags <!!>
%                   MOUSE: getmouse: Fix var name bug. Optim: replace str2num -> str2double.
%                   SPLASH: 
%                   - opendisplay "Graphics Lab" -> "CosyGraphics" !! :-D
%                   - Add "catel inside" logo. Image in/cosydisplay/var/catel-inside.bmp
%                   Suppr. drawshape ; displayanimation: Update lines 400, 430. <!>
%                   COSYDEMOS:
%                   - GazeContingent2, RemoveBackGround: fix figure pos.
%                   - Add workspaceexport at end of file.
% 3-beta2  13 Oct   Fix spelling (where -> were).
%                   VIDEO: importvideo: New fun ... <unfinished>
%                   opendisplay: shorten error message in case of cgopen failure.
%                   drawtext: Check input args.
%                  <TODO: Fix sound / Cogent !!!>
%                   openparallelport: Print digitalio's error message.
%                   BW COMPATIBILITY:
%                   - cosyversion: Fix case v2 installed over v3.
%                   - bentools/synctoolboxplus: Fix.  ==> BentoolsVersionRequired: 0.11.10. <!>
% 3-beta3  15 Nov   PARALLEL PORT OVER INPOUT32:
%                   - openparallelport: Fix missing ";"s.
%                   - openparallelport_inpout32: New fun. <unfinished>
%                   - setlibrary: Add Inpout32 for // port (line 98).
%                   - sendparallelbyte, getparallelbyte: Support InpOut32.
%                   SETUP:
%                   - setupcosy: Fix Win 64 bits:Don't compile mex-file on Win 64 bits. <MAJOR FIX!>
%                   - setupcosy: Fix path: savepath() was called before mexall(). <MAJOR FIX!>
%                   EYELINK: 
%                   - Suppr. eyelinkdemo.m
%                   - helper_telleyelinkscreenres: New fun. 
%                   - Offset Y: Implement the EL part.
% 3-beta4  22 Nov   draw: Check RGB arg validity.
%                   DISPLAY: BUFFERS:
%                   - Suppr BlankBuffer (never used). Changes made in opendisplay, setbackground, showbuffers.
%                   - deletebuffer: Fix deletebuffer('all'): Don't delete DraftBuffer and BackgroundBuffer.
%                   DISPLAY: DEG & PIXELS:
%                   - deg2pix: Round only for Cogent (PTB has sub-pixel precision).
%                   - getscreenres: Fix test display has benn open.
%         /23 Nov -> Laptop Alex
% 3-beta5  23 Nov   EYELINK:
%                   - starteyelinkcalib: Add OffsetY argument.
%                   - openeyelink, seteyelinksaccades: Fix case: EyeLink() -> Eyelink().
%                   - EyelinkDrawCalTarget: Fix target y pos: coord from EL must be translated of TWICE the y offset <!!>
%         /06 Dec   - setoffsety: round Yoff to even nb.
%                   - geteye: Fix y offset. <reverted in 3-beta6 !!>
%         /07 Dec -> Laptop Caroline.
% 3-beta6  08 Dec   DEG <-> PIX:
%                   - deg2pix, pix2deg: Re-write for exact result, when ~is57.
%                   COGENT: 
%                   - setupcosy: Fix inverted order Cog c1.25 / Cog v 1.30. <MAJOR FIX!>
%                   EYELINK: 
%                   - geteyelinktimeoffset: New fun.
%                   - stopeyelinkrecord: Suppr old commented code.
%                   - geteyelinkfile: ...
%                   REAL-TIME:
%                   - startcosy, starttrial, Add drawnow() call <!!>
%                   nb: bentools(v0.11.12)/dispinfo: Use fprintf(), not disp()!!! disp() is queued by Matlab !!
%         /13 Dec   EYELINK: 
%                   - Revert 3-beta5 <!?!?!?>
%                   - openeyelink: Add '-noevents' option.
% 3-beta7  13 Dec   TRIAL LOG:
%                   - plotrialdebug: Fix legend.
%                   - gettrials: Fix doc.
%                   - stopblock: New fun.
%                   - gettargetdata: New fun.
%                   - stoptrial: MissedFramesPerDisplay: last element is 0 (cannot know for last diplay (NaN -> 0))
% 3-beta8  15 Dec   gettargetdata: X, Y in deg.
%                   starttrial: Fix missing declaration of field "iStartAnimation" in COSY_TRIALLOG.
%                   PARALLEL PORT OVER INPOUT32:
%                   - openparallelport_inpout32: +doc for Dell T1600.
%                   - openparallelport_inpout32: Set lines to 0 after opening.
%                   SETUP: cosyversion: Fix 500 recursions bug due to circular recursive calls. <MAJOR FIX!>
% 3-beta9  03 Jan 2012
%                   TRIALS:
%                   - drawtarget: cosydisplay\ -> cosytriallog\
%                   - savetrials4eyeview: Add <obsolete> tag ; dawtarget: Update doc.
% 3-beta10 01 Feb   displaymessage: doc+
%                   TRIALS/TARGETS:
%                   - gettrialdata: Fix case multiple targets <MAJOR FIX! DATA LOST!>
%                   TODO:
%                   doc drawtarget: remove savetrials in ex.
%                   displayanimation: Fix JBB
%         /07 Feb   EYELINK: starteyelinkcalib: + doc OffsetY
%                   EYELINK/OKULO: gettargetdata: Fix commented code <!>
%         /08 Feb   EYELINK:
%                   - stopcosy: Comment line 62-64 (COSY_DISPLAY.ScreenSize_cm = [];)
%                   - starteyelinkrecord: Add "[COSY] INFO" messages for Okulo.
%         /09 Feb   EYELINK/OKULO: gettargetdata: Fix commented code <!>
% 3-beta11 14 Feb   LIBRARIES:
%                   - setlibrary, getlibrary -> setcosylib, getcosylib.
%                   - replace -r etlibrary etcosylib; replace -r ETLIBRARY ETCOSYLIB; <log sent by mail>
%                   + replace manually in setupcosy.
%                   HELP: Suppr. cosy*.m module help files. <TODO: put them in separate folder?>
%                   SOUND: playsound: Now a alias for startsound.
%                   DEMOS: 
%                   - Fix cosydemo_display_MovingTarget_basic, line 52.
%                   - cosydemo_display_MovingTarget2_LogAndSaveData: Finish it.
%                   TRIALS/TARGETS:
%                   - starttrial: Fix case multiple targets <MAJOR FIX! Previous fix was lost somwhere!?!>
%                   EYELINK: 
%                   - checkeyelink: Rewrite 'iscalibrated' case.
%                   - geteyelinkfile: Fix doc (status doc was not correct).
%                   - cleareyelinkevents: New fun. Doesn't work! 
%                   - starttrial: clear eyelink events: hack! <TODO: Rewrite!>
%                   - geteyelinkevents: Add .time field.
%                   - seteyelinksevents: New fun.
%                   - geteyelinkevents, cleareyelinkevents, openeyelink: +Doc.
%         /21 Feb   - geteyelinkevents: <HACK!!!> Must be called 3 times to get an event!!! Let's call it 4 times for security.
%         /22 Feb   - geteyelinkevents: Added .eye field to LostDataEvents
%                   PARALLEL PORT: <HACK!> openparallelport_inpout32: Add 'Direction' field to global var with 'out' value. <HACK!>
% 3-beta12 27 Feb   Apply JBB's fixes (bug reports 25-01 & 10-02-2012.) <Applied in SinStim 1.8.11's sub-fun, in GLab/CGr 2-beta32 & 3-beta12.>
% 3-beta13 27 Mar   SOUND: v3.0
%                   - startpsych, startcosy (line 195): <!!!> Moved "setcosylib('Sound',Lib);" from startpsych to startcosy (was not in startcogent <!>). <!!!> 
%                   - newsoundbuffer: New fun.
%                   - opensound, storesound, closesound: Modif to use newsoundbuffer.
%                   - opensound: New opens one buffer. <Change behavior !!!>
%                   - storesound: Doesn't create a new buffer anymore. Now stores always in same buffer, unless b arg is given. <Change behavior !!!>
%                   - opensound, storesound, startsound, closesound: Replace CurrentBuffer by DefaultBuffer. <Change behavior !!!>
%                   -<TODO: Test on Cog!!>
%                   - opensound: Add optional Lib arg: opensound([Lib],...); <bug, fixed in 3-beta15>
%                   - getsoundrecord: Suppr. fun. (name was changed getsounddata, see 2-beta35).
% 3-beta14 18 Apr   Depl. on Anne's lab 2 PCs (desktop & laptop)
%                   Add file "X:\TOOLBOX+\CosyGraphics-3-beta14\lib\PTB\Update Visual C++ 2005 runtime libraries\vcredist_x86.exe".
%          09 May   Add file: /cosysounnd/portAudio_x86_with_ASIO.zip
% 3-beta15 16 May   SOUND:
%                   - opensound(Lib): Fix: setcosylib(Lib); was missing. <Fix 3-beta13>
%                   - opensound, line 324-326: Suppr. call to newsoundbuffer (sound card was initialized twice). <Fix 3-beta13>
%                   - opensound: Add PTB option args. PTB's vars now in 'PTB.' structure.
%                   - opensound: Support fMRI USB ext card (hack needed). Updated doc.
%                   - storetuut: Fix: iscog -> iscog('Sound')
%                   - storetuut: Fix default buffer : 1 -> COSY_SOUND.DefaultBuffer
% 3-beta16 18 May  -> Erwan on Bragelonne.
% 3-beta18 08 Jun   P-A, on MERCURE.
%                   drawrect: Fix bw compat. code.
%                   waitparallelbyte: Fix missing t output arg. when over PTB.
%         /11       openparallelport_inpout32: Comment fucking line 31 <???!>
% 3-beta19 21 Jun   KEYBOARD:
%                   - waitkeydown: Add '-noclear' option. (Cog only)
%                   - lib/Cogent2000/waitkey: Now a sub-fun of waitkeydown.
%                   - openkeyboard, isopen:  Add "isopen('keyboard')".
%                   - getkeycode, getkeynumber, getkeyname: Check that keyboard is open.
%                   stoptrial, line 132: fix case aborted.
% 3-beta20 26 Jun  -> Julie, on MERCURE.
% 3-beta21 04 Jul   stoptrial: line 86, add test before rmfield() for stability.
%                   stoptrial: Chack trial is started.
%                   backgroundmask: Add TODO tag. <TODO: Fix backgroundmask's FillHole arg. !!>
%                   DRAW:  <MAJOR FIXES!>
%                   - Polygons: Fix coordinates (PTB).
%                   - Cross: Was not implemented.
%                   - 'xcross': Added.
% 3-beta22 10 Sep  -> Julie on MERCURE, Monika on personal laptop.
% 3-beta23 12 Sep   drawdebuginfo: New fun.
%                   SAVE: cosysave: New fun. <!!>
% 3-beta24 12 Oct   Installed on Julien's PC & Anne's experimental PC. <v#: beta23>
% 3-beta25 12 Oct   cosyversion: Call edcv in case of v# mismatch.
%                   VIDEO: ADD VIDEO RECORD MODE. <NEW MODULE !!!>
%                   - CosyVideo: <NEW MODULE!>
%                   - playmovie, closemovie: Where outside of the toolbox! (in D:\MATLAB). <MAJOR FIX!>
%                   - loadmovie, loadvideoimages: Moved to new module folder.
%                   - startvideorecord, stopvideorecord, savevideorecord: New funs.
%                   - displaybuffer, cosyglobal: Modif.
%                   - cosydemo/cosydemo_videorecord: New demo file.
%                   drawrect, drawsquare, drawround: Add nargcheck. Add warning if obsolete syntax (<2-beta43).
%                   MOUSE: waitmouseclick: Add default TimeOut = inf.
%                   DAQ/JOYSTICK: NEW MODULE <!!!>
%                   - CosyDaq: New module.
%                   - opendaq, openanaloginput, closeanaloginput, openanalogjoystick, getjoystick: New fun.
%                   - isopen: Modif.
%                   GENERAL: ERRORS: cosyerror: New fun. <doesn't work as expected!> <TODO: use it or delete it???>
%                   startcosy: Check Screen# arg.
%                   loadimage: Fix 'int' option with indexed images.
%                   getmouse: Doc+
%                   draw: Minor modif: rewrite error msg for invalid RGB range.
%                   opendisplay: Add arg check for RGB range.
%                   ISHIHARA: ishihara: New fun, unfinished. <TODO> New dir: /cosydisplay/var/Ishihara/
%                   KEYBOARD: getallkeynumber: Delete fun. (was unfinished)
%                   PARALLEL PORT: openparallelport, sendparallelbyte: Doc+.
% 3-beta26 02 Nov  -> Monika's USB key (not used). <TODO: Fix inverted value for joystick's buttons.>
% 3-beta27 06 Nov   cosysave: Fix doc.  Internal modif.: add Subj and Block columns: bad idea! => commented.
%                   isaborted: Renamed isabort -> isaborted. isabort moved to /Legacy. Doc+. COSY_GENERAL.isAbort -> isAborted. 
%                   readcondtable: Fix case of vectors of numbers read as strings: convert them to doubles (ex.: rgb array). <!>
%                   round2frame: Use oneframe instead of getframedur => works when CGr was never started.
%                   helper_dispevent: Cosmetic: add one blank.
%                   KEYBOARD: waitkeydown: Fix check isptb in place of isptb('Keyboard').
%                   startpsych, stoppsych: Review dispbox. (dispbox() fixed in bentools 0.12.11.)
%                   AI/JOYSTICK:
%                   - openanalogjoystick: Review verbosity.
%                   - openanalogjoystick: Continuous recording case.
%                   - starttrial, stoptrial: Do nothing in continuous recording mode.
%                   - getjoystick: Fix for continuous recording.
%                   - joystickcalibration, openanalogjoystick, getjoystick: Inverted buttons case. <!>
%                   - joystickcalibration: Fix spelling error in JoystickCalib.
%                   TIME: Add Clock_drift_example.fig in cosytime/
%                   EYELINK: 
%                   - geteyelinktime, helper_measureeyelinktimeoffset: New funs.
%                   - geteyelinktimeoffset: Rewrite in Matlab! Eyelink('TimeOffset') doesn't work!
%                   - openeyelink, starttrial: Update to measure eyelink's time offset.
%                   starttrial: + internal doc.
% 3-beta28 09 Nov  -> Monika's laptop.
%                   cosyversion: Fix case first install: edcv -> try edcv
% 3-beta29 09 Nov   EYELINK/TRIALS: 
%                   - geteyelinkevents: + EventName arg.
%                   - savetrials4eyeview: + warning() if no EL file.
%         /12 Nov   - starttrial: Fix case no EL (!): Remove line 83 (debug line).
%                   - geteyelinkevents: change debug mode.
%                   - geteyelinkfile: +Doc.
%                   - geteyelinkfile: Fix fix EL v3.10: Bug on EyeLink 3.10 !!!: returns 0 instead of file size.
%                   - geteyelinkevents: + internal doc.
%                   - waiteyelinkevents: Total rewrite!
%                   - waiteyelinksaccade: New fun.
%                   <TODO: Test pb of 4 call of geteyelinkevents !!!>
%                   waitkeydown: header: + TODO tag.
% 3-beta30 13 Nov  -> Exp on Marcus lab, on ATHOS.
% 3-beta31 19 Nov   clearcosy: Fix warning about try-catch.
%                   VIDEO: 
%                   - createvideotestfile: Fix doc.
%                   - startvideorecord: Was missing! (misplaced in wrong dir) <!!>
%                   - savevideorecord: File types: Check file types, Doc+.
%                   - savevideorecord: Save uncompressed files.
%                   - helper_checkerrors>sub_displaymissedframeswarning: No warning when recording video.
%                   - setvideorecord: Replace save-/stopvideorecord -> setvideorecord on/off <!!!>
%                   - starttrial: Reset video recording. <BUG!: suppr. in next version!>
%                   displaymessage: Partial rewrite.
% 3-beta32 22 Nov  -> PC Julien.
% 3-beta33 23 Nov   VIDEO: 
%                   - starttrial: Fix 3-beta31: Suppr. Reset of video recording.
%                   - savevideorecord: Clear recorded images after saving, to free memory.
%                   - setvideorecord: Check that mmwrite is installed.
%                   - savevideorecord: +Doc.
% 3-beta34 23 Nov  -> Elo & Rodrigo
%                   VIDEO: setvideorecord: Fix location error <!!>.
%          06 Dec   On HERMES & SESOSTRIS: stoptrial: add stopeyelinkrecord <!!!>
%          03 Jan   loadimage: Fix alpha channel.
% 3-beta35 Jan 2013 SERIAL:
%                   - openserialport: Fix use independent of startcosy (Matalb crash!): call cogstd first.
%                   - setcosylib: CHANGE DEFAULT LIB: now Cogent <!!!> (because pb of sendserialbytes slowness is no more observed)
%                   - sendserialbytes: Suppress warning about slowness pb.
%                   - clearserialbyte: Doc.
%                   - openserialport: Disp CogSerial's error msg in case of failure.
%                   - openserialport: Over Matlab lib, fix baudrate hardcoded at 115200.
%                   - openserialport: Over Matlab lib, set object's TimeOut to 2 ms. <MAJOR FIX!>
%                   - get-, sendserialbyte: +Check port is open.
%                   - openserialport: Over Matlab lib: warning off MATLAB:serial:fread:unsuccessfulRead
%                   - clearseriabytes: Rewrite, now just a wrepper for getserialbytes.
%                   DEVCON:
%                   - cosygeneral\devcon.exe: New file.
%                   - cosygeneral\devcon.m: New fun. Wrapper for devcon.exe.
%                   ARDUINO:
%                   - CosyArduino: New module <!!!> <UNFINISHED>
%                   - findarduinos: New fun. Unfinished.
%                   color2gray: Fix optional 'rec' argument.
%                   stopcosy: Remove global vars not used.
%                   clearbuffer: Rewrite first header line to avoid confusion with deleting the buffer itself.
%                   SCORE: NEW MODULE!
%                   - New module: CosyScore <!!!>
%                   - starttrial: Call resetscore.
%                   <TODO: Doc: add examples, add See also.>
%                   DRAW:
%                   - drawgrid: New fun.
%                   - draw: Doc: replace "penWidth" by "l".
%                   - drawline: Doc: Rewrite doc for PTB's gradients (was obsolete).
%                   DISPLAY:
%                   - opendisplay: Default bg color now mid-grey on both Cog & PTB. <!!>
%                   GAMES: NEW MODULE!
%                   - New module: CosyGames <!!!>
%                   - New game: Sudoku (alpha stage).
%                   - setupcosy: Add all CosyGames' sub-dirs to path.
%                   EYELINK:
%                   - waiteyelinksaccade: Replace mean area (d1.ava), not working, by area at sacc onset (also better scientifically).
% 3-beta36 18 Mar  -> ATHOS on Marcus' labto run Expectation().
% 3-beta37 18 Mar   DRAW:
%                   - draw: Change var name: penWidth -> lineWidth. Replace strcmpi(Shape) -> strcmp(Shape).
%                   - draw('arc'): New sub-fun. <!>
%                   - drawgrid: x, y ouput: now vectors.
%                   - setcoordsystem, draw: Fix PTB coords for buffers of other dim than screen res. <MAJOR FIX!!!>
%                   - copybuffer: b1 arg becomes optional, default=0.
%                   - draw: Accept 'circle' inplace of 'round'.
%                   - iscollision: New fun.
%                   - randxy: New fun.
%                   - draw: Input args checks: Check ischar(Shape) and check RGB dimensions <!!> <MEDIUM FIX! Makes debugging of v2 easier!>
%                   - draw: Clean code: Shape arg parsing: replace if/elseif strcmp(Shape) by switch Shape.
%                   - draw('polygon#'): Fix case more than one polygon.
%                   - draw('star#'): New shape.
%                   SCORE: Delete *_proto0.m files.
%                   ABORT:
%                   - checkabortkey: New fun. <!> (In CosyKeyboard).
%                   - stopfullscreen: New fun. <!>
%                   - waitmouseclick: Add checkabortkey.
%                   - resetabortflag: New fun. <!>
%                   - displaybuffer, waitframe, checkabortkey: Print abortion message. <!!>
%                   - playsudoku: Add resetabortflag;
%                   MOUSE:
%                   - waitmouseclick: see above.
%                   - waitmouseclick: First wait button release.
%                   MANUAL:
%                   - cosymanual: Begun to re-write; unfinished.
%                   GAMMA:
%                   - getgamma: New fun. <!>
%                   - setgamma: Stores gamma value in COSY_DISPLAY.Gamma.
%                   DISPLAY:
%                   - getscreenwidth, getscreenheight: New funs. <!>
%                   - buffersize: small optim.
%                   - getbackroundcolor: New fun (Nicolas Deravet).
%                   - isbuffer: New fun.
%                   startcosy: Review Matlab config dispinfo.
%                   GAMES/SUDOKU:
%                   - CosyGames: New module <!>
%                   - Sudoku: New game.
%                   - setupcosy: Add all ./cosygames/* and all ./cosygames/*/lib dirs to path.
%                   SINSTIM:
%                   - displayanimation: Fix draw() args (fix v3).
%                   - displayanimation: Include SinStim 1.8.12's modifs. <!>
%                   - displayanimation: Fix bg after splash.
%                   - displayanimation: Split! <!!!>
%                   TRIAL:
%                   - stoptrial: Delete 2 redundant lines.
%                   - starttrial: Wait inter-trial only if iTrial > 1.
%                   - starttrial: Disp error msg if inter-trial interval exceeded.
%                   - gettrials/sub_processtrials: helper_processtrials moved as a sub-fun of gettrials. <!>
%                   - starttrial: Fix: global var COSY_DISPLAY was not declared. <MAJOR FIX!>
%                   SOUND: MP3
%                   - New lib: mp3 (mp3read/mp3write) <!!!> NOT INCLUDED <!!!>
%                   - loadsound: Support mp3 <!>
%                   SCORE:
%                   - getscoreparams -> getscoreproperties. 
%                   - Var names *Params -> *Properties
%                   - resetscore -> openscore <!>
%                   - setscoreproperties: New Fun.
%                   - Fields of global var: Change names to automatize.
%                   - cosyglobal: Update.
%                   - drawscorebar: New fun (was a sub-fun): displayscore/sub_drawbar -> drawscorebar;
%                   - drawscoredigit: id.
%                   setparamstruct: Suppressed Fun: CosyGraphics/CosyGeneral/setparamstruct -> bentools/setpropstruct
%                   GAMES/TRAILMAKINGTEST:
%                   - New game.
% 3-beta38 12 Apr  -> Alex & Monika
%                   Delete CosyManual.txt
v = [3 -1 38];
subv = '';

%<TODO: Fix backgroundmask's FillHole arg.>
% TODO 3.0:         o opendisplay: Fix line 135 (Cog 1.25 unsupported res. err. msg).
%                   o edf2asc: Make it independent of CosyG. (use OS's tmp dir).
%                   o Test rgb2ggg
%                   o Test checkeyelink('iscalibrated')
%                   o SOUND: Fix playsound/startsound mess.
%                   o SOUND: Review stability.
%                   o getscreenres -> something more cosy
%                   o getkeydown, other kb funs: Rewrite!
%                   o setcosylib('Cog',...): Review! Must update Matlab's path.


% Question Bruno & Adriano:
% x // Events ? what #
% x Multiple trials ?  no
% - Change color condition ?
% - Different cond. for top/bot ?
% - BG always white ?
%              Todo 2-beta:
%                   x CHANGE NAME !!!
%                   - startpsych/opendisplay:
%                           x bg color argument
%                           x Fix Freq test
%                           - Force Freq
%                           - Check resolution/freq validity ("Screen('Resolutions',screenNum)")
%                   x displayanimation:
%                           x doc.!
%                           x merge rtdiplaybuffers & rtdisplaysprites
%                           x review varargin
%                           x Redo Send bytes.
%                           / 'Luminance' arg. (??)
%                           x AxesRotation
%                           x Draw Shape
%                   x Abort Key
%                   - Gamma:
%                           x gammacorrect/gammaundo (or gammaexpand/gammacompress ?)
%                           x setgamma/getgamma
%                           - save OS gamma in global var, setgamma('reset')
%                   x draw* functions
%                       - Fix drawline 1pix bug.
%                       - Fix drawcross
%                   x makesinusoid (done: sinewave)
%                   x copybuffer: merge copybuffer & copybufferrect (+ drawstoredimage?)
%                   . backgroundmask: See file.
%                   - backgroundmask: FillHoles, ErodeBorder: order ?? ; ErodeBorder or Dilate ??
%                   x stopcogent, stoppsych
%                   ? opendisplay: add Screen('Close') <?>
%                   x opendisplay: Check Freq: error -> warning
%                   - opendisplay: Splash "Graphics Lab v2*"
%                   - copybuffer: Fix multiple b0.
%                   ? Fix Matlab 7.5 with PTB
%
%              Todo 2.0:  
%                   - FILES:
%              <!>      o Folder organisation: GraphicsLab/GLab-*, GraphicsLab/lib
%                       o Cog/CG: external like ptb (?)
%                       ? PTB: Make G-Lab must be able to run without PTB installed.
%                       o Subfolders per categories. + Help.
%                   - KEYBOARD:
%                       o Fix waitkeydown on PTB
%                       o Fix CogInput stability pb on Matlab 7.5.
%                       x openkeyboard: F1 to F12.
%                       x Suppress legacy KEY function.
%                       o getkeynumber: check for bugs when 2 output args.
%                       o getkeynumber, getkeycode, (getkeyname?): multiple names as input
%                       o getkeynames (return always a cell array).
%                       o waitkeydown(keyName|keyCode,...)
%                       o waitkeydown: output format = input format <?? pb with names?>
%                       o waitkeydown/waitkeyup: Check integration with the stack. (See waitkeydown.m-ben)
%                       ? getkey* -> key* (?)
%                   - LIBRARIES: 
%                       o review interaction setlibrary/startglab
%                       o setlibrary: review syntax to set lib version
%                       o setlibrary/getlibrary: Change name ?
%                   ? glab.m for help. (?)
%                   . Help headers: add interlines on all files.
%                   o Version: [x y z] -> 'x.y.z'
%                   x Fix CG startup.
%                   . convertcoord: Optimize! (See convertcoord2)
%                   o checkdisplay/checkbuffer (use assert)
%                   o startpsych: doc.
%                   o Check 1 pixel errors !!! (xy2ij -> cartesian2applecoord ?)
%                        PTB bug: FrameRect: coord = middle of line >< FrameOval: coord = ext. of line
%                   ? Suppress current buffer. ???
%                   x Global var.: * -> COGENT_BUFFERS structure.
%                   x Global var.: * -> COGENT_DISPLAY structure.
%                   o displaybuffer: '-dontclear' option (for CG 1.28 & PTB).
%                   ? getscreenres -> getdisplayresolution (?) change name ?
%                   ? imagesize -> imageresolution ? To avoid trouble with inverted order ([w h])
%                   x PTB: verify needed files
%                   o storeimage: case nargin > 1, what to do ?
%                   o newbuffer: What to do with newbuffer(I) ?
%                   o startcogent: set CG lib version to 1.28 if '-alphamode'.
%                   x opendisplay: Fix test2 ; Use test 2 & 3 results.
%                   ? waitsynch: See <todo>, line 40.
%                   - TEXT:
%                       o PTB text on Windows: See renderer pb.
%                       o Font size PTB ~= size CG
%                       - drawtext: optimize: 
%                           o use settext() to set font before RT
%                           o other optims
%                   x clearcogent if version change. <done, v2-beta21>
%                   o stopglab/startglab: don't restart display if no param change.
%                   o backgroundalpha: suppr.?
%                   o waituntil: port on PTB.
%                   - OPTIMIZATION:
%                       o Optimize iscog, isptb: use persistent var.
%                       o convertcoor: Rewrite in C.
%                   ? All draw fun: Check arg. consistency.
%                   ? Fix startcogent(-1)
%                   ? newbuffer -> openbuffer, deletebuffer -> closebuffer
%                   - DRAW:
%                       ? drawoval ?
%                       o What to do with all draw* functions ?
%                       o draw: Improve doc.
%                   o playsound -> startsound ??
%                   ? fix drawcross with CG.
%                   x getscreenfreq/getframdur: review what to do if GLab not started ?
%                   ? Run w/o PTB installed (Windows only!) : (NB: getscrenfreq('nominal') not implemented)
%                   o BlankBuffer is not used: Suppress ? Replace by DrawBuffer (for background) ?
%                   o startcogent, startpsych -> startglab(lib)
%                   o isopen vs glabcheck vs checkeyelink: Uniformize.
%
%               Todo 2.x:
%                   - ScreenN
%                   - displaybuffer: measure time at drawing completion with "Screen('DrawingFinished')".
%
%               Todo 1.6.4
%                   - Check waitsynch
%                   - setlibrary: default = 'Cog' for kb

% Known issues:
% - Matlab 7 case consistency check: warning disabled. Have to find a better solution.
%
% To do :
% - Doc. rtdisplaysprites
% - Include 'waitserialbyte_or_esc'
% - Function which replaces settextstyle.
% - Text alignement.
% - rgb2g
% - cogentcheck function

% if ~isempty(which('setupglab')) % if v2 has been installed after v3..  <v3-beta2> <Suppr. v3-beta8: 500 recusrion bug!>
%     [v,vstr] = glabversion; % call glabversion in place of cosyversion.
% end

if ~exist('v','var')
    error('version # definition has probably been acccidentally deleted! Check code!')
end

% Second output arg.: version as a string
vstr = vnum2vstr(v);

% Check version number consistency
txt = help(mfilename);
txt(txt==' ') = []; % deblank
pattern = vstr(vstr~=' '); % deblank
e = strfind(txt,'v=[');
text = txt(1:e);
f = strfind(txt,[char(10) int2str(v(1))]);
txt = txt(f(end)+1:end);
if isempty(strmatch(pattern,txt)) || isempty(strfind(sub_cosygraphicsroot,pattern))
    beep
    warning(['Check version number in ' mfilename ' !'])
    try 
        edcv;
    catch
    end
end

% Add sub-version to string <v2-beta12b>
vstr = [vstr subv];

% glabversion('str')  <v2-beta12b>
if nargin
    if strcmpi(type,'str')
        v = vstr;
    end
end

%% SUB-FUN
function pathname = sub_cosygraphicsroot()
% COSYGRAPHICSROOT  CosyGraphics's root directory.
%    pathname = COSYGRAPHICSROOT
% 
% See also COSYGRAPHICSDIR.
%
% Ben,	Nov. 2007.

% <NB: WE WANT NO DEPENDENCIES IN THIS CODE !!!>

p = which(mfilename); % <v3-alpha5: Use mfilename to be robust to fun name changes.>
f = find(p == filesep);
f = f(end) - 1;
pathname = p(1:f);
