# Empatica E4 and Pico Neo Pro 3 Eye VR Headset
### Summary
This repository serves as a  guide for exploring the relationship between stress, arousal, autonomic nervous system behavior, and various physiological indicators measured by the Empatica E4 wearable device. It focuses on parameters such as skin temperature, heart rate (HR), heart rate variability (HRV) - specifically analyzing the inter-beat interval (IBI) and the root mean square of successive differences (RMSSD) to evaluate parasympathetic nervous system activity - and electrodermal activity (EDA), including detailed examination of the skin conductance response (SCR), skin conductance level (SCL), and total skin conductance (SC).

>**Note:** In this experimental workflow, event markers are derived from eye tracking data gathered using the Pico Neo Pro 3 Eye VR headset, which monitors scene changes and timestamps during the experiment. This process is adaptable for various experimental designs, allowing for straightforward modifications to the event marker extraction method in the data processing workflow to suit specific experimental procedures.

## Data Analysis and Processing
To produce all necessary output files, follow these steps:

>**Note:** Every script file used in this workflow contains detailed notes within comments to explain each step of the code for improved clarity.

### Initial Data Processing
In this MATLAB-based workflow for processing data, we first extract the start and end times from each Empatica recording to create time vectors for every segment of raw data. To manage the varying sampling rates of the E4 device, we align data epochs by adjusting the sampling rates for EDA and skin temperature data to 4 Hz, while maintaining HR data at 1 Hz, and averaging the IBI for each epoch. VR headset timestamps, in UTC, are integrated with E4 data to pinpoint event markers and identify participant IDs. The data is then sorted by participant, and batch processing calculates metrics like HR and skin temperature changes from the baseline, average IBI deviations, and RMSSD from the baseline.

The Empatica E4 data is processed using the [script_gen_csv.m](script_gen_csv.m) file.
1. Simply run the [script_gen_csv.m](script_gen_csv.m) script to create the result files.
2. Once the script is done processing, a folder [results](results) will be generated with the processed data.

### Ledalab for EDA analysis
For analyzing EDA, we utilize the continuous decomposition analysis (CDA) technique via the Ledalab V.3.4.9 toolbox, adhering to default settings for response windows (1-4 seconds post-stimulus), minimum amplitude thresholds (0.01 μS), and employing smoothing methods to calculate the mean skin conductance response (SCR), skin conductance level (SCL) fluctuations, and overall skin conductance (SC) for each participant. These metrics, alongside their deviations from the baseline, are extracted for further statistical analysis.

>**Note:** Ledalab software has been modified to ensure compatibility with Matlab 2023 version, while maintaining protection under the GNU General Public License.

To use Ledalab for EDA analysis, the custom version of LedaLab is made under the [ledalab-349](ledalab-349) folder. This version of Ledalab has been modified to work with the E4 data and newer versions of MATLAB.
1. The first step is to collect the EDA data files for batch processing. After running [script_gen_csv.m](script_gen_csv.m), the EDA data files will become available in the [data_batch_for_ledalab](data_batch_for_ledalab) folder.
2. Navigate in MATLAB into the [data_batch_ledalab_output](data_batch_ledalab_output) folder and run the [script_leda_lab_analysis.m](script_leda_lab_analysis.m) script. This will process the EDA data files in batch mode with the settings in the script. Note that Ledalab will export the result files in the current working directory, which is why it is recommended to modify the directory prior. Otherwise, it is possible to manually copy all the generated files named `_era.mat` into the correct folder
3. Run [script_gen_csv_eda.m](script_gen_csv_eda.m) to generate the output CSV files.

### Output structure:
#### Exported CSV File processed for each metric (example shown below is for HR)
##### 1. earliest:

#### Description on the raw E4 data
##### 1. earliest:
- **Description:** Contains information about the earliest recorded data.
- **Type:** 1x2 vector.
  - The first element is the UNIX timestamp of the earliest recorded data.
  - The second element is the index (or location) of the device that started recording first.
##### 2. starttimes:
- **Description:** Table detailing the start times for each recording.
- **Type:** Table (with 1 row and 3 columns in the provided example).
  - **Columns:**
    * **Device:** Describes the device type. In this case, it's 'E4'.
    * **UNIX:** UNIX timestamp indicating when the recording started.
    * **Date_Time:** A human-readable version of the timestamp in local timezone.
##### 3. endtimes:
- **Description:** Information about the end time of the recording.
- **Type:** Vector.
  - First element: UNIX timestamp of when the recording ended.
  - Second element: Total time recorded, in seconds.
  - Third element: Total time recorded, in minutes.
  - Fourth element: Total time recorded, in hours.
##### 4. latest:
- **Description:** Information about the latest data recorded.
- **Type:** 1x2 vector.
  - The first element is the UNIX timestamp of the latest recorded data.
  - The second element is the index (or location) of the device that ended recording last.
##### 5. longest_record:
- **Description:** Information about the longest recording duration.
- **Type:** 1x2 vector.
  - The first element is the duration of the longest recording (in seconds).
  - The second element is the index (or location) of the device that had the longest recording.
##### 6. study_time_vector_sec_unix:
- **Description:** A time vector representing every second from the start to the end of the study.
- **Type:** Column vector of UNIX timestamps_e4.
  - **Length:** Corresponds to the total duration of the study in seconds.
##### 7. study_time_vector_epoch_length_unix:
- **Description:** A time vector with entries spaced by the epoch_length.
- **Type:** Column vector of UNIX timestamps_e4.
  - **Length:** The number of epoch_length intervals in the study.
##### 8. study_data_raw_accelerometer:
- **Description:** The averaged accelerometer data over each second of the study.
- **Type:** Matrix.
  - **Dimensions:** The number of rows corresponds to the number of seconds in the study. The 3 columns correspond to the 3 axes of the accelerometer (typically x, y, and z).
##### 9. build_mat:
- **Description:** A structure containing processed data for various physiological signals like activity, EDA, HR, TEMP, and IBI.
- **Type:** Struct.
  - **Fields:** (based on the provided code)
    * **activity_idx:** Activity index calculated from accelerometer data.
    * **EDA:** Processed Electrodermal Activity data.
    * **HR:** Processed Heart Rate data.
    * **TEMP:** Processed Temperature data.
    * **IBI:** Processed Inter-Beat Interval data.
##### 10. lengE4:
- **Description:** The length (or duration) of the data recorded from the E4 device, in terms of the number of epoch_length intervals.
- **Type:** Scalar.
> **Note:** These descriptions are based on the provided MATLAB code and the example data structure. The actual interpretations might vary depending on the specifics of the study, experimental setup, and other contextual details.
