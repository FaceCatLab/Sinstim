function comNumbers = findarduinos(option)
% FINDARDUINOS  Search for Arduino boards. <Windows only>
%    comNumbers = FINDARDUINOS  returns number of USB COM port of every connected Arduino.
%    
%    comNumbers = FINDARDUINOS('-ALL')  returns number of COM ports of every installed Arduino,
%    either present or not.
%
% Ben, Jan 2013.

if nargin
    if strcmpi(option,'-all')
        fun = 'findall';
        dispinfo(mfilename,'info','Looking for installed Arduino boards...');
    else
        error('Invalid argument.')
    end
else
    fun = 'find';
    dispinfo(mfilename,'info','Looking for connected Arduino boards...');
end

str = devcon(fun,'FTDIBUS*');

disp(str);

b = strfind(str,'(COM');
e = strfind(str,[')' 10]);

for i = 1:length(b)
    comNumbers(i) = str2num( str( (b(i)+4):(e(i)-1) ) );
end

comNumbers = sort(comNumbers);
