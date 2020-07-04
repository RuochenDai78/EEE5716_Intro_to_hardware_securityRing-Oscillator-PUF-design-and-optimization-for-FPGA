fid = fopen('Reliability1.dat');
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

fid = fopen('Reliability2.dat');
tline = fgetl(fid);


while ischar(tline)
data_m(i)=cellstr(tline);
% disp(tline);

tline = fgetl(fid);
i=i+1;
end

fclose(fid);


fid = fopen('Reliability3.dat');
tline = fgetl(fid);


while ischar(tline)
data_m(i)=cellstr(tline);
% disp(tline);

tline = fgetl(fid);
i=i+1;
end

fclose(fid);

One=[];
Zero=[];
One(1)=0;
Zero(1)=0;
One(2)=0;
Zero(2)=0;
One(3)=0;
Zero(3)=0;
for j=1:3
for i=1:100
    
    for k=1:64 
      if (strcmp('1',data_m{1,i+(j-1)*100}(k)))
        One(j)=One(j)+1;
      else 
          Zero(j)=Zero(j)+1;
      end
    end 
    
end 
end 

figure(1);
% x=(1,100);
% ylim([73, 95]);
% axis([1,100,0,3]);
% set(gca, 'YLim',[73 95]);  
% X????????
Uniform=[];
Uniform(1)=0;
Uniform(2)=0;
Uniform(3)=0;
for i=1:3
 One(i)=(One(i)/64/100)*100;
 Zero(i)=(Zero(i)/64/100)*100;
end 

plot([1,2,3],One,'-r*',[1,2,3],Zero,'-k*');
% plot([1,2,3],Zero,'-r*');
ylabel('Uniformity %');
xlabel('Auto/Line/Array');
title('Uniformatiy among 3 placement and Routing')
legend('Ones','Zeros') 