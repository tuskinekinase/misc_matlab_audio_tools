%   List track names in a folder
clear all;
DIRPATH=uigetdir;

file_names = dir(DIRPATH);
file_names = file_names(~[file_names.isdir]);
file_list = {file_names.name}';