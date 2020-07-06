
% Script for testing the remove tree leaf stuff
% close all;
clear all;
clc;

load('C:\Users\matt\Documents\kVIS\kVIS3\sample_data\Flight_1_event_14_Elevator.mat')

[ fds ] = kVIS_fdsRemoveTreeLeaf(fdsExport, 'Inertial_3');

save('C:\Users\matt\Documents\kVIS\kVIS3\sample_data\leaf_removed.mat','fds');