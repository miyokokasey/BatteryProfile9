function  hPlotRawMeasurementsWithSegments(data, parser, cycleIndex, colorList)
% HPLOTRAWMEASUREMENTSWITHSEGMENTS - Helper function to plot the raw data
% with segments. The data has CyclingModes column to indicate the data
% points cycling modes
arguments
    data
    parser
    cycleIndex
    colorList =  [1 0 0;0 0 1;0 1 0;0.9290 0.6940 0.1250]
end
cycleData = data(data.(parser.CycleIndexVariable) == cycleIndex, :);
V = cycleData.(parser.VoltageVariable);
I = cycleData.(parser.CurrentVariable);
t = seconds(cycleData.(parser.TimeVariable) - cycleData.(parser.TimeVariable)(1));
modes = cycleData.CyclingModes;

figure;
subplot(211)
plot(t, V,'k','LineWidth',1, 'Displayname','data');
hold on
gscatter(t, V, modes, colorList)
xlabel('Time [s]');
ylabel('Voltage [V]');
legend('Location','eastoutside');

subplot(212)
plot(t, I,'k','LineWidth', 1, 'Displayname','data');
hold on
gscatter(t, I, modes, colorList)
xlabel('Time [s]');
ylabel('Current [A]');
legend('Location','eastoutside');
hold off
sgtitle(['Measurements during Cycle ',  num2str(cycleIndex)],'FontSize', 11);
end

