# Empatica E4
### Summary
This analysis focuses on extracting and analyzing skin temperature, cardiovascular measures - heart rate (HR) and heart rate variability (HRV), and electrodermal activity (EDA) - examining skin conductance response (SCR), skin conductance level (SCL), and the global mean skin conductance (SC). The aim is to explore correlations with stress, arousal, and autonomic nervous system behavior. HRV assessment used inter-beat interval (IBI) and root mean square of successive differences (RMSSD), the latter indicating parasympathetic activity by measuring the square root of the mean of the sum of the squares of differences between successive normal heartbeats. In this MATLAB-based data processing workflow, we first extract the start and end times of each Empatica recording to generate time vectors for all raw data segments. To account for the E4 device's varying sampling rates, data epochs are aligned by multiplying the sampling rates for EDA and skin temperature data by 4 (to match a 4 Hz sampling rate), leaving HR data unchanged (1 Hz), and averaging IBI over each epoch. VR headset timestamps (in UTC) are then integrated with E4 data to identify event markers and participant IDs. Subsequently, the data is organized by participant and batch processing is used to compute metrics such as changes in HR and skin temperature from baseline, mean IBI deviations, and RMSSD from baseline. For EDA analysis, the continuous decomposition analysis (CDA) method was employed using the Ledalab V.3.4.9 toolbox, following default settings for response windows (1-4 seconds post-stimulus), minimum amplitude thresholds (0.01 μS), and smoothing techniques to compute mean SCR, SCL fluctuations, and global mean SC for each participant. These metrics, and their variations from baseline, were then extracted for statistical analysis.

## Data Analysis and Processing
