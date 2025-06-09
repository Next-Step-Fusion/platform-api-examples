function [status, loops] = fusiontwin_wrapper(i_step, currents)
% Getting control signals and step number as input.
% On i_step == 0 call init_discharge.
% On further steps increment discharge simulation step.

% Load API utility definitions
addpath('..');  % load path with pre-configured FusionTwin API requests.

% Persist userOptions and sim_id within the wrapper.
persistent userOptions; 
persistent sim_id;

    if i_step == 0
        % Define and edit API user options
        userOptions = api_user_options();
        userOptions.api_key = '';
        userOptions.workspace_id = '';

        disp(userOptions);

        % Define additional query params
        queryParams = struct('save', false);  % save the discharge data on the platform

        % Initialize plasma discharge through API.
        % This structure contains initial data the server needs 
        % to register discharge.
        load('initData.mat');

        % NOTE: one can edit initData further here
        rsp = init_discharge(userOptions, initData, queryParams);
        assert(~isempty(rsp.Body) && ~isempty(rsp.Body.Data));
        rspdata = rsp.Body.Data;
        disp(rspdata);
        sim_id = rspdata.id;
        status = int8(1); loops = zeros(44,1);
        return;

    else
        % Step through the plasma discharge
        stepData = struct();  % we'll get the currents from an input block

        try
            stepData.step = (i_step-1);  % NOTE: API Step count starts from 0 
            stepData.signals = currents;
            % NOTE: one can edit stepData further here
            rsp = step_discharge(userOptions, sim_id, stepData);
            assert(~isempty(rsp.Body) && ~isempty(rsp.Body.Data));
            rspdata = rsp.Body.Data;
            disp(rspdata.output);
            status = int8(rspdata.output.ok); loops = rspdata.output.out_params.loops;
            return;
        catch exception
            fprintf('Simulation is broken for step %d\n', i_step);
            fprintf('Exception Message: %s\n', exception.message);
            status = int8(0); loops = zeros(44,1);
            return;
        end   
    end
end
