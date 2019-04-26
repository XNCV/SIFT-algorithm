function [ N, M ] = findMatchIm(image)
  database=dir('X:\172\xla\project\sift\AR LEM Face\*01.bmp');
  distRatio = 0.6;
  [im, des, locs] = sift(image); %%X:\172\xla\project\sift\AR LEM Face\M-001-14.bmp
  out = load(sprintf('Training/data.mat'));
  for count=1:1:length(database)
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
    fprintf('Found %d matches with training image %d.\n', Kpoint(1,count),count);       
  end
  [B,IX] = sort(Kpoint,'descend');
  fprintf('\n\n');
  for count=1:1:length(database)
    fprintf('Found %d matches with training image %d.\n', B(count),IX(count));
  end
  N = IX(1);
  M = out.output{N,1}.person;
  fprintf('The image correspond to person %s\n', database(M).name);
  figure;
  imshow(image);
  title('Subject Image')
  figure;
  imshow(out.output{N,1}.image);
  title(sprintf('The image correspond to person %s', database(M).name))
end