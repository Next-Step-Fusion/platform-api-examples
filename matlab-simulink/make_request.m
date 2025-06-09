function response = make_request(url, method, header, data)
%MAKE_REQUEST Custom HTTP request.
%   Returns JSON payload even on erroneous requests.
    arguments
        url char
        method char
        header matlab.net.http.HeaderField {mustBeVector}
        data struct = []
    end
    
    import matlab.net.http.*;

    uri = matlab.net.URI(url);
    body = MessageBody(data);
    request = RequestMessage(method, header, body);
    options = HTTPOptions('ConnectTimeout', 30, 'DecodeResponse', true);

    try
        fprintf('Attempting HTTP request to endpoint: %s\n', uri);
        response = send(request, uri, options);
        
        if ~isempty(response.Body) && ~isempty(response.Body.Data)
            if ismember(response.StatusCode, [StatusCode.OK, StatusCode.Created, StatusCode.Accepted])
                fprintf('Success: %s\n', response.StatusLine);
            else
                fprintf('HTTP Error %d: %s\n', double(response.StatusCode), jsonencode(response.Body.Data)); 
            end
        else
            if response.StatusCode == StatusCode.NoContent
                fprintf('Success; API server returned no data\n')
            else
                fprintf('No response body received\n');
            end
        end
        
    catch exception
        fprintf('Request completely failed: %s\n', exception.message);

    end
