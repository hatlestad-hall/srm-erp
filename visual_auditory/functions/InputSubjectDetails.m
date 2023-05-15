%% Introduction

% -- Opens dialogue boxes for subject details and save path input.
% -- Returns a struct, 'Subject', with four fields: ID, Condition, Group, and Directory.

% * * * * * * * * *

% * * Christoffer Hatlestad

% * * Last edit: V. 1.2 (14/12/2016)

% * * * * * * * * *

function [Subject] = InputSubjectDetails()

prompt = {'Subject ID (required):','Condition (optional):', 'Group (optional):'};
dlg_title = 'Subject details input';
num_lines = [1 15; 1 30; 1 30];
answer = inputdlg(prompt,dlg_title,num_lines);
if isempty(answer)
	error('Experiment initialization aborted.');
end

Subject.ID = answer{1,1};
Subject.Condition = answer{2,1};
Subject.Group = answer{3,1};

if isempty(Subject.ID)
	error('Subject ID must be provided.');
end

id_length = length(Subject.ID);
if id_length < 3
	switch id_length
		case 1
			Subject.ID = ['00' Subject.ID];
		case 2
			Subject.ID = ['0' Subject.ID];
	end
end

Data_summary = {'Continue with the following details?', ' ', ...
	['Subject ID: ' Subject.ID ], ['Condition: ' Subject.Condition], ['Group: ' Subject.Group]};

button = questdlg(Data_summary, 'Review details', 'Yes', 'No', 'Yes');
switch button
	case 'Yes'
		disp('Starting experiment with provided input as subject details.');
	case 'No'
		error('Experiment initialization aborted.');
end

Subject.Directory = uigetdir(pwd, 'Select where to save subject logs...');
Subject.Directory = [Subject.Directory '/' Subject.ID];

end