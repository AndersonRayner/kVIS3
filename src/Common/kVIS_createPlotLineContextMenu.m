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

function [ m ] = kVIS_createPlotLineContextMenu(line)
    % This function creates a context menu for a given Line object.
    % The menu displays some metadata helping to identify the line, and
    % provides some callback actions.

    m = uicontextmenu();

    % metadata section
    uimenu('Parent', m, 'Label', sprintf('Signal: %s', strip(line.UserData.signalMeta.name)), 'Enable', 'off');
    uimenu('Parent', m, 'Label', sprintf('Units: %s' , strip(line.UserData.signalMeta.unit))       , 'Enable', 'off');
    uimenu('Parent', m, 'Label', sprintf('Data Set: %s', strip(line.UserData.signalMeta.dataSet)), 'Enable', 'off');
    if isstruct(line.UserData) && isfield(line.UserData, 'yyaxis')
        uimenu('Parent', m, 'Label', sprintf('Y Axis: %s', line.UserData.yyaxis), 'Enable', 'off');
    end

    m_actions = uimenu( ...
        'Parent', m, ...
        'Label', 'Actions' ...
        );
    uimenu( ...
        'Parent', m_actions, ...
        'Label', 'Highlight', ...
        'Callback', {@kVIS_plotLineContextMenuActions_Callback, line} ...
        );
    uimenu( ...
        'Parent', m_actions, ...
        'Label', 'Delete', ...
        'Callback', {@kVIS_plotLineContextMenuActions_Callback, line} ...
        );

end
