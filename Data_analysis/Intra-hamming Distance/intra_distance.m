fid = fopen('intra_distance3.dat');
tline = fgetl(fid);

data_m={};

i=1;
while ischar(tline)
data_m(i)=cellstr(tline);
% disp(tline);

tline = fgetl(fid);
i=i+1;
end

fclose(fid);
R=0;
count=0;
R_1=[];
increase=0;
% 
for i=1:100
% %     for j=1:100
%         if (j>i)
          for k=1:64
%                 p=bin2dec(data_m{1,i});
%                 q=bin2dec(data_m{1,j});
                increase=increase+~strcmp(data_m{1,i}(k),data_m{1,1}(k));
                count=count+1;
%                 disp(R);
          end 
            R_1(i)=increase;
            R=R+increase;
            increase=0;
            
%           end 
%     end 
end 
intra=R/99/64*100;
disp(count);
disp(R);
disp(intra);
mean=R/100;
intra_std_dev1=std(R_1);
figure(1);
histogram(R_1);
% title(['Histogram of inter HD1:','mean=',int2str(inter_mean1),',standard deviation1=',int2str(inter_std_dev1)]);
title(['Histogram of intra HD1:','mean=',int2str(mean),'SD=',int2str(intra_std_dev1),'HD Rate',num2str(intra),'%']);