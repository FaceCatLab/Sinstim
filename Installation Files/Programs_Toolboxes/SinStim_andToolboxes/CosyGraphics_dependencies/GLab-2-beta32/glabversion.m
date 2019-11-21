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
%                   - gcw, opendisplay: Optim gcw: 131 �s -> 16 �s (on CHEOPS). 
%                   - iscog, isptb, setlibrary: Optim iscog, isptb: 75 �s -> 15 �s (on CHEOPS).
%                   - convertcoord: Optim convertcoord: 250 �s -> 175 �s (on CHEOPS).
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
%          /22      MAC OS X:
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
% 2-beta30  12 Oct  Used on PORTHOS. (Emeline & PA)  <startcogent broken in 2-beta29! ; fixed 18 Oct>
%                   glabversion: Fix '�' bug.
%          /15 Oct  iscog, isptb: Fix case G.Lab not started. Cog is default lib on Windows. <!!!>
%          /18 Oct  Fix: startcogent: 'CG' -> 'Cog' <fix 2-beta29>
% 2-beta31  18 Nov  <TODO!> copybufferrect: Fix pos. <TODO!>
%                   clearglab: Add "catch" statement to fix ML 7.5 warning. 
% 2-beta32  30 Nov  ERP Lab (SinStim 1.8, Dana)
v = [2 -1 32];
subv = '';

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
if isempty(strmatch(pattern,txt)) || isempty(strfind(glabroot,pattern))
    beep
    warning(['Check version number in ' mfilename ' !'])
end

% Add sub-version to string <v2-beta12b>
vstr = [vstr subv];

% glabversion('str')  <v2-beta12b>
if nargin
    if strcmpi(type,'str')
        v = vstr;
    end
end