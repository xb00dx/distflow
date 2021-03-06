% This code is to do the steady state analysis part

clc
clear
close all
%  Start the timer
start_time = tic;
%% Load the components related to OpenDSS
[DSSObj, DSSText, gridpvpath] = DSSStartup;
DSSSolution=DSSObj.ActiveCircuit.Solution;
DSSText.command = 'Clear';
BaseParam=struct();
Baseparam.slack_voltage=1.02;
time_array=zeros(1,8760);
%%
for i = 1:200 % I am running 200 steps arbitarily, there is no special reason
    clear DSSObj DSSText gridpvpath DSSSolution % clearing up the variables 
    [DSSObj, DSSText, gridpvpath] = DSSStartup; 
    DSSSolution=DSSObj.ActiveCircuit.Solution;
    DSSObj.ClearAll();
%   Choose the feeder we want to test and compile the model

%     DSSText.command = 'Compile C:\feeders\MultiPhase\13Bus\IEEE13Nodeckt.dss';
%     DSSText.command = 'Compile C:\feeders\MultiPhase\34Bus\ieee34Mod1.dss';
%     DSSText.command = 'Compile C:\feeders\MultiPhase\37Bus\ieee37.dss';
    DSSText.command = 'Compile C:\feeders\MultiPhase\123Bus\IEEE123Master.dss';
    %% 
%     Set the slack bus voltage
    setSourceInfo(DSSObj,{'source'},'pu',Baseparam.slack_voltage);
%     Start the power flow time
    power_flow = tic;
    
    DSSSolution.Solve(); % solve the power flow
    if (~DSSSolution.Converged) % check for convergence
        error('Solution Not Converged. Check Model for Convergence');
    end
    t = toc (power_flow); % retrieve the power flow ending time
    %% 
%     The following code is to check whether the minimum voltage that i get
%     at each step is the same if i run the model from OpenDSS directly, so
%     far the result has matched for all the cases, but is kept out of the
%     time loop to ensure that we only record the power flow solving time.
    bus = getBusInfo(DSSObj);
    voltage = [bus.phaseVoltagesPU];
    zero_points = find(voltage ==0);
    voltage (zero_points) = [];
    disp(min(voltage))
    %%
    time_array(i) = t;
end
% The total time to run the full code recorded here 
total_time = toc (start_time);

sprintf('Displaying Solution Time: %f', sum(time_array))
sprintf('Displaying Total Time: %f', total_time)


%% Time reported to run 200 steps so far on my Desktop running MATLAB 2018

% IEEE 13 Bus 
% IEEE 34 Bus 
% IEEE 123 Bus 

