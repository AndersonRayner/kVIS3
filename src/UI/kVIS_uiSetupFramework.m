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

function kVIS_uiSetupFramework(kVIS_Prefs)

if ~nargin
    close all;
    clc
    kVIS3;
    return;
end

%
% create app window
%
appWindow = figure( ...
    'Visible','off', ...
    'Position',[100,100,1350,750],...
    'MenuBar','none',...
    'Toolbar','none',...
    'Tag', 'appWindow');

%
% Assign the a name to appear in the window title.
%
set(appWindow,'name',['kVIS3 alpha build 004 - BSP: ' kVIS_Prefs.BSP_Info.Name ' build ' kVIS_Prefs.BSP_Info.Version]);

%
% get handle structure
%
handles = guihandles(appWindow);

%
% save figure handle/preferences
%
handles.appWindow = appWindow;
handles.preferences = kVIS_Prefs;


%% set up menu
handles = kVIS_uiSetupMenu(handles, kVIS_Prefs);

%% UI framework layout

%
% set up ribbon and main ui area
%
uiRibbonDivider = uix.VBox('Parent',appWindow);

uiRibbon = uix.HBox('Parent', uiRibbonDivider);

uiMainHorizontalDivider = uix.HBoxFlex('Parent',uiRibbonDivider);

uiRibbonDivider.Heights = [60 -1];

%
% set up left and right panels
%
handles.uiFramework.uiTabGroupLeft = uitabgroup('Parent', uiMainHorizontalDivider,...
    'TabLocation','bottom','SelectionChangedFcn', @kVIS_tabLeftChanged_Callback);

uiBoxRight = uix.VBox('Parent', uiMainHorizontalDivider);

uiMainHorizontalDivider.Widths = [-2.5 -1];

%
% divide right panel vertically
%
handles.uiFramework.uiTabGroupRight  = uitabgroup('Parent', uiBoxRight,...
    'TabLocation','bottom','SelectionChangedFcn', []);

uiPanelDataRange = uipanel('Parent', uiBoxRight,...
    'Backgroundcolor',kVIS_Prefs.uiBackgroundColour);

uiBoxRight.Heights = [-1 120];

%
% divide ribbon horizontally
%
handles.uiFramework.uiRibbonLeft  = uix.CardPanel('Parent', uiRibbon);
handles.uiFramework.uiRibbonRight = uix.CardPanel('Parent', uiRibbon);

uiRibbon.Widths = [475 -1];

%
% add default ribbon (file/plot options)
%
handles = kVIS_uiSetupDefaultRibbonGroup(handles, handles.uiFramework.uiRibbonLeft);



%% right hand tabs/elements

%
% default data range panel - common to all views
%
handles = kVIS_uiSetupPanelDataRange(handles, uiPanelDataRange);

%
% RHS tabs
%
handles = kVIS_uiSetupTabData(handles, handles.uiFramework.uiTabGroupRight);
handles = kVIS_uiSetupTabEvents(handles, handles.uiFramework.uiTabGroupRight);
handles = kVIS_uiSetupTabPlots(handles, handles.uiFramework.uiTabGroupRight);
handles = kVIS_uiSetupTabExports(handles, handles.uiFramework.uiTabGroupRight);


%% left hand tabs
% built-in:
handles = kVIS_uiSetupTabDataViewer(handles, handles.uiFramework.uiTabGroupLeft);
handles = kVIS_uiSetupTabSigProc(handles, handles.uiFramework.uiTabGroupLeft);

% BSP provided tabs
for i = 1:size(kVIS_Prefs.BSP_Info.customTabs,1)
    
    tabFun = str2func(kVIS_Prefs.BSP_Info.customTabs{i,2});
    handles = feval(tabFun, handles);
end



%% set up zoom functionality
zoomContextMenu = uicontextmenu;
uimenu(zoomContextMenu, 'Label', 'Undo Zoom', 'Callback', @kVIS_undoZoom_Callback);
uimenu(zoomContextMenu, 'Label', 'Zoom to Fit', 'Callback', {@kVIS_clearPlotLim_Callback, 'all'});
handles.uiFramework.zcmIN = uimenu(zoomContextMenu, 'Label', 'Zoom In', 'Checked', 'on', 'Separator', 'on', 'Callback', {@kVIS_zoomMenu_Callback, 'in'});
handles.uiFramework.zcmOUT= uimenu(zoomContextMenu, 'Label', 'Zoom Out', 'Checked', 'off', 'Callback', {@kVIS_zoomMenu_Callback, 'out'});
handles.uiFramework.zcmXY = uimenu(zoomContextMenu, 'Label', 'Unconstrained', 'Checked', 'on', 'Separator', 'on', 'Callback', {@kVIS_zoomMenu_Callback, 'xy'});
handles.uiFramework.zcmX  = uimenu(zoomContextMenu, 'Label', 'Horizontal', 'Checked', 'off', 'Callback', {@kVIS_zoomMenu_Callback, 'x'});
handles.uiFramework.zcmYL = uimenu(zoomContextMenu, 'Label', 'Vertical Left', 'Checked', 'off', 'Callback', {@kVIS_zoomMenu_Callback, 'yl'});
% handles.uiFramework.zcmYR = uimenu(zoomContextMenu, 'Label', 'Vertical Right', 'Checked', 'off', 'Callback', {@kVIS_zoomMenu_Callback, 'yr'});

zoomHandle = zoom(appWindow);

zoomHandle.UIContextMenu = zoomContextMenu;

zoomHandle.ActionPreCallback = @kVIS_preZoom_Callback;
zoomHandle.ActionPostCallback = @kVIS_postZoom_Callback;

handles.uiFramework.zoomHandle = zoomHandle;
handles.uiFramework.zoomContextMenu = zoomContextMenu;

%% set up pan functionality
panHandle = pan(appWindow);

panHandle.ActionPostCallback = @kVIS_postPan_Callback;
handles.uiFramework.panHandle = panHandle;

%% set default app/ui state

%
% Make the window visible.
%
set(appWindow,'visible','on');

%
% create plot toggle button fields
%
handles.uiFramework.holdToggle = 0;
handles.uiFramework.gridToggle = 1;
%
% Save handles
%
guidata(appWindow, handles);

%
% Default data viewer axes (main axes left)
%
kVIS_dataViewerAxesSelect_Callback(appWindow, [], 0);

% Select initial active tab
handles.uiFramework.uiTabGroupLeft.SelectedTab = handles.uiTabDataViewer.tabHandle;
handles.uiFramework.uiRibbonRight.Selection = 1;
end
