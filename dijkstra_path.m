clear all; clc;
%% Algoritmo de Dijkstra
% Jonas M�ller Gon�alves

% A rota a seguir n�o inclui as dist�ncias chu�-pelotas e ponto N-ira�, uma vez que estas ser�o obrigat�rias
% por�m, o valor da dist�ncia das mesmas � acrescido ao resultado final

WA = [0 80 256 Inf(1,11)];%A
WB = [Inf 0 Inf 96 193 Inf(1,9)];%B
WC = [Inf(1,2) 0 Inf Inf 109 Inf(1,8)];%C
WD = [Inf(1,3) 0 Inf Inf 113 202 Inf(1,6)];%D
WE = [Inf(1,4) 0 Inf Inf Inf 136 Inf(1,5)];%E
WF = [Inf(1,5) 0 Inf Inf 100 Inf(1,5)];%F
WG = [Inf(1,6) 0 Inf Inf 127 Inf(1,4)];%G
WH = [Inf(1,7) 0 Inf 243 Inf(1,4)];%H
WI = [Inf(1,8) 0 Inf 75 Inf(1,3)];%I
WJ = [Inf(1,9) 0 Inf 47 Inf(1,2)];%J
WK = [Inf(1,10) 0 Inf 42 Inf];%K
WL = [Inf(1,11) 0 Inf 78];%L
WM = [Inf(1,12) 0 61];
WN = [Inf(1,13) 0];
Worig = [WA;WB;WC;WD;WE;WF;WG;WH;WI;WJ;WK;WL;WM;WN];
clear WA WB WC WD WE WF WG WH WI WJ WK WL WM WN

W=Worig;
parar = 0; imin = 0; iter = 1;  % Vari�veis Auxiliares
aRotT = [Inf(1,13)];             % R�tulo Antigo Tempor�rio
aRotP = [0 Inf(1,13)];           % R�tulo Antigo Permanente
nRotP = [0 Inf(1,13)];           % Novo R�tulo Permanente
contadores=[2 3 4 5 6 7 8 9 10 11 12 13 14];         % Contadores relativos aos v�rtices, excluindo o primeiro
Vobjetivo = 13;                  % V�rtice objetivo contado a partir do primeiro (excluindo origem)

while parar == 0
    aRotP = nRotP;          % Define o R�tulo Antigo como o Novo R�tulo
    if iter == 1, imin=1;   % V�lido para o primeiro la�o - inicia pelo 0
    else, imin=imin+1;
    end
    
    for ie = 1:size(contadores,2)
        nRotT(ie) = min(aRotT(ie),aRotP(imin)+W(imin,contadores(ie)));  % Equa��o do R�tulo Tempor�rio
    end
    
    if iter == 1
    else, nRotT(marcados) = Inf;    % Evita o erro que ocorre ao manter o vetor completo de r�tulos tempor�rios re-definindo permanentes como infinito
    end
    
    [vmin,imin] = min(nRotT);   % Verifica o menor dos r�tulos tempor�rios
    marcados(iter) = imin;  % Armazena qual r�tulo se tornou permanente
    
    flag=imin+1;            % Flag auxiliar para definir Wij quando i=j como Inf
    nRotP(imin+1) = vmin;   % Define o Novo R�tulo Permanente
    aRotT = nRotT;          % Define o R�tulo Tempor�rio Antigo como o Resultado do Novo R�tulo Tempor�rio
    aRotT(imin) = Inf;      % Define o respectivo tempor�rio que se tornou permanente como Inf
    W(flag,flag)=Inf;       % Define Wij(i=j)=Inf
    
    RotT(:,iter) = nRotT;   % Armazena o R�tulo em uma matriz de tempor�rios
    RotP(:,iter) = nRotP;   % Armazena o R�tulo em uma matriz de permanentes
    
    iter=iter+1;            % Atualiza a Itera��o
    
    if marcados(end) == Vobjetivo, parar=1; % Condi��o de parada - se o �ltimo permanente for o �ltimo v�rtice
    end
end

%% Tratamento para a identifica��o do caminho
MenorCaminho=RotP(end,end);
Temporarios = [Inf(size(RotT,2),1) RotT'];
Temporarios(end,:) = Inf;
Temporarios(end,end) = MenorCaminho;
Temporarios(end+1,:) = Inf;   % Corre��o da matriz completo tempor�ria, adicionando os pontos n�o utilizados

c=1;    % Vari�vel auxiliar de contador
for i=1:size(RotP,2)-1
[perm(c),~]=find(RotP(:,i)~=RotP(:,i+1));   % Identificando quais os r�tulos permanentes que variaram
c=c+1;
end

perm = [1 2 perm];  % Corre��o de um bug que n�o consegui identificar a origem a tempo

%% Checando o Caminho realizado
contador=1; flag=length(perm); caminho=0; caminho(contador)=perm(flag); 

while flag>1 
    [flag,~]=find(Temporarios==MenorCaminho); %verifica onde apareceu o valor minimo
    flag=min(flag); % Identifica onde o m�nimo se tornou permanente, se for menor q 1, para o loop
    caminho(contador+1)=perm(flag); % Atualiza o caminho
    contador=contador+1; % Atualiza o contador
    if flag==1 
        MenorCaminho=min(Temporarios(flag,:)); 
    else
        MenorCaminho=min(Temporarios(flag-1,:));
    end
end

caminho=flip(caminho);

%% Apresentando Resultados
disp(['R�tulos Permanentes = [',num2str(RotP(:,end)'),']']);
disp(['Caminho M�nimo = ',num2str(RotP(end,end)+260+71),' km']);

for i=1:size(caminho,2)
    if caminho(i) == 1, caminhos(i) = 'A';
    elseif caminho(i) == 2,caminhos(i) = 'B';
    elseif caminho(i) == 3,caminhos(i) = 'C';
    elseif caminho(i) == 4,caminhos(i) = 'D';
    elseif caminho(i) == 5,caminhos(i) = 'E';
    elseif caminho(i) == 6,caminhos(i) = 'F';
    elseif caminho(i) == 7,caminhos(i) = 'G';
    elseif caminho(i) == 8,caminhos(i) = 'H';
    elseif caminho(i) == 9,caminhos(i) = 'I';
    elseif caminho(i) == 10,caminhos(i) = 'J';
    elseif caminho(i) == 11,caminhos(i) = 'K';
    elseif caminho(i) == 12,caminhos(i) = 'L';
    elseif caminho(i) == 13,caminhos(i) = 'M';
    elseif caminho(i) == 14,caminhos(i) = 'N';
    end
end
disp(['O caminho m�nimo passa pelos V�rtices: ',num2str(caminhos)]);