
% MAIN      Script used in plotting different transfer functions.
% Author:   Timothy Sipkens, 2019-06-25
%=========================================================================%


%-- Initialize script ----------------------------------------------------%
clear;
close all;

V = 10; % voltage to replicate Ehara et al.
omega1 = 2500*0.1047; % angular speed, converted from rpm to rad/s

e = 1.60218e-19; % electron charge [C]
m = linspace(1e-10,1,601)*e; % vector of mass

z = 1; % integer charge state

rho_eff = 900; % effective density
d = (6.*m./(rho_eff.*pi)).^(1/3);
    % specify mobility diameter vector with constant effective density

prop = tfer_PMA.prop_CPMA('Olfert-Collings'); % get properties of the CPMA
% prop.omega_hat = 1; % NOTE: Uncomment for APM condition
% prop.D = @(B) zeros(size(B));


%=========================================================================%
%-- Finite difference solution -------------------------------------------%
tic;
[tfer_FD,~,n] = tfer_PMA.tfer_FD([],...
    m,d,1,prop,'V',V,'omega1',omega1);
t(1) = toc;


%=========================================================================%
%-- Transfer functions for different cases -------------------------------%
%-- Setup for centriputal force ------------------------------------------%
if ~exist('d','var')
    B = tfer_PMA.mp2zp(m,z,prop.T,prop.p);
else
    B = tfer_PMA.dm2zp(d,z,prop.T,prop.p);
end
tau = B.*m;
D = prop.D(B).*z;
sig = sqrt(2.*prop.L.*D./prop.v_bar);
D0 = D.*prop.L/(prop.del^2*prop.v_bar); % dimensionless diffusion coeff.


%-- Particle tracking approaches -----------------------------------------%
%-- Plug flow ------------------------------------------------------------%
%-- Method A ------------------------------%
tic;
[tfer_A,G0_A] = tfer_PMA.tfer_A([],m,d,z,prop,'V',V,'omega1',omega1);
t(2) = toc;

%-- Method A, Ehara et al. ----------------%
tfer_A_Ehara = tfer_PMA.tfer_A_Ehara([],m,d,z,prop,'V',V,'omega1',omega1);



%-- Parabolic flow -------------------------------------------------------%
%-- Method A ------------------------------%
tic;
[tfer_A_pb,G0_A_pb] = tfer_PMA.tfer_A_pb([],m,d,z,prop,'V',V,'omega1',omega1);
t(8) = toc;



%=========================================================================%
%-- Plot different transfer functions with respect to m/m* ---------------%
m_plot = m./e;

figure(2);
% plot(m_plot,tfer_A);
% hold on;
% plot(m_plot,tfer_A_Ehara);
% plot(m_plot,tfer_A_pb);
plot(m_plot,min(tfer_FD,1),'k');
hold off;

% ylim([0,1.2]);

xlabel('s')
ylabel('{\Lambda}')


