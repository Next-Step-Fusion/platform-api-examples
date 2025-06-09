function response = abort_discharge(user_options, simulation_id)
% Sends command to abort simulation sequence throusg the FusionTwin
% API.
%
% On success should display 'API server returned no data' which
% corresponds to '204 No Content' HTTP status code.
    arguments
        user_options struct
        simulation_id char
    end

    import matlab.net.http.HeaderField;

    header = [HeaderField('Content-Type', 'application/json'), ...
        HeaderField('Accept', 'application/json'), ...
        HeaderField('X-Api-Key', char(user_options.api_key))];

    endpoint = sprintf('%s/workspaces/%s/simulations/abort/%s/', ...
                       char(user_options.backend_url), ...
                       char(user_options.workspace_id), ...
                       simulation_id);

    method = 'DELETE';

    response = make_request(endpoint, method, header);
end
