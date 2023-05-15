function SubDetails = collect_sub_details
%% About

% Function: Pops up a window prompting for standard subject details.

%% Configuration
dlg_title = 'Enter subject details';

input_headers = { 'Subject ID (00xx):', 'Age (years):', 'Sex (F/M):', 'Head circumference (cm):' ...
	, 'Head back-to-front (cm):' 'Head left-to-right (cm):', 'EEG cap size:', 'Language (N/E):' };

input_field_width = [ 1, 45; 1, 45; 1, 45; 1, 45; 1, 45; 1, 45; 1, 45; 1, 45 ];

%% Collect input
% Pop-up window.
input_info = inputdlg ( input_headers, dlg_title, input_field_width );

% Check if "cancel" was clicked.
if isempty ( input_info )
	error ( 'User cancelled' );
end

%% Parse input into struct
SubDetails.ID		= input_info{ 1 };
SubDetails.Age		= str2double ( input_info{ 2 } );
SubDetails.Sex		= input_info{ 3 };
SubDetails.HeadCirc	= str2double ( input_info{ 4 } );
SubDetails.HeadBtF	= str2double ( input_info{ 5 } );
SubDetails.HeadLtR	= str2double ( input_info{ 6 } );
SubDetails.CapSize	= str2double ( input_info{ 7 } );
SubDetails.Language = input_info{ 8 };

%% Review subject details
data_summary = { 'Continue with the following details?', ' ', ...
	[ 'Subject ID: ' SubDetails.ID ], [ 'Age: ' num2str( SubDetails.Age ) ], [ 'Sex: ' SubDetails.Sex ], ...
	[ 'Head circumference: ' num2str( SubDetails.HeadCirc ) ], [ 'Head back-to-front: ' num2str( SubDetails.HeadBtF ) ], ...
	[ 'Head left-to-right: ' num2str( SubDetails.HeadLtR ) ], [ 'EEG cap size: ' num2str( SubDetails.CapSize ) ], ...
	[ 'Language: ' SubDetails.Language ] };

button = questdlg ( data_summary, 'Review details', 'Yes', 'No', 'Yes' );
switch button
	case 'Yes'
		disp ( 'Input subject details confirmed.' );
		
	case 'No'
		error( 'Experiment initialization aborted.' );
end

%% Select output path
try
	SubDetails.Outp_Path = uigetdir ( 'C:/Users/ERP2/Desktop/PL_VEP_Lilly_Johannes/Output/', ...
		'Select output path (subject folder will be created here) ' );
catch
	SubDetails.Outp_Path = uigetdir ( pwd, 'Select output path (subject folder will be created here) ' );
end
SubDetails.Outp_Path = [ SubDetails.Outp_Path '/' SubDetails.ID '/'];

%% Review output path
path_review = { 'Is the following path correct?', ' ', SubDetails.Outp_Path };

button = questdlg ( path_review, 'Review output path', 'Yes', 'No', 'Yes' );
switch button
	case 'Yes'
		disp ( 'Output path confirmed. Subject folder created.' );
		mkdir ( SubDetails.Outp_Path );
		
	case 'No'
		error( 'Experiment initialization aborted.' );
end

end