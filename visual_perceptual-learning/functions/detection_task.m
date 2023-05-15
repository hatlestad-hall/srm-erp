function [ output, err ] = detection_task( sub_details, session, outPath, ptb )

try
    % Directory
	% outPath = 'C:\Users\ERP2\Desktop\SRP_LDAEP\Perseptuell læring\Output\';
	
	
	% Input parameters
    Xcm = 33;                    % Width of screen (in cm)
    ViewDistance = 57;           % Viewing distance (in cm)
    
    stimsize_vd = 5.0;           % Diameter of stimulus (visual degrees)
    dist_vd = 10.0;              % Stimulus distance from center (center to center, in visual degrees)
    fixsize_vd = 0.1;            % Diameter of fixation point(visual degrees)
    fixsize_color = [255, 0, 0]; % Color of fixation point (RGB)
    
    soa1 = 2.0;                 % Time from onset of trial to fixation onset (seconds)
    soa2 = 1.0;                 % Time from onset of fixation to target onset(seconds)
    soa3 = 0.5;                 % Time from onset of target to disappearance of target (also response time; seconds)
    
    respkey{1} = 'LeftArrow';   % Response key if target is in left hemifield
    respkey{2} = 'RightArrow';  % Response key if target is in right hemifield
    escapekey = 'Escape';       % Give this response to terminate experiment
    
    spatfreq = 1.0;             % Spatial frequency of checkerboard stimulus
    contrast = 0.5;             % Contrast of checkerboard stimulus
    
    threshold = 0.75;    % Threshold you want to calculate (intensity level at which subject responds correctly "thresholds" times)
    ntrials = 40;       % number of trials to run
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	% Convert subject ID to double.
	subID = str2double ( sub_details.ID );
	
    % Initialize Psychtoolbox
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'Verbosity', 1);
    Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);
    Priority(2);
    HideCursor;
    GetSecs;
    KbName('UnifyKeyNames');
    KbCheck;
    ListenChar(2);
    
    % Open an onscreen window and fill it with the background color
	if isempty ( ptb )
		[MainWindow, MainRect] = Screen('OpenWindow', max(Screen('Screens')));
	else
		MainWindow = ptb.MainWindow;
		MainRect = ptb.MainRect;
	end
    Screen(MainWindow,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Calculate screen parameters
    [x0, y0] = RectCenter(MainRect);
    scrXvd = (atand((Xcm/2)/ViewDistance))*2;
    scrResXpx = MainRect(3);
    vd2px = scrResXpx/scrXvd;
    black = 0;%BlackIndex(MainRect);
    white = 255;%WhiteIndex(MainRect);
    bgcolor = (white-black)/2; % background color
        
    % Calculate stimulus parameters
    fixsize_px = round(fixsize_vd*vd2px); 
    stimsize_px = round(stimsize_vd*vd2px);
    dist_px = round(dist_vd*vd2px);
    nChecksX = ceil(stimsize_vd/spatfreq);
    nChecksY = ceil(stimsize_vd/spatfreq);
    Checkpx = ceil(stimsize_px/nChecksX/2);
    Check = checkerboard(Checkpx, nChecksY, nChecksX);
    Check(Check > 0) = (white / 2) + (white * (contrast/2));
    Check(Check == 0) = (white / 2) - (white * (contrast/2));
    FixPointPos = round([x0-(fixsize_px/2),y0-(fixsize_px/2),x0+(fixsize_px/2),y0+(fixsize_px/2)]);
    pos{1} = round([x0-dist_px-(stimsize_px/2),y0-(stimsize_px/2),...
        x0-dist_px+(stimsize_px/2),y0+(stimsize_px/2)]);
    pos{2} = round([x0+dist_px-(stimsize_px/2),y0-(stimsize_px/2),...
        x0+dist_px+(stimsize_px/2),y0+(stimsize_px/2)]);
    
    % make checkerboard textures (phase inversed)
    stimtex1 = Screen('MakeTexture', MainWindow, Check);
    stimtex2 = Screen('MakeTexture', MainWindow, flipud(Check));
    
    % Setup QUEST
    beta=3;delta=0.01;gamma=0.5;
    tGuess=0.05;
    tGuessSd=0.1;
    q=QuestCreate(tGuess,tGuessSd,threshold,beta,delta,gamma);
    q.normalizePdf=1;
    
    % Run the experiment
    Screen('FillRect',MainWindow,bgcolor);
    vbl = Screen(MainWindow,'Flip');
    
    for trial = 1:ntrials
        
        %randomize checkerboard phase
        if ceil(2*rand(1,1))==1
            tex1=stimtex1;
        else
            tex1=stimtex2;
        end
        
        %make random noise patch
        tex2 = Screen('MakeTexture', MainWindow, (rand(size(Check)).*(white*contrast))+(bgcolor-(bgcolor*contrast)));
        
        %pick target side randomly
        if ceil(2*rand(1,1))==1
            targetpos=1;
            noisepos=2;
            cresp=respkey{1};
        else
            targetpos=2;
            noisepos=1;
            cresp=respkey{2};
        end
        
        %Get proportion signal to use in the trial (decided by Quest)
        if trial <= 5
            firsttrials=[0.5 0.2 0.1 0.05 0.025];
            proportion_signal=firsttrials(trial);
        else
            proportion_signal = QuestQuantile(q);
            if proportion_signal < 0; proportion_signal = 0; end
        end
        
        %Draw and present fixation before stimulus
        Screen('FillOval',MainWindow,fixsize_color,FixPointPos);
        vbl = Screen(MainWindow,'Flip',vbl+soa1);
        
        %draw target stimulus
        Screen('DrawTexture', MainWindow, tex1,[],pos{targetpos});
        Screen('DrawTexture', MainWindow, tex2,[],pos{targetpos},[],[],(1-proportion_signal));
        
        %draw noise stimulus
        Screen('DrawTexture', MainWindow, tex2,[],pos{noisepos});
        
        %draw fixation
        Screen('FillOval',MainWindow,fixsize_color,FixPointPos);        
        Screen('DrawingFinished', MainWindow);
        
        vbl = Screen(MainWindow,'Flip',vbl+soa2);
        
        %Prepare to clear screen
        Screen('FillRect',MainWindow,bgcolor);
        Screen('DrawingFinished', MainWindow);
        
        %Collect response
        KeyIsDown = false;
        
        while GetSecs-vbl < soa3
            % Check the state of the keyboard.
            if ~KeyIsDown
                [KeyIsDown,~,KeyCode]=KbCheck;
            end
            WaitSecs(0.001);
        end
        
        %Clear screen
        vbl = Screen(MainWindow,'Flip');
        
        %If a response has been detected
        if KeyIsDown == true
            if KeyCode(KbName(escapekey))
                sca
                Priority(0);
                ShowCursor;
                ListenChar(0);
                return
            elseif KeyCode(KbName(cresp))
                resp = 1;
            else
                resp = 0;
            end
        else
            resp = 0;
        end
        
        q=QuestUpdate(q,proportion_signal,resp);
        
        output(trial,1)=subID;
        output(trial,2)=session;
        output(trial,3)=proportion_signal;
        output(trial,4)=resp;
        output(trial,5)=targetpos;

		save ( [ outPath 'tmp_' num2str( session ) '.mat' ] );
	end
    
    output(:,6)=repmat(QuestMean(q),size(output,1),1);
    save ( [ outPath 'PL_' sub_details.ID '_' num2str( session ) '.mat' ] );
	delete ( [ outPath 'tmp_' num2str( session ) '.mat' ] );
    %sca
    %Priority(0);
    %ShowCursor;
    ListenChar(0);
	err = [];
    
catch err
    sca
    Priority(0);
    ShowCursor;
    ListenChar(0);
    rethrow(err)
end
