function Tone = CreateTone(Duration, Frequency, GWN, SaveMatrix, CreateWav)

%% Information

% Usage:
% Required input arguments (*)
% * Duration - in seconds
% * Frequency - in Hz
%
% Optional input arguments (**)
% ** GWN - apply gaussian white noise filter
% ** SaveMatrix - save the tone as .mat file, true or false
% ** CreateWav - save the tone as .wav file, true or false
% ------
%
% Provided by
% 
% Kristiina Kompus
% University of Bergen
% ------
%
% Function by
%
% Christoffer Hatlestad
% Department of Psychology
% University of Oslo
% ------

%% Define variables

switch nargin
	case 4
		SaveMatrix = false;
	case 3
		SaveMatrix = false;
		CreateWav = false;
    case 2
        SaveMatrix = false;
		CreateWav = false;
		GWN = false;
	case 1
		error('Missing argument: Frequency');
	case 0
		error('Missing arguments: Duration and frequency');
end

Amplitude = 1;
SamplingRate = 48000;
PhasePhi = 2 * pi / 1;
t = [0:1 / SamplingRate:Duration];
t = t(1:end - 1);
nSamples = SamplingRate * Duration;

%% Create sound

Tone = Amplitude * sin(2 * pi * Frequency * t + PhasePhi);

%% Make a cosine ramp

RampDur = Duration / 10;
Nr = floor(SamplingRate * RampDur);
R = sin(linspace(0, pi / 2, Nr));
R = [R, ones(1, nSamples - Nr * 2), fliplr(R)];

%% Add ramp to tone

Tone = Tone .* R;

%% Apply gaussian white noise filter
if GWN == true
	X = wgn(1, length(Tone), -12);
	for i = 1:length(Tone)
		Tone(i) = X(i) * Tone(i);
	end
end

%% Save .mat file, if enabled

if SaveMatrix == true
	save([pwd 'Tone.mat'], 'Tone');
end

%% Make .wav file, if enabled

if CreateWav == true
	audiowrite([pwd 'Tone.wav'], Tone, SamplingRate);
end

end