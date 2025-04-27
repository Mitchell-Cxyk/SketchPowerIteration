% Specify the folder where the PNG files are located
folder = '../../dataset/by_class/30/';

% Get a list of all PNG files in the folder and subfolders
filePattern = fullfile(folder, '**', '*.png');
pngFiles = dir(filePattern);

% Initialize parameters
numFiles = length(pngFiles);
imageSize = 128 * 128;

% Preallocate arrays to store non-zero elements
rows = [];
cols = [];
values = [];

% Loop through each file and load the image data
for k = 1:numFiles
    baseFileName = pngFiles(k).name;
    fullFileName = fullfile(pngFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    % Read the image and convert to grayscale
    imageArray = imread(fullFileName);
    if size(imageArray, 3) == 3
        grayImage = rgb2gray(imageArray);
    else
        grayImage = imageArray; % If already grayscale
    end

    % Check if the image is 128x128
    if size(grayImage, 1) ~= 128 || size(grayImage, 2) ~= 128
        error('Image %s is not 128x128 pixels.', fullFileName);
    end

    % Binarize the image (black=1, white=0)
    binaryImage = double(grayImage < 128); % Threshold at 128

    % Convert the image to a column vector and store non-zero elements
    [rowIndices, ~, nonZeroValues] = find(binaryImage(:));
    rows = [rows; rowIndices];
    cols = [cols; k * ones(length(rowIndices), 1)];
    values = [values; nonZeroValues];
end

% Build the sparse matrix in one step
imageMatrix = sparse(rows, cols, values, imageSize, numFiles);

% Display sparse matrix information
whos imageMatrix;
imageMatrix20000=imageMatrix(:,1:20000);
% Save the matrix to a .mat file
% save('NIST.mat', 'imageMatrix','-v7.3');
save('NIST20000.mat', 'imageMatrix20000','-v7.3');