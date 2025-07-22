
cd proc_img_training
e=dir;

%set_cells=[13 18 19 5];

acc_net=nan(size(e,1)-2);
size_roi=[32 32 1];

 for q=3:size(e,1)-1
    for qq=q+1:size(e,1)
%for q=8:8
%    for qq=1:4
        
         imds = imageDatastore({e(q).name,e(qq).name},...
 'FileExtensions','.tif','LabelSource','foldernames');
%        imds = imageDatastore({e(q).name,e(set_cells(qq)).name},...
%'FileExtensions','.tif','LabelSource','foldernames');
T=countEachLabel(imds)
numTrainFiles=min([table2array(T(:,2))-5000;100000]);
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

layers = [
    imageInputLayer(size_roi,'Normalization','none')
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];


options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',30, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',200, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu');

net = trainNetwork(imdsTrain,layers,options);
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation)
acc_net(q-2,qq-2)=accuracy
[q qq]
save(strcat('/media/angel/nov18/basalid/fig1_cellset/',e(q).name,'___',e(set_cells(qq)).name,'.mat'));
    end
    
end
