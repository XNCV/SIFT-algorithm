function [ output ] = trainData()
  database=dir('X:\172\xla\project\sift\AAA_DataLEM\*.bmp'); %%repaired
  [row column] = size(database);
  output = cell(row,1);
  person=1;
  n=1;
  for count=1:1:length(database)
     if(count > (10*n))
     person = person + 1;
       n = n + 1;
     end
     databasename = fullfile('X:\172\xla\project\sift\AR LEM Face', database(count).name);
     [image, descrips, locs] = sift(databasename);
     output{count} = struct('image', image, 'descriptors',descrips ,'locs',locs, 'person', count);
     filename = sprintf('Training/data.mat');
     save (filename, 'output');
     display(count);
  end
end