%重要数据注解表
%OData[N][3]        原始数据矩阵
% N                 顶点个数
%ed[N][N]           距离矩阵
%max                寻找最大的一条边
%len                回路长度
%initTour[N][]      初始化产生的回路
%k                  矩阵下标
%TTour[N][3]        这次的回路，包括x,y,画图用
%V0                 前驱和后继最大的点
%TEmax              两条边之和
%V[1][3]            暂存删掉的点
%Tour[N-1][3]       删掉一个点后
%OpTour[1][N]       挤点法优化的回路
%TEmin              Ek的最小值
%jOpTour[1][N]     判断回路长度
clear
clc
OData = load('data.txt');
N = size(OData,1);
ed = zeros(N,N); %距离矩阵
max = 0;%寻找最大的一条边
%Every point distance
for i = 1:N 
    for j = 1:N
        if i ~= j
           ed(i,j) = int32(sqrt((OData(i,3) - OData(j,3))^2 + (OData(i,2) - OData(j,2))^2));
           if(max < ed(i,j))
               max = ed(i,j);
           end
        end
    end
end
%compute the best tour distance
BTour = load('best.txt');
len = 0;%回路长度
for i = 1 : N-1
    len = len + ed(BTour(i),BTour(i+1));
end
len = len + ed(BTour(1),BTour(N));
formatSpec = 'best tour length is %d \n';
fprintf(formatSpec,len);
%initialize a tour
%--------------------------------初始化回路---------------------------------
%initialize a Hamiltonian cycle
%1.find the mininum from direct column
%2.change traverse set
%3.switch to the mininum's column
traverse = zeros(1,N); %遍历数组
column = 1;%从第一列开始
initTour = zeros(1,N);%初始化产生的回路
k = 2;%矩阵下标
initTour(1)=1;%默认第一个从 1 开始
while 1
    i = column; %首尾依次遍历
    min = max; %每一列的最小值 初始赋值
    for j = 1:N
        if traverse(j) == 0 & ed(i,j) ~= 0 & min > ed(i,j)
            min = ed(i,j);
            column = j;
        end
    end
    initTour(k) = column;
    k = k + 1;
    traverse(i) = 1; % have traversed
    if k == N + 1
        break ;
    end
end
%51个点的回路，最后一个没连上
%回路的长度
len = 0;
for i = 1 : N-1
    len = ed(initTour(i),initTour(i+1)) + len ;
end
len = ed(initTour(1),initTour(N)) + len ;
formatSpec = 'init tour length is %d \n';
fprintf(formatSpec,len);
%回路坐标
TTour = zeros(N,3);%这次得到的回路
for i=1:N
    k = initTour(i);
    for j=1:3
        TTour(i,j) = OData(k,j);
    end
end    
vertex = TTour(:,1);
x = TTour(:,2);
y = TTour(:,3); 
subplot(2,2,1);
plot(x,y)
line([TTour(N,2),TTour(1,2)],[TTour(N,3) ,TTour(1,3)]);
str = [num2str(vertex)];
text(x,y,str);
title(['InitTour and length is ',num2str(len)]);
%初始化后对两个端点进行优化
%--------------------初始化完成---------回路不理想-----------------------
%--------------------node ejection-----------------------------------------
%--------------------挤点法优化---------------------------------------------
%先找Vo=前驱+后继距离最远
%遍历找最小的Dij,并替换 取最小的(EK=新加的两条边-要连接点的两条边）&保证EK>0(贪心）
%将替换下来的点找EK,终止条件待定
%构成回路的两种策略

%-------------------------------start--------------------------------------
%先找Vo=前驱+后继距离最远
%求距离，找Vo

%version3 每次判断整个路径长度决定是否插入
jOpTour =  zeros(1,N) ; %判断回路长度
jb = 1 ;%判断是否执行
nodeEnum = 1 ; %整个回路挤点次数
while nodeEnum <=2
    %寻找V0;
    V0 = 1 ;  
    TEmax = 0 ;  % 两条边最大的
    pre = initTour(N) ;   % 定义一点的前驱节点 第一点的前驱
    suc = 1 ;   % 初始值无用
    V0pre = pre ;
    V0suc = suc ;
    for i = 1 : N
        k = initTour(i) ; %k代表实际的点
        if i == N
            suc = initTour(1) ;%最后一点的后继
        else
            suc = initTour(i+1) ;
        end
        if TEmax < ed(pre,k) + ed(k,suc)
            TEmax = ed(pre,k) + ed(k,suc) ;
            V0 = k ;
            V0pre = pre ;
            V0suc = suc ;
        end
        pre = k ;
    end
    formatSpec = '两边最长的点V0为 ：%d 它的前驱为 ：%d 它的后继为 ： %d \n';
    fprintf(formatSpec,V0,V0pre,V0suc) ;
    %-----找到Vo,将其前驱与后继断开---------------
    V = zeros(1,3);
    for i = 1:3
        V(1,i) = OData(V0,i);
    end
    V
    % 删除V0
    ind = find (initTour == V0) ;
    TTour(ind,:)=[];
    vertex = TTour(:,1) ;
    x1 = TTour(:,2) ;
    y1 = TTour(:,3) ; 
    subplot(2,2,2) ;
    plot(x1,y1,V(1,2),V(1,3),'o', 'MarkerSize',2) ;
    line([TTour(N-1,2),TTour(1,2)],[TTour(N-1,3) ,TTour(1,3)]);
    str = [num2str(vertex)] ;
    text(x1,y1,str) ;
    text(V(1,2),V(1,3),num2str(V(1,1))) ;
    title(['Delete the point :  ',num2str(V0)]);
        %遍历找最小的Dij,并替换
        %取最小的(EK=新加的两条边-要连接点的两条边）&保证EK>0(贪心）-----------------
        %-----------------------从32开始------------------------------------------
        OpTour = zeros(1,N);%优化的回路
        %初始化前驱 找到要取缔的点V1
        %循环取缔，设置终止条件
        Fd = V0 ;%防抖 防止反复替换一点 Fd存储上一次踢掉的点
        n = 1 ; %终止条件
        OpTour = initTour ;
        OpTour(ind) = [] ;
        while n <= N
            %下面的for循环寻找需要挤出的点
            pre = OpTour(N-1) ;
            TEmin = 2*max ;
            c = 0; %记号 操作是否执行
            d = 0;
            %-------------------------在删掉一个的基础上挤点------------------- 
            for i = 1:N-1
                k = OpTour(i) ;
                if i == N-1
                    suc = OpTour(1) ;
                else
                    suc = OpTour(i+1) ;
                end
                if k ~= Fd & k ~= V0 & k ~= V0pre & k ~= V0suc & TEmin > ed(pre,V0)+ed(V0,suc)-ed(pre,k)-ed(k,suc)& ed(V0,V0pre)+ed(V0,V0suc)-ed(pre,V0)-ed(V0,suc)> 0   %-ed(V0,V0pre)-ed(V0,V0suc)      % 我认为的条件& ed(V0,V0pre)+ed(V0,V0suc)-ed(pre,V0)-ed(V0,suc)> 0 
                    TEmin = ed(pre,V0)+ed(V0,suc)-ed(pre,k)-ed(k,suc) ;   %TEmin = ed(pre,V0) + ed(V0,suc) - ed(pre,k) - ed(k,suc)
                    V1 = k ;
                    V1pre = pre ;
                    V1suc = suc ;
                    loc = i ;%记录V1在数组中的位置
                     d = 1;
                end
                pre = k ;
            end
            if d == 0
                 formatSpec = '加入的边大于原来的来了break\n';
                 fprintf(formatSpec) ;
                 break ;
            end
            formatSpec = '挤出的点为： %d，它的前驱: %d,后继: %d\n';
            fprintf(formatSpec,V1,V1pre,V1suc) ;
            Fd = V(1,1);
            OpTour(loc) = V(1,1) ;
            for j=1:3
                temp = TTour(loc,j) ;
                TTour(loc,j) = V(1,j) ;
                V(1,j) = temp ;
                c = 1 ;
            end
            if c == 1
                n = n + 1 ;
            end
            V0 = V(1,1) ; 
            V0pre = V1pre ; 
            V0suc = V1suc ;
        end
        %------------------------挤点结束--------------------------
        vertex = TTour(:,1) ;
        x2 = TTour(:,2) ;
        y2 = TTour(:,3) ; 
        subplot(2,2,3) ;
        plot(x2,y2,V(1,2),V(1,3),'o', 'MarkerSize',2) ;
        line([TTour(N-1,2),TTour(1,2)],[TTour(N-1,3) ,TTour(1,3)]);
        str = [num2str(vertex)] ;
        text(x2,y2,str) ;
        text(V(1,2),V(1,3),num2str(V(1,1))) ;
        title(['This NodeEjection end and NodeEject num:  ',num2str(n-1)]);
    %---------------构成回路的两种策略 策略2----------------------------
    % V插入一条边中
    TEmin = 2 * max ;
    for i = 1:N-1
        k = TTour(i,1) ;
        if i == N-1
            suc = TTour(1,1);
        else
            suc = TTour(i+1,1);
        end
        if  TEmin > ed(k,V(1,1)) + ed(V(1,1),suc) - ed(k,suc)  %两条加入的边-插入的边
            TEmin = ed(k,V(1,1)) + ed(V(1,1),suc) - ed(k,suc) ;
            V1 = k ;
            V1suc = suc ;
            loc = i ;%记录V1在数组中的位置
        end
    end
    formatSpec = '插入边的两端分别为： %d , %d\n';
    fprintf(formatSpec,V1,V1suc) ;
    %---------------计算回路长度看是否插入-----------------------------------
    %需要知道插入方向,在矩阵中小的位置插入
    jOpTour = OpTour ;
    ind1 = find(jOpTour == V1) ;
    ind2 = find(jOpTour == V1suc) ;
    %插入是往位置小的后面插
    %需要修改 OpTour TTour
    if ind1 < ind2
        if ind2 == N-1 & ind1 == 1
            jOpTour(N) = V(1,1) ;
        else
            OpTour1 = jOpTour(1,1:ind1) ;
            OpTour2 = jOpTour(1,ind1+1:N-1) ;
            jOpTour = [OpTour1,V(1,1),OpTour2] ;%插入V(1,1)
        end 
    else
        if ind1 == N-1 & ind2 == 1
            jOpTour(N) = V(1,1) ;
        else
            OpTour1 = jOpTour(1,1:ind2) ;
            OpTour2 = jOpTour(1,ind2+1:N-1) ;
            jOpTour = [OpTour1,V(1,1),OpTour2] ;
        end
    end
    %node eject tour length
    tlen = 0 ; %测试回路长度
    for i = 1 : N-1
        tlen = ed(jOpTour(i),jOpTour(i+1)) + tlen ;
    end
    tlen = ed(jOpTour(1),jOpTour(N)) + tlen ;
    if tlen >= len
         formatSpec = '挤点回路长度已最短break\n';
         fprintf(formatSpec) ;
         jb = 0 ;
         break ;
    end
    ind1 = find(OpTour == V1) ;
    ind2 = find(OpTour == V1suc) ;
    %插入是往位置小的后面插
    %需要修改 OpTour TTour
    if ind1 < ind2
        if ind2 == N-1 & ind1 == 1
            OpTour(N) = V(1,1) ;
            for j=1:3
                TTour(N,j) = V(1,j) ;
            end
        else
            OpTour1 = OpTour(1,1:ind1) ;
            OpTour2 = OpTour(1,ind1+1:N-1) ;
            OpTour = [OpTour1,V(1,1),OpTour2] ;%插入V(1,1)
            TTour1 = TTour(1:ind1,1:3);
            TTour2 = TTour(ind1+1:N-1,1:3) ;
            TTour = cat(1,TTour1,V,TTour2);%cat 合并
        end 
    else
        if ind1 == N-1 & ind2 == 1
            OpTour(N) = V(1,1) ;
            for j=1:3
                TTour(N,j) = V(1,j);
            end
        else
            OpTour1 = OpTour(1,1:ind2) ;
            OpTour2 = OpTour(1,ind2+1:N-1) ;
            OpTour = [OpTour1,V(1,1),OpTour2] ;
            TTour1 = TTour(1:ind2,1:3) ;
            TTour2 = TTour(ind2+1:N-1,1:3) ;
            TTour = cat(1,TTour1,V,TTour2) ;
        end
    end
    %node eject tour length
    len = 0;
    for i = 1 : N-1
        len = ed(OpTour(i),OpTour(i+1)) + len ;
    end
    len = ed(OpTour(1),OpTour(N)) + len ;
    formatSpec = 'NodeEject Optimize tour length is %d \n';
    fprintf(formatSpec,len) ;
    initTour = OpTour ;
    nodeEnum = nodeEnum + 1 ;    
end
if jb == 1
    vertex = TTour(:,1) ;
    x = TTour(:,2) ;
    y = TTour(:,3) ; 
    subplot(2,2,4) ;
    plot(x,y) ;
    line([TTour(N,2),TTour(1,2)],[TTour(N,3) ,TTour(1,3)]);
    str = [num2str(vertex)] ;
    text(x,y,str) ;
    title(['NodeEject and length is ',num2str(len)]) ;
end
        



    




