# **Modeling and Analyzing a Lithium-Ion Battery Charging Profile**
### Group 9 Internship Project
#### Description:

This MATLAB project models and analyzes the charging behavior of a lithium-ion battery cell using real cycling data from MathWorks' single-cell battery aging dataset. It fits the data to a first-order RC (resistor-capacitor) circuit analog, then uses numerical differentiation and integration to quantify charge time, energy delivered, resistive energy loss, and the rate of voltage change throughout a charging cycle.

---
### Methods

The battery's charging voltage is modeled with the classic RC charging equation:

`V(t) = Vmax * (1 - exp(-t / RC))`

Real measurements (current, voltage, time) are loaded from `singleCellLifeTimeData.mat`, parsed and segmented into charge/discharge phases with the Predictive Maintenance Toolbox's `batteryTestDataParser`, then used to:

- **Fit the RC model**: Use the Curve Fitting Toolbox (`fit`) to estimate the time constant `tau = R * C` against a fixed Vmax of 3.6 V.
- **Compute charge time**: Find the elapsed time to reach 80% and 100% of Vmax.
- **Analyze rate of voltage change**: Use `gradient` to compute dV/dt at the 50%, 80%, and 100% charge points and flag direction-change transitions (e.g., CC → CV taper).
- **Compute total energy delivered**: Integrate power (`P = I * V`) over time with `trapz` to get energy in joules and watt-hours.
- **Estimate resistive energy loss**: Integrate `P_loss = I^2 * R` (using the dataset's internal resistance measurements) over time to quantify heat losses.
- **Visualize voltage, current, and power**: Plot all three vs. time as synchronized subplots for one charging cycle.

---

### Folder Structure

#### `/data_analysis_code/`
MATLAB Live Scripts performing the core analysis, each loading and segmenting the cycle-1 charging data before running its analysis:

- [`fitting_RCeq.mlx`](data_analysis_code/fitting_RCeq.mlx): Fits the RC charging equation to the measured voltage curve and reports the fitted time constant and goodness-of-fit statistics (R², RMSE, SSE).
- [`charge_time.mlx`](data_analysis_code/charge_time.mlx): Calculates the time required to reach 80% and 100% state of charge.
- [`rate_change_analysis.mlx`](data_analysis_code/rate_change_analysis.mlx): Computes dV/dt across the charging window and summarizes the rate of voltage change at the 50%, 80%, and 100% charge points.
- [`total_energy_delivered.mlx`](data_analysis_code/total_energy_delivered.mlx): Integrates power over time to compute total energy delivered to the battery (J and Wh).
- [`resistive_energy_loss.mlx`](data_analysis_code/resistive_energy_loss.mlx): Integrates I²R power loss over time to estimate total resistive energy loss (J and Wh).
- [`vIp_vs_t_eq.mlx`](data_analysis_code/vIp_vs_t_eq.mlx): Plots voltage, current, and power vs. time as three subplots for one charging cycle.

---

#### `/battery_dataset/`
Contains the raw dataset and the scripts used to download, load, and parse it:

- [`data_extraction.mlx`](battery_dataset/data_extraction.mlx): Downloads the MathWorks single-cell battery aging dataset, loads it, and demonstrates parsing/segmenting it with `batteryTestDataParser`.
- [`hPlotRawMeasurementsWithSegments.m`](battery_dataset/hPlotRawMeasurementsWithSegments.m): Helper function that plots raw voltage and current for a given cycle, colored by cycling mode/segment.
- `singleCellLifeTimeData.mat`: The battery cycling dataset (voltage, current, temperature, cycle/step index, and derived internal resistance for a single lithium-ion cell cycled to 80% state of health under fast-charging conditions).
- `license.txt`: License (CC BY 4.0) for the dataset, provided by MathWorks.
- `Examples/R2026a/supportfiles/predmaint/batteryagingdata/singlecell/v1/singleCellLifeTimeData.zip`: Cached copy of the dataset archive downloaded by MATLAB's `matlab.internal.examples.downloadSupportFile`.

---

#### Root files
- [`singleCellLifeTimeData.mat`](singleCellLifeTimeData.mat): Copy of the dataset used by the analysis scripts.
- [`license.txt`](license.txt): CC BY 4.0 license text for the dataset.
- [`LICENSE`](LICENSE): MIT license covering this project's code.

---

### How to Run
You can run any `.mlx` Live Script directly in MATLAB:
1. Clone this repository to your local machine.
2. Ensure MATLAB is installed with the **Predictive Maintenance Toolbox** (for `batteryTestDataParser`) and the **Curve Fitting Toolbox** (for `fitting_RCeq.mlx`).
3. Open a script from [`/data_analysis_code/`](data_analysis_code) in MATLAB — each script downloads/loads the dataset itself via `matlab.internal.examples.downloadSupportFile`, so no manual setup is required.
4. Click **Run All Sections**, or run sections interactively one-by-one to inspect intermediate results and plots.

To inspect the raw dataset directly, open [`data_extraction.mlx`](battery_dataset/data_extraction.mlx) first.

---

###  Contributors

Based on the repository's commit history:

- **miyokokasey**
- **AngeloB06**
- **viviingn**
- **Asher Vicera**

---

###  References:
- [MathWorks Predictive Maintenance Toolbox — Battery Aging Dataset](https://www.mathworks.com/help/predmaint/) — source of `singleCellLifeTimeData.mat`, licensed under CC BY 4.0.
- [MATLAB Curve Fitting Toolbox Documentation](https://www.mathworks.com/help/curvefit/)
- [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted)

---
