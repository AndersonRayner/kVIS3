% kVIS3 Data Visualisation
%
% Copyright (C) 2012 - present  Kai Lehmkuehler, Matt Anderson and
% contributors
%
% Contact: kvis3@uav-flightresearch.com
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [] = kVIS_editTimeline_Callback(hObject, ~)

[fds, name] = kVIS_getCurrentFds(hObject);

if isempty(name)
    errordlg('Nothing loaded...')
    return
end


button = questdlg('Trim timeline to selected limits?','Confirm trim','yes','cancel','yes');

if ~strcmp(button, 'yes')
    return
end


TimeRange = kVIS_getDataRange(hObject, 'XLim');

%
% edit the file
%
for I = 1 : size(fds.fdata, 2)
    
    if isempty(fds.fdata{fds.fdataRows.data, I})
        continue;
    end
    
    %
    % relate time to data samples
    %
    t = fds.fdata{fds.fdataRows.data, I}(:,1);

    % start point - use first available sample if data is shorter
    in = find(t <= TimeRange(1), 1, 'last' );
    
    if isempty(in)
        in = 1;
    end
    
    % end point - use last available sample if data is shorter
    out= find(t >= TimeRange(2), 1, 'first');
    
    if isempty(out)
        out = length(t);
    end
    
    %
    % update data length
    %
    data = fds.fdata{fds.fdataRows.data, I};
    
    fds.fdata{fds.fdataRows.data, I} = data(in:out,:);
end

% edit event list to remove events outside new time range
eList = fds.eventList;

EventID = [];
for i = 1:length(eList)
    
    if eList(i).start < TimeRange(1) || eList(i).start > TimeRange(2)
        EventID = [EventID; i];
    end

end

if ~isempty(EventID)
    fds.eventList = ev(EventID, eList);
    msg='Dataset trimming complete. Event list was adjusted.';
else
    msg='Dataset trimming complete';
end

kVIS_updateDataSet(hObject, fds, name)

msgbox(msg)

end


function eList = ev(EventID, eList)

% need to delete later event first
EventID = flipud(EventID);

%
% remove entries from list
%
for j = 1:size(EventID,1)
    
    % first event
    if EventID(j) == 1
        
        eList = eList(2:end);
    
    % last event
    elseif EventID(j) == length(eList)
        
        eList = eList(1:end-1);
     
    % in the middle
    else
        
        eList = eList([1:EventID(j)-1, EventID(j)+1:end]);
        
    end
    
end

end
