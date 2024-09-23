%% Load Data
load("Z:\MaiaProjects\ML_project\allcontours\ARTwarp095_0.mat"); 
% Loads data from a MAT-file located at the specified path. This file is assumed to contain 
% the variable DATA, which holds the contours and related information, and
% should be formatted as an ARTwarp output file.

groups = readtable("Z:\MaiaProjects\ML_project\allcontours\groups_fullname.csv");
% Reads a CSV file containing labels for whistles by species or group. 
% The labels are stored in the same order as the ARTwarp output.

groups = table2array(groups); 
% Converts the table of group labels into a cell array.

[DATA.group] = groups{:}; 
% Assigns each label from the 'groups' array to the corresponding entry in the DATA structure.

num_groups = unique(groups); 
% Finds the unique group labels present in the 'groups' array.
% This helps identify how many different species or groups are in the data. 

%% Import contours
% This section is responsible for categorizing the contours based on their group and category.
% This section runs automatically for 1-5 groups or species; if you have
% that amount, you can just run it without making any alterations.

if length(num_groups) == 1
    % If there's only one group, initialize arrays for storing contours and their sizes.

    byCat = {}; % Initialize an empty cell array to store contours by category.
    catSize = {}; % Initialize an empty cell array to track the number of contours in each category.

    for c1 = 1:NET.numCategories
        % Loop over each category defined in NET.numCategories.

        i = 1; 
        % Initialize index for contours within a category.

        for c2 = 1:length(DATA)
            % Loop over all entries in DATA to categorize contours.

            if DATA(c2).category == c1
                % Check if the current DATA entry's category matches the current category being processed (c1).

                byCat{c1, i} = DATA(c2).contour / 1000; 
                % Store the contour, scaled by dividing by 1000, in the corresponding position in byCat.

                i = i + 1; 
                % Increment the contour index for the current category.
            end
        end

        catSize{c1} = i - 1; 
        % Store the number of contours found in the current category (i-1 because i was incremented after last contour).
    end

elseif length(num_groups) == 2
    % If there are two groups, categorize contours separately for each group.

    byCat1 = {}; % Initialize an empty cell array for contours from the first group.
    catSize1 = {}; % Initialize an empty array to track the size of each category in group 1.

    for c1 = 1:NET.numCategories
        i = 1;
        for c2 = 1:length(DATA)
            if (DATA(c2).category == c1) && (contains(DATA(c2).group, num_groups{1}) == 1)
                % Check if the contour belongs to the current category and the first group.

                byCat1{c1, i} = DATA(c2).contour / 1000; 
                % Store the contour for the first group.

                i = i + 1;
            end
        end

        catSize1{c1, 1} = i - 1;
        % Store the number of contours found in the current category for group 1.
    end

    % Repeat the process for the second group.
    byCat2 = {};
    catSize2 = {};

    for c1 = 1:NET.numCategories
        i = 1;
        for c2 = 1:length(DATA)
            if (DATA(c2).category == c1) && (contains(DATA(c2).group, num_groups{2}) == 1)
                % Check if the contour belongs to the current category and the second group.

                byCat2{c1, i} = DATA(c2).contour / 1000;
                % Store the contour for the second group.

                i = i + 1;
            end
        end

        catSize2{c1, 1} = i - 1;
        % Store the number of contours found in the current category for group 2.
    end
elseif length(num_groups) == 3
% If there are three groups, categorize contours separately for each group.
    byCat1 = {}
    catSize1 = {}; 
    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{1}) == 1)
            byCat1{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize1{c1,1} = i-1
    end

    byCat2 = {}; %initialize empty array for contours
    catSize2 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{2}) == 1)
            byCat2{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize2{c1,1} = i-1
    end

    byCat3 = {} %initialize empty array for contours
    catSize3 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{3}) == 1)
            byCat3{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize3{c1,1} = i-1
    end


elseif length(num_groups) == 4
% If there are four groups, categorize contours separately for each group.
    byCat1 = {}
    catSize1 = {}; 
    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{1}) == 1)
            byCat1{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize1{c1,1} = i-1
    end

    byCat2 = {} %initialize empty array for contours
    catSize2 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{2}) == 1)
            byCat2{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize2{c1,1} = i-1
    end

    byCat3 = {} %initialize empty array for contours
    catSize3 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{3}) == 1)
            byCat3{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize3{c1,1} = i-1
    end

    byCat4 = {} %initialize empty array for contours
    catSize4 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{4}) == 1)
            byCat4{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize4{c1,1} = i-1
    end
elseif length(num_groups) == 5
% If there are five groups, categorize contours separately for each group.

    byCat1 = {}
    catSize1 = {}; 
    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{1}) == 1)
            byCat1{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize1{c1,1} = i-1
    end

    byCat2 = {} %initialize empty array for contours
    catSize2 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{2}) == 1)
            byCat2{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize2{c1,1} = i-1
    end

    byCat3 = {} %initialize empty array for contours
    catSize3 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{3}) == 1)
            byCat3{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize3{c1,1} = i-1
    end

    byCat4 = {} %initialize empty array for contours
    catSize4 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{4}) == 1)
            byCat4{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize4{c1,1} = i-1
    end

    byCat5 = {} %initialize empty array for contours
    catSize5 = {}; %initialize empty array to track category size to iteration

    for c1 = 1:NET.numCategories
    i=1
    for c2 = 1:length(DATA)
        if (DATA(c2).category == c1) & (contains(DATA(c2).group, num_groups{5}) == 1)
            byCat5{c1,i} = DATA(c2).contour / 1000
            i=i+1
        end
    end
    catSize5{c1,1} = i-1
    end
end
%% Label categories by species/group and analyze distribution
% This section creates labels for each category based on the species/groups present and 
% analyzes the distribution of contours across categories.
% As with section above, you can run this section without edits if you have
% between 1 and five groups.

cat_dist = {}; % Initialize an empty cell array for storing distribution information.

if length(num_groups) == 1
    % If there's only one group, assign the group name to all categories.

    for i = 1:length(catSize1)
        cat_dist{i, 1} = num_groups{1}; 
    end
elseif length(num_groups) == 2
    % If there are two groups, determine whether each category is shared or unique to a group.

    for i = 1:length(catSize1)
        if (catSize1{i}) > 0 && (catSize2{i}) > 0
            cat_dist{i, 1} = 'Shared'; % Category is shared between both groups.
        elseif (catSize1{i}) > 0 && (catSize2{i}) == 0
            cat_dist{i, 1} = num_groups{1}; % Category is unique to the first group.
        elseif (catSize1{i}) == 0 && (catSize2{i}) > 0
            cat_dist{i, 1} = num_groups{2}; % Category is unique to the second group.
        end
    end

elseif length(num_groups) == 3
    % If there are three groups, label categories based on combinations of groups sharing them.

    for i = 1:length(catSize1)
        if (catSize1{i}) > 0 && (catSize2{i}) > 0 && (catSize3{i}) > 0
            cat_dist{i, 1} = 'Shared - All'; % Shared by all three groups.
        elseif (catSize1{i}) > 0 && (catSize2{i}) > 0 && (catSize3{i}) == 0
            cat_dist{i, 1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{2}); % Shared by groups 1 and 2.
        elseif (catSize1{i}) > 0 && (catSize2{i}) == 0 && (catSize3{i}) > 0
            cat_dist{i, 1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{3}); % Shared by groups 1 and 3.
        elseif (catSize1{i}) == 0 && (catSize2{i}) > 0 && (catSize3{i}) > 0
            cat_dist{i, 1} = sprintf('Shared - %s, and %s', num_groups{2}, num_groups{3}); % Shared by groups 2 and 3.
        elseif (catSize1{i}) > 0 && (catSize2{i}) == 0 && (catSize3{i}) == 0
            cat_dist{i, 1} = num_groups{1}; % Unique to the first group.
        elseif (catSize1{i}) == 0 && (catSize2{i}) > 0 && (catSize3{i}) == 0
            cat_dist{i, 1} = num_groups{2}; % Unique to the second group.
        elseif (catSize1{i}) == 0 && (catSize2{i}) == 0 && (catSize3{i}) > 0
            cat_dist{i, 1} = num_groups{3}; % Unique to the third group.
        end
    end
    
elseif length(num_groups) == 4
    % If there are four groups, label categories based on combinations of groups sharing them.

    for i = 1:length(catSize1)
        if (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0
            cat_dist{i,1} = 'Shared - All'
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{3})
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{4})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{3}, num_groups{4})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{2}, num_groups{3}, num_groups{4})
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{2})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{3})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{4})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{2}, num_groups{3})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{2}, num_groups{4})
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{3}, num_groups{4})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0
            cat_dist{i,1} = num_groups{1}
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0& (catSize4{i}) == 0
            cat_dist{i,1} = num_groups{2}
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0
            cat_dist{i,1} = num_groups{3}
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0
            cat_dist{i,1} = num_groups{4}
        end
    end
    
elseif length(num_groups) == 5 
    % If there are five groups, label categories based on combinations of groups sharing them.

    for i = 1:length(catSize1)
        if (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = 'Shared - All'
        %4 way splits
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{3}, num_groups{4})
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{3}, num_groups{5})
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{4}, num_groups{5})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, %s, and %s', num_groups{1}, num_groups{3}, num_groups{4}, num_groups{5})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, %s, and %s', num_groups{2}, num_groups{3}, num_groups{4}, num_groups{5})
        %3 way splits
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{3})
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{4})
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{2}, num_groups{5})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{3}, num_groups{4})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{3}, num_groups{5})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{1}, num_groups{4}, num_groups{5})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{2}, num_groups{3}, num_groups{4})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{2}, num_groups{3}, num_groups{5})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{2}, num_groups{4}, num_groups{5})
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, %s, and %s', num_groups{3}, num_groups{4}, num_groups{5})
        %2 way splits
        elseif (catSize1{i}) > 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{2})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{3})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{4})
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{1}, num_groups{5})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{2}, num_groups{3})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{2}, num_groups{4})
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{2}, num_groups{5})
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{3}, num_groups{4})
         elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{3}, num_groups{5})
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) > 0
            cat_dist{i,1} = sprintf('Shared - %s, and %s', num_groups{4}, num_groups{5})
        %1 way
        elseif (catSize1{i}) > 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0 & (catSize5{i}) == 0
            cat_dist{i,1} = num_groups{1}
        elseif (catSize1{i}) == 0 & (catSize2{i}) > 0 & (catSize3{i}) == 0& (catSize4{i}) == 0 & (catSize5{i}) == 0
            cat_dist{i,1} = num_groups{2}
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) > 0 & (catSize4{i}) == 0 & (catSize5{i}) == 0
            cat_dist{i,1} = num_groups{3}
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) > 0 & (catSize5{i}) == 0
            cat_dist{i,1} = num_groups{4}
        elseif (catSize1{i}) == 0 & (catSize2{i}) == 0 & (catSize3{i}) == 0 & (catSize4{i}) == 0 & (catSize5{i}) > 0
            cat_dist{i,1} = num_groups{5}
        end
    end    
end

%%

%From here there are 2 options: create 1 figure with tiles showing
%repertoire, or create subfolder for each group (i.e. one species, shared
%between two species, etc.) and save individual PNGs of each category
%% SHARED FIGURE %%
% This section of the code generates a shared figure with plots of whistle contours for each category.

NC = NET.numCategories + 1; 
% Adds 1 to the number of categories to potentially make the layout more balanced.
% Depending on results, you may need to adjust this value.

K = 1:NC; 
% Creates a range of integers from 1 to the total number of categories plus one.

div = K(rem(NC, K) == 0); 
% Finds the divisors of NC, which are numbers that evenly divide NC.
% This helps to determine the best layout (number of rows and columns) for the figure.

div = num2cell(div); 
% Converts the array of divisors into a cell array.

numRows = cell2mat(div(ceil(end/2))); 
% Selects the middle divisor from the list to use as the number of rows, which should help balance the layout.

numCols = NC / numRows; 
% Calculates the number of columns based on the total number of categories divided by the number of rows.

allValues = [DATA.contour]; 
% Concatenates all contours from the DATA structure into one array.

fmax = max(allValues) / 1000; 
% Determines the maximum frequency across all contours and scales it by dividing by 1000.

time = []; 
% Initializes an empty array to store the lengths of each contour.

for i = 1:size(struct2table(DATA),1)
    time(i) = length(DATA(i).contour); 
    % Loops through each entry in DATA and stores the length of each contour.
end

tmax = max(time) / 100; 
% Finds the maximum contour length and scales it by dividing by 100 to get the maximum time in seconds.

%% Create Shared Figure
clf 
% Clears the current figure window.

t = tiledlayout(numRows, numCols); 
% Creates a tiled layout for the plots with the number of rows and columns determined earlier.

% Add shared title and axis labels
xtxt = xlabel(t,'Time (s)'); 
ytxt = ylabel(t,'Frequency (kHz)');
ytxt.FontSize = 12;
xtxt.FontSize = 12;
t.TileSpacing = 'compact'; 
t.Padding = 'compact'; 
% Adjusts spacing and padding between tiles to make the figure look more compact and organized.

h = zeros(ceil(NET.numCategories), 1); 
% Initializes an array to store axes handles for each subplot.

for i = 1:NET.numCategories
    h(i) = nexttile(t); 
    % Adds a new tile for each category.

    j = 0; 
    % Initializes a counter for the number of contours plotted in each tile.

    for c1 = 1:catSize1{i}
        x = byCat1{i,c1}; 
        % Retrieves the contour for the current category from the first group.

        y = 0.01:0.01:(length(x)/100); 
        % Creates a time array for plotting with 0.01 second intervals.

        plot(y, x, "Color", '#d55e00', 'LineWidth', 2.5); 
        % Plots the contour in orange with a line width of 2.5.

        j = j + 1; 
        % Increments the counter.

        hold on; 
        % Keeps the plot open for additional contours.
    end

    % Repeat the contour plotting process for additional groups if they exist.
    % This process is repeated for up to 5 groups, each with a unique color.

    if exist('byCat2', 'var') == 1
        for c1 = 1:catSize2{i}
            x = byCat2{i,c1};
            y = 0.01:0.01:(length(x)/100);
            plot(y, x, "Color", '#0072b2', 'LineWidth', 2.5); % teal
            j = j + 1;
            hold on;
        end
    end

    if exist('byCat3', 'var') == 1
        for c1 = 1:catSize3{i}
            x = byCat3{i,c1};
            y = 0.01:0.01:(length(x)/100);
            plot(y, x, "Color", '#cc79a7', 'LineWidth', 2.5); % pink
            j = j + 1;
            hold on;
        end
    end

    if exist('byCat4', 'var') == 1
        for c1 = 1:catSize4{i}
            x = byCat4{i,c1};
            y = 0.01:0.01:(length(x)/100);
            plot(y, x, "Color", '#330066', 'LineWidth', 2.5); % purple
            j = j + 1;
            hold on;
        end
    end

    % Adding individual tile labels with species and number of whistles per category.
    tile_title = cat_dist{i}; 
    % Retrieves the category distribution label for the current tile.

    if length(tile_title) >= 25
        tile_title = strsplit(tile_title, "and"); 
        % Splits long labels at "and" to make them more readable.
    end

    if j == 1
        numwhistles = sprintf("%d Whistle", j); 
        % Creates a label with the correct singular form if only one whistle is present.
    else
        numwhistles = sprintf("%d Whistles", j); 
        % Creates a label for multiple whistles.
    end

    tile_title = [tile_title numwhistles]; 
    % Combines the group label and the number of whistles into the title.

    title(tile_title); 
    % Sets the title for the current subplot.

    hold off;
end

set(h, 'FontSize', 25); 
% Sets the font size for all subplots to make labels easier to read.

% Optional linking of axes for shared zoom and pan.
% linkaxes(h, 'xy'); 

set(gcf, 'PaperPosition', [0 0 70 70]); 
% Sets the figure size, allowing it to be larger than the screen.

print(gcf, 'MyFigure.png', '-dpng', '-r300'); 
% Saves the figure as a PNG file with 300 dpi resolution.

%% SEPARATE CATEGORY IMAGES %%
% This section saves individual images of contours for each category in separate folders.

% Create directories for each group based on category distribution.
cd("C:\Users\lmaycoll\OneDrive - University of Vermont\Desktop\writing\ML\Figures\individual_contours"); 
% Sets the current directory to where you want to save images.

types = unique(cat_dist); 
% Finds the unique category distribution labels.

for i = 1:length(types)
    mkdir(types{i}); 
    % Creates a directory for each unique label.
end

% Standardize axes limits based on maximum values.
allValues = [DATA.contour];
fmax = max(allValues) / 1000;

time = [];
for i = 1:size(struct2table(DATA),1)
    time(i) = length(DATA(i).contour);
end

tmax = max(time) / 100;

for i = 1:NET.numCategories
    h = figure('visible', 'off'); 
    % Creates a new figure window that is not visible (for saving only).

    % Plot contours for the first group.
    for c1 = 1:catSize1{i}
        x = byCat1{i,c1};
        y = 0.01:0.01:(length(x)/100);
        plot(y, x, "Color", '#d55e00'); 
        % Plots the contour in orange.
        hold on;
    end

    % Repeat the contour plotting process for up to 5 groups with unique colors.
    if exist('byCat2', 'var') == 1
        for c1 = 1:catSize2{i}
            x = byCat2{i,c1};
            y = 0.01:0.01:(length(x)/100);
            plot(y, x, "Color", '#0072b2'); % teal
            hold on;
        end
    end

    if exist('byCat3', 'var') == 1
        for c1 = 1:catSize3{i}
            x = byCat3{i,c1};
            y = 0.01:0.01:(length(x)/100);
            plot(y, x, "Color", '#cc79a7'); % pink
            hold on;
        end
    end

    if exist('byCat4', 'var') == 1
        for c1 = 1:catSize4{i}
            x = byCat4{i,c1};
            y = 0.01:0.01:(length(x)/100);
            plot(y, x, "Color", '#330066'); % purple
            hold on;
        end
    end

    if exist('byCat5', 'var') == 1
        for c1 = 1:catSize5{i}
            x = byCat5{i,c1};
            y = 0.01:0.01:(length(x)/100);
            plot(y, x, "Color", '#5dc863'); % green
            hold on;
        end
    end

    hold off;
    ylim([0 fmax]);
    xlim([0 tmax]); 
    % Sets the limits for y-axis and x-axis to standardize plots.

    path = [cd '\' cat_dist{i}]; 
    % Creates the full path for saving the image in the appropriate directory.

    filename = sprintf("Category_%d.png", i); 
    % Creates a filename based on the category index.

    saveas(h, fullfile(path, filename)); 
    % Saves the figure as a PNG file in the specified directory.
end