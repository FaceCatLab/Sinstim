% ISHIHARA  Ishihara's test for color blindness. <UNFINISHED>
% 
% 
% [1] Tout le monde doit voir le chiffre 12.
% 
% [2] Vision normale : 8.
% Déficience rouge-vert : 3.
% 
% [3] Vision normale : 6.
% Déficience rouge-vert : 5.
% 
% [4] Vision normale : 29.
% Déficience rouge-vert : 70.
% 
% [5] Vision normale : 57.
% Déficience rouge-vert : 35.
% 
% [6] Vision normale : 5.
% Déficience rouge-vert : 2.
% 
% [7] Vision normale : 3.
% Déficience rouge-vert : 5.
% 
% [8] Vision normale : 15. Déficience rouge-vert : 17.
% 
% [9] Vision normale : 74.
% Déficience rouge-vert : 21.
% 
% [10] Vision normale : 2.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [11] Vision normale : 6.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [12] Vision normale : 97.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [13] Vision normale : 45.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [14] Vision normale : 5.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [15] Vision normale : 7.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [16] Vision normale : 16.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [17] Vision normale : 73.
% La plupart des dischromates ne voient rien, ou de façon erroné.
% 
% [18] Sujets normaux et les dischromates très faiblement atteints ne perçoivent rien.
% Déficience rouge-vert : 5.
% 
% [19] Sujets normaux et les dischromates très faiblement atteints ne perçoivent rien.
% Déficience rouge-vert : 2.
% 
% [20] Sujets normaux et les dischromates très faiblement atteints ne perçoivent rien.
% Déficience rouge-vert : 45.
% 
% [21] Sujets normaux et les dischromates très faiblement atteints ne perçoivent rien. Déficience rouge-vert : 73.
% 
% [22] Vision normale : 26.
% Protanopie ou protanomalie forte lisent seulement : 6.
% Deutéranopie et deutéranomalie grave lisent seulement : 2.
% 
% [23] Vision normale : 42.
% Protanopie ou protanomalie forte lisent seulement : 2.
% Deutéranopie et deutéranomalie grave lisent seulement : 4.
% 
% [24] Vision normale : 35.
% Protanopie ou protanomalie forte lisent seulement : 5.
% Deutéranopie et deutéranomalie grave lisent seulement : 3.
% 
% [25] Vision normale : 96.
% Protanopie ou protanomalie forte lisent seulement : 6.
% Deutéranopie et deutéranomalie grave lisent seulement : 9.
% 
% [26] Vision normale : tracés pourpre et rouge.
% Protanopie ou protanomalie forte : uniquement le tracé pourpre.
% Deutéranopie et deutéranomalie : uniquement le tracé rouge.
% 
% [27] Vision normale : tracés pourpre et rouge.
% Protanopie ou protanomalie forte : uniquement le tracé pourpre.
% Deutéranopie et deutéranomalie : uniquement le tracé rouge.
% 
% [28] Vision normale et les dischromates très faiblement atteints ne perçoivent rien.
% Déficience rouge-vert : un tracé.
% 
% [29] Vision normale et les dischromates très faiblement atteints ne perçoivent rien.
% Déficience rouge-vert : un tracé.
% 
% [30] Vision normale : tracé bleu-vert.
% La plupart des dischromates ne voient rien.
% 
% [31] Vision normale : tracé bleu-vert.
% La plupart des dischromates ne voient rien.
% 
% [32] Vision normale : tracé orange.
% La plupart des dischromates ne voient rien ou suivent un autre chemin.
% 
% [33] Vision normale : tracé orange.
% La plupart des dischromates ne voient rien ou suivent un autre chemin.
% 
% [34] Vision normale : tracé bleuâtre-vert et jaunâtre-vert.
% Déficience rouge-vert : uniquement le tracé bleuâtre-vert et pourpre.
% 
% [35] Vision normale : tracé bleuâtre-vert et jaunâtre-vert.
% Déficience rouge-vert : uniquement le tracé bleuâtre-vert et pourpre.
% 
% [36] Vision normale : tracés pourpre et orange.
% Déficience rouge-vert : tracé bleuâtre-vert et pourpre.
% 
% [37] Vision normale : tracés pourpre et orange.
% Déficience rouge-vert : tracé bleuâtre-vert et pourpre.
% 
% [38] Tout le monde doit voir le chemin tracé.

S.Normal = [ ...
    12	8 6 29 57 5 3 15 74 2 ...
    6 97 45 5 7 16 73 nan nan nan ...
    nan 26 42 35 96 nan nan nan nan nan ...
    nan nan nan nan nan nan nan nan ]';
S.Deficient = [ ...
    12 3 5 70 35 2 5 17 21 2 ...
    6 97 45 5 7 16 73 5 2 45 ...
    0 26 42 35 96 nan nan nan nan nan ...
    nan nan nan nan nan nan nan nan ]';
S.Deficiency = { ...
    'none', 'red-green', 'red-green', 'red-green', 'red-green', 'red-green', 'red-green', 'red-green', 'red-green', 
    