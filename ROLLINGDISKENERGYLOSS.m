% Parameters
             % Distance from the center of mass to the weight (m)
% Parameters
R = 1;                % Radius of the disk (m)
c = 0.2;              % Distance of the center of mass from the center (m)
g = 9.81;             % Acceleration due to gravity (m/s^2)
m = 1;          % Mass of the disk (kg)
m_w = 0.1;     % Mass of the weight (kg)
R_w = 0.1;            % Radius of the weight (m)
d = 0.3;  
% Damping coefficient
b = 0.35;              % Damping coefficient (energy loss)

% Initial conditions
phi0 = pi/4;         % Initial angle (rad)
phi_dot0 = -2.3;       % Initial angular velocity (rad/s)

% Time span
tspan = [0 5];       % Time from 0 to 7 seconds

% Define the system of ODEs
odefun = @(t, y) [
    y(2); 
    -((((m + m_w) * (g * c * cos(y(1)) + 2 * R * c * cos(y(1)) * y(2)^2) ...
      + b * y(2)) / ((m + m_w) * (R^2 + 2 * R * c * sin(y(1)) + c^2) + ...
      (1/2) * m * R^2 + m * c^2 + (1/2) * m_w * R_w^2 + m_w * d^2)))
];

% Solve the ODE using ode45
[t, sol] = ode45(odefun, tspan, [phi0, phi_dot0]);

% Position of the center of mass (CM)
x_CM = R * sol(:, 1) + c * cos(sol(:, 1));  % x position of CM
y_CM = c * sin(sol(:, 1));                    % y position of CM

% Calculate angular acceleration (second derivative of angle)
phi_double_dot = gradient(sol(:, 2), t);      % Angular acceleration

% Plot the results
figure;

% Plot Angular Displacement
subplot(3, 1, 1);
plot(t, sol(:, 1), 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Angle \phi (rad)');
title('Angular Displacement \phi vs. Time');

% Plot Angular Velocity
subplot(3, 1, 2);
plot(t, sol(:, 2), 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Angular Velocity \dot{\phi} (rad/s)');
title('Angular Velocity \dot{\phi} vs. Time');

% Plot y position of the center of mass
subplot(3, 1, 3);
plot(t, y_CM, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('y Position of CM (m)');
title('y Position of Center of Mass vs. Time');

% Display the final position
fprintf('Final angle at t = %0.2f s: \phi = %0.4f rad\n', t(end), sol(end, 1));
fprintf('Final y position at t = %0.2f s: y_{CM} = %0.4f m\n', t(end), y_CM(end));
fprintf('Final x position at t = %0.2f s: x_{CM} = %0.4f m\n', t(end), x_CM(end));
