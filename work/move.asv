%断边 取点  矩阵的移动算法
function [t,p]= move(originalDate,TTour,Vo)
k=0;
temp=0;
fprintf('ok');
for i=1:51
    if TTour(i)==Vo
        k=TTour(i)
    end
    if(k~=0)
        for j=1:3
            temp=TTour(i+1);
            TTour(i,j)=TTour(i+1,j);
        end
    end
end
for j=1:3
    TTour(52,j)=originalDate(Vo,j);
end
t=TTour;
p=k;