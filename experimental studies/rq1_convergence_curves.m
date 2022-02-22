% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the convergence curves obtained by two baseline solvers 
% and six similarity-driven S-ESTOs. The corresponding figure is shown in Fig. 11
% in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted for Peer Review.

clc,clear
warning off;
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight problem families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generations = {'C','U'}; % constrained and unconstrained source generations
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs optimum coverage
ds = [5 10 20]; % problem dimensions
k = 1000; % the number of solved source instances
metrics = {'N','R','C','M1','KLD','WD','OC','SA'}; % similarity metrics

% the problem from which the results to be visualized are collected
idx_family = 1;
idx_scenario = 1;
idx_source_generation = 1;
idx_xi = 4;
idx_d = 2;

fig_width = 350;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
num_points_plot = 15;
std_level = 0.5;
c_list = [0 0 0;255 0 0;0 255 0;0 0 255;255 255 0;0 255 255;255 0 255;125 0 255;255 125 0]/255;
m_list = ['o','+','*','x','s','d','^','v'];
for m = 1:length(metrics)
    load(['results-rq1\',problem_families{idx_family},'-',transfer_scenarios{idx_scenario},'-',...
        source_generations{idx_source_generation},'-x',num2str(xis(idx_xi)),'-d',...
        num2str(ds(idx_d)),'-k',num2str(k),'-S',num2str(m),'+A0.mat']);
    [FEs,fits] = opt_trace_processing(results_opt);
    idx_retrive = ceil(linspace(1,length(FEs),num_points_plot));
    y = log(mean(fits,2));
    plot(FEs(idx_retrive),y(idx_retrive),'linewidth',1,'color',c_list(m,:),'marker',m_list(m));hold on;
    std_upper = log(mean(fits,2)+std_level*std(fits,1,2));
    std_lower = log(mean(fits,2)-std_level*std(fits,1,2));
    fill([FEs;FEs(end:-1:1)],[std_upper;std_lower(end:-1:1)],c_list(m,:),'facealpha',0.3,...
        'edgecolor',c_list(m,:),'edgecolor','none');

end
set(gca,'linewidth',0.5);
grid on;
xlabel('FEs','interpret','latex','fontsize',12)
ylabel('log$\left(y\right)$','interpret','latex','fontsize',12);
title(['$\mathcal{G}=',source_generations{idx_source_generation},'$, $\xi=',...
    num2str(xis(idx_xi)),'$'],'interpret','latex','fontsize',14)