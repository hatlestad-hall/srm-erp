function cfg_vep = vep_checkers_cfg ( )
%% About
% Use function to create configuration struct for VEP checkerboard paradigm.

% Some rules to follow:
%	--> 'blocks', 'labels', and 'pauses' arrays must have the same length.
%	--> The SOA parameters are passed in milliseconds (ms), not seconds.
%	--> The ratio of 'probe_trials' to 'targets_num' should be at least 4.
%	--> The screen properties are passed in centimeters (cm), not meters.

% -----------------------------------
% Christoffer Hatlestad-Hall
% Cognitive Health in Brain Disorders
% Division for Clinical Neuroscience
% Oslo University Hospital
% -----------------------------------

%% Configuration: Parameters
% Blocks.
% ( HFS = 0   |   Probe = 1 )
% ( Pauses preceding blocks given in seconds )
cfg_vep.blocks	= [ 1, 1, 0, 1, 1 ];
cfg_vep.labels	= { 'BL_1', 'BL_2', 'HFS', 'Po_1', 'Po_2' };
cfg_vep.pauses	= [ 60, 60, 60, 120, 60 ];

% cfg_vep.blocks	= [ 1, 1 ];
% cfg_vep.labels	= { 'Po_3', 'Po_4' };
% cfg_vep.pauses	= [ 60, 60 ];

% Event markers (in probe blocks only).
cfg_vep.em_enabled	= true;
cfg_vep.em_addr		= hex2dec ( 'B010' );
cfg_vep.probe_m		= [ 1, 2, 3, 4 ];
cfg_vep.target_m		= [ 11, 12, 13, 14 ];
cfg_vep.resp_m		= 20;

% cfg_vep.em_enabled	= true;
% cfg_vep.em_addr		= hex2dec ( 'B010' );
% cfg_vep.probe_m		= [ 5, 6 ];
% cfg_vep.target_m	= [ 15, 16 ];
% cfg_vep.resp_m		= 20;

% Visual stimuli.
cfg_vep.spatial_freq	= 1.0;
cfg_vep.contrast		= 1.0;

% SOA (milliseconds).
% ( Probe: Interval [ min, max ]   |   HFS: One number )
% ( SOA values will be rounded down (@floor) in order to match screen refresh rate )
cfg_vep.probe_soa	= [ 500, 1500 ];
cfg_vep.hfs_soa		= 125;

% Trials.
cfg_vep.probe_trials	= 40;
cfg_vep.targets_num		= 5;
cfg_vep.hfs_trials		= 1024;

% Screen properties.
cfg_vep.scr_x_cm	= 52.8;
cfg_vep.scr_y_cm	= 29.6;
cfg_vep.view_dist	= 57;

% PTB clear.
cfg_vep.clear_ptb = false;

end