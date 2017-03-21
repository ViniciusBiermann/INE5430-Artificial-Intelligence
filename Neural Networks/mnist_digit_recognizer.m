load exdata.mat

% Prepara��o dos dados de entrada para a rede.

inTrain = zeros(400, 5000);
outTrain = zeros(1, 5000);

for i=0:10-1
    inTrain(1:400, i * 500 + 1:500 * (i + 1)) = ...
        X(1:400, i * 500 + 1:(i * 500) + (500));
    
    outTrain(1, i * 500 + 1:500 * (i + 1)) = ...
        y(1, i * 500 + 1:(i * 500) + (500));
end

trainSize = 5000;
trainOutput = zeros(10,5000);
for i=1:trainSize
  trainOutput(outTrain(1,i), i) = 1;
end

%=============================================%DataPrepFinish%=============================================%
% Normaliza��o dos atributos do conjunto de entrada
[inTrain_N,PS]=mapminmax(inTrain);

% Cria��o da rede. 2 hidden layers, com 100 e 50 neur�nios utilizando as
% fun��es de ativa��o tangente hiperb�lica e sigm�ide. Algoritmo e
% treinamento Conjugate Gradient with Beale-Powell Restars.
net = newff(inTrain_N,trainOutput,[100, 50],{'tansig', 'logsig', 'tansig'},'traincgb');
net.trainParam.epochs=10000; % m�ximo de �pocas
net.trainParam.goal=0.001;    % erro m�nimo

% Separa��o do conjunto em 70% treinamento e 30% teste. N�o foi utilizado
% valida��o.
net.divideParam.trainRatio=0.7;
net.divideParam.valRatio=0.0;
net.divideParam.testRatio=0.3;

% Treinamento da rede
net=train(net,inTrain_N,trainOutput);

% simula��o da rede
Y = sim(net, inTrain_N);

% Matriz de confus�o
plotconfusion(trainOutput,Y);
