function queryString = webparamstostring(params)
% Turns `params` struct fields into query options string.
    fields = fieldnames(params);
    queryString = '';
    
    for i = 1:length(fields)
        fieldName = fields{i};
        if i > 1
            queryString = [queryString, '&'];
        end
        queryString = [queryString, fieldName, '=', urlencode(string(params.(fieldName)))];
    end
end
