%% Constants
% Here, define the path to the SampleData and Scripts folders on your computer:
SOFTWARE_PATH = 'D:\GitRepositories\island\Scripts\RawToProcessed\';
DATA_PATH='D:\GitRepositories\island\SampleData\HeadDirectionData\Raw\';

addpath([SOFTWARE_PATH 'crcns-hc2-scripts']);

MOUSE_NAME = 'Mouse28-140313';

global BEHAVIORAL_SAMPLE_RATE NEURONAL_SAMPLE_RATE ...
       BEHAVIORAL_SAMPLES_PER_TEMPORAL_BIN SAMPLE_LIMIT ...
       NUMBER_OF_ANGLE_BINS CENTER_OF_ANGLE_BINS;

BEHAVIORAL_SAMPLE_RATE = 39.0625; % Hz
NEURONAL_SAMPLE_RATE = 20000; %Hz
BEHAVIORAL_SAMPLES_PER_TEMPORAL_BIN = 4;
SAMPLE_LIMIT = 20000;
NUMBER_OF_ANGLE_BINS = 40;
CENTER_OF_ANGLE_BINS = [0.5 * (2 * pi) / NUMBER_OF_ANGLE_BINS:...
                        (2 * pi) / NUMBER_OF_ANGLE_BINS:...
                        2 * pi - 0.5 * (2 * pi) / NUMBER_OF_ANGLE_BINS];