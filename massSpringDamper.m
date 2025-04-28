%function is to be used in a solver to simulate
function dxdt = massSpringDamper(t, x, m, c, k)
    disp = x(1);
    vel = x(2);

    %% find acceleration

    acc = (-c*vel-k*disp)/m; %from newton's second law
    dxdt = [vel; acc];
end
