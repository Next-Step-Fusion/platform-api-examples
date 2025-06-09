function response = init_discharge(user_options, init_data, query_params)
% Init plasma discharge process with NSF FusionTwin.io API.
%
% On success displays '200 OK' (for the simulation suit finder) and
% '201 Created' (for discharge initialization`) HTTP status codes.
%
% `response` structure then contains response data returned by the API
% server. The JSON payload to be accessed via `response.Body.Data`.
    arguments
        user_options struct
        init_data struct
        query_params struct = struct('save', false)
    end

    import matlab.net.http.HeaderField;

    header = [HeaderField('Content-Type', 'application/json'), ...
        HeaderField('Accept', 'application/json'), ...
        HeaderField('X-Api-Key', char(user_options.api_key))];

    endpoint = sprintf('%s/dicts/simulation_suites/',  char(user_options.backend_url));
    method = 'GET';

    response_ = make_request(endpoint, method, header);
    assert(~isempty(response_.Body) && ~isempty(response_.Body.Data));

    suite = find_suite(response_.Body.Data, ...
                       user_options.twin_key, ...
                       user_options.simulator_key);

    fprintf('using simulation suite %s\n', suite.id)

    % Initialize the discharge through API:
    data = struct( ...
        'digital_twin', suite.digital_twin.id, ...
        'simulator', suite.simulator.id, ...
        'type', suite.simulation_type.id, ...
        'preset', suite.preset.id, ...
        'input', init_data);

    endpoint = sprintf('%s/workspaces/%s/simulations/init/', ...
                       char(user_options.backend_url), ...
                       char(user_options.workspace_id));
    if ~isempty(query_params)
        endpoint = sprintf('%s?%s', endpoint, webparamstostring(query_params));
    end

    method = 'POST';

    response = make_request(endpoint, method, header, data);
end
