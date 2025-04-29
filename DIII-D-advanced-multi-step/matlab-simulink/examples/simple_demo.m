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

initData = loadjson(".." + filesep + "sample-data" + filesep + "init.json");
% NOTE: one can edit initData further here
rsp = init_discharge(userOptions, initData, queryParams);

disp(rsp);
sim_id = rsp.id;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step through the plasma discharge

stepData = loadjson(".." + filesep + "sample-data" + filesep + "step.json");
for i = 0:num_steps
    try
        stepData.step = i;
        % NOTE: one can edit stepData further here
        rsp = step_discharge(userOptions, sim_id, stepData);
        disp(rsp.output);
    catch exception
        fprintf('Simulation is broken for step %d\n', i);
        fprintf('Exception Message: %s\n', exception.message);
        break
        % NOTE: no JSON payload available with `webwrite` on an error in request.
        % NOTE: one can write the step functionality with `matlab.net.http.*`
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optional Environment cleanup

rmpath('..');
