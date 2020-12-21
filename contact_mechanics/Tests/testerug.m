clear all
close all
clc

%% Dados de entrada (CASO APOSTILA FIG 6.3)
Rx1=0.010; %mm
Rx2=10; %mm
Rx=0.020;
po=998510000;
ahertz=1.766072190951245e-04;
atrito=6.96e-2;
E=113077000000;
amp1 = 3.532e-7; %m
amp2 = 0; %m
c_onda1 = ahertz/4;
c_onda2 = 0;
Fn_m = 277;

rugosidade(0.3, 0.3, 205.8E9, 205.8E9, Rx1, Rx2, Rx, po, E, Fn_m, ahertz, atrito, amp1, amp2, c_onda1, c_onda2, true)

