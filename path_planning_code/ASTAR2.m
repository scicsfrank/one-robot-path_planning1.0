function ASTAR2(handles,map2,startposind,goalposind)
 n = 11;   % field size n x n tiles  20*20的界面
%wallpercent = 0.3;  % this percent of field is walls   15%的界面作为阻碍物（墙）
cmap = [1 1 1; ...%  1 - white - 空地
        0 0 0; ...% 2 - black - 障碍 
        1 0 0; ...% 3 - red - 已搜索过的地方
        0 0 1; ...% 4 - blue - 下次搜索备选中心 
        0 1 0; ...% 5 - green - 起始点
        1 1 0;...% 6 - yellow -  到目 标点的路径 
       1 0 1];% 7 - -  目标点 
colormap(cmap); 
 field = map2;
costchart = NaN*ones(n);      %costchart用来存储各个点的实际代价，NaN代表不是数据（不明确的操作）
% set the cost at the starting position to be 0
costchart(startposind) = 0;     %起点的实际代价
% make fieldpointers as a cell array  生成n*n的元胞
fieldpointers = cell(n);      %fieldpointers用来存储各个点的来源方向
% set the start pointer to be "S" for start, "G" for goal   起点设置为"S",终点设置为"G"
% everywhere there is a wall, put a 0 so it is not considered   墙设置为0
fieldpointers(field == 2) = {0};      %很好的方式，field == Inf 返回墙的位置，fieldpointers(field == Inf)设置相应的位置
% field(field == Inf)=2;
fieldpointers{startposind} = 'S'; fieldpointers{goalposind} = 'G';
setOpen = (startposind); setOpenCosts = (0); setOpenHeuristics = (Inf);
setClosed = []; setClosedCosts = [];%初始化起点的open表和close表
movementdirections = {'L','R','U','D'};
%movementdirections1 = {'LU','RU','LD','RD'};
% keep track of the number of iterations to exit gracefully if no solution
counterIterations = 1;
% uicontrol('Style','pushbutton','String','RE-DO', 'FontSize',12, ...
%          'Position', [10 10 60 40], 'Callback','ASTAR');

tic
while true %ismember(A,B)返回与A同大小的矩阵，其中元素1表示A中相应位置的元素在B中也出现，0则是没有出现
  % for the element in OPEN with the smallest cost
  field(startposind )=5;
  field(goalposind )=7;
  image(handles,1.5,1.5,field); 
   set(gca,'gridline','-','gridcolor','r','linewidth',2);
    set(gca,'xtick',1:1:12,'ytick',1:1:12);
grid on; 
axis image;
title('基于A*算法的路径规划 ','fontsize',16)
drawnow;
   if(max(ismember(setOpen,goalposind))) 
       break;
   end;    
  [~, ii] = min(setOpenCosts + setOpenHeuristics);   %从OPEN表中选择花费最低的点temp,ii是其下标(也就是标号索引)

  field(setOpen(ii))=3;
 % field(setOpen1(ii1))=3;
  %n = length(field);  % length of the field
    % convert linear index into [row column]
    [currentpos(1), currentpos(2)] = ind2sub([n n],setOpen(ii));
   % [currentpos1(1), currentpos1(2)] = ind2sub([10 10],setOpen1(ii1));%获得以起点扩展的当前点的行列坐标，注意currentpos(1)是行坐标，currentpos(2)是列坐标
    [goalpos(1) ,goalpos(2)] = ind2sub([n n],goalposind);       %获得目标点的行列坐标
   % [startpos(1) ,startpos(2)] = ind2sub([10 10],startposind);
    % places to store movement cost value and position
    cost = Inf*ones(4,1); heuristic = Inf*ones(4,1); pos = ones(4,2);  
    % if we can look left, we move from the right  左侧
    newx = currentpos(1) ; newy = currentpos(2)-1; 
    if newy > 0  %如果没有到边界
      pos(1,:) = [newx newy];   %获得新的坐标
      heuristic(1) = abs(goalpos(1)-newx) + abs(goalpos(2)-newy);    %heuristic(1)为启发函数计算的距离代价
      % heuristic(1) = sqrt((goalpos(1)-newx)^2 + (goalpos(2)-newy)^2);    %heuristic(1)为启发函数计算的距离代价
      cost(1) = setOpenCosts(ii) +  field(newx,newy);   %costsofar为之前花费的代价，field(newy,newx)为环境威胁代价，cost(1)为经过此方向点的真实代价
    end

    % if we can look right, we move from the left  向右查询
    newx = currentpos(1); newy = currentpos(2)+1;
    if newy <= 11
      pos(2,:) = [newx newy];
     heuristic(2) = abs(goalpos(1)-newx) + abs(goalpos(2)-newy);  %heuristic(1)为启发函数计算的距离代价
     % heuristic(2) = sqrt((goalpos(1)-newx)^2 + (goalpos(2)-newy)^2); 
      cost(2) =setOpenCosts(ii) +  field(newx,newy);
    end

    % if we can look up, we move from down  向上查询
    newx = currentpos(1)+1; newy = currentpos(2);
    if newx <= 11
      pos(3,:) = [newx newy];
      heuristic(3) = abs(goalpos(1)-newx) + abs(goalpos(2)-newy);    %heuristic(1)为启发函数计算的距离代价
    %  heuristic(3) = sqrt((goalpos(1)-newx)^2 + (goalpos(2)-newy)^2); 
      cost(3) =setOpenCosts(ii) + field(newx,newy);
    end

    % if we can look down, we move from up  向下查询
    newx = currentpos(1)-1; newy = currentpos(2);
    if newx > 0
      pos(4,:) = [newx newy];
      heuristic(4) = abs(goalpos(1)-newx) + abs(goalpos(2)-newy);    %heuristic(1)为启发函数计算的距离代价
  %heuristic(4) = sqrt((goalpos(1)-newx)^2 + (goalpos(2)-newy)^2); 
      cost(4) = setOpenCosts(ii) +  field(newx,newy);
    end

%   %   if we can look right up, we move from down  右上查询
%      newx = currentpos(1)-1; newy = currentpos(2)+1;
%      if (newy <= n && newx>0)
%       pos1(2,:) = [newx newy];
%      heuristic1(2) = abs(goalpos(1)-newx) + abs(goalpos(2)-newy);    %heuristic(1)为启发函数计算的距离代价
%     cost1(2) = setOpenCosts(ii)  +sqrt(2)*field(newx,newy);
%      end
%  %  if we can look left down, we move from down  左下查询
%      newx = currentpos(1)+1; newy = currentpos(2)-1;
%      if (newy > 0 && newx<=n)
%        pos1(3,:) = [newx newy];
%        heuristic1(3) = abs(goalpos(1)-newx) + abs(goalpos(2)-newy);    %heuristic(1)为启发函数计算的距离代价
%       cost1(3) = setOpenCosts(ii)  + sqrt(2)*field(newx,newy);
%      end
%     %if we can look right down, we move from down  右下查询
%      newx = currentpos(1)+1; newy = currentpos(2)+1;
%      if (newx <= n && newy<=n)
%        pos1(4,:) = [newx newy];    
%       heuristic1(4) = abs(goalpos(1)-newx) + abs(goalpos(2)-newy);    %heuristic(1)为启发函数计算的距离代价
%        cost1(4) = setOpenCosts(ii)  + sqrt(2)*field(newx,newy);
%      end
     posinds = sub2ind([n,n],pos(:,1),pos(:,2));
   %  posinds1 = sub2ind([10,10],pos1(:,1),pos1(:,2));
    %  posinds1 = sub2ind([n n],pos1(:,1),pos1(:,2));
      setClosed = [setClosed; setOpen(ii)];     %将temp插入CLOSE表中
   setClosedCosts = [setClosedCosts; setOpenCosts(ii)];  %将temp的花费计入ClosedCosts
  %   setClosed1 = [setClosed1; setOpen1(ii1)];     %将temp插入CLOSE表中
  %setClosedCosts1 = [setClosedCosts1; setOpenCosts1(ii1)];  %将temp的花费计入ClosedCosts
  % update OPEN and their associated costs  更新OPEN表 分为三种情况
    if (ii > 1 && ii < length(setOpen))   %temp在OPEN表的中间，删除temp
        setOpen = [setOpen(1:ii-1); setOpen(ii+1:end)];
        setOpenCosts = [setOpenCosts(1:ii-1); setOpenCosts(ii+1:end)];
        setOpenHeuristics = [setOpenHeuristics(1:ii-1); setOpenHeuristics(ii+1:end)];
  elseif (ii == 1)
        setOpen = setOpen(2:end);   %temp是OPEN表的第一个元素，删除temp
        setOpenCosts = setOpenCosts(2:end);
        setOpenHeuristics = setOpenHeuristics(2:end);
  else     %temp是OPEN表的最后一个元素，删除temp
        setOpen = setOpen(1:end-1);
        setOpenCosts = setOpenCosts(1:end-1);
        setOpenHeuristics = setOpenHeuristics(1:end-1);
    end

%    if (ii1 > 1 && ii1 < length(setOpen1))   %temp在OPEN表的中间，删除temp
%     setOpen1 = [setOpen1(1:ii1-1); setOpen1(ii1+1:end)];
%     setOpenCosts1 = [setOpenCosts1(1:ii1-1); setOpenCosts1(ii1+1:end)];
%     setOpenHeuristics1 = [setOpenHeuristics1(1:ii1-1); setOpenHeuristics1(ii1+1:end)];
%   elseif (ii1 == 1)
%     setOpen1 = setOpen1(2:end);   %temp是OPEN表的第一个元素，删除temp
%     setOpenCosts1 = setOpenCosts1(2:end);
%     setOpenHeuristics1 = setOpenHeuristics1(2:end);
%   else     %temp是OPEN表的最后一个元素，删除temp
%     setOpen1 = setOpen1(1:end-1);
%     setOpenCosts1 = setOpenCosts1(1:end-1);
%     setOpenHeuristics1 = setOpenHeuristics1(1:end-1);
%   end
  % for each of these neighbor spaces, assign costs and pointers; 
  % and if some are in the CLOSED set and their costs are smaller, 
  % update their costs and pointers
  for jj=1:length(posinds)      %对于扩展的四个方向的坐标
    % if cost infinite, then it's a wall, so ignore
    if(field(posinds(jj))~=3 && field(posinds(jj))~=2 && field(posinds(jj))~=5)
       field(posinds(jj))=4; 
%        if ~isinf(cost(jj))    %如果此点的实际代价不为Inf,也就是没有遇到墙
      % if node is not in OPEN or CLOSED then insert into costchart and 
      % movement pointers, and put node in OPEN
      if ~max([setClosed; setOpen] == posinds(jj)) %如果此点不在OPEN表和CLOSE表中
        fieldpointers(posinds(jj)) = movementdirections(jj); %将此点的方向存在对应的fieldpointers中
        costchart(posinds(jj)) = cost(jj); %将实际代价值存入对应的costchart中
        setOpen = [setOpen; posinds(jj)]; %将此点加入OPEN表中
        setOpenCosts = [setOpenCosts; cost(jj)];   %更新OPEN表实际代价
        setOpenHeuristics = [setOpenHeuristics; heuristic(jj)];    %更新OPEN表启发代价
      % else node has already been seen, so check to see if we have
      % found a better route to it.
      elseif max(setOpen == posinds(jj)) %如果此点在OPEN表中
        I = find(setOpen == posinds(jj));   %找到此点在OPEN表中的位置
        % update if we have a better route
        if setOpenCosts(I) > cost(jj)  %如果在OPEN表中的此点实际代价比现在所得的大
          costchart(setOpen(I)) = cost(jj);    %将当前的代价存入costchart中，注意此点在costchart中的坐标与其自身坐标是一致的（setOpen(I)其实就是posinds(jj)），下同fieldpointers
          setOpenCosts(I) = cost(jj);      %更新OPEN表中的此点代价，注意此点在setOpenCosts中的坐标与在setOpen中是一致的，下同setOpenHeuristics
          setOpenHeuristics(I) = heuristic(jj);    %更新OPEN表中的此点启发代价(窃以为这个是没有变的)
          fieldpointers(setOpen(I)) = movementdirections(jj);   %更新此点的方向   
        end
      end
     end
  end

  
if isempty(setOpen)
  %if (isempty(setOpen) && isempty(setOpen1))
      break; 
 end%当OPEN表为空，代表可以经过的所有点已经查询完毕
%   frame = getframe;
%     writeVideo(writerObj,frame);
end
if max(ismember(setOpen,goalposind))    %当找到目标点时
%if(setOpen(ii)==setOpen1(ii1))
  disp('已找到路径!');  %disp： Display array， disp(X)直接将矩阵显示出来，不显示其名字，如果X为string，就直接输出文字X
  % n = length(fieldpointers);  % length of the field
    posind = goalposind;
    [px,py] = ind2sub([n,n],posind);
    p = [px py];
    p1=posind;
%    until we are at the starting position
    while ~strcmp(fieldpointers{posind},'S')    %当查询到的点不是'S'起点时
      switch fieldpointers{posind}
        case 'L' % move left  如果获得该点的来源点方向为左时
          py = py +1;
        case 'R' % move right
          py = py - 1;
        case 'U' % move up
          px = px - 1;
        case 'D' % move down
          px = px + 1;
%         case'RD'
%           px = px - 1;  
%            py = py -1;
%         case'LD'   
%             px = px- 1; 
%              py = py + 1;
%         case'LU'  
%             px = px +1;
%             py = py +1;
%         case'RU'  
%             px = px + 1; 
%             py = py - 1;
     end
      p = [p; px py];
      posind = sub2ind([n n],px,py);
      p1=[p1;posind];  
    end  
      p1=flipud(p1);    
    for k = 2:length(p1) - 1 
        field(p1(k)) =6;
        image(handles,1.5, 1.5, field);
        set(gca,'gridline','-','gridcolor','r','linewidth',2);
        set(gca,'xtick',1:1:12,'ytick',1:1:12);
        grid on;
        axis image;
        title('基于A*算法的路径规划 ','fontsize',16)
        drawnow;
    end      
 else if isempty(setOpen)
  disp('路径不存在!'); 
     end
end
toc