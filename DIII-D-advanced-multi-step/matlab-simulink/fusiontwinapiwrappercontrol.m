function [status, loops] = fusiontwinapiwrappercontrol(i_step, currents)
% Getting control signals and step number as input.
% On i_step == 0 call init_discharge.
% On further steps increment discharge simulation step.
%
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

        % Initialize plasma discharge through API% 
        
        % NOTE: the paths may differ on a Windows machine
        initData = loadjson(".." + filesep + "init.json");

        % NOTE: one can edit initData further here
        rsp = init_discharge(userOptions, initData, queryParams);
        disp(rsp);
        sim_id = rsp.id;
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
            disp(rsp.output);
            status = int8(rsp.output.ok); loops = rsp.output.out_params.loops;
            return;
        catch exception
            fprintf('Simulation is broken for step %d\n', i_step);
            fprintf('Exception Message: %s\n', exception.message);
            status = int8(0); loops = zeros(44,1);
            return;
            % NOTE: no JSON payload available with `webwrite` on an error in request.
            % NOTE: one can write the step functionality with `matlab.net.http.*`
        end   
    end
end
