
database=dir('X:\172\xla\project\sift\TestFile\testrotate*.bmp');
for i = 1:12
    I = imread(fullfile('X:\172\xla\project\sift\TestFile', database(i).name));
    subplot(3,4,i);
    imshow(I);
end
