% 参数
N = 100;                 % 横坐标 1..100
x = 1:N;

alpha = 0.1;            % 缓慢衰减的强度（越小越慢）
env = x.^(-alpha);       % 整体的慢衰减包络

x0 = N/3 + 0.5;          % 突降中心位置（约在前三分之一处）
k  = 5;                  % 突降的“陡峭度”（越大越陡，2~3 个点完成）
drop_factor = 1e-2;      % 突降后的相对幅度（2 个数量级 = 1e-2）

% 使用逻辑函数做一个“快速门”，在 x0 附近把幅度从 1 拉到 1e-2
step = drop_factor + (1 - drop_factor) ./ (1 + exp(k * (x - x0)));

% 目标曲线：先慢衰减 * 突降门 * 后续仍慢衰减（由同一 env 控制）
y = env .* step;

% % 作图（线性坐标）
% figure; 
% plot(x, y, '-o', 'LineWidth', 1.5, 'MarkerSize', 4); grid on;
% xlabel('x'); ylabel('y');
% title('慢衰减 → 2个数量级突降 → 慢衰减');
% xline(x0, '--', '突降中心');

% 如果想更直观看到“两个数量级”的变化，也可以用半对数坐标：
figure;
semilogy(x, y, '-o', 'LineWidth', 1.5, 'MarkerSize', 4); grid on;
xlabel('x'); ylabel('y');
xline(x0+5, '--', 'k','LabelVerticalAlignment','middle','LabelOrientation','horizontal','LabelHorizontalAlignment','center','FontSize',15);
xline(floor(x0/2),'--','\rho','LabelVerticalAlignment','middle','LabelOrientation','horizontal','LabelHorizontalAlignment','center','FontSize',15);
xline(floor(x0/2)+5,'--','s','LabelVerticalAlignment','middle','LabelOrientation','horizontal','LabelHorizontalAlignment','center','FontSize',15);
xline(x0+10,'--','l','LabelVerticalAlignment','middle','LabelOrientation','horizontal','LabelHorizontalAlignment','center','FontSize',15);
