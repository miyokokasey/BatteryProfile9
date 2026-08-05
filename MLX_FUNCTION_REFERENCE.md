# MATLAB Live Script (.mlx) Function & Format Specifier Reference

This document catalogs every `fprintf`/`sprintf` format specifier and every built-in / toolbox function used across the project's `.mlx` Live Scripts, what each one does, and which script(s) it appears in. It's a supplement to [`README.md`](README.md) for readers who want to understand the MATLAB mechanics rather than the analysis results.

Scripts covered:

- `battery_dataset/data_extraction.mlx`
- `data_analysis_code/fitting_RCeq.mlx`
- `data_analysis_code/vIp_vs_t_eq.mlx`
- `data_analysis_code/rate_change_analysis.mlx`
- `data_analysis_code/charge_time.mlx`
- `data_analysis_code/total_energy_delivered.mlx`
- `data_analysis_code/resistive_energy_loss.mlx`
- `data_analysis_code/CC_CV_region.mlx`
- `data_analysis_code/energy_distribution_byPhase.mlx`
- `data_analysis_code/fitting_CC_CV.mlx`

---

## 1. `fprintf` / `sprintf` Format Specifiers

All console output and dynamically-built plot labels/legends in this project go through `fprintf` (prints to console) or `sprintf` (returns a string, used for plot titles, legends, `DisplayName`, and `text()` annotations). Both use the same C-style format-specifier syntax.

| Specifier | Meaning | Example in repo | Used in |
|---|---|---|---|
| `%d` | Integer, no decimals | `fprintf('...Cycle %d...', 1)` — prints the cycle number | `fitting_RCeq.mlx` |
| `%f` | Floating-point, default 6 decimal places | `sprintf('%f * (1 - exp(-t / tau))', Vmax)` — embeds a fixed numeric value directly into a `fittype` model string | `fitting_RCeq.mlx`, `fitting_CC_CV.mlx` |
| `%.1f` | Float rounded to 1 decimal place | `sprintf('Transition: t = %.1fs', t_trans)` | `CC_CV_region.mlx`, `energy_distribution_byPhase.mlx`, `fitting_RCeq.mlx` |
| `%.2f` | Float rounded to 2 decimal places | `fprintf('Transition Time: %.2f seconds...', t_trans)` | `CC_CV_region.mlx`, `charge_time.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `total_energy_delivered.mlx` |
| `%.4f` | Float rounded to 4 decimal places (the project's default precision for voltages, currents, energies, and fit statistics) | `fprintf('Transition Voltage: %.4f V\n', V_trans)` | `CC_CV_region.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `resistive_energy_loss.mlx`, `total_energy_delivered.mlx` |
| `%.6f` | Float rounded to 6 decimal places (used for very small values where 4 decimals would round to 0) | `fprintf('dV/dt at Transition: %.6f V/s\n', dVdt(transitionIdx))` | `CC_CV_region.mlx`, `resistive_energy_loss.mlx` |
| `%%` | Literal `%` character (escapes the `%` so it isn't parsed as a specifier) | `fprintf('...reach 80%% charge...\n', t_80)` prints `80%` | `charge_time.mlx`, `energy_distribution_byPhase.mlx` |
| `\n` | Newline escape | Ends nearly every `fprintf` string; `\n\n` is used for a blank line between report sections | All scripts using `fprintf`/`sprintf` |

**Note on LaTeX escapes:** several `sprintf` calls also contain doubled backslashes like `\\tau` or `\\cdot` (e.g. `sprintf('Fit: V(t) [\\tau_{CC} = %.2f s]', tau_cc)` in `fitting_CC_CV.mlx`). These aren't `fprintf` format specifiers — `\\` simply produces a literal single backslash (`\tau`, `\cdot`) in the resulting string, which MATLAB's `tex` text interpreter then renders as the Greek letter τ or a multiplication dot in plot titles/legends.

---

## 2. Built-in & Toolbox Functions

### Data acquisition & loading

| Function | What it does | Used in |
|---|---|---|
| `matlab.internal.examples.downloadSupportFile` | Downloads a MathWorks example support file (here, the zipped battery dataset) to a local cache and returns its path | All 10 scripts |
| `unzip` | Extracts the downloaded `.zip` archive into the current folder | All 10 scripts |
| `load` | Loads variables (here, the `data` table) from a `.mat` file into the workspace | All 10 scripts |
| `head` | Displays the first N rows of a table, for quick inspection | `data_extraction.mlx` |
| `height` | Returns the number of rows in a table | `data_extraction.mlx` |

### Battery data parsing (Predictive Maintenance Toolbox)

| Function | What it does | Used in |
|---|---|---|
| `batteryTestDataParser` | Constructs a parser object that maps raw table columns (current, voltage, time, cycle index, step index) to standardized fields so the data can be segmented | All 10 scripts |
| `segmentData` | Method called on a `batteryTestDataParser` object; splits the raw table into a segmented table labeled by `CyclingPhases` (Charge/Discharge/Rest) and cycle/step index | All 10 scripts |

### Time & duration handling

| Function | What it does | Used in |
|---|---|---|
| `seconds` | Converts a `duration` value (or a difference between two `datetime`s) into a plain numeric value in seconds | All 10 scripts — used to build `chargingData.TimeInSeconds = seconds(chargingData.DateTime - chargingData.DateTime(1))` |

### Numerical analysis

| Function | What it does | Used in |
|---|---|---|
| `find` | Returns the index/indices where a logical condition is true; used throughout to locate the CC→CV transition point or specific charge-percentage thresholds | `CC_CV_region.mlx`, `charge_time.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `rate_change_analysis.mlx` |
| `gradient` | Computes a numerical derivative (central differences) of a vector, used to get `dV/dt` from discrete voltage/time samples | `CC_CV_region.mlx`, `rate_change_analysis.mlx` |
| `trapz` | Trapezoidal numerical integration; integrates power over time to get energy in joules | `energy_distribution_byPhase.mlx`, `resistive_energy_loss.mlx`, `total_energy_delivered.mlx` |
| `diff` | Computes the difference between consecutive elements of a vector; combined with `sign`, used to detect where a slope changes direction | `rate_change_analysis.mlx` |
| `sign` | Returns the sign (-1, 0, +1) of each element; used with `diff` to flag slope sign-flips (direction-change points) | `rate_change_analysis.mlx` |
| `abs` | Absolute value; used to find the index closest to a target value via `min(abs(x - target))` | `fitting_CC_CV.mlx`, `fitting_RCeq.mlx` |
| `exp` | Exponential function `e^x`; the core of the RC charging model `V(t) = Vmax*(1-exp(-t/tau))` and the CV current-decay model `I(t) = I0*exp(-t/tau)` | `fitting_RCeq.mlx`, `fitting_CC_CV.mlx` |
| `min` / `max` | Minimum/maximum of a vector (or, with two outputs, value and index); used for axis limits, peak values, and nearest-point search | `CC_CV_region.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `charge_time.mlx` |
| `round` | Rounds to the nearest integer; used to compute evenly-spaced sample indices | `data_extraction.mlx` |
| `linspace` | Generates a linearly-spaced vector of N points between two bounds; used to build smooth time vectors for plotting fitted curves | `data_extraction.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx` |
| `zeros` | Creates an array of zeros; used to build the baseline edge of a shaded `patch` region | `energy_distribution_byPhase.mlx` |
| `flipud` | Flips a column vector top-to-bottom; used to build a closed polygon outline (forward path + reversed baseline) for `patch` | `energy_distribution_byPhase.mlx` |

### Curve Fitting Toolbox

| Function | What it does | Used in |
|---|---|---|
| `fittype` | Defines a custom nonlinear model (as a string equation, e.g. `'I0 * exp(-t / tau_cv)'`) with named coefficients to fit | `fitting_RCeq.mlx`, `fitting_CC_CV.mlx` |
| `fitoptions` | Creates a fit-options object where starting guesses (`StartPoint`) and bounds (`Lower`, `Upper`) are set before fitting, so the solver converges to a physically reasonable answer | `fitting_RCeq.mlx`, `fitting_CC_CV.mlx` |
| `fit` | Runs the nonlinear least-squares fit given data, a `fittype`, and `fitoptions`; returns the fitted model object and a goodness-of-fit struct (`rsquare`, `adjrsquare`, `rmse`, `sse`) | `fitting_RCeq.mlx`, `fitting_CC_CV.mlx` |

### Tables & console output

| Function | What it does | Used in |
|---|---|---|
| `table` | Constructs a table from named vectors/columns, here used to build a summary of dV/dt at key charge percentages | `rate_change_analysis.mlx` |
| `disp` | Prints a value (here, a table) to the console without a format string | `rate_change_analysis.mlx` |
| `fprintf` | Formatted print to the console (see specifier table above) | `CC_CV_region.mlx`, `charge_time.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `resistive_energy_loss.mlx`, `total_energy_delivered.mlx` |
| `sprintf` | Formatted print into a string variable instead of the console — used to build dynamic titles, legend entries, and annotation text (see specifier table above) | `CC_CV_region.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx` |

### Plotting & visualization

| Function | What it does | Used in |
|---|---|---|
| `figure` | Opens a new figure window (optionally named via `'Name'`) for plotting | `CC_CV_region.mlx`, `data_extraction.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `vIp_vs_t_eq.mlx` |
| `plot` | Draws a 2-D line/marker plot of one vector against another | `CC_CV_region.mlx`, `data_extraction.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `vIp_vs_t_eq.mlx` |
| `subplot` | Divides a figure into a grid of axes and selects one to plot into, used to stack voltage/current/power (or CC/CV fit) plots vertically | `vIp_vs_t_eq.mlx`, `fitting_CC_CV.mlx` |
| `yyaxis` | Switches between a left and right y-axis on the same plot, letting voltage and current share one time axis with independent scales | `CC_CV_region.mlx` |
| `xlabel` / `ylabel` | Labels the x-axis / y-axis of the current plot | `CC_CV_region.mlx`, `data_extraction.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `vIp_vs_t_eq.mlx` |
| `title` | Sets the title of the current axes (often built dynamically with `sprintf`) | `CC_CV_region.mlx`, `data_extraction.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `vIp_vs_t_eq.mlx` |
| `sgtitle` | Sets one overall title spanning all subplots in a figure | `vIp_vs_t_eq.mlx` |
| `legend` | Displays a legend for the plotted series, using each plot's `DisplayName` (or explicit labels/`'Location'`) | `CC_CV_region.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `vIp_vs_t_eq.mlx` |
| `grid` | Toggles the axes grid lines on/off (`grid on`) | `CC_CV_region.mlx`, `data_extraction.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx`, `vIp_vs_t_eq.mlx` |
| `box` | Toggles the axes outline box on/off (`box on`) | `rate_change_analysis.mlx` |
| `hold` | Keeps the current plot in place so subsequent `plot` calls overlay it instead of replacing it (`hold on` / `hold off`) | `CC_CV_region.mlx`, `data_extraction.mlx`, `energy_distribution_byPhase.mlx`, `fitting_CC_CV.mlx`, `fitting_RCeq.mlx`, `rate_change_analysis.mlx` |
| `ylim` | Manually sets the y-axis display range | `CC_CV_region.mlx` |
| `xline` / `yline` | Draws a vertical / horizontal reference line at a given x or y value, optionally labeled | `CC_CV_region.mlx` |
| `patch` | Draws a filled, semi-transparent polygon; used to shade the CC and CV regions of a plot | `CC_CV_region.mlx`, `energy_distribution_byPhase.mlx` |
| `text` | Places a text annotation at a specific data coordinate on the plot | `energy_distribution_byPhase.mlx`, `rate_change_analysis.mlx` |

---

## Quick lookup by script

| Script | Notable functions beyond the shared load/parse boilerplate |
|---|---|
| `data_extraction.mlx` | `head`, `height`, `round`, `linspace`, basic `plot` |
| `fitting_RCeq.mlx` | `exp`, `fittype`, `fitoptions`, `fit`, `abs`, `min`, `linspace` |
| `fitting_CC_CV.mlx` | Same as above, applied twice (CC voltage fit + CV current fit), plus `subplot` |
| `vIp_vs_t_eq.mlx` | `subplot`, `sgtitle` for the 3-panel V/I/P plot |
| `rate_change_analysis.mlx` | `gradient`, `diff`, `sign`, `table`, `disp`, `box` |
| `charge_time.mlx` | `find` against 80%/100% voltage thresholds, `%%` literal-percent formatting |
| `total_energy_delivered.mlx` | `trapz` on `P = I .* V` |
| `resistive_energy_loss.mlx` | `trapz` on `P_loss = I.^2 .* R` |
| `CC_CV_region.mlx` | `yyaxis`, `xline`/`yline`, `patch`, `ylim` |
| `energy_distribution_byPhase.mlx` | `trapz` split by region, `patch`, `flipud`, `zeros`, `text` |
