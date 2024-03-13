# Empatica E4 and Pico Neo Pro 3 Eye VR Headset
### Summary
This repository serves as a  guide for exploring the relationship between stress, arousal, autonomic nervous system behavior, and various physiological indicators measured by the Empatica E4 wearable device. It focuses on parameters such as skin temperature, heart rate (HR), heart rate variability (HRV) - specifically analyzing the inter-beat interval (IBI) and the root mean square of successive differences (RMSSD) to evaluate parasympathetic nervous system activity - and electrodermal activity (EDA), including detailed examination of the skin conductance response (SCR), skin conductance level (SCL), and total skin conductance (SC).

>**Note:** In this experimental workflow, event markers are derived from eye tracking data gathered using the Pico Neo Pro 3 Eye VR headset, which monitors scene changes and timestamps during the experiment. This process is adaptable for various experimental designs, allowing for straightforward modifications to the event marker extraction method in the data processing workflow to suit specific experimental procedures.

## Data Analysis and Processing
To produce all necessary output files, download the entire package and follow these steps:

>**Note:** In this directory, we have a folder called [Programs_for_E4](Programs_for_E4) containing all the source codes used for data processing. Every script file used in this workflow contains detailed notes within comments to explain each step of the code for improved clarity.

### (1) Initial Data Processing
In this MATLAB-based workflow for processing data, we first extract the start and end times from each Empatica recording to create time vectors for every segment of raw data. To manage the varying sampling rates of the E4 device, we align data epochs by adjusting the sampling rates for EDA and skin temperature data to 4 Hz, while maintaining HR data at 1 Hz, and averaging the IBI for each epoch. VR headset timestamps, in UTC, are integrated with E4 data to pinpoint event markers and identify participant IDs. The data is then sorted by participant, and batch processing calculates metrics like HR and skin temperature changes from the baseline, average IBI deviations, and RMSSD from the baseline.

The Empatica E4 data is processed using the [script_gen_csv.m](script_gen_csv.m) file.
1. Simply run the [script_gen_csv.m](script_gen_csv.m) script to create the result files.
2. Once the script is done processing, a folder [results](results) will be generated with the processed data.

### (2) Ledalab for EDA analysis
For analyzing EDA, we utilize the continuous decomposition analysis (CDA) technique via the Ledalab V.3.4.9 toolbox, adhering to default settings for response windows (1-4 seconds post-stimulus), minimum amplitude thresholds (0.01 μS), and employing smoothing methods to calculate the mean skin conductance response (SCR), skin conductance level (SCL) fluctuations, and overall skin conductance (SC) for each participant. These metrics, alongside their deviations from the baseline, are extracted for further statistical analysis.

>**Note:** Ledalab software has been modified to ensure compatibility with Matlab 2023 version, while maintaining protection under the GNU General Public License.

To use Ledalab for EDA analysis, the custom version of LedaLab is made under the [ledalab-349](ledalab-349) folder. This version of Ledalab has been modified to work with the E4 data and newer versions of MATLAB.
1. The first step is to collect the EDA data files for batch processing. After running [script_gen_csv.m](script_gen_csv.m), the EDA data files will become available in the [data_batch_for_ledalab](data_batch_for_ledalab) folder.
2. Navigate in MATLAB into the [data_batch_ledalab_output](data_batch_ledalab_output) folder and run the [script_leda_lab_analysis.m](script_leda_lab_analysis.m) script. This will process the EDA data files in batch mode with the settings in the script. Note that Ledalab will export the result files in the current working directory, which is why it is recommended to modify the directory prior. Otherwise, it is possible to manually copy all the generated files named `_era.mat` into the correct folder
3. Run [script_gen_csv_eda.m](script_gen_csv_eda.m) to generate the output CSV files.

## Output structure
### Exported CSV File
After executing this script, a new CSV file will be generated containing batch-processed participant data for each metric. The structure of the CSV file may vary slightly depending on the metric, but it will always include raw values and differences from baseline. Below is an example structure for HR data of a random participant from an experiment with 15 scenes:
#### 1. participant_id: 
Unique identifier assigned to each individual to distinguish them while anonymizing their personal information.
#### 2. session_id: 
Information on the session number for experiments with multiple sessions, facilitating within-subject comparisons or continuous data collection over a specific time duration.
#### 3. scene_id: 
Identification of the scene number for experiments featuring multiple scenes for each participant within the experimental setup.
- 'baseline' refers to the resting period before the experiment, during which resting HR data for each participant is collected.
#### 4. scene_order:
Scene order information for experiments with pre-defined presentation sequence or randomized order.
#### 5. n_data_points: 
Number of data points collected for the specific segment of the session (in this case, for each scene number).
#### 6. min, max, range, median, mean, std: 
Minimum, maximum, range, median, mean, and standard deviation values for raw HR for each segment.
#### 7. mean_diff_baseline: 
Changes in HR recorded in beats per minute (BPM) from each participant's resting HR measured during the baseline period. A separate CSV file will be created focusing on HRV in terms of IBI and RMSSD.

```bash
    participant_id    session_id      scene_id      scene_order    scene_duration    n_data_points     min       max      range    median     mean       std      mean_diff_baseline
    ______________    __________    ____________    ___________    ______________    _____________    ______    ______    _____    ______    ______    _______    __________________
          1               1         {'baseline'}         0              298               150         80.095     84.95    4.855    82.263    82.338     1.2954              NaN
          1               1         {'1'       }        11               90                46          80.88      85.2     4.32     81.89    82.502     1.4095          0.16361
          1               1         {'2'       }        14               86                44         80.675    83.475      2.8    82.585    82.153    0.97305         -0.18495
          1               1         {'3'       }        10               75                38          83.16     84.75     1.59     83.96    83.916    0.44829           1.5782
          1               1         {'4'       }         6              104                53          80.74     86.83     6.09    83.765     83.72     1.7393           1.3819
          1               1         {'5'       }         4               82                42         81.925    85.925        4     84.67    84.229      1.353           1.8912
          1               1         {'6'       }         5               80                41          82.62     87.48     4.86     84.76    84.747     1.3504           2.4091
          1               1         {'7'       }        15               74                38         83.435     84.91    1.475    84.028    84.113    0.46631           1.7753
          1               1         {'8'       }         3               94                48          82.65     87.79     5.14    85.635    85.526     1.7262           3.1883
          1               1         {'9'       }         2               86                44          83.09     87.76     4.67    84.888    84.961     1.1539           2.6231
          1               1         {'10'      }         7               84                43             82    85.885    3.885    83.705    83.846     1.2231           1.5078
          1               1         {'11'      }         9              102                52          81.16     84.04     2.88     82.21    82.348      0.767          0.01004
          1               1         {'12'      }        13              104                53         81.595    86.055     4.46     83.86    83.627     1.1203           1.2891
          1               1         {'13'      }         1              127                64          81.25     85.05      3.8    82.558    82.692    0.83095          0.35413
          1               1         {'14'      }        12               94                48          82.84    86.265    3.425    84.078     84.35     1.0619           2.0114
          1               1         {'15'      }         8              124                63          81.37     85.94     4.57    84.315    83.944     1.7012            1.606
```
