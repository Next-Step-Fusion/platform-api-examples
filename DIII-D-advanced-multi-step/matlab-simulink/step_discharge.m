function response = step_discharge(user_options, simulation_id, step_data, query_params)
% Send a step command for the plasma discharge process through NSF
% FusionTwin.io API    
    arguments
        user_options struct
        simulation_id char
        step_data struct
        query_params struct = struct([])
    end

    header_fields = {'X-Api-Key', char(user_options.api_key)}; % character array needed here
    request_options = weboptions( ...
        'RequestMethod', 'post', ...
        'MediaType', 'application/json', ...
        'HeaderFields', header_fields);
    endpoint = sprintf('%s/workspaces/%s/simulations/step/%s/', ...
                       char(user_options.backend_url), ...
                       char(user_options.workspace_id), ...
                       simulation_id);
    if ~isempty(query_params)
        response = webwrite([endpoint, '?', webparamstostring(query_params)], step_data, request_options);
    else
        response = webwrite(endpoint, step_data, request_options);
    end
end
