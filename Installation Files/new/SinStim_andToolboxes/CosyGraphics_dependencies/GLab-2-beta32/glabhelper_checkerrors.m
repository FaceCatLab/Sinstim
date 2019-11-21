function glabhelper_checkerrors(CallingFun,ErrorName,varargin)
% CHECKERRORS  Error check and error message display.
%    CHECKERRORS(CallingFun,'missedframes',FramesMissed,Tolerance,<isIsochronous>)


switch lower(ErrorName)
    case 'missedframes'
        % Input Args
        CallingFun = upper(CallingFun);
        FramesMissed = varargin{1};
        nDisplayed = varargin{2};
        Tolerance = varargin{3};
        if length(varargin) >= 4,   isIsochronous = varargin{4};
        else                        isIsochronous = NaN;
        end
        FramesMissed = FramesMissed(1:nDisplayed);
        
        % # errors
        nFrameMisses = nansum(FramesMissed);
        iFrameMissed = find(FramesMissed > 0);
        
        % Big error: display GLab warning
        if ~isabort && nFrameMisses > Tolerance; % <TODO: hard coded -> global var?>
            str = {'!!! Timing errors !!!';...
                '';...
                'Unusual number of timing errors:';...
                '';...
                [int2str(nFrameMisses) ' frames where missed.']};
            displaywarning(str);
        end

        % Big error: display GLab warning
        if ~isabort && nFrameMisses >= 5 + 5*isIsochronous; % Tresh is 5 in std mode and 10 in isochronous mode. 
            %                                                 <TODO: hard coded -> global var?>
            str = {'!!! Timing errors !!!';...
                '';...
                'Unusual number of timing errors:';...
                '';...
                [int2str(nFrameMisses) ' frames where missed.']};
            displaywarning(str);
        end
        
        % Display in Command window
        str = [int2str(nFrameMisses) ' missed frames, on ' int2str(nDisplayed) ' displays.'];
        if ~isabort && nFrameMisses > 0
            % Error: Display WARNING
            dispinfo(CallingFun,'warning','')
            disp(str)
            disp(['Displays which where missed are displays #:  ' int2str(iFrameMissed)])
            if isIsochronous == 1
                disp('Isochronous mode: Frames have been skipped to correct the phase shift.')
            elseif isIsochronous == 0
                disp('Non-isochronous mode: No correction has been applied.')
            else % isIsochronous is NaN
                % do nothing.
            end
        elseif ~isabort
            % No Error: Display INFO
            str = [str ' :-)'];
            dispinfo(CallingFun,'info',str)
        else
            dispinfo(CallingFun,'info',['ABORTED BY USER! ' str])
        end
        disp(' ')
        
end
        
