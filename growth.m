%Start queue
q = LinkedList();

%Initialize Labels structure, each 'point' has a label (0 or 1) a
%'thickness'(<?) and maxima values from when they were labeld. 
binarySurf=zeros(size(grad));

maximaSurf=zeros([size(grad) 2]); % Need to store 2 things 

thicknessSurf=zeros(size(grad));

%Pick a start point
q. add([42, 100, 21]);

max_x = 55;
max_y = 167;
max_z = 93;

count = 0;

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

%     range = -10:10;
% 
%     xdir = zeros(size(range));
%     ydir = zeros(size(range));
%     zdir = zeros(size(range));
% 
%     for off = 1:length(range)
% 
%         xdir(off) = grad(startx+range(off),starty,startz);
% 
%         ydir(off) = grad(startx,starty+range(off),startz);
% 
%         zdir(off) = grad(startx,starty,startz+range(off));
% 
%     end
    
    
    
    
    %Find 'right' local max
    
    while( grad(searchx, searchy, searchz) <= grad(searchx+1, searchy, searchz) || ...
            grad(searchx, searchy, searchz) <= grad(searchx-1, searchy, searchz))
        
        searchx=searchx+1;
        
        if searchx == max_x
            break;
        end
    end
    
    R=searchx;
    
    searchx=startx;
    
    
    %Find 'left' local max
    
    while( grad(searchx, searchy, searchz) <= grad(searchx+1, searchy, searchz) || ...
            grad(searchx, searchy, searchz) <= grad(searchx-1, searchy, searchz))
        
        searchx=searchx-1;
        
        if searchx == 1
            break;
        end
        
    end
    
    L=searchx;
    
    searchx=startx;
    
    
    
    %Find 'up' local max
    
    while( grad(searchx, searchy, searchz) <= grad(searchx, searchy+1, searchz) || ...
            grad(searchx, searchy, searchz) <= grad(searchx, searchy-1, searchz))
        
        searchy=searchy+1;
        
        if searchy == max_y;
            break;
        end
    end
    
    U=searchy;
    
    searchy=starty;
    
    %Find 'down' local max
    
    while( grad(searchx, searchy, searchz) <= grad(searchx, searchy+1, searchz) || ...
            grad(searchx, searchy, searchz) <= grad(searchx, searchy-1, searchz))
        
        searchy=searchy-1;
        if searchy == 1
            break;
        end
        
    end
    
    D=searchy;
    
    searchy=starty;
    
    
    
    %Find 'forward' local max
    
    while( grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz-1) || ...
            grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz+1))
        
        searchz=searchz+1;
        
        if searchz == max_z;
            break;
        end
    end
    
    F=searchz;
    
    searchz=startz;
    
    
    %Find 'backward' local max
    
    while( grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz-1) || ...
            grad(searchx, searchy, searchz) <= grad(searchx, searchy, searchz+1))
        
        searchz=searchz-1;
        if searchz == 1
            break;
        end
        
    end
    
    B=searchz;
    
    searchz=startz;
    
    xdist=R-L;
    
    ydist=U-D;
    
    zdist=F-B;
    
    %Symmetry check
    
    sym_thr = 2;
    
    if abs((R-startx) - (startx-L)) > sym_thr
        %not symmetrical
    end
    
    if abs((U-starty) - (starty-D)) > sym_thr
        %not symmetrical
    end
    
    if abs((F-startx) - (startz-B)) > sym_thr
        %not symmetrical
    end
    
    
        
    
    [m,i] = min([xdist ydist zdist]);
    
    if i==1
        %check labels
        xdiff = [0 0 0 0];
        ydiff = [1 0 -1 0];
        zdiff = [0 1 0 -1];
        thickness = xdist;
        max1 = grad(R,starty,startz);
        max2 = grad(L,starty,startz);
    elseif i==2
        
        xdiff = [1 0 -1 0];
        ydiff = [0 0 0 0];
        zdiff = [0 1 0 -1];
        thickeness = ydist;
        max1 = grad(startx,U,startz);
        max2 = grad(startx,D,startz);
    elseif i==3
        
        xdiff = [1 0 -1 0];
        ydiff = [0 1 0 -1];
        zdiff = [0 0 0 0];
        thickness = zdist;
        max1 = grad(startx,starty,F);
        max2 = grad(startx,starty,B);
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