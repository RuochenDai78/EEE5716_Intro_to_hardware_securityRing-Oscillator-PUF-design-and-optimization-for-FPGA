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
R=[];
R(1)=0;
R(2)=0;
R(3)=0;
for j=1:3
for i=1:100
    for k=1:64
                if(i<=10)
                R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,1+(j-1)*100}(k));
                
                elseif (i>10 && i<=20)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,11+(j-1)*100}(k));
                 
                elseif (i>20 && i<=30)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,21+(j-1)*100}(k)) ;
                elseif (i>30 && i<=40)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,31+(j-1)*100}(k)) ;
                elseif (i>40 && i<=50)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,41+(j-1)*100}(k)) ;
                elseif (i>50 && i<=60)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,51+(j-1)*100}(k)) ;
                elseif (i>60 && i<=70)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,61+(j-1)*100}(k));
                elseif (i>70 && i<=80)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,71+(j-1)*100}(k));
                elseif (i>80 && i<=90)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,81+(j-1)*100}(k));
                elseif (i>90 && i<=100)
                 R(j)=R(j)+~strcmp(data_m{1,i+(j-1)*100}(k),data_m{1,91+(j-1)*100}(k));
               end  
    end 
    
end 
end 
for i=1:3
    R(i)=(1-R(i)/99/64)*100;
end 
disp(R);
figure(1);
% x=(1,100);
% ylim([73, 95]);
% axis([1,100,0,3]);
% set(gca, 'YLim',[73 95]);  
% X????????

plot([1,2,3],R,'-r*');
ylabel('Reliability %');
xlabel('Auto/Line/Array');
title('Reliability among 3 placement and Routing');




