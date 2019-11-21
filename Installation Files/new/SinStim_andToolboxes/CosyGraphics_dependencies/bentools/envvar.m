function dirpath = envvar(var)
% ENVVAR  Evaluate Windows or UNIX environment variable.
%    ENVVAR(VARNAME)  evaluates VARNAME and returns resulting string.
%
%    Example, on Windows:  
%       envvar('USERPROFILE')  returns user directory's path.
%
%    Example, on UNIX:
%       envvar('HOME')  does the same.
%
%    Edit code for documentation about Microsoft's Environment Variables.
%
% See also USERDIR.
%
% Ben, Sep 2010.

if ispc % Windows
    [s,msg] = dos(['"%' var '%"']);
    f = strfind(msg,'"''');
    dirpath = msg(2:f-1);
    if dirpath(1) == '"', dirpath(1) = []; end
    
else % UNIX
    [s,msg] = unix(['echo $' var]);
    dirpath = msg;
    
end
dirpath = [dirpath filesep]; 


%% DOCUMENTATION: Microsoft's Recognized Environment Variables

% APPDATA
% 	
% 
% Same as CSIDL_APPDATA.
% 
% CSIDL_ADMINTOOLS
% 	
% 
% The file system directory that is used to store administrative tools for an individual user. The Microsoft Management Console (MMC) will save customized consoles to this directory, and it will roam with the user.
% 
% CSIDL_ALTSTARTUP
% 	
% 
% The file system directory that corresponds to the user's nonlocalized Startup program group.
% 
% CSIDL_APPDATA
% 	
% 
% The file system directory that serves as a common repository for application-specific data. A typical path is C:\Documents and Settings\username\Application Data. This CSIDL is supported by the redistributable Shfolder.dll for systems that do not have the Microsoft Internet Explorer 4.0 integrated shell installed.
% 
% CSIDL_BITBUCKET
% 	
% 
% The virtual folder containing the objects in the user's Recycle Bin.
% 
% CSIDL_CDBURN_AREA
% 	
% 
% The file system directory acting as a staging area for files waiting to be written to CD. A typical path is C:\Documents and Settings\username\Local Settings\Application Data\Microsoft\CD Burning.
% 
% CSIDL_CONNECTIONS
% 	
% 
% The virtual folder representing Network Connections, containing network and dial-up connections.
% 
% CSIDL_CONTACTS
% 	
% 
% On computers running Windows Vista, this refers to the Contacts folder in %CSIDL_PROFILE%.
% 
% CSIDL_CONTROLS
% 	
% 
% The virtual folder containing icons for the Control Panel applications.
% 
% CSIDL_COOKIES
% 	
% 
% The file system directory that serves as a common repository for Internet cookies. A typical path is C:\Documents and Settings\username\Cookies.
% 
% CSIDL_DESKTOP
% 	
% 
% The virtual folder representing the Windows desktop, the root of the namespace.
% 
% CSIDL_DESKTOPDIRECTORY
% 	
% 
% The file system directory used to physically store file objects on the desktop (which should not be confused with the desktop folder itself). A typical path is C:\Documents and Settings\username\Desktop.
% 
% CSIDL_DRIVES
% 	
% 
% The virtual folder representing My Computer, containing everything on the local computer: storage devices, printers, and Control Panel. The folder may also contain mapped network drives.
% 
% CSIDL_FAVORITES
% 	
% 
% The file system directory that serves as a common repository for the user's favorite items. A typical path is C:\Documents and Settings\username\Favorites.
% 
% CSIDL_HISTORY
% 	
% 
% The file system directory that serves as a common repository for Internet history items.
% 
% CSIDL_INTERNET
% 	
% 
% A virtual folder for Internet Explorer (icon on desktop).
% 
% CSIDL_INTERNET_CACHE
% 	
% 
% The file system directory that serves as a common repository for temporary Internet files. A typical path is C:\Documents and Settings\username\Local Settings\Temporary Internet Files.
% 
% CSIDL_LOCAL_APPDATA
% 	
% 
% The file system directory that serves as a data repository for local (nonroaming) applications. A typical path is C:\Documents and Settings\username\Local Settings\Application Data.
% 
% CSIDL_MYDOCUMENTS
% 	
% 
% The virtual folder representing the My Documents desktop item.
% 
% CSIDL_MYMUSIC
% 	
% 
% The file system directory that serves as a common repository for music files. A typical path is C:\Documents and Settings\User\My Documents\My Music.
% 
% CSIDL_MYPICTURES
% 	
% 
% The file system directory that serves as a common repository for image files. A typical path is C:\Documents and Settings\username\My Documents\My Pictures.
% 
% CSIDL_MYVIDEO
% 	
% 
% The file system directory that serves as a common repository for video files. A typical path is C:\Documents and Settings\username\My Documents\My Videos.
% 
% CSIDL_NETHOOD
% 	
% 
% A file system directory containing the link objects that may exist in the My Network Places virtual folder. It is not the same as CSIDL_NETWORK, which represents the network namespace root. A typical path is C:\Documents and Settings\username\NetHood.
% 
% CSIDL_NETWORK
% 	
% 
% A virtual folder representing My Network Places, the root of the network namespace hierarchy.
% 
% CSIDL_PERSONAL
% 	
% 
% Version 6.0. The virtual folder representing the My Documents desktop item. This is equivalent to CSIDL_MYDOCUMENTS.
% 
% Previous to Version 6.0. The file system directory used to physically store a user's common repository of documents. A typical path is C:\Documents and Settings\username\My Documents. This should be distinguished from the virtual My Documents folder in the namespace. To access that virtual folder, use SHGetFolderLocation, which returns the ITEMIDLIST for the virtual location, or refer to the technique described in Managing the File System (http://go.microsoft.com/fwlink/?LinkId=74611).
% 
% CSIDL_PLAYLISTS
% 	
% 
% For computers running Windows Vista, the virtual folder used to store play albums, typically username\My Music\Playlists.
% 
% CSIDL_PRINTERS
% 	
% 
% The virtual folder containing installed printers.
% 
% CSIDL_PRINTHOOD
% 	
% 
% The file system directory that contains the link objects that can exist in the Printers virtual folder. A typical path is C:\Documents and Settings\username\PrintHood.
% 
% CSIDL_PROFILE
% 	
% 
% The user's profile folder. A typical path is C:\Documents and Settings\username. Applications should not create files or folders at this level; they should put their data under the locations referred to by CSIDL_APPDATA or CSIDL_LOCAL_APPDATA.
% 
% CSIDL_PROGRAMS
% 	
% 
% The file system directory that contains the user's program groups (which are themselves file system directories). A typical path is C:\Documents and Settings\username\Start Menu\Programs.
% 
% CSIDL_RECENT
% 	
% 
% The file system directory that contains shortcuts to the user's most recently used documents. A typical path is C:\Documents and Settings\username\My Recent Documents. To create a shortcut in this folder, use SHAddToRecentDocs. In addition to creating the shortcut, this function updates the shell's list of recent documents and adds the shortcut to the My Recent Documents submenu of the Start menu.
% 
% CSIDL_SENDTO
% 	
% 
% The file system directory that contains Send To menu items. A typical path is C:\Documents and Settings\username\SendTo.
% 
% CSIDL_STARTMENU
% 	
% 
% The file system directory containing Start menu items. A typical path is C:\Documents and Settings\username\Start Menu.
% 
% CSIDL_STARTUP
% 	
% 
% The file system directory that corresponds to the user's Startup program group. A typical path is C:\Documents and Settings\username\Start Menu\Programs\Startup.
% 
% CSIDL_TEMPLATES
% 	
% 
% The file system directory that serves as a common repository for document templates. A typical path is C:\Documents and Settings\username\Templates.
% 
% HOMEPATH
% 	
% 
% Same as %USERPROFILE%.
% 
% TEMP
% 	
% 
% The temporary folder on the computer. For Windows XP, a typical path is %USERPROFILE%\Local Settings\Temp. For Windows Vista, a typical path is %USERPROFILE%\AppData\Local\Temp.
% 
% TMP
% 	
% 
% The temporary folder on the computer. For Windows XP, a typical path is %USERPROFILE%\Local Settings\Temp. For Windows Vista,, a typical path is %USERPROFILE%\AppData\Local\Temp.
% 
% USERPROFILE
% 	
% 
% Same as CSIDL_PROFILE.
% 
% USERSID
% 	
% 
% Represents the current user account security identifier (SID). For example,
% 
% S-1-5-21-1714567821-1326601894-715345443-1026.