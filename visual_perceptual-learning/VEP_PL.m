%% About

% INSTRUCTIONS:
%	1. Make sure the folder containing the scripts, functions, and .mat files is added to MATLAB path.
%	2. Also, ensure that Psychtoolbox is properly set up (if not, run 'SetupPsychtoolbox.m').
%	3. On completion, do a backup of the output file (copy whole folder to someplace safe).

% -----------------------------------
% Christoffer Hatlestad-Hall
% Cognitive Health in Brain Disorders
% Division for Clinical Neuroscience
% Oslo University Hospital
% -----------------------------------

%% Subject details and configuration

% Enter subject details.
sub_details = collect_sub_details;

% Define and create PL output directory.
pl_path = [ sub_details.Outp_Path 'PL/' ];
mkdir ( pl_path );

% Also, define and create a temporary VEP directory.
vep_path = [ sub_details.Outp_Path 'VEP_tmp/' ];
mkdir ( vep_path );

% Load the pre-defined VEP configuration structs.
load ( 'cfg_vep_1.mat' );
load ( 'cfg_vep_2.mat' );

% Load the pre-defined instruction text cell.
switch sub_details.Language
	case { 'N', 'n' }
		load ( 'text_instr_nor.mat' );
		
	case { 'E', 'e' }
		load ( 'text_instr_eng.mat' );
end

%% Setup event marker triggering driver

config_io;
addr = hex2dec ( 'B010' );
pause ( 0.01 );
outp ( addr, 0 );
pause ( 0.01 );

%% Initialize PTB and open the paradigm window

PsychDefaultSetup ( 2 );
Screen ( 'Preference', 'SkipSyncTests', 1 );
ScreenID = max ( Screen( 'Screens' ) );
[ ptb.MainWindow, ptb.MainRect ] = Screen ( 'OpenWindow', ScreenID, 127.5 );
Priority ( 2 );
HideCursor;
GetSecs;

%% Part 1: Perceptual learning 1

% Display text instructions.
pause_text ( ptb, text_instr{ 1 }, 3, 3 );

% Session 1.1 (#1).
[ tmp_outp.pl_1, err ] = detection_task ( sub_details, 1, pl_path, ptb );
if ~isempty ( err )
	return
end

% Pause text.
pause_text ( ptb, text_instr{ 2 }, 3, 3 );

% Session 1.2 (#2).
[ tmp_outp.pl_2, err ] = detection_task ( sub_details, 2, pl_path, ptb );
if ~isempty ( err )
	return
end

% Pause text.
pause_text ( ptb, text_instr{ 2 }, 3, 3 );

% Session 1.3 (#3).
[ tmp_outp.pl_3, err ] = detection_task ( sub_details, 3, pl_path, ptb );
if ~isempty ( err )
	return
end

%% Part 2: VEP (baseline 1/2, HFS, post 1/2)

% Display text instructions.
pause_text ( ptb, text_instr{ 3 }, 3, 3 );

% Unpause EEG/ActiView recording.
em_send_clear ( addr, 254, true );
WaitSecs ( 2 );

% Run VEP function.
[ tmp_outp.vep_1, error_info ] = vep_checkers ( cfg_vep_1, vep_path, ptb );
if ~isempty ( error_info )
	return
end

% Flip blank background to the screen.
Screen ( 'Flip', ptb.MainWindow );

% Pause EEG/ActiView recording.
pause ( 15 );
em_send_clear ( addr, 255, true );

%% Part 3: Perceptual learning 2

% Display text instructions.
pause_text ( ptb, text_instr{ 4 }, 3, 3 );

% Session 2.1 (#4).
[ tmp_outp.pl_4, err ] = detection_task ( sub_details, 4, pl_path, ptb );
if ~isempty ( err )
	return
end

% Pause text.
pause_text ( ptb, text_instr{ 2 }, 3, 3 );

% Session 2.2 (#5).
[ tmp_outp.pl_5, err ] = detection_task ( sub_details, 5, pl_path, ptb );
if ~isempty ( err )
	return
end

% Pause text.
pause_text ( ptb, text_instr{ 2 }, 3, 3 );

% Session 2.3 (#6).
[ tmp_outp.pl_6, err ] = detection_task ( sub_details, 6, pl_path, ptb );
if ~isempty ( err )
	return
end

%% Part 4: VEP (post 3/4)

% Display text instructions.
pause_text ( ptb, text_instr{ 5 }, 3, 3 );

% Unpause EEG/ActiView recording.
em_send_clear ( addr, 254, true );
WaitSecs ( 2 );

% Run VEP function.
tmp_outp.vep_2 = vep_checkers ( cfg_vep_2, vep_path, ptb );
if ~isempty ( error_info )
	return
end

% Flip blank background to the screen.
Screen ( 'Flip', ptb.MainWindow );

% Pause EEG/ActiView recording.
WaitSecs ( 2 );
em_send_clear ( addr, 255, true );

%% Part 5: Perceptual learning 3

% Display text instructions.
pause_text ( ptb, text_instr{ 4 }, 3, 3 );

% Session 3.1 (#7).
[ tmp_outp.pl_7, err ] = detection_task ( sub_details, 7, pl_path, ptb );
if ~isempty ( err )
	return
end

% Pause text.
pause_text ( ptb, text_instr{ 2 }, 3, 3 );

% Session 3.2 (#8).
[ tmp_outp.pl_8, err ] = detection_task ( sub_details, 8, pl_path, ptb );
if ~isempty ( err )
	return
end

% Pause text.
pause_text ( ptb, text_instr{ 2 }, 3, 3 );

% Session 3.3 (#9).
[ tmp_outp.pl_9, err ] = detection_task ( sub_details, 9, pl_path, ptb );
if ~isempty ( err )
	return
end

% Flip blank background to the screen.
Screen ( 'Flip', ptb.MainWindow );

% End text.
pause_text ( ptb, text_instr{ 6 }, 3, 3 );

WaitSecs ( 2 );

%% Close and clear PTB

% Close all open PTB windows.
Screen ( 'CloseAll' );

% Enable display of the cursor.
ShowCursor;

% Reset the PTB priority.
Priority ( 0 );

%% Wrap up output structs

% Define output struct namme.
outp_name = [ 'VEP_PL_' sub_details.ID ];

% Write subject details.
eval ( [ outp_name ' = sub_details;' ] );

% Write the VEP logs.
eval ( [ outp_name '.VEP_1 = tmp_outp.vep_1;' ] );
eval ( [ outp_name '.VEP_2 = tmp_outp.vep_2;' ] );

% Write the PL logs.
eval ( [ outp_name '.PL_1 = tmp_outp.pl_1;' ] );
eval ( [ outp_name '.PL_2 = tmp_outp.pl_2;' ] );
eval ( [ outp_name '.PL_3 = tmp_outp.pl_3;' ] );
eval ( [ outp_name '.PL_4 = tmp_outp.pl_4;' ] );
eval ( [ outp_name '.PL_5 = tmp_outp.pl_5;' ] );
eval ( [ outp_name '.PL_6 = tmp_outp.pl_6;' ] );
eval ( [ outp_name '.PL_7 = tmp_outp.pl_7;' ] );
eval ( [ outp_name '.PL_8 = tmp_outp.pl_8;' ] );
eval ( [ outp_name '.PL_9 = tmp_outp.pl_9;' ] );

% Save the final output file.
save ( [ sub_details.Outp_Path outp_name '.mat' ], outp_name );

%% Clean up

% Delete the temporary VEP directory.
if exist ( vep_path, 'dir' ) == 7, rmdir ( vep_path ); end

% Clear everything. Yes. Everything.
clear_check = questdlg ( 'Clear all variables?', 'Clear variables?', 'Yes', 'No', 'Yes' );
if strcmpi ( clear_check, 'Yes' ), clear all; end %#ok<CLSCR>

% ## End of script ##