function [solution,ud]=su(matrix,TimeLimit,output,udTest,go)
%  [solution,ud]=su(matrix,TimeLimit,output,udTest,go)
%  This is code that solves Sudoku puzzles.
%  "solution" is a 9x9 solution matrix or the scalar 0.
%  "ud" equals...
%     1 if Sudoku is underdetermined
%     0 if Sudoku has ONE solution
%    -1 if number of solutions is unknown
%  "matrix" is a 9x9 matrix
%  "TimeLimit" is in seconds
%  "output" equals 1 if command window output is wanted (else 0)
%  "udTest" equals 1 if the code should try to determine if the Sudoku is
%    underdetermined (else 0). A say "try" because sometimes this takes
%    longer than the TimeLimit allows.
%  "go" equals 1 if determining the difficulty of the Sudoku is a higher
%    priority than speed (else 0).
%
%If there is ONE solution, it will be found quickly regardless of
%difficulty. If it is easy or moderate, the difficulty will be
%displayed. If guessing is needed, the Sudoku is hard and the
%guessing routine will spit out some information about the difficulty such
%as the elapsed time and depth of thread. Perhaps if I implement
%more solving algorithms in suan.m, I could prevent much guessing and give
%better descriptions of difficulty, but I simply refuse to write code for
%all of the many possible algorithms.
%
%If the Sudoku is overdetermined (no solutions), this program will display
%"invalid input matrix."
%
%UNDERdetermined Sudokus will produce one solution. Running the program
%over and over can give other solutions because I put randomness into it.
%This program will notify you if the Sudoku is underdetermined if the
%adjustable time limit is not reached. Extremely underdetermined Sudokus
%will cause this program to spend hours or maybe years, or maybe memory
%will run out eventually.
%
% (c) 2008 Bradley Knockel


%% organize the problem

now=cputime;

solution=0;
ud=-1;

%"matrix" is tested for format errors
if any(size(matrix)~=[9,9])...
        ||ndims(matrix)~=2 ...
        ||any(any(rem(matrix,1)))...
        ||not(strcmp(class(matrix),'double'))...
        ||any(any(matrix<0))...
        ||any(any(matrix>9))
    if output
        disp('su.m error: invalid input format')
    end
    return
end

%Every element in "matrix" is assigned 9 elements in the 3rd dimension of
%"big." These 9 elements are the valid choices for every element in
%"matrix."
big=ones(9);
big=cat(3,big,2*big,3*big,4*big,5*big,6*big,7*big,8*big,9*big);
for c=1:81  %"matrix" alters "big" using "sufu.m"
    value=matrix(c);
    if value
        [a,b]=ind2sub([9,9],c);
        if big(a,b,value)==0
            if output
                disp('su.m error: invalid input matrix (1)')
            end
            return
        end
        big=sufu(c,value,big);
    end
end

%% analyze the problem
%"big and "matrix" are the inputs to this part
%improved versions of "big" and "matrix" are the outputs.
%The improved "matrix" might be the solution.
%This part does much to determine the difficulty of the Sudoku.

[endstate,matrix,big]=suan(big,matrix,0);
if endstate
    solution=matrix;
    ud=0;
    if output
        disp('su.m comment: this is an easy Sudoku, and there is only ONE solution')
    end
    return
end

[endstate,matrix,big]=suan(big,matrix,1);
if endstate
    solution=matrix;
    ud=0;
    if output
        disp('su.m comment: this is a moderate Sudoku, and there is only ONE solution')
    end
    return
end

if output
    disp('su.m comment: no solution yet found, so guessing is needed...')
end  

%% Ariadne's thread
%this part uses algorithmic guesswork for the tricky Sudokus that have not
%yet been solved

%%%%%%%%%%%%%%%%%%PREPARATIONS%%%%%%%%%%%%%%%%%%%%%%%%%

%"list" is created with four columns
%the first is the index of a space that still needs to be solved
%the second is the row of the space
%the third is the column of the space
%the fourth is the number of choices for that square
a=find(matrix==0);
[c,d]=ind2sub([9,9],a);
list=[a,c,d];
b=[];
for a=list'
    b=[b;length(find(big(a(2),a(3),:)))];
end
list=[list,b];
[c,d]=sort(b);  %c and d are different things than before
list=list(d,:);
if list(1,4)==0
    if output
        disp('su.m error: invalid input matrix (2)')
    end
    return
end
%randomize things so depth of thread can change from run to run
if go
    b=list(:,4);
    c=zeros(1,9);
    for i=1:9
        if i==1
            c(i)=length(b(b==i));
        else
            c(i)=length(b(b==i))+c(i-1);
        end
    end
    ind=zeros(1,size(list,1));
    for i=1:9
        if i==1
            ind(1:c(1))=randperm(c(1));
        else
            ind(c(i-1)+1:c(i))=randperm(c(i)-c(i-1))+c(i-1);
        end
    end
    list=list(ind,:);
end

%"choices" is created from "big" so that all the zeros are at the least
%possible depth (I need to randomize "choices" to produce unbiased
%solutions for underdetermined Sudokus, or else I could just use "sort")
choices=zeros(9,9,9);
for c=1:81
    [a,b]=ind2sub([9,9],c);
    y=big(a,b,:);
    y=y(y~=0);
    x=numel(y);
    y=y(randperm(x));
    choices(a,b,1:x)=y;
end

%"lists" is starting to form
lists=1:list(1,4);

%%%%%%%%%%%%%%%%%%LET'S DO THIS MOFO!!!!%%%%%%%%%%%%%%%%%%%%%%
%this part creates "matrix2," which is hoped to be a solvable guess based
%on "matrix." If it is solvable, "solution" is displayed.

for a=1:(size(list,1)-3)   % "a" is the length of Ariadne's thread

    %create "lists," an axf matrix where each column is a thread
    if a>1
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
        [d,bla,big3]=suan(big2,matrix2,go);
        if d
            solution=bla;
            if output
                disp('su.m comment: solution found!')
                disp(['su.m comment: elapsed time is ',num2str(cputime-now,'%.4f'),' seconds'])
                if go>0,disp(['su.m comment: depth of thread is ',int2str(a)]),end
            end
            if udTest
                if output
                    disp('su.m comment: testing to see if Sudoku is underdetermined...')
                end
                lists(:,f)=[];
                switch suu(big,matrix,list,lists,choices,now,TimeLimit,a)
                    case {0}
                        if output
                            disp('su.m comment: only ONE solution exists')
                            disp(['su.m comment: total elapsed time is ',num2str(cputime-now,'%.4f'),' seconds'])
                        end
                        ud=0;
                    case {1}
                        if output
                            disp('su.m comment: Sudoku is underdetermined (i.e. multiple solutions exist)')
                            disp(['su.m comment: total elapsed time is ',num2str(cputime-now,'%.4f'),' seconds'])
                        end
                        ud=1;
                    otherwise
                        if output
                            disp('su.m error: I give up, and so should you (i.e. time limit reached)')
                        end
                end
            end
            return
        end

        %see if big3 is reasonable
        r=-1*ones(9);
        r(bla==0)=0;
        if any(any(any(big3,3)==r))
            fbad=[fbad,f];
            continue
        end

        if cputime-now>TimeLimit
            if output
                disp('su.m error: I give up, and so should you (i.e. time limit reached)')
                disp(['su.m comment: depth of thread is ',int2str(a)])
            end
            return
        end

    end
    lists(:,fbad)=[];

end

if output
    disp('su.m error: invalid input matrix (3)')
    disp(['su.m comment: elapsed time is ',num2str(cputime-now,'%.4f'),' seconds'])
end
