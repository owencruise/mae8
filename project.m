clear all;
close all;
clc;
format long;

name = 'Owen Cruise';
hw_num = 'project';

global R; %Radius of Earth

%% Task 1: Generate and store time, pos, & vel vectors for each satellite
sats = cell(6); %Cell array to hold satellite data
for id = 1:6
    sats{id, 1} = id;
    
    % Read initial conditions using function read_input
    [Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust] = ...
        read_input('satellite_data.txt', id);
    
    % Generate resultant vectors using function satellite
    [T, X, Y, Z, U, V, W] = satellite(Xo, Yo, Zo, Uo, Vo, Wo,...
        tstart, tend, maxthrust);
    
    sats{id, 2} = T; %Time
    sats{id, 3} = X; %X position
    sats{id, 4} = Y; %Y position
    sats{id, 5} = Z; %Z position
    sats{id, 6} = U; %Velocity in the X-direction
    sats{id, 7} = V; %Velocity in the Y-direction
    sats{id, 8} = W; %Velocity in the Z-direction
    
    Al = []; %Acceleration
    for n = 1:length(T)
        % Distance from center of Earth minus radius of Earth
        Al(n) = sqrt(X(n)^2 + Y(n)^2 + Z(n)^2) - R;
    end
    sats{id, 9} = Al;
    
    S = []; %Speed
    for n = 1:length(T)
        % Square-root sum of squares of velocity components
        S(n) = sqrt(U(n)^2 + V(n)^2 + W(n)^2);
    end
    sats{id, 10} = S;
    
    Ac = diff(S) ./ diff(T); %Acceleration using derivative of speed
    sats{id, 11} = Ac;
    
end



%% Task 2, Figure 1: Plot trajectories
figure(1);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]); %Fullscreen
colors = ['b', 'y', 'r', 'm', 'k', 'g'];
accents = ['k', 'r', 'b', 'g', 'm', 'c']; %Colors used in Pham's animation

for id = 1:6
    
    %Retrieve position vectors
    X = sats{id, 3};
    Y = sats{id, 4};
    Z = sats{id, 5};
    
    subplot(2, 3, id);
    hold on;
    plot_earth; %Plot Earth's topography
    % Divide by 1e6 because units of plot_earth are in millions
    plot3(X/(1e6), Y/(1e6), Z/(1e6), colors(id), 'LineWidth', 3);
    plot3(X(end)/1e6, Y(end)/1e6, Z(end)/1e6, '.', 'color', accents(id),...
        'MarkerSize', 37);
    view(3); %Maintain 3D view
    hold off;
    
    title_st = sprintf('Satellite #%i', id);
    title(title_st);
    legend_st1 = sprintf('Sat. #%i''s orbit', id);
    legend_st2 = sprintf('Sat. #%i''s final position', id);
    legend('Earth', legend_st1, legend_st2, 'location', 'north');
    
end



%% Task 2, Figure 2: Plot altitude, speed, & acceleration vs. time
figure(2);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]); %Fullscreen

subplot(3, 1, 1);
hold on;

for id = 1:6
    % In sats, second column is time; ninth column is altitude
    plot(sats{id, 2}, sats{id, 9}, colors(id));
end

hold off;
title('Altitude vs. Time');
xlabel('Time (s)');
ylabel('Altitude (m)');
legend('Sat 1', 'Sat 2', 'Sat 3', 'Sat 4', 'Sat 5', 'Sat 6', 'location',...
    'west');


subplot(3, 1, 2);
hold on;

for id = 1:6
    % In sats, second column is time; tenth column is speed
    plot(sats{id, 2}, sats{id, 10}, colors(id));
end

hold off;
title('Speed vs. Time');
xlabel('Time (s)');
ylabel('Speed (m/s)');
legend('Sat 1', 'Sat 2', 'Sat 3', 'Sat 4', 'Sat 5', 'Sat 6', 'location',...
    'west');


subplot(3, 1, 3);
hold on;

for id = 1:6
    % Function diff reduces the length of Ac by 1;
    % trim last element of T to compensate
    T_lessone = sats{id, 2}(1:end - 1);
    
    % In sats, second column is time; eleventh column is acceleration
    plot(T_lessone, sats{id, 11}, colors(id));
end

hold off;
title('Acceleration vs. Time');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
legend('Sat 1', 'Sat 2', 'Sat 3', 'Sat 4', 'Sat 5', 'Sat 6', 'location',...
    'west');



%% Task 2, figure 3: Plot acceleration vs. speed
figure(3);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]); %Fullscreen
hold on;
for id = 1:6
    % Function diff reduces the length of Ac by 1;
    % trim last element of S to compensate
    S_lessone = sats{id, 10}(1:end - 1);
    
    % In sats, tenth column is speed; eleventh column is acceleration 
    plot(S_lessone, sats{id, 11}, colors(id));
end
hold off;
title('Acceleration vs. Speed')
xlabel('Speed (m/s)');
ylabel('Acceleration (m/s^2)');
legend('Sat 1', 'Sat 2', 'Sat 3', 'Sat 4', 'Sat 5', 'Sat 6', 'location',...
    'best');



%% Task 3: Create data structure
% Retrieve vectors
for id = 1:6
    [T, X, Y, Z, U, V, W, Al, S, Ac] = deal(sats{id, 2}, sats{id, 3},...
        sats{id, 4}, sats{id, 5}, sats{id,  6}, sats{id,  7},...
        sats{id, 8}, sats{id, 9}, sats{id, 10}, sats{id, 11});
    
    % Find local maxima in altitude throughout satellite orbit
    maxct = 1;
    for n = 2:length(Al) - 1
        if Al(n) > Al(n-1) && Al(n) > Al(n+1)
            lmax_alt(maxct) = Al(n);
            lmax_t(maxct)   =  T(n);
            maxct = maxct + 1;
        end
    end
    
    % Populate data structure
    stat(id) = struct(...
                       'sat_id',  id,...
                     'end_time',  T(end),...
               'final_position', [X(end) Y(end) Z(end)],...
               'final_velocity', [U(end) V(end) W(end)],...
                    'max_speed',  max(S),...
                    'min_speed',  min(S),...
           'time_lmax_altitude',  lmax_t,...
        'orbital_period_before',  lmax_t(2) - lmax_t(1),...
         'orbital_period_after',  lmax_t(end) - lmax_t(end - 1));
end



%% Task 4: Generate report
fid = fopen('report.txt', 'w');
fprintf(fid, '%s\n%s\n', 'Owen Cruise');
fprintf(fid, '%s\n', ['sat_id max_speed min_speed orbital_period_before'...
    ' orbital_period_after']);

% Format data
for id = 1:6
    fprintf(fid, '%i %15.9e %15.9e %15.9e %15.9e\n', stat(id).sat_id,...
        stat(id).max_speed,...
        stat(id).min_speed,...
        stat(id).orbital_period_before,...
        stat(id).orbital_period_after);
end

fclose(fid);



%% Task 5: Answer questions
p1a = evalc('help read_input ');
p1b = evalc('help satellite ');
p1c ='See figure 1';
p1d ='See figure 2';
p1e ='See figure 3';

p2a = stat(1);
p2b = stat(2);
p2c = stat(3);
p2d = stat(4);
p2e = stat(5);
p2f = stat(6);

p3 = evalc('type report.txt');

p4a = 'The satellites move fastest when they are closest to Earth';
p4b = 'As the satellites travel away from Earth, their velocity decreases';
