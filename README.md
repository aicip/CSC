# Multi-event Analysis for Large-scale Power System through Cluster-based Sparse Coding
Accurate event analysis in real time is of paramount importance for high-fidelity situational awareness such that proper actions can take place before any isolated faults escalate to cascading blackouts. Existing approaches are limited to detecting only single or double events or a specified event type. The proposed algorithm Cluster-based Sparse Coding (**CSC**) can extract all the underlying single events involved in a multi-event scenario.

## Pre-requisite
* Matlab (tested on Matlab R2015a)

## Dataset:
The “NPCC” testbed is based on a 48-machine (140 buses) system of 28 GW of load. This model represents the NPCC region covering the whole or parts of ISO-NE, NYISO, PJM, MISO and IESO. These simulations are done based on the “NPCC” testbed which is a reduced model of the real system, using Power System Simulator for Engineering (PSS/E).

Based on NPCC test dataset, we generated single event cases (S1C), double event cases (M2C) and triple event cases (M3C). Roughly, over 100 testing samples are created for each type of case.

![NPCC.jpeg](https://bitbucket.org/repo/Lg4jdo/images/4100919883-NPCC.jpeg)


## Functions
### Main Functions
* [`demo_FreqUnmixing_all.m`](https://bitbucket.org/aicip/csc/src/d7b97ffaad76d9b6b5b8001b91de4bfd169f91d1/demo_FreqUnmixing_all.m?fileviewer=file-view-default): the main function to run the demo
* `normalization.m`: z-score normalization
* `sparsecoding.m`: calculate the sparse coefficient
* `bulidingdictionary_all`: using "time shift" to generate root patterns

### Performance Calculation
* `falserate.m`:calculate the false alarm rate
* `accuracy.m`: calculate the accuracy
* `RPRecog.m`: calculate the pattern recognition rate
* `OTDelay.m`: calculate the delay time

### Plotting
* `plot_reconsturct.m`: show reconstruction of the input signals
* `plot_endmembers.m`: show the endmembers learned from sparse coding
* `plot_bar.m`: show the sparse coefficients

## Run the Demo
```
>> demo_FreqUnmixing_all
```

## Results
### Performance Metrics
* **Detection accuracy (DA)**: ratio between the number of correctly detected root events/faults and the number of total root events/faults according to the ground truth.
* **False alarm rate (FA)**: ratio between the number of detected root events/faults not actually happened and the total number of root events/faults according to the ground truth.
* **Root-pattern recognition rate (RPR)**: ratio between the number of correctly identified events (i.e., events with the correct type of root-pattern) and the number of correctly detected events.
* **Occurrence time deviation (OTD)**: deviation between the detected occurrence time and the ground truth.

### Experimental Results
|Event Type|Total Case|DA (%)|FA (%)|RPR (%)|OTD (sec)|
|:---:|:---:|:---:|:---:|:---:|:---:|
| S1C | 144 | 100.0 | 0.00 | 100.0 | 0.123 |
| M2C | 115 | 95.65 | 2.17 | 98.64 | 0.193 |
| M3C | 138 | 91.55 | 0.97 | 98.15 | 0.202 |

## Citation
Please cite the following paper if it helps your research.
```
@article{song2017multiple,
  title={Multiple Event Detection and Recognition for Large-scale Power Systems through Cluster-based Sparse Coding},
  author={Song, Yang and Wang, Wei and Zhang, Zhifei and Qi, Hairong and Liu, Yilu},
  journal={IEEE Transactions on Power Systems},
  year={2017},
  publisher={IEEE}
}
```

```
@inproceedings{yang2015smartgridcomm,
  title={Multiple Event Analysis for Large-scale Power Systems Through Cluster-based Sparse Coding},
  author={Song, Yang and Wang, Wei and Zhang, Zhifei and Qi, Hairong and Liu, Yilu},
  booktitle={Smart Grid Communications (SmartGridComm), 2015 IEEE International Conference on},
  year={2015},
  organization={IEEE}
}
```

## Email
If there are any questions, please email <ysong18@utk.edu>.