# **Modeling and Optimizing a Battery Charging Profile** 
### Group 9 Internship Project
#### Description:

This MATLAB project models, simulates, and optimizes lithium-ion battery charging behavior using an RC (resistor-capacitor) circuit approximation. It includes interactive visualizations, energy and power analysis, resistive loss, temperature-based adjustments, and a comparison of constant current vs. constant voltage (CC-CV) charging strategies.

---
### Methods

We used the classic RC circuit model to simulate the battery charging process:

`V(t) = V_max * (1 - exp(-t / (R * C)))`

Using this model, we performed the following analyses:

- **Time to charge**: Calculated the time required to reach 80% and 100% of the maximum voltage.
- **Energy delivery**: Used numerical integration to determine total energy delivered to the battery.
- **Energy loss**: Estimated energy lost due to internal resistance using \( I^2R \).
- **Optimization**: Applied MATLAB's `fmincon` to optimize the charging time while keeping current within safety limits.

All battery parameters — including maximum voltage (Vmax), charge capacity (Qmax), and internal resistance (R) — were extracted from **Table 5** of the INELTRO lithium-ion battery datasheet included in the `/Dataset/` folder.

---

###  Folder Structure

#### `/Code/`
This folder contains all MATLAB scripts and the Live Script used for modeling and analysis.

- [`LiveScript_Matlab_Internship.mlx`](Code/LiveScript_Matlab_Internship.mlx): Main Live Script combining all modules for running the full project.
- [`Model_battery_Voltage`](Code/Model_battery_Voltage):  
  *Simple RC Charging Curve* — Visualizes voltage response of a basic RC circuit using `V(t) = Vmax(1 - exp(-t/RC))` with user-defined sliders.
- [`Fitting_Voltage_Curve`](Code/Fitting_Voltage_Curve):  
  *Fitted Curve* — Simulates RC charging to a user-specified charge percentage and computes the time needed to reach it.
- [`Energy_delivered`](Code/Energy_delivered):  
  *Total Energy Delivered To Battery* — Computes instantaneous power and integrates it over time to calculate total energy in joules.
- [`voltage_different_intervals`](Code/voltage_different_intervals):  
  *Rate of Voltage Change* — Computes dV/dt at different intervals of charging and calculates average change in each segment.
- [`Energy_lost_resistence`](Code/Energy_lost_resistence):  
  *Energy Lost Due to Resistance* — Models resistive losses with `I²R` and integrates to calculate total heat loss over time.
- [`Optimized_RC_Safety`](Code/Optimized_RC_Safety):
  *Optimized Charging With Safety Limits* — Uses optimization (`fmincon`) to find the RC value that minimizes time while keeping current under a safe threshold.
- [`Temp_Adjusted_Charging`](Code/Temp_Adjusted_Charging):  
  *Temperature Constraints* — Adjusts internal resistance based on temperature, recalculates charging profile, and flags unsafe temps.
- [`CC_CV_Comparison`](Code/CC_CV_Comparisons):  
  *CC-CV Comparison* — Compares Constant Current and Constant Voltage charging strategies with time, current, and energy results.

---

#### `/Dataset/`
- [`Lithium_Ion_Battery.pdf`](../Dataset/Lithium_Ion_Battery.pdf): Datasheet(Table 5) used to extract Vmax, Qmax, resistance, and safety parameters.

---

#### `/Media/`
Contains all visual output from the code as JPG figures:

- [`Simple Battery Charing Curve.jpg`](../Media/Simple_Battery_Charging_Curve.jpg) – General project diagram 
- [`Power_lost_over_time.jpg`](../Media/Power_lost_over_time.jpg) – Estimated power loss due to resistance 
- [`Power_vs_Time.jpg`](../Media/Power_vs_Time.jpg) – Power delivered to battery over time
- [`RC_Battery.jpg`](../Media/RC_Battery.jpg) – Standard RC charging curve
- [`RC_Battery_100.jpg`](../Media/RC_Battery_100.jpg) – RC curve to 100% charge
- [`current_vs_time.jpg`](../Media/current_vs_time.jpg) – Current over time in RC charging
- [`Voltage_vs_Time_for_Choosen_R_and_RC0.png`](../Media/Voltage_vs_Time_for_Choosen_R_and_RC0.png)-user-defined resistance (R) and time constant (RC0)
- [`Temp_Adjusted_Charging_Curve_at_25.png`](../Media/Temp_Adjusted_Charging_Curve_at_25.png)- how temperature affects resistance and charge time
- [`CC_vs_CV.png`](../Media/CC_vs_CV.png)-comparing CC (constant current) and CV (constant voltage) charging
  
---

### How to Run
You can run `.mlx` file in MATLAB as follows:
1. Open [`LiveScript_Matlab_Internship.mlx`](../Code/LiveScript_Matlab_Internship.mlx) in MATLAB.
2. Ensure that files from `/Code/` and `/Dataset/` are in the same working directory.
3. Click **Run All Sections** or run them interactively one-by-one.
4. View plots in the figures window, and save plots using:
```matlab
saveas(gcf, 'Media/your_plot_name.jpg');
```

 To run individual `.m` files:
- Click any script (e.g., [`Energy_delivered`](../Code/Energy_delivered)) → click **Raw** → copy into MATLAB and run.
---
### To view the code

Click on any `.m` or `.mlx` file and then click the **"Raw"** button to download or open it in MATLAB.

---

## Figures and Descriptions

#### Simple RC Charging Curve
This first section of [code](Code/Model_battery_Voltage) visualizes the voltage response of a simple RC (resistor-capacitor) charging
circuit over time, using user-defined inputs for maximum voltage (Vmax1), resistance (R1), and
capacitance (C1). These inputs are intended to be controlled via sliders in an interactive environment. The
voltage is calculated using the standard charging equation V(t)=Vmax(1-e-t/RC), and the simulation time
spans from 0 to 10 hours. The computed voltage values are plotted as a smooth curve, showing how the
voltage rises and asymptotically approaches Vmax1 over time, depending on the RC time constant. The
resulting plot includes labeled axes, a title, a legend, and a grid for readability. This [visualization](Media/Simple_Battery_Charging_Curve.jpg) provides
a clear and interactive way to understand how RC circuits behave during the charging process.

![Simple Battery Charging Curve](Media/Simple_Battery_Charging_Curve.jpg)

#### Fitted Curve
The next portion of code simulates and visualizes the voltage curve of a lithium battery charging through
an RC circuit, allowing users to select a target charge percentage (desired_pct) via a slider. The battery
parameters: maximum voltage (Vmax2), resistance (R2), and RC time constant (RC2) are used to
compute the capacitance (C2) and generate the voltage curve V(t)=Vmax(1-e-t/RC) over a time range of 0
to 5 hours. The user-specified charge percentage is validated to stay within realistic bounds (0–100%,
non-inclusive), and the time to reach that voltage is calculated analytically. The resulting plot displays the
charging curve and highlights the point in time where the battery reaches the desired percentage. Axis
labels, a title, grid lines, and a dynamic legend provide a clear and informative visualization. This block is
ideal for demonstrating how charging time varies with different target charge levels in lithium-ion battery
systems.

![RC Battery](Media/RC_Battery.jpg)
![RC Battery at 100 Percent](Media/RC_Battery_100.jpg)

#### Total Energy Delivered To Battery
Our next block calculates and visualizes the instantaneous power delivered to a battery during RC
charging over time. It defines a power function P(t) as the product of voltage and current in an RC circuit,
using the expressions for both as functions of time. The power values are evaluated across a time range
from 0 to 18,000 seconds and plotted to show how power delivery changes during the charging process.
The graph includes labeled axes, a title, grid, and legend for clarity. Additionally, the code computes the
total energy delivered to the battery by integrating the power function over the full charging period and
outputs the result in joules. This block provides insight into the dynamic power behavior and energy
transfer during RC-based battery charging.
![Instanteour Power vs Time](Media/Instanteous_Power_vs_Time.jpg)

#### Rate of Voltage Change
This code analyzes the rate of voltage change (dV/dt) during RC battery charging and breaks it down into
user-defined voltage intervals, controlled by a percentage slider (interval_pct). It computes the voltage
curve V(t) and its gradient dV/dt to approximate the charging current over time. The result is visualized in
a plot that shows how the current decreases as the battery charges. The code then divides the voltage
range (0%–100% of Vmax) into equal intervals and calculates the average dV/dt within each range. These
averages are printed to the console, offering insight into how charging speed varies across different
voltage levels. This block is useful for understanding current behavior and efficiency throughout the
charge cycle.

![Rate of Voltage Change over Time](Media/Rate_of_Voltage_Change_over_time_(current_vs_time).jpg)

#### Energy Lost Due to Resistance
The next section of code calculates and visualizes the power lost due to internal resistance during the
charging of an RC battery. It defines the time-dependent current I(t) and computes power loss as
P(t)=I(t)^2*R, representing resistive heating. The total energy lost over the entire charging duration
(T_end) is calculated using numerical integration and printed in joules. A plot is then generated showing
how resistive power loss decreases over time, with labeled axes, a title, legend, and grid for clarity. This
block provides a clear view of inefficiencies in the charging process due to resistive losses in the circuit.

![Power Lost over Time](Media/Power_lost_over_time.jpg)

#### Optimized Charging With Safety Limits
After that, the next block of code simulates RC battery charging and evaluates how optimal a
user-selected time constant (RC0) is for reaching 90% of the maximum voltage (Vmax). Using adjustable
sliders for resistance (R) and RC0, it calculates the voltage curve over time and checks whether the initial
charging current exceeds a safe limit (I_max). If safe, the code uses optimization (fmincon) to find the RC
value that minimizes time to reach 90% charge, then compares it to the user's RC0 to assess efficiency.
The resulting plot shows voltage vs. time, and printed feedback informs whether RC0 is near-optimal, too
high (slow charging), or too low (potentially unsafe). This block helps users balance fast charging and
battery protection through interactive parameter tuning.

![Chosen R and RC0](Media/Voltage_vs_Time_for_Chosen_R_and_RC0.png)

#### Temperature Constraints
To add to our previous block, our next section models the impact of temperature on lithium-ion battery
charging by adjusting internal resistance based on the user's input temperature (user_temp_C). It issues
warnings if the temperature is outside the safe range (0–60°C), then calculates the temperature-adjusted
resistance using a linear temperature coefficient. Using this resistance, it computes the corresponding
capacitance and simulates the charging voltage over time. The resulting plot shows how temperature
affects the charging curve, while console output reports the adjusted resistance, initial charging current,
and time constant. This helps visualize and quantify temperature-related non-ideal behavior in our
lithium-ion battery charging model.

![Temperature Constraints](Media/Temp_Adjusted_Charging_Curve_at_25.png)

#### CC-CV Comparison
Finally, our last section compares constant current (CC) and constant voltage (CV) charging methods for a
lithium-ion battery. It calculates voltage and current profiles over time for both methods, ensuring the
voltage doesn't exceed Vmax. For CC, it computes charging time based on reaching 99% of Vmax and
integrates power to find the total energy delivered. For CV, it models an exponentially decaying current,
with charging ending when current drops to a threshold value. The code then plots voltage and current
over time for both methods and prints out total charging time and energy consumption for each. This
allows for a visual and quantitative comparison of the two charging strategies, both of which work in
tandem to keep a battery cell fully operational when charging.

![CC and CV Comparison](Media/CC_vs_CV.png)


---

###  Contributions

**Marc Ajay Rajesh**: Worked on MATLAB advanced temperature analysis and facilitated team meetings.

**Louise Marie Maganto**: Provided framework for GitHub and worked on dv/dt voltage intervals. 

**Karthik Chennimalai Ganesh**: Worked on MATLAB optimization as well as integration under power curves. 

**Atanacia Sanchez**: Also helped in creating the GitHub project, readme.md, formatting energy and power curves.

---

###  References:
- [INELTRO Datasheet (Table 5)](../Dataset/Lithium_Ion_Battery.pdf)
- [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted)  
- [Optimization Onramp](https://matlabacademy.mathworks.com/details/optimization-onramp/optim)  
- [Simulink RC Circuit](https://www.mathworks.com/help/simscape/ug/rc-circuit-in-simulink-and-simscape.html)

---
