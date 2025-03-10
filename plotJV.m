clear; clc; close all;
area_cm2 = 0.045;
numIntensities = 12;
intensityPercentages = [1, 3, 10, 16, 25, 32, 40, 50, 63, 79, 93, 100];

data = xlsread('Group 1 ELEC0148_Data.xlsx');

for i = 1:numIntensities
    voltageCol = (i-1)*4 + 1;
    currentCol = (i-1)*4 + 2;
    voltage_V = data(:, voltageCol);
    current_A = data(:, currentCol);
    validIdx = ~isnan(voltage_V) & ~isnan(current_A);
    voltage_V = voltage_V(validIdx);
    current_A = current_A(validIdx);
    currentDensity_mA_cm2 = (current_A / area_cm2) * 1e3;
    
    figure;
    plot(voltage_V, currentDensity_mA_cm2, 'o-', 'LineWidth', 1.5);
    hold on;
    grid on;
    
    set(gca, 'LineWidth', 2, 'FontWeight', 'bold', 'XColor', 'k', 'YColor', 'k');
    xlabel('Voltage (V)', 'FontWeight', 'bold', 'FontSize', 14);
    ylabel('Current Density (mA/cm^2)', 'FontWeight', 'bold', 'FontSize', 14);
    xline(0, 'Color', 'yellow', 'LineWidth', 2);
    yline(0, 'Color', 'yellow', 'LineWidth', 2);

    Voc = interp1(currentDensity_mA_cm2, voltage_V, 0, 'linear');
    Isc = interp1(voltage_V, currentDensity_mA_cm2, 0, 'linear');
    
    dx_offset = 0.05 * (max(voltage_V) - min(voltage_V));
    dy_offset = 0.05 * (max(currentDensity_mA_cm2) - min(currentDensity_mA_cm2));
    
    plot(Voc, 0, 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(Voc - dx_offset, 0 + dy_offset, ['V_{oc} = ', num2str(Voc, '%.2f'), ' V'], ...
         'Color', 'r', 'FontWeight', 'bold');
    plot(0, Isc, 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
    text(0 - 1.5*dx_offset, Isc + dy_offset, ['J_{sc} = ', num2str(Isc, '%.2f'), ' mA/cm^2'], ...
         'Color', 'b', 'FontWeight', 'bold');

    region = (voltage_V >= 0 & voltage_V <= Voc) & (currentDensity_mA_cm2 <= 0 & currentDensity_mA_cm2 >= Isc);
    
    if any(region)
        power_region = voltage_V(region) .* currentDensity_mA_cm2(region);
        [minPower, idx_region] = min(power_region);
        idx_candidates = find(region);
        idx_mp = idx_candidates(idx_region);
        V_mp = voltage_V(idx_mp);
        I_mp = currentDensity_mA_cm2(idx_mp);

        plot(V_mp, I_mp, 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
        dx_mp = 0.25 * (max(voltage_V) - min(voltage_V));  
        dy_mp = 0.05 * (max(currentDensity_mA_cm2) - min(currentDensity_mA_cm2));
        text(V_mp - dx_mp, I_mp + dy_mp, ['V_{mp} = ', num2str(V_mp, '%.2f'), ' V' newline 'I_{mp} = ', num2str(I_mp, '%.2f'), ' mA/cm^2'], ...
             'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', 'k', 'FontWeight', 'bold');
    else
        disp(['No valid MPP region found for intensity ', num2str(intensityPercentages(i)), '%.']);
    end
    
    title(['J–V Curve at ', num2str(intensityPercentages(i)), '% Intensity'], 'FontWeight', 'bold', 'FontSize', 16);
    
    hold off;
end
