function ud=suu(big,matrix,list,lists,choices,now,TimeLimit,a0)

%
%function used within su.m
%
% (c) 2008 Bradley Knockel

%this function tries to determine if "matrix" is underdetermined

ud=-1;

%we start where the old routine left off, except now the thread that
%contains the known solution has been taken out of "lists" already
for a=a0:(size(list,1)-3)   % "a" is the length of Ariadne's thread
    
    %create "lists," an axf matrix where each column is a thread
    if a>1 && a~=a0
        b=list(a,4);
        lists=repmat(lists,1,b);
        lists=[lists;sort(repmat(1:b,1,size(lists,2)/b))];
    end
    
    fbad=[];
    for f=1:size(lists,2)   % "f" is a possible thread given "a"
        
        %create "matrix2"
        big2=big;
        matrix2=matrix;
        problem=0;
        for e=1:a
            number=choices(list(e,2),list(e,3),lists(e,f));
            if big2(list(e,2),list(e,3),number)==0
                problem=1;
            end
            matrix2(list(e,2),list(e,3))=number;
            big2=sufu(list(e,1),number,big2);
        end
        if problem
            fbad=[fbad,f];
            continue
        end

        %test "matrix2"
        [d,bla,big2]=suan(big2,matrix2,0);
        if d
            ud=1;
            return
        end

        %see if big2 is reasonable
        r=-1*ones(9);
        r(bla==0)=0;
        if any(any(any(big2,3)==r))
            fbad=[fbad,f];
            continue
        end
        
        if cputime-now>TimeLimit
            return
        end

    end
    lists(:,fbad)=[];
    
end

ud=0;
