function response = step_discharge(user_options, simulation_id, step_data, query_params)
% Send a step command for the plasma discharge process through NSF
% FusionTwin.io API.
% On success displays `201 Created` HTTP status code.
%
% `response` structure then contains response data returned by the API
% server. The JSON payload to be accessed via `response.Body.Data`.
%
% NOTE: `step_data` structure needs to contain correct number of the
% step in `step_data.step` field.
    arguments
        user_options struct
        simulation_id char
        step_data struct
        query_params struct = struct([])
    end

    import matlab.net.http.HeaderField;

    header = [HeaderField('Content-Type', 'application/json'), ...
        HeaderField('Accept', 'application/json'), ...
        HeaderField('X-Api-Key', char(user_options.api_key))];

    endpoint = sprintf('%s/workspaces/%s/simulations/step/%s/', ...
                       char(user_options.backend_url), ...
                       char(user_options.workspace_id), ...
                       simulation_id);
    if ~isempty(query_params)
        endpoint = sprintf('%s?%s', endpoint, webparamstostring(query_params));
    end

    method = 'POST';

    response = make_request(endpoint, method, header, step_data);
end
