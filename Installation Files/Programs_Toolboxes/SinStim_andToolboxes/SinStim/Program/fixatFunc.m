function [indShapeA,indShapeB,indColorA,indColorB]=fixatFunc(lengthOfBlock,shapeChangesNum,colorChangesNum,simultChangesNum,graceTimeStart,graceTimeEnd,getframedur,nFrames,refractoryPeriod)
% lengthOfBlock=70;
% shapeChangesNum=5;
% colorChangesNum=5;
% simultChangesNum=5;
% graceTimeStart=4;
% graceTimeEnd=4;
frameDurTime=getframedur/1000;
frameNum=nFrames;
% refractoryPeriod=1.5;



totalChangeOfBlocks=shapeChangesNum+colorChangesNum+simultChangesNum;
condPerm=[ones(1,shapeChangesNum) ones(1,colorChangesNum)*2 ones(1,simultChangesNum)*3];
ind=randperm(size(condPerm,2));
condPerm=condPerm(ind);
indShapeA=[];
indShapeB=[];
indColorA=[];
indColorB=[];

jitter=floor(random('unif',0.5,1.5)/frameDurTime);
frameNum=floor(graceTimeStart/frameDurTime+jitter);
stam=randperm(2);
if stam(1)==1
    indShapeA=[1:frameNum];
    currentShape=1;
else
    indShapeB=[1:frameNum];
    currentShape=2;
end

stam=randperm(2);
if stam(1)==1
    indColorA=[1:frameNum];
    currentColor=3;
else
    indColorB=[1:frameNum];
    currentColor=4;
end
frameNum=frameNum+1;

winAver=(lengthOfBlock-graceTimeStart-graceTimeEnd)/totalChangeOfBlocks;
winHalfGap=winAver-refractoryPeriod;
winHigh=winAver+winHalfGap;

for i=1:length(condPerm)
   jitter=floor(random('unif',refractoryPeriod/frameDurTime+1,winHigh/frameDurTime));
   
   if   condPerm(i)==1 
       switch currentShape
           case 1
           indShapeB=[indShapeB frameNum:frameNum+jitter];
           currentShape=2;
               switch currentColor
                   case 3
                       indColorA=[indColorA frameNum:frameNum+jitter];
                   case 4
                       indColorB=[indColorB frameNum:frameNum+jitter];
               end
           frameNum=frameNum+jitter+1;
           case 2
           indShapeA=[indShapeA frameNum:frameNum+jitter];
           currentShape=1;
               switch currentColor
                    case 3
                       indColorA=[indColorA frameNum:frameNum+jitter];
                    case 4
                       indColorB=[indColorB frameNum:frameNum+jitter];
               end
            frameNum=frameNum+jitter+1;
       end
   elseif condPerm(i)==2
       switch currentColor
           case 3
               indColorB=[indColorB frameNum:frameNum+jitter];
               currentColor=4; 
                   switch currentShape
                       case 1
                           indShapeA=[indShapeA frameNum:frameNum+jitter];
                       case 2
                           indShapeB=[indShapeB frameNum:frameNum+jitter];
                   end
                   frameNum=frameNum+jitter+1;
            case 4
               indColorA=[indColorA frameNum:frameNum+jitter];
               currentColor=3;
                   switch currentShape
                        case 1
                           indShapeA=[indShapeA frameNum:frameNum+jitter];
                        case 2
                           indShapeB=[indShapeB frameNum:frameNum+jitter];
                   end
                   frameNum=frameNum+jitter+1;
       end
   elseif condPerm(i)==3
       switch currentShape
           case 1
               indShapeB=[indShapeB frameNum:frameNum+jitter];
               currentShape=2;
               switch currentColor
                   case 3
                   indColorB=[indColorB frameNum:frameNum+jitter];
                   currentColor=4;
                   case 4
                   indColorA=[indColorA frameNum:frameNum+jitter];
                   currentColor=3;
               end
               frameNum=frameNum+jitter+1;
           case 2
               indShapeA=[indShapeA frameNum:frameNum+jitter];
               currentShape=1;
               switch currentColor
                   case 3
                   indColorB=[indColorB frameNum:frameNum+jitter];
                   currentColor=4;
                   case 4
                   indColorA=[indColorA frameNum:frameNum+jitter];
                   currentColor=3;
               end
               frameNum=frameNum+jitter+1;
       end
   end
               
end            
               
   
       
       
