changeCurrentFolderToScriptFolder();
filename='air.1948.nc';
lat = ncread(filename, 'lat');
lon = ncread(filename, 'lon');
changeCurrentFolderToScriptFolder();
T=110;
load(strcat("dataNewPara/SingularVectorPoly42_",num2str(T),"_",num2str(1),".mat"));
if ~exist('U')||~exist('S')||~exist('V')
    load("dataMatrixS100.mat");
end
if ~exist('dataMatrix')
    load('dataMatrix.mat');
end
%%
% Z = ncread(filename, 'air');
% Z=Z(:,:,1);
UOrigin=dataMatrix(:,1);
UOrigin=reshape(UOrigin,144,[]);
UOrigin=UOrigin';
UOrigin = [UOrigin, UOrigin(:,1)]; % 复制第一列到最后
lon = mod(lon + 180, 360) - 180;
lon=[lon;lon(1)];
[lonGrid, latGrid] = meshgrid(lon, lat);
% lonGrid = [lonGrid, lonGrid(:,1)]; % 同样处理 lonGrid
% figure;
% wm=worldmap('world'); % Adjust the region as needed
% land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas
% Create a map axes
figure;
wm=worldmap('world'); % Adjust the region as needed
land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas

% Display your data on the map
geoshow(latGrid, lonGrid, UOrigin, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
% saveas(gcf,strcat("geoFigure/SingularVectorGeo_Exact_",num2str(order),".fig"));
ax = gca; % 获取当前地图轴
set(ax, 'OuterPosition', [0, 0, 1, 1]); % 让地图轴填满图形窗口
set(gcf, 'PaperPositionMode', 'auto'); % 自动调整 PaperPosition
saveas(gcf, strcat("worldmap/worldmap.fig"));
%%
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑
colorbar;
%%
order=1;
U1=U(:,order);
U2=LowRankApprox.U(:,order);
U3=LowRankApprox1.U(:,order);
U4=UU(:,order);
[U1,U2,U3,U4]=alignVectors(U1,U2,U3,U4);
U1=reshape(U1,144,[]);
U1=U1';
U1 = [U1, U1(:,1)]; % 复制第一列到最后
U2=reshape(U2,144,[]);
U2=U2';
U2 = [U2, U2(:,1)]; % 复制第一列到最后
U3=reshape(U3,144,[]);
U3=U3';
U3 = [U3, U3(:,1)]; % 复制第一列到最后
U4=reshape(U4,144,[]);
U4=U4';
U4 = [U4, U4(:,1)]; % 复制第一列到最后


% Create a map axes
% lonGrid = [lonGrid, lonGrid(:,1)]; % 同样处理 lonGrid
% figure;
% wm=worldmap('world'); % Adjust the region as needed
% land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas
% Create a map axes
figure;
wm=worldmap('world'); % Adjust the region as needed
land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas

% Display your data on the map
geoshow(latGrid, lonGrid, U1, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
% saveas(gcf,strcat("geoFigure/SingularVectorGeo_Exact_",num2str(order),".fig"));
ax = gca; % 获取当前地图轴
set(ax, 'OuterPosition', [0, 0, 1, 1]); % 让地图轴填满图形窗口
set(gcf, 'PaperPositionMode', 'auto'); % 自动调整 PaperPosition
saveas(gcf, strcat("geoFigure/SingularVectorGeo_Exact_",num2str(order),".fig"));
%%
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑
colorbar;
% Add a colorbar to show the data values
figure;
wm=worldmap('world'); % Adjust the region as needed
% land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas


% Display your data on the map
geoshow(latGrid, lonGrid, U2, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
saveas(gcf,strcat("geoFigure/SingularVectorGeo_SPI_",num2str(order),".fig"));
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑

% Add a colorbar to show the data values
colorbar;
figure;
wm=worldmap('world'); % Adjust the region as needed
land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas

% Display your data on the map
geoshow(latGrid, lonGrid, U3, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
saveas(gcf,strcat("geoFigure/SingularVectorGeo_TYUC17_",num2str(order),".fig"));
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑

% Add a colorbar to show the data values
colorbar;
figure;
wm=worldmap('world'); % Adjust the region as needed
land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas

% Display your data on the map
geoshow(latGrid, lonGrid, U4, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
saveas(gcf,strcat("geoFigure/SingularVectorGeo_RSVD_",num2str(order),".fig"));
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑

% Add a colorbar to show the data values
colorbar;

%%
lat = ncread(filename, 'lat');
lon = ncread(filename, 'lon');
order=2;
U1=-U(:,order);
U2=LowRankApprox.U(:,order);
U3=LowRankApprox1.U(:,order);
U4=-UU(:,order);
[U1,U2,U3,U4]=alignVectors(U1,U2,U3,U4);
U1=reshape(U1,144,[]);
U1=U1';
U1 = [U1, U1(:,1)]; % 复制第一列到最后
U2=reshape(U2,144,[]);
U2=U2';
U2 = [U2, U2(:,1)]; % 复制第一列到最后
U3=reshape(U3,144,[]);
U3=U3';
U3 = [U3, U3(:,1)]; % 复制第一列到最后
U4=reshape(U4,144,[]);
U4=U4';
U4 = [U4, U4(:,1)]; % 复制第一列到最后


% Create a map axes
lon = mod(lon + 180, 360) - 180;
lon=[lon;lon(1)];
[lonGrid, latGrid] = meshgrid(lon, lat);
% lonGrid = [lonGrid, lonGrid(:,1)]; % 同样处理 lonGrid
% figure;
% wm=worldmap('world'); % Adjust the region as needed
% land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas
% Create a map axes
figure;
wm=worldmap('world'); % Adjust the region as needed
land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas

% Display your data on the map
geoshow(latGrid, lonGrid, U1, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
saveas(gcf,strcat("geoFigure/SingularVectorGeo_Exact_",num2str(order),".fig"));
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑

% Add a colorbar to show the data values
figure;
wm=worldmap('world'); % Adjust the region as needed
% land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas


% Display your data on the map
geoshow(latGrid, lonGrid, U2, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
saveas(gcf,strcat("geoFigure/SingularVectorGeo_SPI_",num2str(order),".fig"));
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑

% Add a colorbar to show the data values
colorbar;
figure;
wm=worldmap('world'); % Adjust the region as needed
land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas

% Display your data on the map
geoshow(latGrid, lonGrid, U3, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
saveas(gcf,strcat("geoFigure/SingularVectorGeo_TYUC17_",num2str(order),".fig"));
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑

% Add a colorbar to show the data values
colorbar;
figure;
wm=worldmap('world'); % Adjust the region as needed
land = shaperead('landareas.shp', 'UseGeoCoords', true);
% geoshow(land, 'FaceColor', [0.5 0.7 0.5]); % Display land areas

% Display your data on the map
geoshow(latGrid, lonGrid, U4, 'DisplayType', 'texturemap', 'FaceColor', 'interp');
geoshow(land, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', '-');
setm(wm, 'MeridianLabel', 'off', 'ParallelLabel', 'off');
saveas(gcf,strcat("geoFigure/SingularVectorGeo_RSVD_",num2str(order),".fig"));
% figure;
% pcolor(lonGrid, latGrid, U1);
% shading flat; % 使颜色填充平滑

% Add a colorbar to show the data values
colorbar;