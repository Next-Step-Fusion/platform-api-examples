%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Next-Step-Fusion FusionTwin.io API simple demo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load API definitions
addpath('..');

% Define number of steps in the simulation
num_steps = 200;

% Define and edit API user options
userOptions = api_user_options();
userOptions.api_key = '';
userOptions.workspace_id = '';

disp(userOptions);

% Define additional query params
queryParams = struct('save', false);  % save the discharge data on the platform

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize plasma discharge through API

load('initData.mat');
% NOTE: one can edit initData further here
rsp = init_discharge(userOptions, initData, queryParams);

assert(~isempty(rsp.Body) && ~isempty(rsp.Body.Data));
rspdata = rsp.Body.Data;
disp(rspdata);
sim_id = rspdata.id;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step through the plasma discharge

load('stepData.mat'); % load step signals data structure from adjacent .mat-file
for i = 0:num_steps
    try
        stepData.step = i;
        % NOTE: one can edit stepData further here
        rsp = step_discharge(userOptions, sim_id, stepData);
        assert(~isempty(rsp.Body) && ~isempty(rsp.Body.Data));
        rspdata = rsp.Body.Data;
        disp(rspdata.output);
    catch exception
        fprintf('Simulation is broken for step %d\n', i);
        fprintf('Exception Message: %s\n', exception.message);
        break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abort the discharge.
% Should result in empty response with 204 code (No Content).

abort_discharge(userOptions, sim_id);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optional Environment cleanup

% rmpath('..');
