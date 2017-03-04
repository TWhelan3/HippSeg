%Start queue
q = LinkedList();

%Initialize Labels structure, each 'point' has a label (0 or 1) a
%'thickness'(<?) and maxima values from when they were labeld. 
binarySurf=zeros(size(grad));
binarySurf(:) = NaN;
maximaSurf=zeros([size(grad) 2]); % Need to store 2 things 
maximaSurf(:) = NaN;
thicknessSurf=zeros(size(grad));
thicknessSurf(:) = NaN;
%Pick a start point
q. add([42, 100, 21]);

max_x = 55;
max_y = 167;
max_z = 93;

count = 0;

searchwindow = 10;

while q.size()~=0 && count < 10000
    
    count = count +1;
    
    start =  q.pop();
    
    startx=start(1);
    starty=start(2);
    startz=start(3);
    
    searchx = startx;
    
    searchy = starty;
    
    searchz = startz;
    
    %get pts surrounding

    range = -searchwindow:searchwindow;

    xdir = zeros(size(range));
    ydir = zeros(size(range));
    zdir = zeros(size(range));

    for off = 1:length(range)

        if(startx+range(off) > 0 && startx+range(off) < max_x)
            xdir(off) = grad(startx+range(off),starty,startz);
        else
            xdir(off) = NaN;
        end
        if(starty+range(off) > 0 && starty+range(off) < max_y)
            ydir(off) = grad(startx,starty+range(off),startz);
        else
            ydir(off) = NaN;
        end
        if(startz+range(off) > 0 && startz+range(off) < max_z)
            zdir(off) = grad(startx,starty,startz+range(off));
        else
            zdir(off) = NaN;
        end

    end
    
    
    
    
%     %Find 'right' local max
%     
%     while( grad(searchx, searchy, searchz) <= grad(searchx+1, searchy, searchz) || ...
%             grad(searchx, searchy, searchz) <= grad(searchx-1, searchy, searchz))
%         
%         searchx=searchx+1;
%         
%         if searchx == max_x
%             break;
%         end
%     end
%     
%     R=searchx;
%     
%     searchx=startx;
%     
%     
%     %Find 'left' local max
%     
%     while( grad(searchx, searchy, searchz) <= grad(searchx+1, searchy, searchz) || ...
%             grad(searchx, searchy, searchz) <= grad(searchx-1, searchy, searchz))
%         
%         searchx=searchx-1;
%         
%         if searchx == 1
%             break;
%         end
%         
%     end
%     
%     L=searchx;
%     
%     searchx=startx;
%     
%     
%     
%     %Find 'up' local max
%     
%     while( grad(searchx, searchy, searchz) <= grad(searchx, searchy+1, searchz) || ...
%             grad(searchx, searchy, searchz) <= grad(searchx, searchy-1, searchz))
%         
%         searchy=searchy+1;
%         
%         if searchy == max_y;
%             break;
%         end
%     end
%     
%     U=searchy;
%     
%     searchy=starty;
%     
%     %Find 'down' local max
%     
%     while( grad(searchx, searchy, searchz) <= grad(searchx, searchy+1, searchz) || ...
%             grad(searchx, searchy, searchz) <= grad(searchx, searchy-1, searchz))
%         
%         searchy=searchy-1;
%         if searchy == 1
%             break;
%         end
%         
%     end
%     
%     D=searchy;
%     
%     searchy=starty;
%     
%     
%     
%     %Find 'forward' local max
%     
%     while( grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz-1) || ...
%             grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz+1))
%         
%         searchz=searchz+1;
%         
%         if searchz == max_z;
%             break;
%         end
%     end
%     
%     F=searchz;
%     
%     searchz=startz;
%     
%     
%     %Find 'backward' local max
%     
%     while( grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz-1) || ...
%             grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz+1))
%         
%         searchz=searchz-1;
%         if searchz == 1
%             break;
%         end
%         
%     end
%     
%     B=searchz;
%     
%     searchz=startz;

    [Lv, Li]=max(xdir(1:searchwindow+1));
    Li=Li+startx-searchwindow-1;
    
    [Rv, Ri]=max(xdir(searchwindow+1:end));
    Ri=Ri+startx-1;
    
    xdist=Ri-Li;
    
    [Dv, Di]=max(ydir(1:searchwindow+1));
    Di=Di+starty-searchwindow-1;
    [Uv, Ui]=max(ydir(searchwindow+1:end));
    Ui=Ui+starty-1;
    ydist=Ui-Di;
    
    [Bv, Bi]=max(zdir(1:searchwindow+1));
    Bi=Bi+startz-searchwindow-1;
    [Fv, Fi]=max(zdir(searchwindow+1:end));
    Fi=Fi+startz-1;
    zdist=Fi-Bi;
    
    %Symmetry check
    
    sym_thr = 2;
    
    if abs((Ri-startx) - (startx-Li)) > sym_thr
        %not symmetrical
    end
    
    if abs((Ui-starty) - (starty-Di)) > sym_thr
        %not symmetrical
    end
    
    if abs((Fi-startx) - (startz-Bi)) > sym_thr
        %not symmetrical
    end
    
    hold off
    plot(xdir, 'r');
    hold on
    plot(ydir, 'g');
    plot(zdir, 'b');
    pause
    
    
    
        
    
    [m,i] = min([xdist ydist zdist]);
    
    if m > 10
        continue;
    end
    
    if i==1
        %check labels
        xdiff = [0 0 0 0];
        ydiff = [1 0 -1 0];
        zdiff = [0 1 0 -1];
        thickness = xdist;
        max1 = grad(Ri,starty,startz);
        max2 = grad(Li,starty,startz);
    elseif i==2
        
        xdiff = [1 0 -1 0];
        ydiff = [0 0 0 0];
        zdiff = [0 1 0 -1];
        thickeness = ydist;
        max1 = grad(startx,Ui,startz);
        max2 = grad(startx,Di,startz);
    elseif i==3
        
        xdiff = [1 0 -1 0];
        ydiff = [0 1 0 -1];
        zdiff = [0 0 0 0];
        thickness = zdist;
        max1 = grad(startx,starty,Fi);
        max2 = grad(startx,starty,Bi);
    end
    for ii = 1:4
        xp = startx+xdiff(ii);
        yp = starty+ydiff(ii);
        zp = startz+zdiff(ii);
        
        if xp == 1 || yp == 1 || zp == 1 || xp == max_x || yp == max_y || zp == max_z
            continue;
        end
        
        if binarySurf(xp,yp,zp) ~= 1
            q.add([xp,yp,zp]);
            binarySurf(xp,yp,zp) = 1;
            maximaSurf(xp,yp,zp, 1) = max1;
            maximaSurf(xp,yp,zp, 2) = max2;
            thicknessSurf(xp,yp,zp) = thickness;
            
        end
    end
end

count