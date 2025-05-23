function response = init_discharge(user_options, init_data, query_params)
% Init plasma discharge process with NSF FusionTwin.io API
    arguments
        user_options struct
        init_data struct
        query_params struct = struct('save', false)
    end

    header_fields = {'X-Api-Key', char(user_options.api_key)}; % character array needed here

    % Find suitable simulation suite:
    request_options = weboptions( ...
        'RequestMethod', 'get', ...
        'MediaType', 'application/json', ...
        'HeaderFields', header_fields);
    disp(request_options);
    endpoint = sprintf('%s/dicts/simulation_suites/',  char(user_options.backend_url));
    response = webread(endpoint, request_options);
    suite = find_suite(response, ...
                       user_options.twin_key, ...
                       user_options.simulator_key);
    fprintf('using simulation suite %s\n', suite.id);

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
    request_options = weboptions( ...
        'RequestMethod', 'post', ...
        'MediaType', 'application/json', ...
        'HeaderFields', header_fields);
    if ~isempty(query_params)
        response = webwrite([endpoint, '?', webparamstostring(query_params)], data, request_options);
    else
        response = webwrite(endpoint, data, request_options);
    end
end
