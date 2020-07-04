fid = fopen('Inter_distance1.dat');
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

fid = fopen('Inter_distance2.dat');
tline = fgetl(fid);


while ischar(tline)
data_m(i)=cellstr(tline);
% disp(tline);

tline = fgetl(fid);
i=i+1;
end

fclose(fid);


fid = fopen('Inter_distance3.dat');
tline = fgetl(fid);


while ischar(tline)
data_m(i)=cellstr(tline);
% disp(tline);

tline = fgetl(fid);
i=i+1;
end

fclose(fid);

inter_distance(1)=0;
inter_distance(2)=0;
inter_distance(3)=0;

    for i=1:100
        for k=1:64
%                 p=bin2dec(data_m{1,i});
%                 q=bin2dec(data_m{1,j});
                
                inter_distance(1)=inter_distance(1)+~strcmp(data_m{1,i}(k),data_m{1,100+i}(k));
                
                
%                
            end 
    end 
    for i=1:100
        for k=1:64
%                 p=bin2dec(data_m{1,i});
%                 q=bin2dec(data_m{1,j});
                
                inter_distance(2)=inter_distance(2)+~strcmp(data_m{1,1}(k),data_m{1,i+200}(k));
                
                
%                
            end 
    end
    
     for i=1:100
        for k=1:64
%                 p=bin2dec(data_m{1,i});
%                 q=bin2dec(data_m{1,j});
                
                inter_distance(3)=inter_distance(3)+~strcmp(data_m{1,i+100}(k),data_m{1,i+200}(k));
                
                
%                
            end 
     end
    
for i=1:3
    inter_distance(i)=(inter_distance(i)/100);
end 


figure(1);
plot([1,2,3],inter_distance,'-m.');
ylabel('Inter_hamming distance ');
xlabel('Auto--Line/Auto-Array/1-D Line -- 2-D Array');
title('Inter-hamming distance among 3 placement and Routing Pairs');