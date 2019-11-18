%% Constants
% Paths
global SOFTWARE_PATH DATA_PATH;
% Here, define the path to the SampleData and Scripts folders on your computer:
SOFTWARE_PATH = 'D:\GitRepositories\island\Scripts\InternalStructureHeadDirection\';
DATA_PATH='D:\GitRepositories\island\SampleData\HeadDirectionData';

addpath([SOFTWARE_PATH 'custom_scripts']);

% Data extraction
global BEHAVIORAL_SAMPLE_RATE NEURONAL_SAMPLE_RATE BEHAVIORAL_SAMPLES_PER_TEMPORAL_BIN ...
       NUMBER_OF_ANGLE_BINS NUMBER_OF_ESTIMATED_ANGLE_BINS CENTER_OF_ANGLE_BINS NUMBER_OF_ANGULAR_VELOCITY_BINS ...
       MAX_ANGULAR_VELOCITY MIN_ANGULAR_VELOCITY CENTER_OF_ANGULAR_VELOCITY_BINS ...
       TEMPORAL_TIME_BIN SAMPLE_LIMIT INCLUDE_UNIDENTIFIED_ANGLES;

BEHAVIORAL_SAMPLE_RATE = 39.0625; % Hz
NEURONAL_SAMPLE_RATE = 20000; %Hz
BEHAVIORAL_SAMPLES_PER_TEMPORAL_BIN = 4; %for now, we use only integer number of samples
NUMBER_OF_ANGLE_BINS = 40;
NUMBER_OF_ESTIMATED_ANGLE_BINS = 40;
CENTER_OF_ANGLE_BINS = [0.5 * (2 * pi) / NUMBER_OF_ANGLE_BINS:...
                        (2 * pi) / NUMBER_OF_ANGLE_BINS:...
                        2 * pi - 0.5 * (2 * pi) / NUMBER_OF_ANGLE_BINS];
NUMBER_OF_ANGULAR_VELOCITY_BINS = 16;
MAX_ANGULAR_VELOCITY = 0.25;
MIN_ANGULAR_VELOCITY = -0.25;
CENTER_OF_ANGULAR_VELOCITY_BINS = [MIN_ANGULAR_VELOCITY:...
                                   (MAX_ANGULAR_VELOCITY - MIN_ANGULAR_VELOCITY) / (NUMBER_OF_ANGULAR_VELOCITY_BINS - 1):...
                                   MAX_ANGULAR_VELOCITY];
TEMPORAL_TIME_BIN = BEHAVIORAL_SAMPLES_PER_TEMPORAL_BIN / BEHAVIORAL_SAMPLE_RATE;
SAMPLE_LIMIT = 20000;
% Notice that if we choose not to include these angles we get
% incorrect results by the decoder because of some delay in the decoded
% angles compared to the actual angle.
INCLUDE_UNIDENTIFIED_ANGLES = true;

% Head directionality criterion (find_head_direction_neurons.m)
global FIRING_RATE_THRESHOLD RAYLEIGH_VECTOR_LENGTH_THRESHOLD;
FIRING_RATE_THRESHOLD = 5; % Hz
RAYLEIGH_VECTOR_LENGTH_THRESHOLD = 0.5;

% LEM
global P_NEIGHBORS_VEC NUMBER_OF_REDUCED_DIMENSIONS_VEC;
P_NEIGHBORS_VEC = [0.075 / 30 0.075];
NUMBER_OF_REDUCED_DIMENSIONS_VEC = [10 10];

% 
NUMBER_OF_ACTIVE_NEURONS_THRESHOLD = 15;
NUMBER_OF_CLUSTERS = 8;
CLUSTERING_DIMENSIONS = 2:7;

ACTUAL_VERSUS_CLUSTERING_SHIFT = 1.5 * pi; % for Wake all filtered
MIRROR_ORDERING = true; % for Wake all filtered

CENTER_OF_CLUSTERING_ANGLE_BINS = 0.5 * (2 * pi) / NUMBER_OF_CLUSTERS:...
                                  (2 * pi) / NUMBER_OF_CLUSTERS:...
                                  2 * pi - 0.5 * (2 * pi) / NUMBER_OF_CLUSTERS;