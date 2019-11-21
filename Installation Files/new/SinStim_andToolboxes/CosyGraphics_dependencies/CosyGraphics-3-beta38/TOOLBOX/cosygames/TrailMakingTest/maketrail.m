function XY = maketrail(FinalNbOfCircles,ExclusionDiameter,NbOfReachableNeighbors)
% MAKETRAIL  Generate x, y coordinates of circles for TRAILMAKINGTEST.
%    XY = MAKETRAIL(NbOfCircles,ExclusionDiameter,NbOfReachableNeighbors)

%% Input Args
if nargin<3, error('Not enough input args.'); end

%% Pure Random Trail
if NbOfReachableNeighbors==0
    XY = randxy(FinalNbOfCircles,'round',Param.ExclusionDiameter);

%% Not Totally Random Trail: Choose between N closest neighbors
else
    InitialNbOfCircles = FinalNbOfCircles + NbOfReachableNeighbors;

    XY = round(randxy(InitialNbOfCircles,'round',ExclusionDiameter));
    X = XY(:,1);
    Y = XY(:,2);

    % b=0;
    % clearbuffer;
    % draw('rounddots', [0 0 .5], b, XY, 44);
    % draw('rounddots', [.8 .8 .8], b, XY, 40);
    % for i=1:InitialNbOfCircles
    %     xy = XY(i,:) + [0 -6];
    %     drawtext(num2str(i), b, xy, [0 0 0], 18);
    % end
    % displaybuffer(b);

    order = zeros(FinalNbOfCircles,1);
    order(1) = 1;
    choosen = false(InitialNbOfCircles,1);
    choosen(1) = true;

    for i = 1 : FinalNbOfCircles-1
        [TH,R] = cart2pol(X-X(order(i)),Y-Y(order(i)));
        [R,I] = sort(R);
        candidates = I(2:1+NbOfReachableNeighbors);
        nFree = sum(~choosen(candidates));
        if nFree
            candidates = intersect(candidates,find(~choosen));
            elected = randele(candidates);
        else
            sorted = I(2:end);
            isfree = ~choosen(sorted);
            f = find(isfree);
            sorted_free = sorted(f);
            candidates = sorted_free(1:NbOfReachableNeighbors);
            elected = randele(candidates);
        end
        order(i+1) = elected;
        choosen(elected) = true;
    end
    XYini=XY;
    workspaceexport
    XY = XY(order,:);
end