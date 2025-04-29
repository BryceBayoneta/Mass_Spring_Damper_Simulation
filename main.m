clearvars
clc

%% get values to run simulation
fprintf('This is a solver for a system with a block, a spring, and a damper\n\n')
m = input('what is the mass of the block (kg)?\n->');
c = input('what is the damping coefficient?\n->');
k = input('what is the spring constant?\n->');
tf = input('how long should the simulation run (s)?\n->');
time = [0,tf];
x0 = input('how far is the block from the spring'' initially (m)?\n->');
v0 = input('how fast is the block moving at first (m/s)?\n->');
initials = [x0;v0];

%% solver
[t, x] = ode45(@(t, x) massSpringDamper(t, x, m, c, k), time, initials);

%% plot distance and velocity vs time
figure
subplot(1, 2, 1)
p1 = plot(t, x(:, 1), "b"); % displacement
xlabel('Time (s)')
ylabel('Displacement (m)')
hold on
yyaxis right
p2 = plot(t, x(:,2), "r"); % veloctity
ylabel('Velocity (m/s)')
axes = gca;
axes.YAxis(2).Color = 'k';
legend([p1 p2],{'Displacement (m)', 'Velocity (m/s)'})
hold off

%% find important info
maxD = max(abs(x(:,1))); % max displacement
maxV = max(abs(x(:,2))); % max velocity

% find stopping time
tStop = NaN;
i=1;
[rows, ~] = size(x);

while isnan(tStop) && i<=rows 
    if abs(x(i, 2)) < 0.001  && abs(x(i,1)) < 0.001 % finds when velocity and displacement are very small
        tStop = (t(i));
    end
    i = i+1;
end

%find oscillation frequency
oFreq = NaN;
peaks = [];
j=1;
for i = 1:2 % makes sure to only get 2 peaks
    check = false;
    while ~check
        if abs(x(j,2)) < 0.001 % checks if velocity is basically 0
            peaks(i) = t(j);
            check = true;
        end
        j = j+1;
    end
end
oFreq = 1/(peaks(2) - peaks(1));

% find energy decay graph
KE = .5 * m * (x(:,2)).^2;
PE = .5 * k * (x(:,1)).^2;
eTot = KE+PE;
subplot(1,2,2)
plot(t, eTot)
xlabel('Time (s)')
ylabel('Total Energy in System (J)')
title('Energy Decay Over Time')
eChange = eTot(1) - eTot(end);

%% print out important values
clc
fprintf('Important Values:\n\n')
fprintf('Max Displacement: %f m\n', maxD)
fprintf('Max Velocity: %f m/s\n', maxV)
if ~isnan(tStop)
    fprintf('Stopping Time: %f s\n',tStop)
else
    fprintf('Mass didn''t stop during simulation')
end
fprintf('Oscillation Frequency: %f Hz\n', oFreq)
fprintf('Energy Lost: %f J\n', eChange)