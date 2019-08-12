% Yun Pu (2019). Waitbar for Parfor (https://www.mathworks.com/matlabcentral/fileexchange/71083-waitbar-for-parfor), MATLAB Central File Exchange. Retrieved July 30, 2019. 
% Etienne Vaccaro-Grange (31 May 2019)
classdef parfor_wait < handle
    %This class creates a waitbar or message when using for or parfor.
    %Required Input:
    %TotalMessage: N in "i = 1: N".
    %Optional Inputs:
    %'Waitbar': true of false (default). If true, this class creates a
    %               waitbar.
    %'FileName': 'screen' or a char array. If 'screen', print the message
    %               on screen; otherwise, save the message in the file
    %               named 'FileName'.
    %'ReportInterval': 1x1. Report at every i is costly. This number
    %                defines the interval for reporting.
    %%To use this class, one needs to call the class right before the loop:
    %N = 1000;
    %WaitMessage = parfor_wait(N);
    %%Call "Send" method in the loop.
    %for i = 1: N
    %   WaitMessage.Send;
    %   pause(0.5);
    %end
    %%Delete the obj after the loop.
    %WaitMessage.Destroy;
    %Copyright (c) 2019, Yun Pu
    properties (SetAccess = private)
        NumMessage; %Number of messages received from the workers.
        TotalMessage; %Number of total messages.
        Waitbar; %If waitbar is true, create a waitbar; otherwise, save the message in a file.
        FileName; %If FileName = 'screen', the current message does not save in a file.
        StartTime
        UsedTime_1; %Time at last step.
        WaitbarHandle;
        ReportInterval;
        FileID;
        DataQueueHandle;
    end
    
    methods
        function Obj = parfor_wait(TotalMessage, varargin)
            Obj.DataQueueHandle = parallel.pool.DataQueue;
            Obj.StartTime = tic;
            Obj.NumMessage = 0;
            Obj.UsedTime_1 = Obj.StartTime;
            Obj.TotalMessage = TotalMessage;
            InParser = inputParser;
            addParameter(InParser,'Waitbar',false,@islogical);
            addParameter(InParser,'FileName', 'screen', @ischar);
            addParameter(InParser,'ReportInterval', ceil(TotalMessage/100), @isnumeric);
            parse(InParser, varargin{:})
            Obj.Waitbar = InParser.Results.Waitbar;
            Obj.FileName = InParser.Results.FileName;
            Obj.ReportInterval = InParser.Results.ReportInterval;
            if Obj.Waitbar
                Obj.WaitbarHandle = waitbar(0,[num2str(0), '% Please wait'], 'Resize', true','Units', 'centimeters','Position', [4,3,9.68,2.8]);
            end
            switch Obj.FileName
                case 'screen'
                otherwise
                    Obj.FileID = fopen(Obj.FileName, 'w');
            end
            afterEach(Obj.DataQueueHandle, @Obj.Update);
        end
        function Send(Obj)
            send(Obj.DataQueueHandle, 0);
        end
        function Destroy(Obj)
            if Obj.Waitbar
                delete(Obj.WaitbarHandle);
            end
            delete(Obj.DataQueueHandle);
            delete(Obj);
        end
    end
    
    methods (Access = private)
        function Obj = Update(Obj, ~)
            Obj.AddOne;
            if mod(Obj.NumMessage, Obj.ReportInterval)
                return
            end
            if Obj.Waitbar
                Obj.WaitbarUpdate;
            else
                Obj.FileUpdate;
            end
        end
        
        function WaitbarUpdate(Obj)
            UsedTime_now = toc(Obj.StartTime);
            EstimatedTimeNeeded = (UsedTime_now-Obj.UsedTime_1)/Obj.ReportInterval*(Obj.TotalMessage-Obj.NumMessage);
            waitbar(Obj.NumMessage/Obj.TotalMessage, Obj.WaitbarHandle,{['Completed: ',num2str(Obj.NumMessage/Obj.TotalMessage*100,'%.2f'), '% '],['in ',num2str(floor(UsedTime_now/3600), '%.2f'), ' hours ', num2str(floor(rem(UsedTime_now,3600)/60), '%.2f'), ' min and ', num2str(60*((rem(UsedTime_now,3600)/60)-floor(rem(UsedTime_now,3600)/60)), '%.2f'), ' sec'],['Estimated time needed: ', num2str(floor(EstimatedTimeNeeded/3600), '%.2f'), ' hours ', num2str(floor(rem(EstimatedTimeNeeded,3600)/60), '%.2f'), ' min and ', num2str(60*((rem(EstimatedTimeNeeded,3600)/60)-floor(rem(EstimatedTimeNeeded,3600)/60)), '%.2f'), ' sec']});
            Obj.UsedTime_1 = UsedTime_now;
        end
        
        function FileUpdate(Obj)
            UsedTime_now = toc(Obj.StartTime);
            EstimatedTimeNeeded = (UsedTime_now-Obj.UsedTime_1)/Obj.ReportInterval*(Obj.TotalMessage-Obj.NumMessage);
            switch Obj.FileName
                case 'screen'
                    fprintf('%.2f%%; %.2fs used and %.2fs needed...\n', Obj.NumMessage/Obj.TotalMessage*100, UsedTime_now, EstimatedTimeNeeded);
                otherwise
                    fprintf(Obj.FileID, '%.2f%%; %.2fs used and %.2fs needed...\n', Obj.NumMessage/Obj.TotalMessage*100, UsedTime_now, EstimatedTimeNeeded);
            end
            Obj.UsedTime_1 = UsedTime_now;
        end
        function AddOne(Obj)
            Obj.NumMessage = Obj.NumMessage + 1;
        end
    end
end