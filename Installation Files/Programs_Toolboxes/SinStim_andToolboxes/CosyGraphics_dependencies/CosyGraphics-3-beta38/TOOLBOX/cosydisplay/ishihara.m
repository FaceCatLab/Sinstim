% ISHIHARA  Ishihara's test for color blindness. <UNFINISHED>
% 
% 
% [1] Tout le monde doit voir le chiffre 12.
% 
% [2] Vision normale : 8.
% D�ficience rouge-vert : 3.
% 
% [3] Vision normale : 6.
% D�ficience rouge-vert : 5.
% 
% [4] Vision normale : 29.
% D�ficience rouge-vert : 70.
% 
% [5] Vision normale : 57.
% D�ficience rouge-vert : 35.
% 
% [6] Vision normale : 5.
% D�ficience rouge-vert : 2.
% 
% [7] Vision normale : 3.
% D�ficience rouge-vert : 5.
% 
% [8] Vision normale : 15. D�ficience rouge-vert : 17.
% 
% [9] Vision normale : 74.
% D�ficience rouge-vert : 21.
% 
% [10] Vision normale : 2.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [11] Vision normale : 6.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [12] Vision normale : 97.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [13] Vision normale : 45.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [14] Vision normale : 5.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [15] Vision normale : 7.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [16] Vision normale : 16.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [17] Vision normale : 73.
% La plupart des dischromates ne voient rien, ou de fa�on erron�.
% 
% [18] Sujets normaux et les dischromates tr�s faiblement atteints ne per�oivent rien.
% D�ficience rouge-vert : 5.
% 
% [19] Sujets normaux et les dischromates tr�s faiblement atteints ne per�oivent rien.
% D�ficience rouge-vert : 2.
% 
% [20] Sujets normaux et les dischromates tr�s faiblement atteints ne per�oivent rien.
% D�ficience rouge-vert : 45.
% 
% [21] Sujets normaux et les dischromates tr�s faiblement atteints ne per�oivent rien. D�ficience rouge-vert : 73.
% 
% [22] Vision normale : 26.
% Protanopie ou protanomalie forte lisent seulement : 6.
% Deut�ranopie et deut�ranomalie grave lisent seulement : 2.
% 
% [23] Vision normale : 42.
% Protanopie ou protanomalie forte lisent seulement : 2.
% Deut�ranopie et deut�ranomalie grave lisent seulement : 4.
% 
% [24] Vision normale : 35.
% Protanopie ou protanomalie forte lisent seulement : 5.
% Deut�ranopie et deut�ranomalie grave lisent seulement : 3.
% 
% [25] Vision normale : 96.
% Protanopie ou protanomalie forte lisent seulement : 6.
% Deut�ranopie et deut�ranomalie grave lisent seulement : 9.
% 
% [26] Vision normale : trac�s pourpre et rouge.
% Protanopie ou protanomalie forte : uniquement le trac� pourpre.
% Deut�ranopie et deut�ranomalie : uniquement le trac� rouge.
% 
% [27] Vision normale : trac�s pourpre et rouge.
% Protanopie ou protanomalie forte : uniquement le trac� pourpre.
% Deut�ranopie et deut�ranomalie : uniquement le trac� rouge.
% 
% [28] Vision normale et les dischromates tr�s faiblement atteints ne per�oivent rien.
% D�ficience rouge-vert : un trac�.
% 
% [29] Vision normale et les dischromates tr�s faiblement atteints ne per�oivent rien.
% D�ficience rouge-vert : un trac�.
% 
% [30] Vision normale : trac� bleu-vert.
% La plupart des dischromates ne voient rien.
% 
% [31] Vision normale : trac� bleu-vert.
% La plupart des dischromates ne voient rien.
% 
% [32] Vision normale : trac� orange.
% La plupart des dischromates ne voient rien ou suivent un autre chemin.
% 
% [33] Vision normale : trac� orange.
% La plupart des dischromates ne voient rien ou suivent un autre chemin.
% 
% [34] Vision normale : trac� bleu�tre-vert et jaun�tre-vert.
% D�ficience rouge-vert : uniquement le trac� bleu�tre-vert et pourpre.
% 
% [35] Vision normale : trac� bleu�tre-vert et jaun�tre-vert.
% D�ficience rouge-vert : uniquement le trac� bleu�tre-vert et pourpre.
% 
% [36] Vision normale : trac�s pourpre et orange.
% D�ficience rouge-vert : trac� bleu�tre-vert et pourpre.
% 
% [37] Vision normale : trac�s pourpre et orange.
% D�ficience rouge-vert : trac� bleu�tre-vert et pourpre.
% 
% [38] Tout le monde doit voir le chemin trac�.

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
    