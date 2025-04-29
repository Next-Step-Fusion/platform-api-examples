function suite = find_suite(suites, twin_key, simulator_key, simulator_version)
% Filter the suites list in response of the API for the matching criteria
    matches = arrayfun(@(s) ...
                       strcmp(s.digital_twin.key, twin_key) && ...
                       strcmp(s.simulator.key, simulator_key) && ...
                       strcmp(s.simulator.version, simulator_version) && ...
                       s.available == true, ...
                       suites);
    
    % Find the first matching suite
    suiteIndex = find(matches, 1); % Get the index of the first match
    if ~isempty(suiteIndex)
        suite = suites(suiteIndex); % Return the matching suite
    else
        suite = []; % Return empty if no match is found
    end
end
