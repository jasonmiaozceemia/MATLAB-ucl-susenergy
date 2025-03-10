clear; clc; close all;

area_cm2 = 0.045;
numIntensities = 12;
intensityPercentages = [1, 3, 10, 16, 25, 32, 40, 50, 63, 79, 93, 100];

data = xlsread('Group 1 ELEC0148_Data.xlsx');


figure;
hold on;
grid on;

for i = 1:numIntensities

    voltageCol = (i-1)*4 + 1;
    currentCol = (i-1)*4 + 2;
    
    voltage_V = data(:, voltageCol);
    current_A = data(:, currentCol);
    
    validIdx = ~isnan(voltage_V) & ~isnan(current_A);
    voltage_V = voltage_V(validIdx);
    current_A = current_A(validIdx);
    
    currentDensity_mA_cm2 = (current_A / area_cm2) * 1e3;
    
    plot(voltage_V, currentDensity_mA_cm2, '-', 'LineWidth', 1.5);
end

xlabel('Voltage (V)', 'FontSize', 14);
ylabel('Current Density (mA/cm^2)', 'FontSize', 14);
title('J–V Curves at Different Intensities', 'FontSize', 18);


legendStrings = arrayfun(@(p) [num2str(p) '%'], intensityPercentages, 'UniformOutput', false);
legend(legendStrings, 'Location', 'best');

hold off;
