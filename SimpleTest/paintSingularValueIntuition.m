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
figure;
set(gcf, 'Renderer', 'opengl');        % 透明叠加更稳妥
ax = axes; hold(ax, 'on'); grid(ax, 'on'); box(ax, 'on');
yscale(ax, "log");

% 主曲线（不进图例）
hLine = semilogy(ax, x, y, '-o', 'LineWidth', 1.6, 'MarkerSize', 4, ...
    'HandleVisibility','off');

% 两条竖线（不进图例）
x1 = floor(x0/2)-5;
x2 = x0+10;
xs = sort([x1 x2]); x1 = xs(1); x2 = xs(2);
% xline(ax, x1, '--k', 'LineWidth', 1.2, 'HandleVisibility','off');
% xline(ax, x2, '--k', 'LineWidth', 1.2, 'HandleVisibility','off');

% 当前坐标范围（先画完曲线/竖线再取）
xl = xlim(ax);
yl = ylim(ax);           % 注意：对数轴下，yl 是正数
L = xl(1);  R = xl(2);

% 颜色与透明度（可改）
c1 = [0.20 0.60 0.95];  a1 = 0.30;   % 区域 Y（x <= x1）
c2 = [0.95 0.60 0.20];  a2 = 0.30;   % 区域 Z（x <= x2）

% 两块“左侧到竖线”的半透明矩形（允许重叠；不进图例）
p1 = patch(ax, [L+0.5 x1 x1 L+0.5], [yl(1)+0.0002 yl(1)+0.0002 yl(2)-0.01 yl(2)-0.01], c1, ...
    'FaceAlpha', a1, 'EdgeColor', 'blue', 'Clipping','on', 'HandleVisibility','off');
p2 = patch(ax, [L x2 x2 L], [yl(1) yl(1) yl(2) yl(2)], c2, ...
    'FaceAlpha', a2, 'EdgeColor', 'red', 'Clipping','on', 'HandleVisibility','off');

% 文本位置：横向=各自区域的中点；纵向=对数轴“几何中值”
xY = mean([L, x1]);
xZ = mean([L, x2]);
yC = sqrt(yl(1) * yl(2));   % 对数轴视觉正中

% 在区域中心写 Y / Z，文字颜色与区域颜色一致（不进图例）
tY = text(ax, xY, yC, 'Y', 'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', 'FontSize', 14, 'FontWeight','bold', ...
    'Color', c1, 'BackgroundColor', 'none', 'Clipping','on', 'HandleVisibility','off');
tZ = text(ax, xZ, yC, 'Z', 'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', 'FontSize', 14, 'FontWeight','bold', ...
    'Color', c2, 'BackgroundColor', 'none', 'Clipping','on', 'HandleVisibility','off');

% 把主曲线和文字放最上层
uistack([hLine tY tZ], 'top');

xlabel(ax, 'x'); ylabel(ax, 'y');

% ===== 图例：只显示两块区域的含义（用“代理”句柄，方块色块） =====
hLegY = plot(ax, NaN, NaN, 's', 'MarkerFaceColor', c1, 'MarkerEdgeColor', c1, ...
    'MarkerSize', 10, 'LineStyle', 'none', 'DisplayName', ' Y');
hLegZ = plot(ax, NaN, NaN, 's', 'MarkerFaceColor', c2, 'MarkerEdgeColor', c2, ...
    'MarkerSize', 10, 'LineStyle', 'none', 'DisplayName', 'Z');
legend(ax, [hLegY hLegZ], 'Location', 'best', 'AutoUpdate','off');

