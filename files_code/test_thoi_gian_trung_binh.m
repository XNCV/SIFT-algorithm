%%begin
clear
clc
database=dir('X:\172\xla\project\sift\AR LEM Face\m*01.bmp'); %%repaired
datatest=dir('X:\172\xla\project\sift\AR LEM Face\m*14.bmp');
[row column] = size(database);
A = zeros(1,10);
output = cell(row,1);
%%
%%Tinh toi gian nhan dang
for imtrain = 1:1:10 %length(datatest)
  databasename = fullfile('X:\172\xla\project\sift\AR LEM Face', database(imtrain).name);
  [image, descrips, locs] = sift(databasename);
  output{imtrain} = struct('image', image, 'descriptors',descrips ,'locs',locs, 'person', imtrain);
  filename = sprintf('Training/data.mat');
  save (filename, 'output');
  tic;
  for numberIm = 1:1:imtrain
  distRatio = 0.6;
  [im, des, locs] = sift(fullfile('X:\172\xla\project\sift\AR LEM Face', datatest(numberIm).name)); %%X:\172\xla\project\sift\AR LEM Face\M-001-14.bmp
  out = load(sprintf('Training/data.mat'));
  for count=1:1:imtrain
    desc = out.output{count,1}.descriptors;
    dest = desc';
    for i = 1 : size(des,1)
      dotprods = des(i,:) * dest;
      [vals,indx] = sort(acos(dotprods));
      if (vals(1) < distRatio * vals(2))
        match(i) = indx(1);
      else
        match(i) = 0;
      end
    end 
    Kpoint(1,count) = sum(match > 0); %bao nhieu so lon hon 0
  end
  [B,IX] = sort(Kpoint,'descend');
  N = IX(1);
  M = out.output{N,1}.person;
  end
  toc;
  A(1, numberIm) = toc/numberIm;
end
plot(A);