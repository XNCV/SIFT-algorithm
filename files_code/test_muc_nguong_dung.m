%test muc nguong dung
clear
clc
database=dir('X:\172\xla\project\sift\AR LEM Face\m*01.bmp'); %%repaired
datatest=dir('X:\172\xla\project\sift\AR LEM Face\m*14.bmp');
[row column] = size(database);
A = zeros(1,50);
output = cell(row,1);
for count = 1:1:length(database)
    %%training nhe
       databasename = fullfile('X:\172\xla\project\sift\AR LEM Face', database(count).name);
       [image, descrips, locs] = sift(databasename);
       output{count} = struct('image', image, 'descriptors',descrips ,'locs',locs, 'person', count);
       filename = sprintf('Training/data.mat');
       save (filename, 'output');
end
%%
        %%Nhan dang nhe
  
  out = load(sprintf('Training/data.mat'));
for nguong = 0:2:100
  correct = 0;
  for looptest=1:1:50
    image = fullfile('X:\172\xla\project\sift\AR LEM Face', datatest(looptest).name);
    distRatio = 0.6;
    [im, des, locs] = sift(image); %%X:\172\xla\project\sift\AR LEM Face\M-001-14.bmp
    for loopdata=1:1:50
      desc = out.output{loopdata,1}.descriptors;
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
      Kpoint(1,loopdata) = sum(match > 0); %bao nhieu so lon hon 0     
    end
    [B,IX] = sort(Kpoint,'descend');
    N = IX(1);
    M = out.output{N,1}.person;
    
    threshold = B(1)/size(des,1)*100;
    if((threshold > nguong)&&strcmp(database(M).name(1:end-7), datatest(looptest).name(1:end-7)))
        correct = correct+1;
    end
  end
  correct = correct/50*100;
  A(1,nguong/2+1) = correct;
end
plot(A)