originalDate=[1 37 52
2 49 49
3 52 64
4 20 26
5 40 30
6 21 47
7 17 63
8 31 62
9 52 33
10 51 21
11 42 41
12 31 32
13 5 25
14 12 42
15 36 16
16 52 41
17 27 23
18 17 33
19 13 13
20 57 58
21 62 42
22 42 57
23 16 57
24 8 52
25 7 38
26 27 68
27 30 48
28 43 67
29 58 48
30 58 27
31 37 69
32 38 46
33 46 10
34 61 33
35 62 63
36 63 69
37 32 22
38 45 35
39 59 15
40 5 6
41 10 17
42 21 10
43 5 64
44 30 15
45 39 10
46 32 39
47 25 32
48 25 55
49 48 28
50 56 37
51 30 40];
vertex=originalDate(:,1);
x=originalDate(:,2);
y=originalDate(:,3);
ed=zeros(51,51); %距离矩阵
max=0; 
%ans=sqrt((originalDate(2,3)-originalDate(1,3))^2)
%Every point distance
for i=1:1:51 
    for j=1:1:51
        if i~=j
           ed(i,j)=int32(sqrt((originalDate(i,3)-originalDate(j,3))^2+(originalDate(i,2)-originalDate(j,2))^2));
           if(max<ed(i,j))
               max=ed(i,j);
           end
        end
    end
end
%--------------------------------初始化回路---------------------------------
%initialize a Hamiltonian cycle
%1.find the mininum from direct column
%2.change traverse set
%3.switch to the mininum's column
traverse=zeros(1,51); %遍历数组
column=1;
initTour=zeros(1,52);%初始化产生的回路
k=1;
while 1
    i=column; %首尾依次遍历
    min=max; %每一列的最小值 初始赋值
    for j=1:51
        if traverse(j)==0&ed(i,j)~=0&min>ed(i,j)
            min=ed(i,j);
            column=j;
        end
    end
    initTour(k)=column;
    k=k+1;
    traverse(i)=1; % have traversed
    if k==52
        break;
    end
end
initTour(51)=1; %point 51->1 connect=> form tour
%回路的长度
initdis=0;
for i=1:51
    initdis=ed(initTour(i))+initdis;
end
initdis=initdis+6
%回路坐标
TTour=zeros(52,3);%这次得到的回路
for i=1:51
    k=initTour(i);
    for j=1:3
        TTour(i,j)=originalDate(k,j);
    end
end
%加上1-》32这条边
for j=1:3
    TTour(52,j)=originalDate(32,j);
end    
vertex=TTour(:,1);
x=TTour(:,2);
y=TTour(:,3); 
subplot(2,2,1);plot(x,y)
str=[num2str(vertex)];
text(x,y,str);
%--------------------初始化完成---------回路不理想-----------------------
%--------------------node ejection-----------------------------------------
%--------------------挤点法优化---------------------------------------------
%先找Vo=前驱+后继距离最远
%遍历找最小的Dij,并替换 取最小的(EK=新加的两条边-要连接点的两条边）&保证EK>0(贪心）
%将替换下来的点找EK,终止条件待定
%构成回路的两种策略
%-------------------------------start--------------------------------------

%求距离，找Vo
Vo=1;%是V和字母o
TEmax=0;%两条边最大的
pre=1;
suc=1;%定义一点的前驱节点 相当于第一点从32开始
Vopre=pre;
Vosuc=suc;
initTour(52)=32;
for i=1:51
    k=initTour(i);
    j=i+1;
    suc=initTour(j);
    if TEmax<ed(pre,k)+ed(k,suc)
        TEmax=ed(pre,k)+ed(k,suc);
        Vo=k;
        Vopre=pre;
        Vosuc=suc;
    end
    pre=k;
end
Vo
formatSpec = 'Vo is %d \n';
fprintf(formatSpec,Vo);
Vopre
Vosuc
%找到Vo,将其前驱与后继断开
V=0;
[TTour,V]=move(originalDate,TTour,Vo);%V表示要删除的点
%TTour(52)=Vo;%52内存的多画了一遍
vertex=TTour(:,1);
x1=TTour(:,2);
y1=TTour(:,3); 
subplot(2,2,2);plot(x1,y1)
str=[num2str(vertex)];
text(x1,y1,str);
%----------------------------多窗口展示-----------------------------------


%遍历找最小的Dij,并替换
%取最小的(EK=新加的两条边-要连接点的两条边）&保证EK>0(贪心）--------------------------------
%---------------------从32开始------------------------------------------
optimizeTour=zeros(1,52);%优化的回路
%初始化前驱 找到要取缔的点V1
%循环取缔，设置终止条件
Fd=Vo;%防抖 防止反复替换一点 Fd存储上一次踢掉的点
n=1;
while n<=1
    %下面的for循环寻找需要挤出的点
    pre=1;
    TEmin=TEmax;
    c=0;%记号 操作是否执行
    %-------------------------判断是应插入到两点间构成回路，还是挤点-------------------
    
    for i=1:51
        k=initTour(i);
        suc=initTour(i+1);
        if k~=Fd&k~=Vo&k~=Vopre&k~=Vosuc&TEmin>ed(pre,Vo)+ed(Vo,suc)-ed(pre,k)-ed(k,suc)
            TEmin=ed(pre,Vo)+ed(Vo,suc)-ed(pre,k)-ed(k,suc);
            V1=k;
            V1pre=pre;
            V1suc=suc;
            loc=i;%记录V1在数组中的位置
        end
        pre=k;
    end
    %if ed(Vopre,Vo)+ed(Vo,Vosuc)-ed(V1pre,Vo)-ed(Vo,V1suc)<=0 %原来的两条边>替换后的两条边
     %   break;
    %end
    formatSpec = '挤出的点为： %d，它的前驱: %d,后继: %d\n';
    fprintf(formatSpec,V1,V1pre,V1suc);
    %替换掉挤出的点 被挤掉的点存储在TTour的最后
    Fd=TTour(52,1)
    for j=1:3
        temp=TTour(loc,j);
        TTour(loc,j)=TTour(52,j);
        TTour(52,j)=temp;
        c=1;
    end
    if c==1
        n=n+1;
    end
    Vo=TTour(52,1)
    Vopre=V1pre
    Vosuc=V1suc
end
vertex=TTour(:,1);
x2=TTour(:,2);
y2=TTour(:,3); 
subplot(2,2,3);plot(x2,y2)
str=[num2str(vertex)];
text(x2,y2,str);
    
    
    
    


    
    










    
    

          