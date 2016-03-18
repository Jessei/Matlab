%��Ҫ����ע���
%OData[N][3]        ԭʼ���ݾ���
% N                 �������
%ed[N][N]           �������
%max                Ѱ������һ����
%len                ��·����
%initTour[N][]      ��ʼ�������Ļ�·
%k                  �����±�
%TTour[N][3]        ��εĻ�·������x,y,��ͼ��
%V0                 ǰ���ͺ�����ĵ�
%TEmax              ������֮��
%V[1][3]            �ݴ�ɾ���ĵ�
%Tour[N-1][3]       ɾ��һ�����
%OpTour[1][N]       ���㷨�Ż��Ļ�·
%TEmin              Ek����Сֵ
%jOpTour[1][N]     �жϻ�·����
clear
clc
OData = load('data.txt');
N = size(OData,1);
ed = zeros(N,N); %�������
max = 0;%Ѱ������һ����
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
len = 0;%��·����
for i = 1 : N-1
    len = len + ed(BTour(i),BTour(i+1));
end
len = len + ed(BTour(1),BTour(N));
formatSpec = 'best tour length is %d \n';
fprintf(formatSpec,len);
%initialize a tour
%--------------------------------��ʼ����·---------------------------------
%initialize a Hamiltonian cycle
%1.find the mininum from direct column
%2.change traverse set
%3.switch to the mininum's column
traverse = zeros(1,N); %��������
column = 1;%�ӵ�һ�п�ʼ
initTour = zeros(1,N);%��ʼ�������Ļ�·
k = 2;%�����±�
initTour(1)=1;%Ĭ�ϵ�һ���� 1 ��ʼ
while 1
    i = column; %��β���α���
    min = max; %ÿһ�е���Сֵ ��ʼ��ֵ
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
%51����Ļ�·�����һ��û����
%��·�ĳ���
len = 0;
for i = 1 : N-1
    len = ed(initTour(i),initTour(i+1)) + len ;
end
len = ed(initTour(1),initTour(N)) + len ;
formatSpec = 'init tour length is %d \n';
fprintf(formatSpec,len);
%��·����
TTour = zeros(N,3);%��εõ��Ļ�·
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
%��ʼ����������˵�����Ż�
%--------------------��ʼ�����---------��·������-----------------------
%--------------------node ejection-----------------------------------------
%--------------------���㷨�Ż�---------------------------------------------
%����Vo=ǰ��+��̾�����Զ
%��������С��Dij,���滻 ȡ��С��(EK=�¼ӵ�������-Ҫ���ӵ�������ߣ�&��֤EK>0(̰�ģ�
%���滻�����ĵ���EK,��ֹ��������
%���ɻ�·�����ֲ���

%-------------------------------start--------------------------------------
%����Vo=ǰ��+��̾�����Զ
%����룬��Vo

%version3 ÿ���ж�����·�����Ⱦ����Ƿ����
jOpTour =  zeros(1,N) ; %�жϻ�·����
jb = 1 ;%�ж��Ƿ�ִ��
nodeEnum = 1 ; %������·�������
while nodeEnum <=2
    %Ѱ��V0;
    V0 = 1 ;  
    TEmax = 0 ;  % ����������
    pre = initTour(N) ;   % ����һ���ǰ���ڵ� ��һ���ǰ��
    suc = 1 ;   % ��ʼֵ����
    V0pre = pre ;
    V0suc = suc ;
    for i = 1 : N
        k = initTour(i) ; %k����ʵ�ʵĵ�
        if i == N
            suc = initTour(1) ;%���һ��ĺ��
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
    formatSpec = '������ĵ�V0Ϊ ��%d ����ǰ��Ϊ ��%d ���ĺ��Ϊ �� %d \n';
    fprintf(formatSpec,V0,V0pre,V0suc) ;
    %-----�ҵ�Vo,����ǰ�����̶Ͽ�---------------
    V = zeros(1,3);
    for i = 1:3
        V(1,i) = OData(V0,i);
    end
    V
    % ɾ��V0
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
        %��������С��Dij,���滻
        %ȡ��С��(EK=�¼ӵ�������-Ҫ���ӵ�������ߣ�&��֤EK>0(̰�ģ�-----------------
        %-----------------------��32��ʼ------------------------------------------
        OpTour = zeros(1,N);%�Ż��Ļ�·
        %��ʼ��ǰ�� �ҵ�Ҫȡ�޵ĵ�V1
        %ѭ��ȡ�ޣ�������ֹ����
        Fd = V0 ;%���� ��ֹ�����滻һ�� Fd�洢��һ���ߵ��ĵ�
        n = 1 ; %��ֹ����
        OpTour = initTour ;
        OpTour(ind) = [] ;
        while n <= N
            %�����forѭ��Ѱ����Ҫ�����ĵ�
            pre = OpTour(N-1) ;
            TEmin = 2*max ;
            c = 0; %�Ǻ� �����Ƿ�ִ��
            d = 0;
            %-------------------------��ɾ��һ���Ļ����ϼ���------------------- 
            for i = 1:N-1
                k = OpTour(i) ;
                if i == N-1
                    suc = OpTour(1) ;
                else
                    suc = OpTour(i+1) ;
                end
                if k ~= Fd & k ~= V0 & k ~= V0pre & k ~= V0suc & TEmin > ed(pre,V0)+ed(V0,suc)-ed(pre,k)-ed(k,suc)& ed(V0,V0pre)+ed(V0,V0suc)-ed(pre,V0)-ed(V0,suc)> 0   %-ed(V0,V0pre)-ed(V0,V0suc)      % ����Ϊ������& ed(V0,V0pre)+ed(V0,V0suc)-ed(pre,V0)-ed(V0,suc)> 0 
                    TEmin = ed(pre,V0)+ed(V0,suc)-ed(pre,k)-ed(k,suc) ;   %TEmin = ed(pre,V0) + ed(V0,suc) - ed(pre,k) - ed(k,suc)
                    V1 = k ;
                    V1pre = pre ;
                    V1suc = suc ;
                    loc = i ;%��¼V1�������е�λ��
                     d = 1;
                end
                pre = k ;
            end
            if d == 0
                 formatSpec = '����ıߴ���ԭ��������break\n';
                 fprintf(formatSpec) ;
                 break ;
            end
            formatSpec = '�����ĵ�Ϊ�� %d������ǰ��: %d,���: %d\n';
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
        %------------------------�������--------------------------
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
    %---------------���ɻ�·�����ֲ��� ����2----------------------------
    % V����һ������
    TEmin = 2 * max ;
    for i = 1:N-1
        k = TTour(i,1) ;
        if i == N-1
            suc = TTour(1,1);
        else
            suc = TTour(i+1,1);
        end
        if  TEmin > ed(k,V(1,1)) + ed(V(1,1),suc) - ed(k,suc)  %��������ı�-����ı�
            TEmin = ed(k,V(1,1)) + ed(V(1,1),suc) - ed(k,suc) ;
            V1 = k ;
            V1suc = suc ;
            loc = i ;%��¼V1�������е�λ��
        end
    end
    formatSpec = '����ߵ����˷ֱ�Ϊ�� %d , %d\n';
    fprintf(formatSpec,V1,V1suc) ;
    %---------------�����·���ȿ��Ƿ����-----------------------------------
    %��Ҫ֪�����뷽��,�ھ�����С��λ�ò���
    jOpTour = OpTour ;
    ind1 = find(jOpTour == V1) ;
    ind2 = find(jOpTour == V1suc) ;
    %��������λ��С�ĺ����
    %��Ҫ�޸� OpTour TTour
    if ind1 < ind2
        if ind2 == N-1 & ind1 == 1
            jOpTour(N) = V(1,1) ;
        else
            OpTour1 = jOpTour(1,1:ind1) ;
            OpTour2 = jOpTour(1,ind1+1:N-1) ;
            jOpTour = [OpTour1,V(1,1),OpTour2] ;%����V(1,1)
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
    tlen = 0 ; %���Ի�·����
    for i = 1 : N-1
        tlen = ed(jOpTour(i),jOpTour(i+1)) + tlen ;
    end
    tlen = ed(jOpTour(1),jOpTour(N)) + tlen ;
    if tlen >= len
         formatSpec = '�����·���������break\n';
         fprintf(formatSpec) ;
         jb = 0 ;
         break ;
    end
    ind1 = find(OpTour == V1) ;
    ind2 = find(OpTour == V1suc) ;
    %��������λ��С�ĺ����
    %��Ҫ�޸� OpTour TTour
    if ind1 < ind2
        if ind2 == N-1 & ind1 == 1
            OpTour(N) = V(1,1) ;
            for j=1:3
                TTour(N,j) = V(1,j) ;
            end
        else
            OpTour1 = OpTour(1,1:ind1) ;
            OpTour2 = OpTour(1,ind1+1:N-1) ;
            OpTour = [OpTour1,V(1,1),OpTour2] ;%����V(1,1)
            TTour1 = TTour(1:ind1,1:3);
            TTour2 = TTour(ind1+1:N-1,1:3) ;
            TTour = cat(1,TTour1,V,TTour2);%cat �ϲ�
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
        



    




