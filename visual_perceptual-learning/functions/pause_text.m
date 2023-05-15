function pause_text ( ptb, inp_text, pause_pre, pause_post, min_wait )

if nargin < 1
	fprintf ( '\n\npause_text: ptb struct required\n\n' );
	return
elseif nargin == 1
	inp_text = 'No input text provided (so this is shown instead).';
	pause_pre = 3;
	pause_post = 3;
	min_wait = 0;
elseif nargin == 2
	pause_pre = 3;
	pause_post = 3;
	min_wait = 0;
elseif nargin == 3
	pause_post = 3;
	min_wait = 0;
elseif nargin == 4
	min_wait = 0;
end

% Flip blank background to the screen.
Screen ( 'Flip', ptb.MainWindow );

% Wait the specified number of seconds.
WaitSecs ( pause_pre );

% Setup response key structure.
KbName ( 'UnifyKeyNames' );

% Initiate PTB response function.
KbQueueCreate;

% Start listening for key presses.
KbQueueStart;

% Set font and text size.
Screen ( 'TextSize', ptb.MainWindow, 28 );
Screen ( 'TextFont', ptb.MainWindow, 'Arial' );

% Draw the specified text.
DrawFormattedText ( ptb.MainWindow, inp_text, 'center', 'center', 255 );

% Flip the drawn text to the screen.
Screen ( 'Flip', ptb.MainWindow );

% If minimum waiting time is specified, wait the specified number of seconds.
if min_wait > 0
	WaitSecs ( min_wait )
	KbQueueFlush;
end

% Keep the text on-screen until a key is pressed; and then flush the keyboard queue.
KbStrokeWait;
KbQueueFlush;

% Stop listening for key presses.
KbQueueRelease;

% Remove the text from the screen.
Screen ( 'Flip', ptb.MainWindow );

% Wait the specified number of seconds.
WaitSecs ( pause_post );

end