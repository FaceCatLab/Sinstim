function [vnum,vstr] = bentoolsversion
% BENTOOLSVERSION  BenTools version number, and version infos.
%    v = BENTOOLSVERSION  returns version number, a [0 y m d] vactor.
%
%    [v,vstr] = BENTOOLSVERSION  returns also version string vstr.

%% Version Log
% 0.9.4.28  Fix stdtextread.m
% 0.9.6.11  UI tools developped for GLM View.
%           stdtextread: Add 'FORMAT' output arg; Fix nargin bug, when nargin = 3.
% 0.9.7.30  <Fork: From 0.9.24.8> Fix sinewave.m
%
% 0.9.8.19  VERSION: Create this file (bentoolsversion.m) !!!
%           <End Fork: Merge 0.9.6.11 and 0.9.7.30>
%           autoregfiltinpart: Fix to become standalone file.
%      .21  findgroup: Modified version of evFindGroups
%      .26  fitaxesv: Fix Matlab zoom bug: puts non-visible axes outside figure.
%      .27  save6: New fun. <Not yet tested>
%           cell2char: Modif doc (cosmetic)
%      .28  dealvect: New fun
% 0.9.10.15 randpattern: new fun
% 0.9.11.04 sinewave: Fix "Index exceed matrix dimension" bug
%
% 0.10       COMPATIBILITY MATLAB 7.? to 7.4: Rewrite bentools/savepath.m.
%            LEGACY: Add "legacy" folder; update setupbentools.
%            SAVE TAB COL. SEP. TABLE:
%            savetxt: new fun
%            mat2asciifile.m vect2asciifile.m textwrite.m struct2asciifile.m var2ascii.m -> legacy
% 0.10.1     fitrange: Fix case M is integer.
% 0.10.1.14  replace: -r option <error in version #: .14 was missing>
% 0.10.1.26  bentoolsroot, cdbentools: new funs.
%            excel: new fun.
%
% 0.12.2     datesuffix: new fun
% 0.10.2.3   bentoolsversion -> btversion, cdbentools -> cdbt
%            setupbentools: add version info
%            readcondtable, structvect2cell, disptable, disptableh: new funs
% 0.10.2.4   callername: new fun
% 0.10.2.10  cell2vectstruct, structvect2vectstruct: new fun ; structvect2cell: modif.
%
% 0.10.3    <v# error!> datesuffix: Add sec to fix erasing one file by the next one. + Fix doc
% 0.10.3.19 <v# error!> nandiff: new fun  
% 0.10.3.24  fitaxesv: Fix line95: length -> numel
% 0.10.3.29  txtfile2struct: Finish doc.
%            structmerge: new fun ; + update structcat.
% 0.10.3.31  togglecheck: Fix uicontrol case.
%
% 0.10.4  :) uisignalcontrols: New fun.
%
% 0.10.4.16  matlab6 folder ; modif setupbentools <!>
%            fix bentoolsversion
%            vstr2vnum: Fix case vstr is numeric ; vstr2vnum, vnum2vstr: Add "See also".
%            vcmp: new fun
% 0.10.4.20  bentoolsversion (the wrapper): Add doc.
%            fieldtree, treestruct2flatstruct: New fun.
%            structvect2cell: v2.0, support sub-fields.
%            disptable: support sub-fields ; add options
%            savetxt: Fix ";" bugs
% 0.10.4.23  countloc: verbose
%            isoption: New fun.
% 0.10.4.30  fieldtree -> fieldstree
%            fieldstree: Add 'Sizes' and 'Classes' output args.
%            vectstruct2cell: New fun.
%            disptable: Support vectstructs
%
% 0.10.5     findoptions: New fun. isoption: update "see also".
% 0.10.5.7   save6: Fix ";" bug.
%
% 0.10.6     moved from GLab -> bentools
%            dispinfo: 'INFO' -> 'info'
%            setupbentools: disp() -> dispinfo()
% 0.10.6.3   synctoolboxplus: New fun.
% 0.10.6.9   derivee -> deriv, because of conflict with eyeview*\programmers\okulo\derivee; input args change.
%            xcorr: Copy Matlab's function into bentools to avoid it to be overloaded by the eponymous BioSig function.    
% 0.10.6.10  synctoolboxplus: fix for DARTAGNAN & clones: remove M: and N: to search for USB drives.
% 0.10.6.11  openfolder: New fun.
% 0.10.6.14  callername: Rewrite using dbstack in place of evalin + mfilename.
%            editbtversion: New fun.
%            dispbox: New fun.
% 0.10.6.18  isazero: New fun.
%            checkdir: New fun.
%            Delete empty file findoption.m. <del>
%            findoptions: Fix doc.
% 0.10.6.28  dispinfo: only 'warning' & 'error' "uppered".
%
% 0.10.7     save6: Fix "spaces in folder name" bug.
% 0.10.7.7   delpath, savepath, doublons: Fix doc.
%            structvect2cell: Verbose.
% 0.10.7.13  matlab6\intmax: New fun (copy of M7.5 fun)
% 0.10.7.15  structvect2cell: Optimize: moved line 94 out of "for i" loop. Huge difference on big tables!
% 0.10.7.16  editbtversion -> edbtv.
% 0.10.7.19  isfieldtrue: New fun.
%            isfilledfield: Doc.
% 0.10.7.20  openfolder: Case w/o arg.
%            Delete findoption.
% 0.10.7.22  isfieldtrue: Fix.
%            findgroup: Fix doc.
%            disptable: Case multi-lines strings: replace them by '[MxN char]'.
%            rmnans: New fun.
% 0.10.7.27  cp: New fun.
%            getfilesize: Fix case file does not exist. (-> Eyeview/programmers/private)
% 0.10.7.28  Fix cp.
% 0.10.7.30  rm: New fun.
%            datesuffix: Suppress 's' after seconds. '-' -> '_'.
%
% 0.10.9     writetxt, readtxt: New fun.
%            envvar, userdir: New fun.
%            edbv: Change name: edbtv -> edbv ; Fix doc.
%            fullfile: Fixed version, replaces std fun.
%
% 0.10.11    savetxt: '-append' option; '-overwrite' option; Handle case existing file; Check write permission. Fix doc.
%            savetable: Change name: savetxt -> savetable <!!>
%                       '.CSV becomes the default!; '-sep' option; 
%                       CR+LF at the end.
%            savetxt: Deprecated <!>
%            isoption: doc+.
%            tmpdir: New fun.
%            filenameparts: New fun.
% 0.10.11.18 savetable: Fix savetable(M,titles)
%
% 0.11       sinewave: Support variable freq.
%
% 0.11.2     structvect2cell: Minor fix: remove old debug display
%
% 0.11.3     structvect2cell: Fix case 1 row.
% 0.11.3.10  Fix version number: was still 0.11
% 0.11.3.14  squareaxes: New fun.
% 0.11.3.18  sigmoid: New fun. <TODO>
%
% 0.11.4     FIX MATLAB6:
%            setupbentools: Fix double file separator in bentools\matlab6 & bentools\legacy. <MAJOR FIX !!!>
%            isscalar: Fix. <MAJOR FIX !>
% 0.11.4.19  savetable(file,S,n): Fix case when some fields contain scalars (suppress those fields)
% 0.11.4.20  savetable(file,S,n): Fix fix above.
%
% 0.11.5     disptable, findoptions: doc+
%            structvect2cell: '-silent' option.
%            disptable: Fix case of NaNs.  Suppress warning in case of invalid fields.
%            cell2char: Fix first ':' (cosmetic).
% 0.11.5.4   findsub: New fun.
% 0.11.5.5   datesuffix: Add 's' after seconds. Doc+
%            plotfft: New fun.
%            findgroup: Default arg. values.
% 0.11.5.13  savepath: Moved to matlab6\savepath.
%            savepath7: Deleted.
% 0.11.5.18  plotfft: Fix missing freq string. Review code.
% 0.11.5.25  randpattern: Review digits. Check # of chars in pattern.
% 0.11.5.31  randpattern: minor fix.
%
% 0.11.6     setupglab: Move obsolete files to "bentools/trash/". Concerned files: repele.m, mfiledir.m. <!!>
%            mfilecaller, mfilepath: New fun. (+update mfilecontent)
%            cp: Check if file exist; Fix case of *.m files (without extension, accepted by exist(), refused by fopen()).
%            workspace export: New script <todo: scipt -> function ??>
% 0.11.6.8   envvar: Fix '"' at beginning.
%            getfiledate v3.0: Change output arg.!! <!!! Eyeview uses v2.0 !!!>
%            globcmp: New fun.
%            copy: New fun: cp -> copy
%            cp: Rewrite totally. <TODO: debug!>
% 0.11.6.9   sinewave: Fix bug in phases indexes when start angle is not 3*pi/2.
%            openfolder: input arg can be an m-file name.
%            of: New fun.
% 0.11.6.10  disptable: Fix: replace nans by string after option to fix bug due to class change.
%            disptable: Options: fix non-double numeric classes. Add blank row.
%            getfiledate: Fix case 0 output arg.
%            getfiledate: Fix full name as input. <TODO: Update other getfile* functions>
% 0.11.6.15  mexall: New fun.
%            openfolder: Fix v0.11.6.9: fix folder arg.
%            getsubdirlist: Fix dir repet bug. Add '-onlysub' option.
%            getfiledate: Fix localisation bug with WinXP french: use datevec(d.datenum).
%            getsubdirlist, filenameparts, stdtextread, readtxt, getfiledate: doc+.
%            stdtextread: Fix space bug: add 'delimiter' param to strread(), line 104.
% 0.11.6.16  mexall: Finished 1.0.
% 0.11.6.22  syntoolboxplus: fix ";" bug.
%            mexall: Fix rmpath unwanted warning.
% 0.11.6.29  workspacexport: +dispinfo.
% 0.11.6.30  uisearch: Add dir field.
% 
% 0.11.7     noisyround: GLab -> BenTools.
% 0.11.7.5   cell2char: doc+.
% 0.11.7.6   mexall: Fix case no compilator (or other mex error): display warning.
% 0.11.7.7   randpattern: Add repetions of char (between parenthesis)
% 0.11.7.11  dispstructree: New fun. <TODO: what about disptabl, dispstruct, dispstructree names ??>
%            synctoolboxplus: Update GLab's manual.
%            getfiledependencies: New fun.
% 0.11.7.13  mexall: Fix Matlab in datevec bug on M6.5/Win2000 <hack>.
%
% 0.11.9     synctoolboxplus: Fix case backup root lettre = install root letter.
%            stdtextread: Add '-skip' and '-nan' options.
% 0.11.9.13  stdtextread: Fix '-skip' option.
% 0.11.9.15  uisearch: v2.1.1.
%            stdtextread: Comment tic/toc
% 0.11.9.19  Fix date # (month # stayed to 7)
% 0.11.9.21  synctoolboxplus: Update for CosyGraphics v3.
%
% 0.11.10    synctoolboxplus: Print command also ad the end.
%            synctoolboxplus: Fix v2 bw compat. v3 befor 3-beta2 no more supported <!!!>
% 0.11.10.15 <bug in version #>
%            mexall: Fix doc. 
%
% 0.11.11.x  Modifs in randpattern, mexall, plotfft <log erased in 0.11.12>
%
% 0.11.12 <ERROR: From 0.11.10.15 in place of 0.11.11.24 !!!>
%            dispinfo: Use fprintf(), not disp()!!! disp() is queued by Matlab !!!
% 0.11.12.14 Fix version error: Merge 0.11.12 and 0.11.11.24. <Fix> <error in v#: still 0.11.12>
%
% 0.12       Suppr. derivee.m (was overloading Okulo's fun.; was already replaced by deriv.m) <!!>
%            setupbentools: Add 'derivee' to "obsolete" var.
%            setupbentools: Obsolete funs: simply delete (instead of moving to trash (v0.11.6) <!!>
%            of: Fix case no input arg. ; openfolder: +doc.
%
% 0.12.1     txtfile2struct -> readtable <Suppr. txtfile2struct.m, <setupbentools udated in 0.12.2!>>
%            readtable: +Doc. ; +verbose.
%            readtable, readcondtable: Add 'm' output arg.
%            disptable, line 100: fix case cell element.
% 0.12.1.19  sinewave: Don't compute ouput arg. if not necessary. 
%            <FIXME: sinewave: Crash when start angle greather than pi/2.>
%
% 0.12.2     apsp: New fun.
%            setupbentools: Add 'txtfile2struct' to obsolete. <fix 0.12.1>
%            sinewave: Doc+.
% 0.12.2.9   apsp: Default arg = cd. <v# not updated>
% 0.12.2.14  setupbentools, line 30: add 'file' option to exist().
% 0.12.2.16  setupbentools: obsolete files: use full name for avoid false + with eponymous files outside bentools.
%
% 0.12.3     disptable, cell2char: Cosmetic.
%            structvect2cell: Fix case of empty structs.
%            Suppr. file <!>: fieldtree.m (missspelling of fieldStree.m), added to obosolete in setupbentools.
% 0.12.3.21  savetable: Add input arg checks.
%            disptable: Attempt to disp row by row to adapt for big table but was to slow.
% 0.12.3.27  readcondtable: Doc+. Change 3d and 3d args defaults <!!!>  <erikson9 is the updated version of erikson8 !!>
%
% 0.12.4     readcondtable: Initialise random number generator.
% 0.12.4.18  savetable: +Support dataset object as arg.
%
% 0.12.5     Suppr. findoption.m, update setupbentools.
%
% 0.12.6     readcondtable: Compat with OpenOffice.Calc: remove quotes ("). Add error catch for doConvertCell2Mat arg.
%
% 0.12.8 <# err> readtxt: Comment: Line 40: warning('bentools:NonASCIIChar',wrn)  <TODO: Review this!>
%
% 0.12.9     getfreememory: New fun.
%            readtable: Fix ";" bug. Doc+.
% 0.12.9.11  nanmean: Replace ML6.5 version by ML7.5 version.
% 0.12.9.19  readcondtable: fix spelling.
%% Version #
vstr = '0.12.9.19'; % 0.y.m.d
vnum = vstr2vnum(vstr);

%% NB: EyeView 0.25.0 "programmers\private\" content:
% cell2num.m             findword.m             globfind.m             on2one.m               structcat.m            
% delpath.m              getfiledate.m (*)      isfilledfield.m        popupdlg.m             structfind.m           
% edittoline.m           getfilesize.m          kmeanscluster.m        search.m               uisearch.m             
% findclosest.m          getscreenresolution.m  nanmean.m              stdtextread.m          
%
% (*) v2.0: output args inverteds !!!