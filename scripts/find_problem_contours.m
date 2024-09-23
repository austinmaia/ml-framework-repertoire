function DATA = find_problem_contours()
    % This function loads all .ctr files in a user-selected directory into a DATA array 
    % and returns the DATA structure containing only files with length 0.
    % To use, either Hit "Run" under editor above or type
    % find_problem_contours() into Command window.
    
    global numSamples tempres

    % Select the folder containing the contour files
    path = uigetdir('Select the folder containing the contour files');
    if path == 0
        disp('No folder selected. Exiting function.');
        return;
    end

    % Get all .ctr files in the selected directory
    filePattern = fullfile(path, '*.ctr');
    ctrFiles = dir(filePattern);

    % Initialize an empty array to hold the valid DATA entries
    validData = [];

    for c1 = 1:length(ctrFiles)
        % Clear temporary variables
        clear tempres ctrlength fcontour
        
        % Load the .ctr file
        fullFileName = fullfile(ctrFiles(c1).folder, ctrFiles(c1).name);
        loadedData = load(fullFileName, '-mat');

        % Determine the length and store relevant information temporarily
        if isfield(loadedData, 'ctrlength')
            ctrlength = loadedData.ctrlength;
            lengthVal = length(loadedData.fcontour);
            contour = loadedData.fcontour;
        else
            ctrlength = loadedData.fcontour(end) / 1000;
            lengthVal = length(loadedData.fcontour) - 1;
            contour = loadedData.fcontour(1:end-1);
        end
        if isfield(loadedData, 'tempres')
            tempres = loadedData.tempres;
        else
            tempres = ctrlength / lengthVal;
        end
        
        % Check if the length is zero and add to validData if it is
        if lengthVal == 0
            newEntry = struct();
            newEntry.name = ctrFiles(c1).name;
            newEntry.ctrlength = ctrlength;
            newEntry.length = lengthVal;
            newEntry.contour = contour;
            newEntry.tempres = tempres;
            newEntry.category = 0;
            validData = [validData, newEntry];
        end
    end

    % Convert the validData array to the DATA structure array
    DATA = validData;
    
    % Update numSamples
    numSamples = length(DATA);

    % Enable the Runmenu if it exists
    h = findobj('Tag', 'Runmenu');
    if ~isempty(h)
        set(h, 'Enable', 'on');
    end
end
