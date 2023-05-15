function [ out, error_info ] = vep_checkers ( par, tmp_savedir, ptb )
%% About

% SUMMARY
% Function to run checkerboard reversal Visual Evoked Potentials (VEP) paradigm.

% REQUIREMENTS
% Psychtoolbox (version 3 or newer) must be installed.

% -----------------------------------
% Christoffer Hatlestad-Hall
% Cognitive Health in Brain Disorders
% Division for Clinical Neuroscience
% Oslo University Hospital
% -----------------------------------

% Run the whole function within a 'try' instance.
% Only the gods can help you if a function crashes with open PTB windows... No, seriously.
try
	
%% Check input arguments
if nargin < 1
	fprintf ( 'Please provide input argument ''par''.' );
	error ( 'Please provide input argument ''par''.' );
end

if nargin < 2
	tmp_savedir = [ pwd '/' ];
	ptb = [];
end

if nargin < 3
	ptb = [];
end

%% Initialize
% Store the configuration structure to the output file.
out.Config = par;

% Retrieve number of blocks to run.
blocks2run = length ( par.blocks );

%% If not provided as input, initialize Psychtoolbox
if isempty ( ptb )
	PsychDefaultSetup(2);
	
	% Open the PTB window and computes properties.
	Screen ( 'Preference', 'SkipSyncTests', 1 );
	ScreenID = max ( Screen( 'Screens' ) );
	[ MainWindow, MainRect ] = Screen ( 'OpenWindow', ScreenID, 127.5 );
	Priority ( 2 );
	HideCursor;
	GetSecs;
else
	MainWindow	= ptb.MainWindow;
	MainRect	= ptb.MainRect;
end

% Setup colors.
Screen ( MainWindow, 'BlendFunction', GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

% Compute screen/window properties.
scrXvd = ( atand( ( par.scr_x_cm / 2 ) / par.view_dist ) ) * 2;
scrYvd = ( atand( ( par.scr_y_cm / 2 ) / par.view_dist ) ) * 2;

scrResXpx	= MainRect ( 3 );
[ x0, y0 ]	= RectCenter ( MainRect );
vd2px		= scrResXpx / scrXvd;
fpSpx		= round ( 0.2 * vd2px );

Contrast	= par.contrast / 2;

% Retrieve screen refresh rate.
IFI	= Screen ( 'GetFlipInterval', MainWindow );

% Setup response key structure.
KbName ( 'UnifyKeyNames' );

%% Configure the log structure
% Create array for storage of probe SOAs.
log_probe_soa = NaN ( sum( par.blocks ), par.probe_trials );

% Create array for storage of probe responses.
log_probe_resp = NaN ( sum( par.blocks ), par.targets_num );

% Create array for storage of HFS SOAs.
log_hfs_soa = NaN ( length( par.blocks ) - sum( par.blocks ), par.hfs_trials );

% Create array for storage of pause blocks durations.
log_pause_dur = NaN ( length( par.blocks ), 1 );

% Create array for storage (getting repetive, yes?) of probe blocks durations.
log_probe_dur = NaN ( sum( par.blocks ), 1 );

% Create array for storage (last one..) of HFS block(s) duration(s).
log_hfs_dur = NaN ( length( par.blocks ) - sum( par.blocks ), 1 );

%% Generate and apply parameters
% Generate initial SOA arrays for the probe blocks.
probes_soa = randi ( par.probe_soa, sum( par.blocks ), par.probe_trials ) / 1000;

% Adjust SOAs according to screen refresh rate.
probes_soa = floor ( probes_soa / IFI ) * IFI;

% Adjust HFS SOA.
hfs_soa = par.hfs_soa / 1000;
hfs_soa = floor ( hfs_soa / IFI ) * IFI;

% Calculate HFS frequency and block duration (for log).
hfs_freq		= 1 / hfs_soa;
hfs_blockdur	= par.hfs_trials / hfs_freq;

% Set the pause SOA to 1 sec (screen flip necessary to enable quitting in pauses).
pause_soa = IFI * ( 1 / IFI );

% Preserve interesting values for eternity and beyond.
out.Parameters.Probes_SOA			= probes_soa;
out.Parameters.HFS_SOA				= hfs_soa;
out.Parameters.HFS_Frequency		= hfs_freq;
out.Parameters.HFS_BlockDuration	= hfs_blockdur;
out.Parameters.IFI					= IFI;

%% Generate visual stimuli
% Generate checkerboards.
nChecksX = ceil ( scrXvd / par.spatial_freq );
nChecksY = ceil ( scrYvd / par.spatial_freq );
Checkpx = ceil ( scrResXpx / nChecksX / 2 );
Check = checkerboard ( Checkpx, nChecksY, nChecksX );
Check( Check > 0 ) = ( 255 / 2 ) + ( 255 * Contrast );
Check( Check == 0 ) = ( 255 / 2 ) - ( 255 * Contrast );
CheckerboardTexture( 1 ) = Screen ( 'MakeTexture', MainWindow, Check );
CheckerboardTexture( 2 ) = Screen ( 'MakeTexture', MainWindow, fliplr( Check ) );

% Generate fixation point - regular and target.
FixPointPos = round ( [x0 - fpSpx / 2, y0 - fpSpx / 2, x0 + fpSpx / 2, y0 + fpSpx / 2 ] );
FixPointCol = [ 255, 0, 0 ];
FixPointTargCol = [ 0, 127.5, 0 ];

%% Configure response structure
% Initiate PTB response function.
KbQueueCreate;

% Start listening for key presses.
KbQueueStart;

% Define response and function keys (for Windows OS).
ResponseKey		= KbName ( 'DownArrow' );
EscapeKey		= KbName ( 'ESCAPE' );
SkipKey			= KbName ( 's' );

% Just have to define some variables counting the progress.
pause_count = 0;
probe_count = 0;
hfs_count = 0;
target_count = 0;

%% Run block
% Initiate block loop.
for b = 1 : blocks2run
	
	% Update the count keeping track of how many pause blocks have been run.
	pause_count = pause_count + 1;
	
	% Run block-preceding pause (i.e. non-stimulus period).
	% Get duration for the upcoming pause. Calculate number of trials (multiples of 1).
	pause_trials = round ( par.pauses( b ) );
	
	% Draw the stimulus (grey screen with regular fixation point).
	Screen ( 'Flip', MainWindow );
	Screen ( 'FillOval', MainWindow, FixPointCol, FixPointPos );
	Screen ( 'DrawingFinished', MainWindow );
	
	% Flip the stimulus. Notes the onset time.
	BlockOnset = Screen ( 'Flip', MainWindow );
	
	% Loop through all (artificial) trials (1 sec each).
	for p = 1 : pause_trials
		
		% Retrieve time stamp at "trial" start.
		pause_trl_start = GetSecs;
		
		% Check if a key has been pressed since last interation.
		[ Response, Call ] = KbQueueCheck;
		
		% Flush the stored key presses; information stored in 'Call'.
		KbQueueFlush;
		
		% If a key has been pressed: Identify which and initiate its function.
		if Response == true
			
			% Escape key has been pressed: Initiate termination of the paradigm.
			if Call( EscapeKey ) > 0
				error ( 'Escape key pressed. Experiment terminated.' );
			end
			
			% Skip key has been pressed: Initiate skipping of the current block.
			if Call( SkipKey ) > 0
				break
			end
		end
		
		% Initiate the actual pause (i.e. 1 sec of it).
		WaitSecs ( pause_soa - ( GetSecs - pause_trl_start ) );
	end
	
	% Do another flush of the stored key presses (for good measure).
	KbQueueFlush;
	
	% Log the duration of the now finished pause.
	log_pause_dur( pause_count, 1 ) = GetSecs - BlockOnset;

	% Determine if the next block to be run is a probe or HFS block.
	cur_blk_type = par.blocks( b );
	
	% Reset the checkerboard phase controller.
	Phase = 1;
	
	% Initiate the correct pathway corresponding to the current block type.
	switch cur_blk_type
		
		% HFS block pathway:
		case 0
			
			% Update the count keeping track of how many HFS blocks have been run.
			hfs_count = hfs_count + 1;
			
			% Draw the checkerboard (phase-dependent) for the first iteration.
			Screen ( 'DrawTexture', MainWindow, CheckerboardTexture( Phase ) );
			Screen ( 'FillOval', MainWindow, FixPointCol, FixPointPos );
			Screen ( 'DrawingFinished', MainWindow );
			
			% Initiate the loop which traverses through all the trials.
			for h = 1 : par.hfs_trials
				
				% Do the actual stimulus presentation (the "flip").
				% Record the onset time if the current iteration is the first (block onset time).
				trl_onset = Screen ( 'Flip', MainWindow );
				if h == 1
					blk_onset = trl_onset;
				end
				
				% Calculate the actual SOA by subtracting the previous flip time from the current.
				% Carve into stone the actual duration of the current trial.
				if h ~= 1
					log_hfs_soa( hfs_count, h - 1 ) = trl_onset - prev_trl_onset;
				end
				
				% Neglect SOA of the final trial.
				if h == par.hfs_trials
					log_hfs_soa( hfs_count, h ) = NaN;
				end
				
				% Update the previous trial onset buffer.
				prev_trl_onset = trl_onset;
				
				% Update the checkerboard phase controller.
				Phase = Phase + 1;
				if Phase > 2, Phase = 1; end
				
				% Check if a key has been pressed since last interation.
				[ Response, Call ] = KbQueueCheck;
				
				% Flush the stored key presses; information stored in 'Call'.
				KbQueueFlush;
				
				% If a key has been pressed: Identify which and initiate its function.
				if Response == true
					
					% Escape key has been pressed: Initiate termination of the paradigm.
					if Call( EscapeKey ) > 0
						error ( 'Escape key pressed. Experiment terminated.' );
					end
					
					% Skip key has been pressed: Initiate skipping of the current block.
					if Call( SkipKey ) > 0
						break
					end
				end
				
				% Draw the checkerboard (phase-dependent) for the next iteration.
				Screen ( 'DrawTexture', MainWindow, CheckerboardTexture( Phase ) );
				Screen ( 'FillOval', MainWindow, FixPointCol, FixPointPos );
				Screen ( 'DrawingFinished', MainWindow );
				
				% And now we wait for the duration of the HFS SOA.
				WaitSecs ( hfs_soa - IFI );
				
			end
			
			% Do another flush of the stored key presses (for good measure).
			KbQueueFlush;
			
			% Log the duration of the now finished HFS block.
			log_hfs_dur( hfs_count, 1 ) = GetSecs - blk_onset;
			
		% Probe block pathway:	
		case 1
			
			% Update the count keeping track of how many probe blocks have been run.
			probe_count = probe_count + 1;
			
			% Update event marker values for the upcoming block.
			cur_em.trial = par.probe_m( probe_count );
			cur_em.trg = par.target_m( probe_count );
			
			% Select a subset of the trials to be target trials (avoids first four and the final).
			% Note: The ratio of trials to targets should be at least 4.
			trg_trls = round ( linspace ( 6, ( par.probe_trials - 2 ), par.targets_num ) );
			
			% Shift each target trial one up, one down, or do nothing (to avoid regular spacing).
			for t = 1 : length ( trg_trls )
				random_num = randi ( [ 1 3 ] );
				if random_num == 1
					trg_trls( t ) = trg_trls( t ) + 1;
				elseif random_num == 2
					trg_trls( t ) = trg_trls( t ) - 1;
				end
			end
			
			% Draw the checkerboard (phase-dependent) for the first iteration (which never is a target).
			Screen ( 'DrawTexture', MainWindow, CheckerboardTexture( Phase ) );
			Screen ( 'FillOval', MainWindow, FixPointCol, FixPointPos );
			Screen ( 'DrawingFinished', MainWindow );
			
			% Initiate the loop which traverses through all the trials.
			for p = 1 : par.probe_trials
				
				% Check if the current iteration is supposed to be a regular or a target trial.
				if ~isempty ( find( p == trg_trls, 1 ) )
					target_trial = true;
					
					% Update target counter.
					target_count = target_count + 1;
					
					% Reset RT tracker.
					trg_rt = [];
					
				else
					target_trial = false;
				end
				
				% Do the actual stimulus presentation (the "flip").
				% Record the onset time if the current iteration is the first (block onset time).
				trl_onset = Screen ( 'Flip', MainWindow );
				if p == 1
					blk_onset = trl_onset;
				end
				
				% Send trigger signal to place event marker at stimulus onset.
				if par.em_enabled
					if target_trial
						em_send_clear ( par.em_addr, cur_em.trg, true );
					else
						em_send_clear ( par.em_addr, cur_em.trial, true );
					end
				end
				
				% Calculate the actual SOA by subtracting the previous flip time from the current.
				% Carve into stone the actual duration of the current trial.
				if p ~= 1
					log_probe_soa( probe_count, p - 1 ) = trl_onset - prev_trl_onset;
				end
				
				% Neglect SOA of the final trial.
				if p == par.probe_trials
					log_probe_soa( probe_count, p ) = NaN;
				end
				
				% Update the previous trial onset buffer.
				prev_trl_onset = trl_onset;
				
				% Reset the "next is target" tracker.
				next_is_trg = false;
				
				% Check if the next iteration is supposed to be a regular or a target trial (for drawing purposes).
				if ~isempty ( find( p + 1 == trg_trls, 1 ) )
					next_is_trg = true;
				end
				
				% Update the checkerboard phase controller.
				Phase = Phase + 1;
				if Phase > 2, Phase = 1; end
				
				% Check if a key has been pressed since last interation.
				[ Response, Call ] = KbQueueCheck;
				
				% Flush the stored key presses; information stored in 'Call'.
				KbQueueFlush;
				
				% If a key has been pressed: Identify which and initiate its function.
				if Response == true
					
					% Escape key has been pressed: Initiate termination of the paradigm.
					if Call( EscapeKey ) > 0
						error ( 'Escape key pressed. Experiment terminated.' );
					end
					
					% Skip key has been pressed: Initiate skipping of the current block.
					if Call( SkipKey ) > 0
						break
					end
				end
				
				% Enter a 'while' loop spanning the current trial's SOA.
				while GetSecs - trl_onset + IFI < probes_soa( probe_count, p )
					
					% If the trial was a target: Evaluate the response.
					if target_trial
						
						% First 'if', check if there has been an actual key press.
						[ trg_resp, trg_call ] = KbQueueCheck;
						if trg_resp
							
							% Second 'if', check if the key pressed is the response key.
							if trg_call( ResponseKey ) > 0
								
								% Third, calculate the difference between the target onset and the key press.
								% And to simplify an otherwise complicated world, round off to three decimals.
								trg_rt = round ( trg_call( ResponseKey ) - trl_onset, 3 );
								
								% Also, log the RT.
								log_probe_resp( probe_count, target_count ) = trg_rt;
								
								% For good measure, deploy an event marker at response.
								if par.em_enabled, em_send_clear ( par.em_addr, par.resp_m, true ); end
								
							end
						end
					end
				end
				
				% If the trial was a target trial but no response was recorded, log that as well (as NaN).
				if target_trial && isempty ( trg_rt )
					log_probe_resp( probe_count, target_count ) = NaN;
				end
				
				% Draw the checkerboard (phase-dependent) for the next iteration.
				Screen ( 'DrawTexture', MainWindow, CheckerboardTexture( Phase ) );
				
				% Draw the fixation point (regular/target-dependent).
				switch next_is_trg
					
					% Prepare target fixation point:
					case true
						Screen ( 'FillOval', MainWindow, FixPointTargCol, FixPointPos );
						
					% Prepare regular fixation point:
					case false
						Screen ( 'FillOval', MainWindow, FixPointCol, FixPointPos );
						
				end
				
				% Wrap up the stimulus drawing.
				Screen ( 'DrawingFinished', MainWindow );
				
			end
			
			% Do another flush of the stored key presses (for good measure).
			KbQueueFlush;
			
			% Log the duration of the now finished probe block.
			log_probe_dur( probe_count, 1 ) = GetSecs - blk_onset;
			
			% Reset the target count.
			target_count = 0;
			
			% Do a temporary save of all variables, in case of unforeseen circumstances (i.e. a crash).
			save ( [ tmp_savedir 'tmp_vep.mat' ] );
			
	end	% Next block!
end % Alright, that's it for the blocks.

%% Wrap up the output file
% Re-define those useful counting variables.
probe_count = 0;
hfs_count = 0;

% Assign stored SOA values to correct labels.
for s = 1 : length ( par.blocks )
	
	% Probe blocks go in here.
	if par.blocks( s ) == 1
		
		% Update probe block count.
		probe_count = probe_count + 1;
		
		% Loop through all stored trial SOAs.
		for t = 1 : par.probe_trials
			eval_string = [ 'out.SOA.' par.labels{ s } '(' num2str( t ) ') = ' num2str( log_probe_soa( probe_count, t ) ) ';' ];
			eval ( eval_string );
		end
		
	% ... and HFS blocks in here.
	else
		
		% Update probe block count.
		hfs_count = hfs_count + 1;
		
		% Loop through all stored trial SOAs.
		for t = 1 : par.hfs_trials
			eval_string = [ 'out.SOA.' par.labels{ s } '(' num2str( t ) ') = ' num2str( log_hfs_soa( hfs_count, t ) ) ';' ];
			eval ( eval_string );
		end
	end
end % Alright, SOAs dealt with.

% Yet again we need to reset a counting variable.
probe_count = 0;

% Now, let's consider the probe response times.
for s = 1 : length ( par.blocks )
	
	% Should only take into account the probe blocks.
	if par.blocks( s ) == 1
		
		% Update probe block count.
		probe_count = probe_count + 1;
		
		% Loop through all stored responses.
		for t = 1 : par.targets_num
			eval_string = [ 'out.RT.' par.labels{ s } '(' num2str( t ) ') = ' num2str( log_probe_resp( probe_count, t ) ) ';' ];
			eval ( eval_string );
		end
		
	end
end % Responses accounted for.

% You know the count reset drill...
pause_count = 0;
probe_count = 0;
hfs_count = 0;

% Finally, the block durations (now we will include the pauses as well).
for s = 1 : length ( par.blocks )
	
	% Probe blocks go in here.
	if par.blocks( s ) == 1
		
		% Update pause block count.
		pause_count = pause_count + 1;
		
		% Consider the preceding pause sequence.
		eval_string = [ 'out.Durations.Pause_' par.labels{ s } ' = ' num2str( log_pause_dur( pause_count, 1 ) ) ';' ];
		eval ( eval_string );
		
		% Update probe block count.
		probe_count = probe_count + 1;
		
		% ... and then the probe block.
		eval_string = [ 'out.Durations.' par.labels{ s } ' = ' num2str( log_probe_dur( probe_count, 1 ) ) ';' ];
		eval ( eval_string );
		
	% ... and HFS blocks in here.
	else
		
		% Update pause block count.
		pause_count = pause_count + 1;
		
		% Consider the preceding pause sequence.
		eval_string = [ 'out.Durations.Pause_' par.labels{ s } ' = ' num2str( log_pause_dur( pause_count, 1 ) ) ';' ];
		eval ( eval_string );
		
		% Update probe block count.
		hfs_count = hfs_count + 1;
		
		% ... and then the HFS block.
		eval_string = [ 'out.Durations.' par.labels{ s } ' = ' num2str( log_hfs_dur( hfs_count, 1 ) ) ';' ];
		eval ( eval_string );
	end
end % Pauses done as well. Yay.

%% Clean up after PTB (if enabled by parameters struct)
if par.clear_ptb
	
	% Close all open PTB windows.
	Screen ( 'CloseAll' );
	
	% Enable display of the cursor.
	ShowCursor;
	
	% Reset the PTB priority.
	Priority ( 0 );
end

% Stop listening for key presses.
KbQueueRelease;

% No errors occurred? Brilliant.
error_info = [];

% Delete the temporary file containing all workspace variables.
delete ( [ tmp_savedir 'tmp_vep.mat' ] );

%% Error catch procedure
% If an error occurs during execution, clean up PTB stuff and terminate smoothly.
catch error_info
	% Close all open PTB windows.
	Screen ( 'CloseAll' );
	
	% Enable display of the cursor.
	ShowCursor;
	
	% Reset the PTB priority.
	Priority ( 0 );
	
	% Stop listening for key presses.
	KbQueueRelease;
	
	% And that should hopefully do it.
end