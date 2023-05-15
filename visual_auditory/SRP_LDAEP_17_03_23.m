%% Introduction

% Paradigm requires Psychtoolbox-3
% -- www.psychtoolbox.org
% * * * * * * * * * * * * * * * * * *

% SRP + LDAEP paradigm
% * * * * * * * * * * * * * * * * * *

% Default response key: Arrow down
% --      skip key: F1
% --      abort key: Escape
% --	  pause key: F4 (press during non-stimulus blocks to pause)
% * * * * * * * * * * * * * * * * * *

% Last edit: 23/03/2017
% * * * * * * * * * * * * * * * * * *

% Christoffer Hatlestad
% * * * * * * * * * * * * * * * * * *

function SRP_LDAEP_17_03_23()

try
	PsychDefaultSetup(2);
	TriggersEnabled = true;
	TriggerBoundaryStart = 100;
	TriggerBoundaryEnd = 101;
	TrainingEnabled = false;
	
	%% Subject details and trigger initialization 
	
	% Subject details - dialogue box pop-up
	Subject = InputSubjectDetails();
	
	if isempty(Subject.ID)
		error('To run this function, you must provide at least a subject ID.');
	end
	
	if isempty(Subject.Condition) && isempty(Subject.Group)
		SaveDirectory = [Subject.Directory '/Subject_' Subject.ID];
	elseif ~isempty(Subject.Condition) && isempty(Subject.Group)
		SaveDirectory = [Subject.Directory '/' Subject.Condition ...
			'_Subject_' Subject.ID];
	elseif isempty(Subject.Condition) && ~isempty(Subject.Group)
		SaveDirectory = [Subject.Directory '/' Subject.Group ...
			'_Subject_' Subject.ID];
	else
		SaveDirectory = [Subject.Directory '/' Subject.Group '_' ...
			Subject.Condition '_Subject_' Subject.ID];
	end
	mkdir(SaveDirectory);
	
	% Setup event triggering driver
	if TriggersEnabled == true
		config_io; Address = hex2dec('B010');
		WaitSecs(0.001); outp(Address, 0); WaitSecs(0.001);
	end
	
	%% SRP settings 
	
	% Auditory modality
	SRP.Auditory.Stimulus.Duration = 0.050;
	SRP.Auditory.Stimulus.Frequency = 1000;
	
	SRP.Auditory.Target.Duration = 0.050;
	SRP.Auditory.Target.Frequency = 1500;
	SRP.Auditory.Target.Number = 5;
	
	SRP.Auditory.Training.Trials = 10;
	SRP.Auditory.Baseline.Trials = 40;
	SRP.Auditory.Post.Trials = 40;
	
	SRP.Auditory.Tetanus.Duration = 120;
	
	SRP.Auditory.Training.SOA = [1800 2600];
	SRP.Auditory.Baseline.SOA = [1800 2600];
	SRP.Auditory.Post.SOA = [1800 2600];

	% Visual modality
	SRP.Visual.Stimulus.SpatialFrequency = 1.0;
	SRP.Visual.Stimulus.Contrast = 1.0;
	SRP.Visual.Target.Contrast = 0.50;
	
	SRP.Visual.Training.Trials = 10;
	SRP.Visual.Baseline.Trials = 40;
	SRP.Visual.Post.Trials = 40;
	
	SRP.Visual.Tetanus.Duration = 120;
	
	SRP.Visual.Training.SOA = [500 1500];
	SRP.Visual.Baseline.SOA = [500 1500];
	SRP.Visual.Post.SOA = [500 1500];
	
	SRP.Visual.Target.Number = 5;
	
	% Non-stimulus
	SRP.NonStimulus.Duration_60 = 60;
	SRP.NonStimulus.Duration_120 = 120;
	SRP.NonStimulus.Duration_47 = 47;
	SRP.NonStimulus.Duration_55 = 55;
	SRP.NonStimulus.Duration_77 = 77;
	SRP.NonStimulus.Duration_90 = 90;
	
	% Block onset cue
	SRP.Onset.Enable = false;
	SRP.Onset.Tone.Duration = 0.250;
	SRP.Onset.Tone.Frequency = 2000;
	SRP.Onset.TimeBefore = 5.0;
	
	%% LDAEP settings 
	
	LDAEP.Stimulus.Duration = 0.030;
	LDAEP.Stimulus.Frequency = 1000;
	
	LDAEP.Stimulus.Volume_1 = 0.0119;	% 55 dB
	LDAEP.Stimulus.Volume_2 = 0.03565;	% 65 dB
	LDAEP.Stimulus.Volume_3 = 0.1073;	% 75 dB
	LDAEP.Stimulus.Volume_4 = 0.325;	% 85 dB
	LDAEP.Stimulus.Volume_5 = 0.985;	% 95 dB
	
	LDAEP.Triggers.Code_1 = 51;
	LDAEP.Triggers.Code_2 = 52;
	LDAEP.Triggers.Code_3 = 53;
	LDAEP.Triggers.Code_4 = 54;
	LDAEP.Triggers.Code_5 = 55;
	
	LDAEP.Trials.Each = 80;
	LDAEP.Trials.Total = LDAEP.Trials.Each * 5;
	LDAEP.Trials.SOA = [1200 1800];
	
	%% Resting EEG settings 
	
	RestEEG.Duration = 240;
	RestEEG.Signal.Duration = 1.0;
	RestEEG.Signal.Frequency = 500;
	
	RestEEG.TriggerOpenOnset = 61;
	RestEEG.TriggerClosedOnset = 62;
	
	RestEEG.TriggerOpenOffset = 68;
	RestEEG.TriggerClosedOffset = 69;
	
	%% Text 
	
	% Instructions before start
	Line_1 = 'Velkommen, og takk for at du vil delta i denne studien!\n\n\n\n';
	Line_2 = 'Hele programmet vil ta omtrent 60 minutter.\n\n\n\n';
	Line_3 = 'Det er viktig å til enhver tid sitte i ro og holde blikket festet på den røde prikken.\n\n';
	Line_4 = 'Du skal trykke på "pil ned"-knappen når prikken skifter til grønn.\n\n\n\n';
	Line_5 = 'Det vil nå bli vist sjakkbrettmønstre på skjermen.\n\n\n\n';
	Line_6 = 'Trykk "pil ned"-knappen for å starte.';
	
	Text.Instructions.Intro = [Line_1 Line_2 Line_3 Line_4 Line_5 Line_6];
	
	% **********
	% Auditory training instructions
	Line_1 = 'Nå starter en treningsrunde med lyder.\n\n';
	Line_2 = 'Trykk på "pil ned"-knappen når prikken skifter til grønn.\n\n\n\n';
	Line_3 = 'Trykk for å begynne.';
	
	Text.Instructions.TrainingAuditory = [Line_1 Line_2 Line_3];
	
	% Visual training instructions
	Line_1 = 'Nå starter en treningsrunde med sjakkbrettmønstre.\n\n';
	Line_2 = 'Trykk på "pil ned"-knappen når prikken skifter til grønn.\n\n\n\n';
	Line_3 = 'Trykk for å begynne.';
	
	Text.Instructions.TrainingVisual = [Line_1 Line_2 Line_3];
	
	% End of training
	Line_1 = 'Nå er treningsrundene ferdige, og vi vil sette i gang med hoveddelen.\n\n';
	Line_2 = 'Har du forstått oppgaven?\n\n\n\n';
	Line_3 = 'Hvis nei, trykk "shift"-tasten på venstre side. Hvis ja, trykk responstasten.\n\n';
	
	Text.Instructions.AfterTraining = [Line_1 Line_2 Line_3];
	
	% Text for the slower subjects
	Line_1 = 'Vennligst vent på testleder, slik at vi kan gå over instruksjonene en gang til.';
	
	Text.Instructions.Repetition = Line_1;
	
	% Start of experiment
	Line_1 = 'Fint! Da setter vi i gang.\n\n\n\n';
	Line_2 = 'Lykke til! Trykk for å begynne.';
	
	Text.Instructions.Start = [Line_1 Line_2];
	
	% *********
	% Instructions before LDAEP
	Line_1 = 'Nå vil du få høre lyder med forskjellig volum i omtrent 10 minutter.\n\n';
	Line_2 = 'Sitt i ro med åpne øyne og blikket festet på den røde prikken.\n\n';
	Line_3 = 'Du skal ikke trykke på noen knapper i denne delen.\n\n\n\n';
	Line_4 = 'Trykk "pil ned"-knappen for å fortsette.';
	
	Text.Instructions.BeforeLDAEP = [Line_1 Line_2 Line_3 Line_4];
	
	% Instructions before late visual post
	Line_1 = 'Nå får du igjen se sjakkbrettmønstre på skjermen.\n\n';
	Line_2 = 'Hold blikket festet på den røde prikken, og trykk "pil ned"-knappen når den skifter til grønn.\n\n\n\n';
	Line_3 = 'Trykk "pil ned"-knappen for å fortsette.';
	
	Text.Instructions.LateVisual = [Line_1 Line_2 Line_3];
	
	% Instructions before second part of SRP
	Line_1 = 'Nå vil det bli spilt av enkle toner.\n\n';
	Line_2 = 'Du skal sitte i ro med lukkede øyne, og trykke "pil ned"-knappen når en avvikende tone spilles.\n\n\n\n';
	Line_3 = 'Trykk "pil ned"-knappen for å fortsette.';
	
	Text.Instructions.SecondSRP = [Line_1 Line_2 Line_3];
	
	% Instructions before resting EEG
	Line_1 = 'Nå skal du lukke øynene, og sitte i ro med lukkede øyne i omtrent 4 minutter.\n\n';
	Line_2 = 'Når du hører et tydelig lydsignal, skal du åpne øynene igjen, og sitte i ro med åpne øyne i 4 minutter til.\n\n\n\n';
	Line_3 = 'Du skal verken se mønstre, høre lyder eller trykke på noen knapper i denne delen.\n\n\n\n';
	Line_4 = 'Trykk "pil ned"-knappen for å fortsette.';
	
	Text.Instructions.BeforeEEG = [Line_1 Line_2 Line_3 Line_4];
	
	% Instructions before late auditory post
	Line_1 = 'Nå vil det igjen bli spilt av enkle toner.\n\n';
	Line_2 = 'Du skal sitte i ro med lukkede øyne, og trykke "pil ned"-knappen når en avvikende tone spilles.\n\n\n\n';
	Line_3 = 'Trykk "pil ned"-knappen for å fortsette.';
	
	Text.Instructions.LateAuditory = [Line_1 Line_2 Line_3];
	
	% Outro
	Line_1 = 'Tusen takk for din deltakelse!\n\n';
	Line_2 = 'Sitt i ro, så vil vi demontere utstyret.\n\n\n\n';
	Line_3 = 'Trykk for å avslutte.';
	
	Text.Outro = [Line_1 Line_2 Line_3];
	
	%% Preparations 
	
	% General audio settings
	SampleRate = 48000;
	Channels = 2;
	
	% Screen properties
	Xcm = 52.8;
	Ycm = 29.6;
	ViewDistance = 90;
	
	% Configure on-screen window
	ScreenID = max(Screen('Screens'));
	[MainWindow, MainRect] = Screen('OpenWindow', ScreenID, 127.5);
	Priority(2); HideCursor; GetSecs;
	
	scrXvd = (atand((Xcm / 2) / ViewDistance)) * 2;
	scrYvd = (atand((Ycm / 2) / ViewDistance)) * 2;
	scrResXpx = MainRect(3);
	[x0, y0] = RectCenter(MainRect);
	vd2px = scrResXpx / scrXvd;
	fpSpx = round(0.2 * vd2px);
	Contrast = SRP.Visual.Stimulus.Contrast / 2;
	ContrastTarget = SRP.Visual.Target.Contrast / 2;
	
	% Adjust visual tetanus according to screen refresh rate
	IFI = Screen('GetFlipInterval', MainWindow);
	SRP.IFI = IFI;
	
	SRP.Visual.Tetanus.Frequency = 1 / (IFI * 7);
	SRP.Visual.Tetanus.SOA = 1 / SRP.Visual.Tetanus.Frequency;
	SRP.Visual.Tetanus.Trials = round(SRP.Visual.Tetanus.Duration * SRP.Visual.Tetanus.Frequency);
	
	SRP.NonStimulus.SOA = 60 * IFI;
	
	SRP.Auditory.Tetanus.SOA = 0.075;
	SRP.Auditory.Tetanus.Frequency = 1 / SRP.Auditory.Tetanus.SOA;
	SRP.Auditory.Tetanus.Trials = round(SRP.Auditory.Tetanus.Duration * SRP.Auditory.Tetanus.Frequency);
	
	% Configure audio driver and create auditory stimuli
	InitializePsychSound(0);
	PsychPortAudio('Close');
	
	AudioHandle = PsychPortAudio('Open', [], [], 3, SampleRate, Channels, [], [], [], 4);
	PsychPortAudio('Volume', AudioHandle, 1.0);
	
	SRP_Stimulus = CreateTone(SRP.Auditory.Stimulus.Duration, SRP.Auditory.Stimulus.Frequency);
	SRP_Target = CreateTone(SRP.Auditory.Target.Duration, SRP.Auditory.Target.Frequency);
	SRP_OnsetCue = CreateTone(SRP.Onset.Tone.Duration, SRP.Onset.Tone.Frequency);
	
	LDAEP_Stimulus = CreateTone(LDAEP.Stimulus.Duration, LDAEP.Stimulus.Frequency);
	
	RestEEG_Signal = CreateTone(RestEEG.Signal.Duration, RestEEG.Signal.Frequency);
	
	Buffer_SRP_Stimulus = PsychPortAudio('CreateBuffer', AudioHandle, [SRP_Stimulus; SRP_Stimulus]);
	Buffer_SRP_Target = PsychPortAudio('CreateBuffer', AudioHandle, [SRP_Target; SRP_Target]);
	Buffer_SRP_OnsetCue = PsychPortAudio('CreateBuffer', AudioHandle, [SRP_OnsetCue; SRP_OnsetCue]);
	
	Buffer_LDAEP_Stimulus = PsychPortAudio('CreateBuffer', AudioHandle, [LDAEP_Stimulus; LDAEP_Stimulus]);
	
	Buffer_RestEEG_Signal = PsychPortAudio('CreateBuffer', AudioHandle, [RestEEG_Signal; RestEEG_Signal]);
	
	% Create visual stimuli
	nChecksX = ceil(scrXvd / SRP.Visual.Stimulus.SpatialFrequency);
	nChecksY = ceil(scrYvd / SRP.Visual.Stimulus.SpatialFrequency);
	Checkpx = ceil(scrResXpx / nChecksX / 2);
	Check = checkerboard(Checkpx, nChecksY, nChecksX);
	Check(Check > 0) = (255 / 2) + (255 * Contrast);
	Check(Check == 0) = (255 / 2) - (255 * Contrast);
	CheckerboardTexture(1) = Screen('MakeTexture', MainWindow, Check);
	CheckerboardTexture(2) = Screen('MakeTexture', MainWindow, fliplr(Check));
	Phase = 0;
	
	Check(Check > 0) = (255 / 2) + (255 * ContrastTarget);
	Check(Check == 0) = (255 / 2) - (255 * ContrastTarget);
	CheckerboardTargetTexture(1) = Screen('MakeTexture', MainWindow, Check);
	CheckerboardTargetTexture(2) = Screen('MakeTexture', MainWindow, fliplr(Check));
	
	FixPointPos = round([x0 - fpSpx / 2, y0 - fpSpx / 2, x0 + fpSpx / 2, y0 + fpSpx / 2]);
	FixPointCol = [255, 0, 0];
	FixPointTargCol = [0, 127.5, 0];
	
	% Response configuration
	KbQueueCreate();
	if IsWin == 0
		ReKey = 117; EsKey = 10; SkKey = 63; PaKey = 38;
	else
		ReKey = 40; EsKey = 27; SkKey = 112; PaKey = 115;
	end
	ResponseKey = ReKey;		% Windows: 40		% Ubuntu: 117
	EscapeKey = EsKey;			% Windows: 27		% Ubuntu: 10
	SkipKey = SkKey;			% Windows: 161		% Ubuntu: 63
	PauseKey = PaKey;			% Windows: 162		% Ubuntu: 38
	
	% Create logs
	Subject.Logs.BlockDuration = {};
	Subject.Logs.TrialDuration.Baseline = {};
	Subject.Logs.TrialDuration.Tetanus = {};
	Subject.Logs.TrialDuration.Post = {};
	Subject.Logs.Responses = {};
	
	% SRP - first part blocklist
	SRP.Blocklists.First = ...
		[60	0	0	0	0	0		% 60 sec
		2	2	1	2	41	40	 % Visual baseline 1
		60	0	0	0	0	0		% 60 sec
		2	2	3	4	41	40	 % Visual baseline 2
		60	0	0	0	0	0		% 60 sec
		3	2	0	0	0	0	 % Visual tetanus
		120	0	0	0	0	0		% 120 sec
		4	2	5	6	42	40	 % Visual post 1
		60	0	0	0	0	0		% 60 sec
		4	2	7	8	42	40	 % Visual post 2
		120	0	0	0	0	0		% 120 sec
		4	2	9	10	42	40	 % Visual post 3
		60	0	0	0	0	0		% 60 sec
		4	2	11	12	42	40]; % Visual post 4
	
	SRP.Blocklists.FirstLate = ...
		[4	2	13	14	43	40];	 % Visual post 5
	
	% SRP - second part blocklist
	SRP.Blocklists.Second = ...
		[60	0	0	0	0	0		% 60 sec
		2	1	15	16	44	40	 % Auditory baseline 1
		60	0	0	0	0	0		% 60 sec
		2	1	17	18	44	40	 % Auditory baseline 2
		60	0	0	0	0	0		% 60 sec
		3	1	0	0	0	0	 % Auditory tetanus
		120	0	0	0	0	0		% 120 sec
		4	1	19	20	45	40	 % Auditory post 1
		60	0	0	0	0	0		% 60 sec
		4	1	21	22	45	40	 % Auditory post 2
		120	0	0	0	0	0		% 120 sec
		4	1	23	24	45	40	 % Auditory post 3
		60	0	0	0	0	0		% 60 sec
		4	1	25	26	45	40]; % Auditory post 4
	
	SRP.Blocklists.SecondLate = ...
		[4	1	27	28	46	40	 % Auditory post 5
		60	0	0	0	0	0];		% 60 sec
	
	% 1st column:	0 = non-stimulus short | 1 = non-stimulus long | ...
	%				2 = baseline | 3 = tetanus | 4 = post
	% 2nd column:	0 = none | 1 = auditory | 2 = visual
	% 3rd column:	Trigger code first block half
	% 4th column:	Trigger code second block half
	% 5th column:	Trigger code target onset
	% 6th column:	Trigger code target response
	
	%% SRP - Intro and (optional) training 
	
	% Set volume for auditive SRP stimulus (70 dB)
	PsychPortAudio('Volume', AudioHandle, 0.0616);
	
	% Instructions before start
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, Text.Instructions.Intro, 'center', 'center', 255);
	Screen('Flip', MainWindow); [~, Call] = KbStrokeWait;
	if TriggersEnabled == true
		outp(Address, 254); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
	end
	if Call(EscapeKey) > 0, error('Escape key pressed. Experiment terminated.'); end
	KbQueueFlush(); Screen('Flip', MainWindow); WaitSecs(1);
		
	if TrainingEnabled == true
		%% Auditory training
		
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, Text.Instructions.TrainingAuditory, 'center', 'center', 255);
		Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
		Screen('Flip', MainWindow); WaitSecs(1);
		
		SOA = SRP.Auditory.Training.SOA;
		Trials = SRP.Auditory.Training.Trials;
		ResponseCollected = false;
		Response = false; %#ok<*NASGU>
		TrainingResponses = 0;
		TrainingRT = 0;
		
		Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
		Screen('DrawingFinished', MainWindow);
		Screen('Flip', MainWindow);
		
		for t = 1:Trials
			if t == 4 || t == 8
				PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Target);
				Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
			else
				PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
				Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
			end
			TrialSOA = (randi(SOA, 1, 1)) / 1000;
			Screen('DrawingFinished', MainWindow);
			PsychPortAudio('Start', AudioHandle);
			Onset = Screen('Flip', MainWindow); KbQueueStart();
			while GetSecs - Onset < TrialSOA - IFI
				if t == 4 || t == 8
					if ResponseCollected == false
						[Response, RTime] = KbQueueCheck;
						if Response == true
							RT = round(RTime(ResponseKey) - Onset, 2);
							ResponseCollected = true;
						end
					end
				end
			end
			if t == 4 && ResponseCollected == true || t == 8 && ResponseCollected == true
				TrainingResponses = TrainingResponses + 1;
				TrainingRT = TrainingRT + RT;
			end
			ResponseCollected = false; KbQueueFlush();
		end
		
		TrainingRTavg = TrainingRT / 2;
		
		switch TrainingResponses
			case 2
				Feedback = [['Du gjennomførte oppgaven riktig.\n\n'] ['Gjennomsnittsresponstid var: ' ...
					num2str(TrainingRTavg) ' sekunder']];
			case 1
				Feedback = [['Respons registrert på 1 av 2 skifter.\n\n'] ...
					['Husk å trykke når prikken skifter til grønn.']];
			case 0
				Feedback = [['Ingen respons registrert.\n\n'] ...
					['Husk å trykke når prikken skifter til grønn.']];
		end
		
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, Feedback, 'center', 'center', 255);
		Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
		Screen('Flip', MainWindow); WaitSecs(1);
		
		%% Visual training
		
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, Text.Instructions.TrainingVisual, 'center', 'center', 255);
		Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
		Screen('Flip', MainWindow); WaitSecs(1);
		
		SOA = SRP.Visual.Training.SOA;
		Trials = SRP.Visual.Training.Trials;
		ResponseCollected = false;
		Response = false;
		TrainingResponses = 0;
		TrainingRT = 0;
		
		Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
		Screen('DrawingFinished', MainWindow);
		Screen('Flip', MainWindow);
		
		for t = 1:Trials
			Phase = Phase + 1;
			if Phase == 3, Phase = 1; end
			if t == 4 || t == 8
				Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
				Screen('FillOval', MainWindow, FixPointTargCol, FixPointPos);
			else
				Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
				Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
			end
			TrialSOA = (randi(SOA, 1, 1)) / 1000;
			Screen('DrawingFinished', MainWindow);
			Onset = Screen('Flip', MainWindow); KbQueueStart();
			while GetSecs - Onset < TrialSOA - IFI
				if t == 4 || t == 8
					if ResponseCollected == false
						[Response, RTime] = KbQueueCheck;
						if Response == true
							RT = round(RTime(ResponseKey) - Onset - IFI, 2);
							ResponseCollected = true;
						end
					end
				end
			end
			if t == 4 && ResponseCollected == true || t == 8 && ResponseCollected == true
				TrainingResponses = TrainingResponses + 1;
				TrainingRT = TrainingRT + RT;
			end
			ResponseCollected = false; KbQueueFlush();
		end
		TrainingRTavg = TrainingRT / 2;
		switch TrainingResponses
			case 2
				Feedback = [['Du gjennomførte oppgaven riktig.\n\n'] ...
					['Gjennomsnittsresponstid var: ' ...
					num2str(TrainingRTavg) ' sekunder']]; %#ok<*NBRAK>
			case 1
				Feedback = [['Respons registrert på 1 av 2 skifter.\n\n'] ...
					['Husk å trykke når prikken skifter til grønn.']];
			case 0
				Feedback = [['Ingen respons registrert.\n\n'] ...
					['Husk å trykke når prikken skifter til grønn.']];
		end
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, Feedback, 'center', 'center', 255);
		Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
		Screen('Flip', MainWindow); WaitSecs(1);
		
		% Display after training text
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, Text.Instructions.AfterTraining, 'center', 'center', 255);
		Screen('Flip', MainWindow); [~, InstructionsKey] = KbStrokeWait;
		Screen('Flip', MainWindow); WaitSecs(1);
		
		InstructionsKey = find(InstructionsKey);
		if IsWin == 0
			InsKey = 51;
		else
			InsKey = 160;
		end
		if InstructionsKey == InsKey		% Windows: 160		Ubuntu: 51
			Screen('TextSize', MainWindow, 28);
			Screen('TextFont', MainWindow, 'Arial');
			DrawFormattedText(MainWindow, Text.Instructions.Repetition, 'center', 'center', 255);
			Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
			Screen('Flip', MainWindow); WaitSecs(1);
		else
			Screen('TextSize', MainWindow, 28);
			Screen('TextFont', MainWindow, 'Arial');
			DrawFormattedText(MainWindow, Text.Instructions.Start, 'center', 'center', 255);
			Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
			Screen('Flip', MainWindow); WaitSecs(1);
		end
		
	end
	
	%% SRP - First part 
	
	% Create global counters
	Ct_SRP_Blocks_Total = 0;
	Ct_SRP_Trials_Total = 0;
	Ct_SRP_Targets_Total = 0;
	
	% Create global debug counters
	Debug_Ct_SRP_Tr_BL = 0;
	Debug_Ct_SRP_Tr_T = 0;
	Debug_Ct_SRP_Tr_P = 0;
	
	% Set volume for auditive SRP stimulus (70 dB)
	PsychPortAudio('Volume', AudioHandle, 0.0616);
	
	SkipBlock = false;
	
	for i = 1:size(SRP.Blocklists.First)
		
		Ct_SRP_Blocks_Total = Ct_SRP_Blocks_Total + 1;
		
		% Identify upcoming block
		if SRP.Blocklists.First(i, 2) == 0, BlockModality = 0;
			if SRP.Blocklists.First(i, 1) == 60, BlockType = 0; Block_String = 'Non-stimulus 60 secs';
			elseif SRP.Blocklists.First(i, 1) == 120, BlockType = 0; Block_String = 'Non-stimulus 120 secs';
			elseif SRP.Blocklists.First(i, 1) == 47, BlockType = 0; Block_String = 'Non-stimulus 47 secs';
			elseif SRP.Blocklists.First(i, 1) == 55, BlockType = 0; Block_String = 'Non-stimulus 55 secs';
			elseif SRP.Blocklists.First(i, 1) == 77, BlockType = 0; Block_String = 'Non-stimulus 77 secs';
			elseif SRP.Blocklists.First(i, 1) == 90, BlockType = 1; Block_String = 'Non-stimulus 90 secs';
			end
		elseif SRP.Blocklists.First(i, 2) == 1, BlockModality = 1;
			if SRP.Blocklists.First(i, 1) == 2, BlockType = 2; Block_String = 'Auditory baseline';
			elseif SRP.Blocklists.First(i, 1) == 3, BlockType = 3; Block_String = 'Auditory tetanus';
			elseif SRP.Blocklists.First(i, 1) == 4, BlockType = 4; Block_String = 'Auditory post';
			end
		elseif SRP.Blocklists.First(i, 2) == 2, BlockModality = 2;
			if SRP.Blocklists.First(i, 1) == 2, BlockType = 2; Block_String = 'Visual baseline';
			elseif SRP.Blocklists.First(i, 1) == 3, BlockType = 3; Block_String = 'Visual tetanus';
			elseif SRP.Blocklists.First(i, 1) == 4, BlockType = 4; Block_String = 'Visual post';
			end
		end
		
		switch BlockModality
			
			case 0			% Non-stimulus blocks
				switch SRP.Blocklists.First(i, 1)
					case 60
						Duration = SRP.NonStimulus.Duration_60;
					case 120
						Duration = SRP.NonStimulus.Duration_120;
					case 47
						Duration = SRP.NonStimulus.Duration_47;
					case 55
						Duration = SRP.NonStimulus.Duration_55;
					case 77
						Duration = SRP.NonStimulus.Duration_77;
					case 90
						Duration = SRP.NonStimulus.Duration_90;
				end
						
				if SRP.Onset.Enable == true
					CuePlayed = false;
					PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_OnsetCue);
				end
				
				Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
				Screen('DrawingFinished', MainWindow);
				BlockOnset = Screen('Flip', MainWindow); KbQueueStart();
				
				while GetSecs - BlockOnset < Duration
					[Response, Call] = KbQueueCheck;
					if SRP.Onset.Enable == true
						if GetSecs - BlockOnset > Duration - SRP.Onset.TimeBefore && CuePlayed == false
							PsychPortAudio('Start', AudioHandle);
							CuePlayed = true;
						end
					end
					if Response == true
						if Call(EscapeKey) > 0
							error('Escape key pressed. Experiment terminated.');
						elseif Call(SkipKey) > 0
							SkipBlock = true; break
						elseif Call(PauseKey) > 0
							if TriggersEnabled == true
								outp(Address, TriggerBoundaryStart); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, 255); WaitSecs(0.001);
								outp(Address, 0);
							end
							ExtPause = true; KbQueueFlush(); Response = false;
							Screen('TextSize', MainWindow, 28);
							Screen('TextFont', MainWindow, 'Arial');
							DrawFormattedText(MainWindow, ...
								'Paused. Press pause key again to continue.', 'center', 'center', 255);
							ExtPauseStart = Screen('Flip', MainWindow);
							while ExtPause == true
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(PauseKey) > 0
										ExtPause = false;
									else
										Response = false;
									end
								end
							end
							Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							Screen('DrawingFinished', MainWindow);
							ExtPauseEnd = Screen('Flip', MainWindow); KbQueueFlush();
							Duration = Duration + (ExtPauseEnd - ExtPauseStart);
							if TriggersEnabled == true
								outp(Address, 254); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, TriggerBoundaryEnd); WaitSecs(0.001);
								outp(Address, 0);
							end
						else
							Response = false;
						end
					end
				end
				KbQueueFlush(); Response = false;
				
			case 1			% Auditory blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						
						ResponseCollected = false;
						Response = false;
						
						Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Targets = SRP.Auditory.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Auditory.Baseline.Trials;
								SOA = SRP.Auditory.Baseline.SOA;
							case 4
								Trials = SRP.Auditory.Post.Trials;
								SOA = SRP.Auditory.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Target);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							else
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							end
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.First(i, 5);
								TriggerResponse = SRP.Blocklists.First(i, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.First(i, 3);
							else
								Trigger = SRP.Blocklists.First(i, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Screen('DrawingFinished', MainWindow);
							PsychPortAudio('Start', AudioHandle);
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI / 2
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Trials = SRP.Auditory.Tetanus.Trials;
						SOA = SRP.Auditory.Tetanus.SOA;
						
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							PsychPortAudio('Start', AudioHandle);
							Onset = GetSecs; KbQueueStart();
							while GetSecs - Onset < SOA
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
			case 2			% Visual blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						ResponseCollected = false;
						Response = false;
						
						Targets = SRP.Visual.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Visual.Baseline.Trials;
								SOA = SRP.Visual.Baseline.SOA;
								
							case 4
								Trials = SRP.Visual.Post.Trials;
								SOA = SRP.Visual.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							AdjustToIFI = randi([1 2]);
							if AdjustToIFI == 1
								TrialSOA = floor(TrialSOA / IFI) * IFI;
							elseif AdjustToIFI == 2
								TrialSOA = ceil(TrialSOA / IFI) * IFI;
							end
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointTargCol, FixPointPos);
							else
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							end
							Screen('DrawingFinished', MainWindow);
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.First(i, 5);
								TriggerResponse = SRP.Blocklists.First(i, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.First(i, 3);
							else
								Trigger = SRP.Blocklists.First(i, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
									
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Trials = SRP.Visual.Tetanus.Trials;
						SOA = SRP.Visual.Tetanus.SOA;
						
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
							Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							Screen('DrawingFinished', MainWindow);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < SOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
		end
		
		% Save block details to log
		BlockDuration = GetSecs - BlockOnset;
		Subject.Logs.BlockDuration{i, 1} = Block_String;
		Subject.Logs.BlockDuration{i, 2} = BlockDuration;
		
		if SkipBlock == true
			Screen('TextSize', MainWindow, 28);
			Screen('TextFont', MainWindow, 'Arial');
			DrawFormattedText(MainWindow, ['Block skipped.'], 'center', 'center', 255);
			Screen('Flip', MainWindow); WaitSecs(1);
			Screen('Flip', MainWindow); WaitSecs(1);
			KbQueueFlush();
			SkipBlock = false;
		end
		
	end
	
	%% LDAEP 
	
	Screen('Flip', MainWindow); WaitSecs(1);
	i = i + 1;
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, Text.Instructions.BeforeLDAEP, 'center', 'center', 255);
	Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
	Screen('Flip', MainWindow); WaitSecs(1);
	
	Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
	Screen('DrawingFinished', MainWindow);
	Screen('Flip', MainWindow);
	
	SOA = LDAEP.Trials.SOA;
	Limit = LDAEP.Trials.Each;
	
	Volume_1 = LDAEP.Stimulus.Volume_1;
	Volume_2 = LDAEP.Stimulus.Volume_2;
	Volume_3 = LDAEP.Stimulus.Volume_3;
	Volume_4 = LDAEP.Stimulus.Volume_4;
	Volume_5 = LDAEP.Stimulus.Volume_5;
	
	Count_Total = 0;
	Count_1 = 0; Count_2 = 0; Count_3 = 0; Count_4 = 0; Count_5 = 0;
	
	LDAEP_Sequence = LDAEP_Array(5, LDAEP.Trials.Each);
	
	for l = 1:length(LDAEP_Sequence)
		
		Count_Total = Count_Total + 1;
		
		TrialSOA = (randi(SOA, 1, 1)) / 1000;
		AdjustToIFI = randi([1 2]);
		if AdjustToIFI == 1
			TrialSOA = floor(TrialSOA / IFI) * IFI;
		end
		if AdjustToIFI == 2
			TrialSOA = ceil(TrialSOA / IFI) * IFI;
		end
		
		Next = LDAEP_Sequence(l);
		
		switch Next
			case 1
				Volume = Volume_1;
				Count_1 = Count_1 + 1;
				Trigger = LDAEP.Triggers.Code_1;
			case 2
				Volume = Volume_2;
				Count_2 = Count_2 + 1;
				Trigger = LDAEP.Triggers.Code_2;
			case 3
				Volume = Volume_3;
				Count_3 = Count_3 + 1;
				Trigger = LDAEP.Triggers.Code_3;
			case 4
				Volume = Volume_4;
				Count_4 = Count_4 + 1;
				Trigger = LDAEP.Triggers.Code_4;
			case 5
				Volume = Volume_5;
				Count_5 = Count_5 + 1;
				Trigger = LDAEP.Triggers.Code_5;
		end
		
		if TriggersEnabled == true
			outp(Address, Trigger); WaitSecs(0.001);
			outp(Address, 0);
		end
		
		PsychPortAudio('Volume', AudioHandle, Volume);
		
		PsychPortAudio('FillBuffer', AudioHandle, Buffer_LDAEP_Stimulus);
		PsychPortAudio('Start', AudioHandle);
		
		Onset = GetSecs;
		while GetSecs - Onset < TrialSOA
			[Response, Call] = KbQueueCheck;
			if Response == true
				if Call(EscapeKey) > 0
					error('Escape key pressed. Experiment terminated.');
				elseif Call(SkipKey) > 0
					SkipBlock = true;
				else
					Response = false;
				end
			end
		end
		KbQueueFlush();
		if Count_Total == 1
			LDAEP_Onset = Onset;
		end
		if SkipBlock == true
			break
		end
	end
	
	LDAEP.Trials.Played.Level_1 = Count_1;
	LDAEP.Trials.Played.Level_2 = Count_2;
	LDAEP.Trials.Played.Level_3 = Count_3;
	LDAEP.Trials.Played.Level_4 = Count_4;
	LDAEP.Trials.Played.Level_5 = Count_5; %#ok<*STRNU>
	
	% Save block details to log
	BlockDuration = GetSecs - LDAEP_Onset;
	Subject.Logs.BlockDuration{i, 1} = 'LDAEP';
	Subject.Logs.BlockDuration{i, 2} = BlockDuration;
	
	PsychPortAudio('Volume', AudioHandle, 0.25);
	
	if SkipBlock == true
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, ['Block skipped.'], 'center', 'center', 255);
		Screen('Flip', MainWindow); WaitSecs(1);
		Screen('Flip', MainWindow); WaitSecs(1);
		KbQueueFlush();
		SkipBlock = false;
	end
	
	%% SRP - late post visual 
	
	Screen('Flip', MainWindow); WaitSecs(1);
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, Text.Instructions.LateVisual, 'center', 'center', 255);
	Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
	Screen('Flip', MainWindow); WaitSecs(1);
	
	% Set volume for auditive SRP stimulus (70 dB)
	PsychPortAudio('Volume', AudioHandle, 0.0616);
	
	for k = 1:size(SRP.Blocklists.FirstLate)
		
		i = i + 1;
		Ct_SRP_Blocks_Total = Ct_SRP_Blocks_Total + 1;
		
		% Identify upcoming block
		if SRP.Blocklists.FirstLate(k, 2) == 0, BlockModality = 0;
			if SRP.Blocklists.FirstLate(k, 1) == 60, BlockType = 0; Block_String = 'Non-stimulus 60 secs';
			elseif SRP.Blocklists.FirstLate(k, 1) == 120, BlockType = 0; Block_String = 'Non-stimulus 120 secs';
			elseif SRP.Blocklists.FirstLate(k, 1) == 47, BlockType = 0; Block_String = 'Non-stimulus 47 secs';
			elseif SRP.Blocklists.FirstLate(k, 1) == 55, BlockType = 0; Block_String = 'Non-stimulus 55 secs';
			elseif SRP.Blocklists.FirstLate(k, 1) == 77, BlockType = 0; Block_String = 'Non-stimulus 77 secs';
			elseif SRP.Blocklists.FirstLate(k, 1) == 90, BlockType = 1; Block_String = 'Non-stimulus 90 secs';
			end
		elseif SRP.Blocklists.FirstLate(k, 2) == 1, BlockModality = 1;
			if SRP.Blocklists.FirstLate(k, 1) == 2, BlockType = 2; Block_String = 'Auditory baseline';
			elseif SRP.Blocklists.FirstLate(k, 1) == 3, BlockType = 3; Block_String = 'Auditory tetanus';
			elseif SRP.Blocklists.FirstLate(k, 1) == 4, BlockType = 4; Block_String = 'Auditory post';
			end
		elseif SRP.Blocklists.FirstLate(k, 2) == 2, BlockModality = 2;
			if SRP.Blocklists.FirstLate(k, 1) == 2, BlockType = 2; Block_String = 'Visual baseline';
			elseif SRP.Blocklists.FirstLate(k, 1) == 3, BlockType = 3; Block_String = 'Visual tetanus';
			elseif SRP.Blocklists.FirstLate(k, 1) == 4, BlockType = 4; Block_String = 'Visual post';
			end
		end
		
		switch BlockModality
			
			case 0			% Non-stimulus blocks
				switch SRP.Blocklists.FirstLate(k, 1)
					case 60
						Duration = SRP.NonStimulus.Duration_60;
					case 120
						Duration = SRP.NonStimulus.Duration_120;
					case 47
						Duration = SRP.NonStimulus.Duration_47;
					case 55
						Duration = SRP.NonStimulus.Duration_55;
					case 77
						Duration = SRP.NonStimulus.Duration_77;
					case 90
						Duration = SRP.NonStimulus.Duration_90;
				end
				
				if SRP.Onset.Enable == true
					CuePlayed = false;
					PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_OnsetCue);
				end
				
				Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
				Screen('DrawingFinished', MainWindow);
				BlockOnset = Screen('Flip', MainWindow); KbQueueStart();
				
				while GetSecs - BlockOnset < Duration
					[Response, Call] = KbQueueCheck;
					if SRP.Onset.Enable == true
						if GetSecs - BlockOnset > Duration - SRP.Onset.TimeBefore && CuePlayed == false
							PsychPortAudio('Start', AudioHandle);
							CuePlayed = true;
						end
					end
					if Response == true
						if Call(EscapeKey) > 0
							error('Escape key pressed. Experiment terminated.');
						elseif Call(SkipKey) > 0
							SkipBlock = true; break
						elseif Call(PauseKey) > 0
							if TriggersEnabled == true
								outp(Address, TriggerBoundaryStart); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, 255); WaitSecs(0.001);
								outp(Address, 0);
							end
							ExtPause = true; KbQueueFlush(); Response = false;
							Screen('TextSize', MainWindow, 28);
							Screen('TextFont', MainWindow, 'Arial');
							DrawFormattedText(MainWindow, ...
								'Paused. Press pause key again to continue.', 'center', 'center', 255);
							ExtPauseStart = Screen('Flip', MainWindow);
							while ExtPause == true
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(PauseKey) > 0
										ExtPause = false;
									else
										Response = false;
									end
								end
							end
							Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							Screen('DrawingFinished', MainWindow);
							ExtPauseEnd = Screen('Flip', MainWindow); KbQueueFlush();
							Duration = Duration + (ExtPauseEnd - ExtPauseStart);
							if TriggersEnabled == true
								outp(Address, 254); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, TriggerBoundaryEnd); WaitSecs(0.001);
								outp(Address, 0);
							end
						else
							Response = false;
						end
					end
				end
				KbQueueFlush(); Response = false;
				
			case 1			% Auditory blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						ResponseCollected = false;
						Response = false;
						
						Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Targets = SRP.Auditory.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Auditory.Baseline.Trials;
								SOA = SRP.Auditory.Baseline.SOA;
								
							case 4
								Trials = SRP.Auditory.Post.Trials;
								SOA = SRP.Auditory.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Target);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							else
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							end
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.FirstLate(k, 5);
								TriggerResponse = SRP.Blocklists.FirstLate(k, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.FirstLate(k, 3);
							else
								Trigger = SRP.Blocklists.FirstLate(k, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
									
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Screen('DrawingFinished', MainWindow);
							PsychPortAudio('Start', AudioHandle);
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI / 2
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Trials = SRP.Auditory.Tetanus.Trials;
						SOA = SRP.Auditory.Tetanus.SOA;
						
						BlockOnset = GetSecs;
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							PsychPortAudio('Start', AudioHandle);
							Onset = GetSecs; KbQueueStart();
							while GetSecs - Onset < SOA
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
			case 2			% Visual blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						ResponseCollected = false;
						Response = false;
						
						Targets = SRP.Visual.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Visual.Baseline.Trials;
								SOA = SRP.Visual.Baseline.SOA;
								
							case 4
								Trials = SRP.Visual.Post.Trials;
								SOA = SRP.Visual.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							AdjustToIFI = randi([1 2]);
							if AdjustToIFI == 1
								TrialSOA = floor(TrialSOA / IFI) * IFI;
							end
							if AdjustToIFI == 2
								TrialSOA = ceil(TrialSOA / IFI) * IFI;
							end
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointTargCol, FixPointPos);
							else
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							end
							Screen('DrawingFinished', MainWindow);
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.FirstLate(k, 5);
								TriggerResponse = SRP.Blocklists.FirstLate(k, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.FirstLate(k, 3);
							else
								Trigger = SRP.Blocklists.FirstLate(k, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
									
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Trials = SRP.Visual.Tetanus.Trials;
						SOA = SRP.Visual.Tetanus.SOA;
						
						BlockOnset = GetSecs;
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
							Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							Screen('DrawingFinished', MainWindow);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < SOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
		end
		
		% Save block details to log
		BlockDuration = GetSecs - BlockOnset;
		Subject.Logs.BlockDuration{i, 1} = Block_String;
		Subject.Logs.BlockDuration{i, 2} = BlockDuration;
		
		if SkipBlock == true
			Screen('TextSize', MainWindow, 28);
			Screen('TextFont', MainWindow, 'Arial');
			DrawFormattedText(MainWindow, ['Block skipped.'], 'center', 'center', 255);
			Screen('Flip', MainWindow); WaitSecs(1);
			Screen('Flip', MainWindow); WaitSecs(1);
			KbQueueFlush();
			SkipBlock = false;
		end
	end
	
	%% SRP - Second part 
	
	if TriggersEnabled == true
		outp(Address, TriggerBoundaryStart); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
		
		WaitSecs(2);
		
		outp(Address, 255); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
	end
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, 'Vennligst vent...', 'center', 'center', 255);
	cont = false;
	Screen('Flip', MainWindow);
	while cont == false
		[~, code] = KbStrokeWait; KbQueueFlush();
		if code(PauseKey) > 0
			cont = true;
		else
			cont = false;
		end
	end
	Screen('Flip', MainWindow); WaitSecs(1);
	
	Screen('Flip', MainWindow); WaitSecs(1);
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, Text.Instructions.SecondSRP, 'center', 'center', 255);
	Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
	if TriggersEnabled == true
		outp(Address, 254); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
		
		WaitSecs(2);
		
		outp(Address, TriggerBoundaryEnd); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
		
		WaitSecs(2);
	end
	Screen('Flip', MainWindow); WaitSecs(1);
	
	% Set volume for auditive SRP stimulus (70 dB)
	PsychPortAudio('Volume', AudioHandle, 0.0616);
	
	for j = 1:size(SRP.Blocklists.Second)
		
		i = i + 1;
		Ct_SRP_Blocks_Total = Ct_SRP_Blocks_Total + 1;
		
		% Identify upcoming block
		if SRP.Blocklists.Second(j, 2) == 0, BlockModality = 0;
			if SRP.Blocklists.Second(j, 1) == 60, BlockType = 0; Block_String = 'Non-stimulus 60 secs';
			elseif SRP.Blocklists.Second(j, 1) == 120, BlockType = 0; Block_String = 'Non-stimulus 120 secs';
			elseif SRP.Blocklists.Second(j, 1) == 47, BlockType = 0; Block_String = 'Non-stimulus 47 secs';
			elseif SRP.Blocklists.Second(j, 1) == 55, BlockType = 0; Block_String = 'Non-stimulus 55 secs';
			elseif SRP.Blocklists.Second(j, 1) == 77, BlockType = 0; Block_String = 'Non-stimulus 77 secs';
			elseif SRP.Blocklists.Second(j, 1) == 90, BlockType = 1; Block_String = 'Non-stimulus 90 secs';
			end
		elseif SRP.Blocklists.Second(j, 2) == 1, BlockModality = 1;
			if SRP.Blocklists.Second(j, 1) == 2, BlockType = 2; Block_String = 'Auditory baseline';
			elseif SRP.Blocklists.Second(j, 1) == 3, BlockType = 3; Block_String = 'Auditory tetanus';
			elseif SRP.Blocklists.Second(j, 1) == 4, BlockType = 4; Block_String = 'Auditory post';
			end
		elseif SRP.Blocklists.Second(j, 2) == 2, BlockModality = 2;
			if SRP.Blocklists.Second(j, 1) == 2, BlockType = 2; Block_String = 'Visual baseline';
			elseif SRP.Blocklists.Second(j, 1) == 3, BlockType = 3; Block_String = 'Visual tetanus';
			elseif SRP.Blocklists.Second(j, 1) == 4, BlockType = 4; Block_String = 'Visual post';
			end
		end
		
		switch BlockModality
			
			case 0			% Non-stimulus blocks
				switch SRP.Blocklists.Second(j, 1)
					case 60
						Duration = SRP.NonStimulus.Duration_60;
					case 120
						Duration = SRP.NonStimulus.Duration_120;
					case 47
						Duration = SRP.NonStimulus.Duration_47;
					case 55
						Duration = SRP.NonStimulus.Duration_55;
					case 77
						Duration = SRP.NonStimulus.Duration_77;
					case 90
						Duration = SRP.NonStimulus.Duration_90;
				end
				
				if SRP.Onset.Enable == true
					CuePlayed = false;
					PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_OnsetCue);
				end
				
				Screen('TextSize', MainWindow, 28);
				Screen('TextFont', MainWindow, 'Arial');
				DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
				Screen('DrawingFinished', MainWindow);
				BlockOnset = Screen('Flip', MainWindow); KbQueueStart();
				
				while GetSecs - BlockOnset < Duration
					[Response, Call] = KbQueueCheck;
					if SRP.Onset.Enable == true
						if GetSecs - BlockOnset > Duration - SRP.Onset.TimeBefore && CuePlayed == false
							PsychPortAudio('Start', AudioHandle);
							CuePlayed = true;
						end
					end
					if Response == true
						if Call(EscapeKey) > 0
							error('Escape key pressed. Experiment terminated.');
						elseif Call(SkipKey) > 0
							SkipBlock = true; break
						elseif Call(PauseKey) > 0
							if TriggersEnabled == true
								outp(Address, TriggerBoundaryStart); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, 255); WaitSecs(0.001);
								outp(Address, 0);
							end
							ExtPause = true; KbQueueFlush(); Response = false;
							Screen('TextSize', MainWindow, 28);
							Screen('TextFont', MainWindow, 'Arial');
							DrawFormattedText(MainWindow, ...
								'Paused. Press pause key again to continue.', 'center', 'center', 255);
							ExtPauseStart = Screen('Flip', MainWindow);
							while ExtPause == true
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(PauseKey) > 0
										ExtPause = false;
									else
										Response = false;
									end
								end
							end
							Screen('TextSize', MainWindow, 28);
							Screen('TextFont', MainWindow, 'Arial');
							DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							Screen('DrawingFinished', MainWindow);
							ExtPauseEnd = Screen('Flip', MainWindow); KbQueueFlush();
							Duration = Duration + (ExtPauseEnd - ExtPauseStart);
							if TriggersEnabled == true
								outp(Address, 254); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, TriggerBoundaryEnd); WaitSecs(0.001);
								outp(Address, 0);
							end
						else
							Response = false;
						end
					end
				end
				KbQueueFlush(); Response = false;
				
			case 1			% Auditory blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						ResponseCollected = false;
						Response = false;
						
						Screen('TextSize', MainWindow, 28);
						Screen('TextFont', MainWindow, 'Arial');
						DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Targets = SRP.Auditory.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Auditory.Baseline.Trials;
								SOA = SRP.Auditory.Baseline.SOA;
								
							case 4
								Trials = SRP.Auditory.Post.Trials;
								SOA = SRP.Auditory.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Target);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							else
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							end
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.Second(j, 5);
								TriggerResponse = SRP.Blocklists.Second(j, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.Second(j, 3);
							else
								Trigger = SRP.Blocklists.Second(j, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
									
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Screen('DrawingFinished', MainWindow);
							PsychPortAudio('Start', AudioHandle);
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI / 2
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Screen('TextSize', MainWindow, 28);
						Screen('TextFont', MainWindow, 'Arial');
						DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Trials = SRP.Auditory.Tetanus.Trials;
						SOA = SRP.Auditory.Tetanus.SOA;
						
						BlockOnset = GetSecs;
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							PsychPortAudio('Start', AudioHandle);
							Onset = GetSecs; KbQueueStart();
							while GetSecs - Onset < SOA
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
			case 2			% Visual blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						ResponseCollected = false;
						Response = false;
						
						Targets = SRP.Visual.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Visual.Baseline.Trials;
								SOA = SRP.Visual.Baseline.SOA;
								
							case 4
								Trials = SRP.Visual.Post.Trials;
								SOA = SRP.Visual.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							AdjustToIFI = randi([1 2]);
							if AdjustToIFI == 1
								TrialSOA = floor(TrialSOA / IFI) * IFI;
							end
							if AdjustToIFI == 2
								TrialSOA = ceil(TrialSOA / IFI) * IFI;
							end
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointTargCol, FixPointPos);
							else
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							end
							Screen('DrawingFinished', MainWindow);
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.Second(j, 5);
								TriggerResponse = SRP.Blocklists.Second(j, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.Second(j, 3);
							else
								Trigger = SRP.Blocklists.Second(j, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
									
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Trials = SRP.Visual.Tetanus.Trials;
						SOA = SRP.Visual.Tetanus.SOA;
						
						BlockOnset = GetSecs;
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
							Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							Screen('DrawingFinished', MainWindow);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < SOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
		end
		
		% Save block details to log
		BlockDuration = GetSecs - BlockOnset;
		Subject.Logs.BlockDuration{i, 1} = Block_String;
		Subject.Logs.BlockDuration{i, 2} = BlockDuration;
		
		if SkipBlock == true
			Screen('TextSize', MainWindow, 28);
			Screen('TextFont', MainWindow, 'Arial');
			DrawFormattedText(MainWindow, ['Block skipped.'], 'center', 'center', 255);
			Screen('Flip', MainWindow); WaitSecs(1);
			Screen('Flip', MainWindow); WaitSecs(1);
			KbQueueFlush();
			SkipBlock = false;
		end
	end
	
	%% Rest EEG 
	
	if TriggersEnabled == true
		outp(Address, TriggerBoundaryStart); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
		
		WaitSecs(2);
		
		outp(Address, 255); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
	end
	
	Screen('Flip', MainWindow); WaitSecs(1);
	i = i + 1;
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, 'Vennligst vent...', 'center', 'center', 255);
	cont = false;
	Screen('Flip', MainWindow);
	while cont == false
		[~, code] = KbStrokeWait; KbQueueFlush();
		if code(PauseKey) > 0
			cont = true;
		else
			cont = false;
		end
	end
	Screen('Flip', MainWindow); WaitSecs(1);
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, Text.Instructions.BeforeEEG, 'center', 'center', 255);
	Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
	if TriggersEnabled == true
		outp(Address, 254); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
		
		WaitSecs(2);
		
		outp(Address, TriggerBoundaryEnd); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
		
		WaitSecs(2);
	end
	if TriggersEnabled == true
		outp(Address, RestEEG.TriggerClosedOnset); WaitSecs(0.001);
		outp(Address, 0);
	end
	RestEEG_Onset = Screen('Flip', MainWindow); WaitSecs(1);
	PsychPortAudio('FillBuffer', AudioHandle, Buffer_RestEEG_Signal);
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
	Screen('Flip', MainWindow);
	while GetSecs - RestEEG_Onset < RestEEG.Duration
		[Response, Call] = KbQueueCheck;
		if Response == true
			if Call(EscapeKey) > 0
				error('Escape key pressed. Experiment terminated.');
			elseif Call(SkipKey) > 0
				SkipBlock = true; break
			else
				Response = false;
			end
		end
	end
	
	if TriggersEnabled == true
		outp(Address, RestEEG.TriggerClosedOffset); WaitSecs(0.001);
		outp(Address, 0);
	end
	
	% Save block details to log
	BlockDuration = GetSecs - RestEEG_Onset;
	Subject.Logs.BlockDuration{i, 1} = 'EEG - closed';
	Subject.Logs.BlockDuration{i, 2} = BlockDuration;
	
	if SkipBlock == true
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, ['Block skipped.'], 'center', 'center', 255);
		Screen('Flip', MainWindow); WaitSecs(1);
		Screen('Flip', MainWindow); WaitSecs(1);
		SkipBlock = false;
	end
	
	% Play signal
	PsychPortAudio('Start', AudioHandle);
	RestEEG_Onset = GetSecs;
	if TriggersEnabled == true
		outp(Address, RestEEG.TriggerOpenOnset); WaitSecs(0.001);
		outp(Address, 0);
	end
	Screen('Flip', MainWindow); WaitSecs(1);
	i = i + 1;
	
	Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
	Screen('DrawingFinished', MainWindow);
	Screen('Flip', MainWindow);
	while GetSecs - RestEEG_Onset < RestEEG.Duration
		[Response, Call] = KbQueueCheck;
		if Response == true
			if Call(EscapeKey) > 0
				error('Escape key pressed. Experiment terminated.');
			elseif Call(SkipKey) > 0
				SkipBlock = true; break
			else
				Response = false;
			end
		end
	end
	
	if TriggersEnabled == true
		outp(Address, RestEEG.TriggerOpenOffset); WaitSecs(0.001);
		outp(Address, 0);
	end
	
	% Save block details to log
	BlockDuration = GetSecs - RestEEG_Onset;
	Subject.Logs.BlockDuration{i, 1} = 'EEG - open';
	Subject.Logs.BlockDuration{i, 2} = BlockDuration;
	
	if SkipBlock == true
		Screen('TextSize', MainWindow, 28);
		Screen('TextFont', MainWindow, 'Arial');
		DrawFormattedText(MainWindow, ['Block skipped.'], 'center', 'center', 255);
		Screen('Flip', MainWindow); WaitSecs(1);
		Screen('Flip', MainWindow); WaitSecs(1);
		KbQueueFlush();
		SkipBlock = false;
	end
	
	%% SRP - late post auditory 
	
	Screen('Flip', MainWindow); WaitSecs(1);
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, Text.Instructions.LateAuditory, 'center', 'center', 255);
	Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
	Screen('Flip', MainWindow); WaitSecs(1);
	
	% Set volume for auditive SRP stimulus (70 dB)
	PsychPortAudio('Volume', AudioHandle, 0.0616);
	
	for l = 1:size(SRP.Blocklists.SecondLate)
		
		i = i + 1;
		Ct_SRP_Blocks_Total = Ct_SRP_Blocks_Total + 1;
		
		% Identify upcoming block
		if SRP.Blocklists.SecondLate(l, 2) == 0, BlockModality = 0;
			if SRP.Blocklists.SecondLate(l, 1) == 60, BlockType = 0; Block_String = 'Non-stimulus 60 secs';
			elseif SRP.Blocklists.SecondLate(l, 1) == 120, BlockType = 0; Block_String = 'Non-stimulus 120 secs';
			elseif SRP.Blocklists.SecondLate(l, 1) == 47, BlockType = 0; Block_String = 'Non-stimulus 47 secs';
			elseif SRP.Blocklists.SecondLate(l, 1) == 55, BlockType = 0; Block_String = 'Non-stimulus 55 secs';
			elseif SRP.Blocklists.SecondLate(l, 1) == 77, BlockType = 0; Block_String = 'Non-stimulus 77 secs';
			elseif SRP.Blocklists.SecondLate(l, 1) == 90, BlockType = 1; Block_String = 'Non-stimulus 90 secs';
			end
		elseif SRP.Blocklists.SecondLate(l, 2) == 1, BlockModality = 1;
			if SRP.Blocklists.SecondLate(l, 1) == 2, BlockType = 2; Block_String = 'Auditory baseline';
			elseif SRP.Blocklists.SecondLate(l, 1) == 3, BlockType = 3; Block_String = 'Auditory tetanus';
			elseif SRP.Blocklists.SecondLate(l, 1) == 4, BlockType = 4; Block_String = 'Auditory post';
			end
		elseif SRP.Blocklists.SecondLate(l, 2) == 2, BlockModality = 2;
			if SRP.Blocklists.SecondLate(l, 1) == 2, BlockType = 2; Block_String = 'Visual baseline';
			elseif SRP.Blocklists.SecondLate(l, 1) == 3, BlockType = 3; Block_String = 'Visual tetanus';
			elseif SRP.Blocklists.SecondLate(l, 1) == 4, BlockType = 4; Block_String = 'Visual post';
			end
		end
		
		switch BlockModality
			
			case 0			% Non-stimulus blocks
				switch SRP.Blocklists.SecondLate(l, 1)
					case 60
						Duration = SRP.NonStimulus.Duration_60;
					case 120
						Duration = SRP.NonStimulus.Duration_120;
					case 47
						Duration = SRP.NonStimulus.Duration_47;
					case 55
						Duration = SRP.NonStimulus.Duration_55;
					case 77
						Duration = SRP.NonStimulus.Duration_77;
					case 90
						Duration = SRP.NonStimulus.Duration_90;
				end
				
				if SRP.Onset.Enable == true
					CuePlayed = false;
					PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_OnsetCue);
				end
				
				Screen('TextSize', MainWindow, 28);
				Screen('TextFont', MainWindow, 'Arial');
				DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
				Screen('DrawingFinished', MainWindow);
				BlockOnset = Screen('Flip', MainWindow); KbQueueStart();
				
				while GetSecs - BlockOnset < Duration
					[Response, Call] = KbQueueCheck;
					if SRP.Onset.Enable == true
						if GetSecs - BlockOnset > Duration - SRP.Onset.TimeBefore && CuePlayed == false
							PsychPortAudio('Start', AudioHandle);
							CuePlayed = true;
						end
					end
					if Response == true
						if Call(EscapeKey) > 0
							error('Escape key pressed. Experiment terminated.');
						elseif Call(SkipKey) > 0
							SkipBlock = true; break
						elseif Call(PauseKey) > 0
							if TriggersEnabled == true
								outp(Address, TriggerBoundaryStart); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, 255); WaitSecs(0.001);
								outp(Address, 0);
							end
							ExtPause = true; KbQueueFlush(); Response = false;
							Screen('TextSize', MainWindow, 28);
							Screen('TextFont', MainWindow, 'Arial');
							DrawFormattedText(MainWindow, ...
								'Paused. Press pause key again to continue.', 'center', 'center', 255);
							ExtPauseStart = Screen('Flip', MainWindow);
							while ExtPause == true
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(PauseKey) > 0
										ExtPause = false;
									else
										Response = false;
									end
								end
							end
							Screen('TextSize', MainWindow, 28);
							Screen('TextFont', MainWindow, 'Arial');
							DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							Screen('DrawingFinished', MainWindow);
							ExtPauseEnd = Screen('Flip', MainWindow); KbQueueFlush();
							Duration = Duration + (ExtPauseEnd - ExtPauseStart);
							if TriggersEnabled == true
								outp(Address, 254); WaitSecs(0.001);
								outp(Address, 0);
								
								WaitSecs(2);
								
								outp(Address, TriggerBoundaryEnd); WaitSecs(0.001);
								outp(Address, 0);
							end
						else
							Response = false;
						end
					end
				end
				KbQueueFlush(); Response = false;
				
			case 1			% Auditory blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						ResponseCollected = false;
						Response = false;
						
						Screen('TextSize', MainWindow, 28);
						Screen('TextFont', MainWindow, 'Arial');
						DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Targets = SRP.Auditory.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Auditory.Baseline.Trials;
								SOA = SRP.Auditory.Baseline.SOA;
								
							case 4
								Trials = SRP.Auditory.Post.Trials;
								SOA = SRP.Auditory.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Target);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							else
								PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
								Screen('TextSize', MainWindow, 28);
								Screen('TextFont', MainWindow, 'Arial');
								DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
							end
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.SecondLate(l, 5);
								TriggerResponse = SRP.Blocklists.SecondLate(l, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.SecondLate(l, 3);
							else
								Trigger = SRP.Blocklists.SecondLate(l, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
									
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Screen('DrawingFinished', MainWindow);
							PsychPortAudio('Start', AudioHandle);
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI / 2
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Screen('TextSize', MainWindow, 28);
						Screen('TextFont', MainWindow, 'Arial');
						DrawFormattedText(MainWindow, ['Hold øynene lukket.'], 'center', 'center', 255);
						Screen('DrawingFinished', MainWindow);
						Screen('Flip', MainWindow);
						
						Trials = SRP.Auditory.Tetanus.Trials;
						SOA = SRP.Auditory.Tetanus.SOA;
						
						BlockOnset = GetSecs;
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							PsychPortAudio('FillBuffer', AudioHandle, Buffer_SRP_Stimulus);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							PsychPortAudio('Start', AudioHandle);
							Onset = GetSecs; KbQueueStart();
							while GetSecs - Onset < SOA
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
			case 2			% Visual blocks
				switch BlockType
					
					case {2, 4}		% Baseline / post
						ResponseCollected = false;
						Response = false;
						
						Targets = SRP.Visual.Target.Number;
						TempRT = 0;
						
						switch BlockType
							case 2
								Trials = SRP.Visual.Baseline.Trials;
								SOA = SRP.Visual.Baseline.SOA;
								
							case 4
								Trials = SRP.Visual.Post.Trials;
								SOA = SRP.Visual.Post.SOA;
						end
						
						rFirst = Trials / Targets;
						rStep = rFirst - rFirst / Targets;
						rEnd = Trials - rFirst + rFirst / Targets;
						
						rRandUp = round(rStep * 0.35, 3) * 1000;
						rRandDown = rRandUp * (-1);
						rRandAdj = [rRandDown rRandUp];
						
						TargetList = rFirst:rStep:rEnd;
						for n = 1:Targets
							TargetList(1, n) = round(TargetList(1, n) ...
								+ randi(rRandAdj, 1, 1) / 1000);
						end
						TargetList = rot90(TargetList, 3);
						TargetListIndex = 1;
						
						for a = 1:Trials
							
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							switch BlockType
								case 2
									Debug_Ct_SRP_Tr_BL = Debug_Ct_SRP_Tr_BL + 1;
								case 4
									Debug_Ct_SRP_Tr_P = Debug_Ct_SRP_Tr_P + 1;
							end
							
							if TempRT == 0, ResponseNotCollected = false; end
							
							TrialSOA = (randi(SOA, 1, 1)) / 1000;
							AdjustToIFI = randi([1 2]);
							if AdjustToIFI == 1
								TrialSOA = floor(TrialSOA / IFI) * IFI;
							end
							if AdjustToIFI == 2
								TrialSOA = ceil(TrialSOA / IFI) * IFI;
							end
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							if a == TargetList(TargetListIndex)
								if TargetListIndex < Targets
									TargetListIndex = TargetListIndex + 1;
								end
								Ct_SRP_Targets_Total = Ct_SRP_Targets_Total + 1;
								
								TrialIsTarget = true;
							else
								TrialIsTarget = false;
							end
							
							if TrialIsTarget == true
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointTargCol, FixPointPos);
							else
								Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
								Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							end
							Screen('DrawingFinished', MainWindow);
							
							if TrialIsTarget == true
								Trigger = SRP.Blocklists.SecondLate(l, 5);
								TriggerResponse = SRP.Blocklists.SecondLate(l, 6);
							elseif a <= Trials / 2
								Trigger = SRP.Blocklists.SecondLate(l, 3);
							else
								Trigger = SRP.Blocklists.SecondLate(l, 4);
							end
							if TriggersEnabled == true
								outp(Address, Trigger); WaitSecs(0.001);
								outp(Address, 0);
							end
							
							switch BlockType
								case 2
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL - 1, 1} = '--';
									end
									
								case 4
									if a == 1
									elseif a == 2
										BlockOnset = Onset;
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = Block_String;
									else
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P - 1, 1} = '--';
									end
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < TrialSOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									elseif TrialIsTarget == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									elseif TrialIsTarget == false && ResponseNotCollected == true && Call(ResponseKey) > 0
										RT = round(Call(ResponseKey) - Onset - IFI, 2);
										RT = TempRT + RT;
										ResponseCollected = true;
										if TriggersEnabled == true
											outp(Address, TriggerResponse); WaitSecs(0.001);
											outp(Address, 0);
										end
									else
										Response = false;
									end
								end
							end
							if TrialIsTarget == true && ResponseCollected == false
								ResponseNotCollected = true;
								TempRT = round(TrialSOA, 2);
							end
							
							if TrialIsTarget == true && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								
							elseif TrialIsTarget == false && ResponseCollected == true
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = RT;
								ResponseNotCollected = false;
								TempRT = 0;
								
							elseif TrialIsTarget == false && ResponseNotCollected == true && ResponseCollected == false
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 1} = Block_String;
								Subject.Logs.Responses{Ct_SRP_Targets_Total, 2} = 'Miss';
								ResponseNotCollected = false;
								TempRT = 0;
							end
							
							switch BlockType
								case 2
									if a > 1
										Subject.Logs.TrialDuration.Baseline{Debug_Ct_SRP_Tr_BL, 2} = Onset - PreviousOnset;
									end
								case 4
									if a > 1
										Subject.Logs.TrialDuration.Post{Debug_Ct_SRP_Tr_P, 2} = Onset - PreviousOnset;
									end
							end
							
							ResponseCollected = false; KbQueueFlush(); Response = false;
							
							if SkipBlock == true
								break
							end
						end
						
					case 3			% Tetanus
						ResponseCollected = false;
						Response = false;
						
						Trials = SRP.Visual.Tetanus.Trials;
						SOA = SRP.Visual.Tetanus.SOA;
						
						BlockOnset = GetSecs;
						for a = 1:Trials
							
							Debug_Ct_SRP_Tr_T = Debug_Ct_SRP_Tr_T + 1;
							Ct_SRP_Trials_Total = Ct_SRP_Trials_Total + 1;
							
							Phase = Phase + 1; if Phase == 3, Phase = 1; end
							
							Screen('DrawTexture', MainWindow, CheckerboardTexture(Phase));
							Screen('FillOval', MainWindow, FixPointCol, FixPointPos);
							Screen('DrawingFinished', MainWindow);
							
							if a == 1
							elseif a == 2
								BlockOnset = Onset;
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = Block_String;
							else
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T - 1, 1} = '--';
							end
							
							if a > 1
								PreviousOnset = Onset;
							end
							Onset = Screen('Flip', MainWindow); KbQueueStart();
							while GetSecs - Onset < SOA - IFI
								[Response, Call] = KbQueueCheck;
								if Response == true
									if Call(EscapeKey) > 0
										error('Escape key pressed. Experiment terminated.');
									elseif Call(SkipKey) > 0
										SkipBlock = true;
									else
										Response = false;
									end
								end
							end
							KbQueueFlush(); Response = false;
							
							if a > 1
								Subject.Logs.TrialDuration.Tetanus{Debug_Ct_SRP_Tr_T, 2} = Onset - PreviousOnset;
							end
							
							if SkipBlock == true
								break
							end
						end
						
				end
				
		end
		
		% Save block details to log
		BlockDuration = GetSecs - BlockOnset;
		Subject.Logs.BlockDuration{i, 1} = Block_String;
		Subject.Logs.BlockDuration{i, 2} = BlockDuration;
		
		if SkipBlock == true
			Screen('TextSize', MainWindow, 28);
			Screen('TextFont', MainWindow, 'Arial');
			DrawFormattedText(MainWindow, ['Block skipped.'], 'center', 'center', 255);
			Screen('Flip', MainWindow); WaitSecs(1);
			Screen('Flip', MainWindow); WaitSecs(1);
			KbQueueFlush();
			SkipBlock = false;
		end
	end
	
	%% Save subject details 
	
	save([SaveDirectory '/Subject_Details.mat'], 'Subject');
	save([SaveDirectory '/SRP_Details.mat'], 'SRP');
	save([SaveDirectory '/LDAEP_Details.mat'], 'LDAEP');
	save([SaveDirectory '/RestEEG_Details.mat'], 'RestEEG');
	
	%% End of script 
	
	Screen('Flip', MainWindow); WaitSecs(1);
	
	Screen('TextSize', MainWindow, 28);
	Screen('TextFont', MainWindow, 'Arial');
	DrawFormattedText(MainWindow, Text.Outro, 'center', 'center', 255);
	Screen('Flip', MainWindow); KbStrokeWait; KbQueueFlush();
	Screen('Flip', MainWindow); WaitSecs(1);
	if TriggersEnabled == true
		outp(Address, 255); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
	end
	Screen('CloseAll'); ShowCursor; Priority(0); clear all; clear; %#ok<*CLALL>
	
catch exception
	disp('Error encountered. See details below:');
	disp(exception); disp(exception.cause); disp(exception.stack);
	save([SaveDirectory '/Subject_Details.mat'], 'Subject');
	save([SaveDirectory '/SRP_Details.mat'], 'SRP');
	save([SaveDirectory '/LDAEP_Details.mat'], 'LDAEP');
	save([SaveDirectory '/RestEEG_Details.mat'], 'RestEEG');
	if TriggersEnabled == true
		outp(Address, 255); WaitSecs(0.001);
		outp(Address, 0); WaitSecs(0.001);
	end
	Screen('CloseAll'); ShowCursor; Priority(0); clear all; clear;
end

end