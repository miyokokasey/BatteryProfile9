# BatteryProfile9
MATLAB simulation and analysis framework modeling lithium-ion battery charging profiles using a first-order RC equivalent circuit model with numerical integration.

# Lithium-Ion Battery Charging Profile Modeling and Analytics

## Project Motivation
Understanding battery charging dynamics is critical for applications like electric vehicles, drones, and consumer electronics. Because a battery’s charging curve involves complex, non-linear changes in current and voltage over time, this project applies principles of electric circuits, energy transfer, and numerical calculus to model charging behavior, evaluate efficiency, and inform the design of safe charging systems.

## Project Description
This engineering project uses MATLAB to model a lithium-ion battery charging profile as a simple, first-order RC-circuit analog (capacitor charging). By utilizing real time-series battery cycling data, the system evaluates model fit, computes energy transfer via numerical integration, and quantifies performance efficiency losses.

## Core Tasks
1. **Mathematical Curve Fitting:** Uses the MATLAB Curve Fitting Toolbox to fit the exponential equation \(V(t) = V_{max}(1 - e^{-t/RC})\) to estimate the unknown RC time constant (\(\tau\)) against a fully charged target of 3.6V.
2. **Electrical Visualization:** Generates a unified figure with three synchronized subplots tracking Voltage vs. Time, Current vs. Time, and Power vs. Time (\(P = I \times V\)).
3. **Numerical Differentiation:** Performs a rate-of-change analysis via the `gradient` function to calculate derivatives across intervals and compute exact times to reach 80% and 100% state of charge.
4. **Numerical Integration:** Employs the trapezoidal rule (`trapz`) to calculate the total energy delivered (area under the power-time curve).
5. **Efficiency Loss Estimation:** Estimates total resistive energy dissipation via Joule's heating formula (\(P_{loss} = I^2 \times R\)).

## Directory Structure
```text
├── data/              # MathWorks Lithium-Ion battery cycling datasets
├── scripts/           # BatteryCharging_StudentProjectTemplate.mlx & helper functions
├── outputs/           # Generated plots (voltage, current, power) and summary table
├── .gitignore         # MATLAB specific tracking rules
└── README.md          # Project documentation
```

## How to Run the Project
1. Clone this repository to your local machine.
2. Ensure MATLAB and the **Curve Fitting Toolbox** are installed.
3. Open and run the Live Script: `scripts/BatteryCharging_StudentProjectTemplate.mlx`.

## Summary of Results
*(Populate this table with your calculated numerical values upon script execution)*.

| Analytical Metric | Value |
| --- | --- |
| Estimated RC Time Constant ($\tau$) | `[Insert Value]` |
| Time to 80% Charge | `[Insert Value]` |
| Time to 100% Charge | `[Insert Value]` |
| Total Energy Delivered | `[Insert Value]` |
| Estimated Resistive Energy Loss | `[Insert Value]` |
| R-squared (Goodness of Fit) | `[Insert Value]` |
