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

function handles = kVIS_uiSetupDefaultRibbonGroup(handles, uiRibbonLeft)

if ~nargin
    close all;
    kVIS3;
    return;
end

rbn = uix.HButtonBox('Parent', uiRibbonLeft,...
    'HorizontalAlignment','left',...
    'Backgroundcolor',handles.preferences.uiBackgroundColour);

uicontrol(rbn, 'Style', 'pushbutton',...
    'CData', imread('icons8-open-36.png'),...
    'TooltipString','Open FDS file',...
    'Callback',@kVIS_menuFileOpen_Callback);

uicontrol(rbn, 'Style', 'pushbutton',...
    'CData', imread('icons8-save-36.png'),...
    'TooltipString','Save FDS file',...
    'Callback',@kVIS_menuSaveCurrentFile_Callback);

uix.Empty('Parent', rbn);

uicontrol(rbn, 'Style', 'togglebutton',...
    'CData', imread('icons8-search-36.png'),...
    'TooltipString','Zoom on/off',...
    'Tag','DefaultRibbonGroupZoomToggle',...
    'Callback', {@kVIS_zoomButton_Callback, 0});

uicontrol(rbn, 'Style', 'pushbutton',...
    'CData', imread('icons8-zoom-to-extents-36.png'),...
    'TooltipString','Zoom to fit',...
    'Callback', {@kVIS_clearPlotLim_Callback, 'all'});

uicontrol(rbn, 'Style', 'togglebutton',...
    'CData', imread('icons8-four-fingers-36.png'),...
    'TooltipString','Pan on/off',...
    'Tag','DefaultRibbonGroupPanToggle',...
    'Callback',{@kVIS_panButton_Callback, 0});

uicontrol(rbn, 'Style', 'togglebutton',...
    'CData', imread('icons8-target-36.png'),...
    'TooltipString','Matlab Data Cursor on/off',...
    'Tag','DefaultRibbonGroupCursorToggle',...
    'Callback', {@kVIS_cursorButton_Callback, 0});

uicontrol(rbn,  'Style', 'togglebutton', ...
    'CData', imread('icon_hold.png'),...
    'TooltipString','Add line (hold) on/off',...
    'Tag','DefaultRibbonGroupHoldToggle',...
    'Callback', {@kVIS_holdButton_Callback, 0});

uicontrol(rbn, 'Style', 'pushbutton',...
    'CData', imread('icons8-close-window-36.png'),...
    'TooltipString','Clear plots',...
    'Callback', @kVIS_clearPlot_Callback);


rbn.ButtonSize = [50 50];
end

