# Empatica E4 and Pico Neo Pro 3 Eye VR Headset
### Summary
This analysis focuses on extracting and analyzing skin temperature, cardiovascular measures - heart rate (HR) and heart rate variability (HRV), and electrodermal activity (EDA) - examining skin conductance response (SCR), skin conductance level (SCL), and the global mean skin conductance (SC). The aim is to explore correlations with stress, arousal, and autonomic nervous system behavior. HRV assessment used inter-beat interval (IBI) and root mean square of successive differences (RMSSD), the latter indicating parasympathetic activity by measuring the square root of the mean of the sum of the squares of differences between successive normal heartbeats. In this MATLAB-based data processing workflow, we first extract the start and end times of each Empatica recording to generate time vectors for all raw data segments. To account for the E4 device's varying sampling rates, data epochs are aligned by multiplying the sampling rates for EDA and skin temperature data by 4 (to match a 4 Hz sampling rate), leaving HR data unchanged (1 Hz), and averaging IBI over each epoch. VR headset timestamps (in UTC) are then integrated with E4 data to identify event markers and participant IDs. Subsequently, the data is organized by participant and batch processing is used to compute metrics such as changes in HR and skin temperature from baseline, mean IBI deviations, and RMSSD from baseline. For EDA analysis, the continuous decomposition analysis (CDA) method was employed using the Ledalab V.3.4.9 toolbox, following default settings for response windows (1-4 seconds post-stimulus), minimum amplitude thresholds (0.01 μS), and smoothing techniques to compute mean SCR, SCL fluctuations, and global mean SC for each participant. These metrics, and their variations from baseline, were then extracted for statistical analysis.
To generate all the output files, please do as follows.

### Analysis of Empatica E4 data
The Empatica E4 data is processed using the [script_gen_csv.m](script_gen_csv.m) file.
1. Simply run the [script_gen_csv.m](script_gen_csv.m) script to create the result files.
2. Once the script is done processing, you will get a folder [results](results) with the processed data.

### Ledalab for EDA analysis
To use Ledalab for EDA analysis, you can use the custom version of LedaLab that is available in the [ledalab-349](ledalab-349) folder. This version of Ledalab has been modified to work with the E4 data and newer versions of MATLAB.
1. The first step is to collect the EDA data files for batch processing. After running [script_gen_csv.m](script_gen_csv.m), the EDA data files will become available in the [data_batch_for_ledalab](data_batch_for_ledalab) folder.
2. Navigate in MATLAB into the [data_batch_ledalab_output](data_batch_ledalab_output) folder and run the [script_leda_lab_analysis.m](script_leda_lab_analysis.m) script. This will process the EDA data files in batch mode with the settings in the script. Note that Ledalab will dump the result files in the current working directory, which is why we wanted to change directory earlier. Otherwise, you may manually copy all the generated files named `_era.mat` int o that folder
3. Then, you can run [script_gen_csv_eda.m](script_gen_csv_eda.m) to generate the output CV files.

## Data Analysis and Processing
### Output structure:
#### 1. earliest:
- **Description:** Contains information about the earliest recorded data.
- **Type:** 1x2 vector.
  - The first element is the UNIX timestamp of the earliest recorded data.
  - The second element is the index (or location) of the device that started recording first.
#### 2. starttimes:
- **Description:** Table detailing the start times for each recording.
- **Type:** Table (with 1 row and 3 columns in the provided example).
  - **Columns:**
    * **Device:** Describes the device type. In this case, it's 'E4'.
    * **UNIX:** UNIX timestamp indicating when the recording started.
    * **Date_Time:** A human-readable version of the timestamp in local timezone.
#### 3. endtimes:
- **Description:** Information about the end time of the recording.
- **Type:** Vector.
  - First element: UNIX timestamp of when the recording ended.
  - Second element: Total time recorded, in seconds.
  - Third element: Total time recorded, in minutes.
  - Fourth element: Total time recorded, in hours.
#### 4. latest:
- **Description:** Information about the latest data recorded.
- **Type:** 1x2 vector.
  - The first element is the UNIX timestamp of the latest recorded data.
  - The second element is the index (or location) of the device that ended recording last.
#### 5. longest_record:
- **Description:** Information about the longest recording duration.
- **Type:** 1x2 vector.
  - The first element is the duration of the longest recording (in seconds).
  - The second element is the index (or location) of the device that had the longest recording.
#### 6. study_time_vector_sec_unix:
- **Description:** A time vector representing every second from the start to the end of the study.
- **Type:** Column vector of UNIX timestamps_e4.
  - **Length:** Corresponds to the total duration of the study in seconds.
#### 7. study_time_vector_epoch_length_unix:
- **Description:** A time vector with entries spaced by the epoch_length.
- **Type:** Column vector of UNIX timestamps_e4.
  - **Length:** The number of epoch_length intervals in the study.
#### 8. study_data_raw_accelerometer:
- **Description:** The averaged accelerometer data over each second of the study.
- **Type:** Matrix.
  - **Dimensions:** The number of rows corresponds to the number of seconds in the study. The 3 columns correspond to the 3 axes of the accelerometer (typically x, y, and z).
#### 9. build_mat:
- **Description:** A structure containing processed data for various physiological signals like activity, EDA, HR, TEMP, and IBI.
- **Type:** Struct.
  - **Fields:** (based on the provided code)
    * **activity_idx:** Activity index calculated from accelerometer data.
    * **EDA:** Processed Electrodermal Activity data.
    * **HR:** Processed Heart Rate data.
    * **TEMP:** Processed Temperature data.
    * **IBI:** Processed Inter-Beat Interval data.
#### 10. lengE4:
- **Description:** The length (or duration) of the data recorded from the E4 device, in terms of the number of epoch_length intervals.
- **Type:** Scalar.
> **Note:** These descriptions are based on the provided MATLAB code and the example data structure. The actual interpretations might vary depending on the specifics of the study, experimental setup, and other contextual details.
