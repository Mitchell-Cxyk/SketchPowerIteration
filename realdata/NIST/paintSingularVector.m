load('NIST100k.mat');
load('data/SingularVector_320_1.mat');
for iter = 1:9
    figure(iter);
    % Set the figure size and position for better layout
    set(gcf, 'Position', [100, 100, 1200, 300]);
    
    % Define the margins and spacing
    margin = 0.05;
    spacing = 0.02;
    width = (1 - 2 * margin - 3 * spacing) / 4;
    height = 1 - 2 * margin;
    
    % 第一个子图
    U22 = UU(:, iter);
    U222 = U22;
    U222reshape = reshape(U222, 128, 128);
    subplot('Position', [margin, margin, width, height]);
    h1 = heatmap(abs(U222reshape));
    h1.XDisplayLabels = repmat({''}, 1, 128); % 去掉横坐标数字
    h1.YDisplayLabels = repmat({''}, 1, 128); % 去掉纵坐标数字
    h1.GridVisible = 'off'; % 去掉网格
    h1.ColorbarVisible="off";
    % title('RSVD'); % 添加标题
    
    % 第二个子图
    U22 = LowRankApprox.U(:, iter);
    U222 = U22;
    U222reshape = reshape(U222, 128, 128);
    subplot('Position', [margin + width + spacing, margin, width, height]);
    h2 = heatmap(abs(U222reshape));
    h2.XDisplayLabels = repmat({''}, 1, 128); % 去掉横坐标数字
    h2.YDisplayLabels = repmat({''}, 1, 128); % 去掉纵坐标数字
    h2.GridVisible = 'off'; % 去掉网格
    h2.ColorbarVisible="off";
    % title(''); % 添加标题
    
    % 第三个子图
    U22 = LowRankApprox1.U(:, iter);
    U222 = U22;
    U222reshape = reshape(U222, 128, 128);
    subplot('Position', [margin + 2 * (width + spacing), margin, width, height]);
    h3 = heatmap(abs(U222reshape));
    h3.XDisplayLabels = repmat({''}, 1, 128); % 去掉横坐标数字
    h3.YDisplayLabels = repmat({''}, 1, 128); % 去掉纵坐标数字
    h3.GridVisible = 'off'; % 去掉网格
    h3.ColorbarVisible="off";
    % title('AnotherMethod'); % 添加标题
    
    % 第四个子图
    U22 = U(:, iter);
    U222 = U22;
    U222reshape = reshape(U222, 128, 128);
    subplot('Position', [margin + 3 * (width + spacing), margin, width, height]);
    h4 = heatmap(abs(U222reshape));
    h4.XDisplayLabels = repmat({''}, 1, 128); % 去掉横坐标数字
    h4.YDisplayLabels = repmat({''}, 1, 128); % 去掉纵坐标数字
    h4.GridVisible = 'off'; % 去掉网格
    % title('YetAnotherMethod'); % 添加标题
    saveas(gcf,['figure/NISTSingularVector/SingularVectorVis/NISTSingularVector_T_',num2str(T),'_order_',num2str(iter),'.fig']);
end