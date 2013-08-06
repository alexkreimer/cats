clear all;
close all;
dbstop if error;

cat_train(@dst2im_ssd,'ssd');
cat_train(@dst2im_sad,'sad');
cat_train(@dst2im_ncc,'ncc');
cat_train(@dst2im_zncc,'zncc');
