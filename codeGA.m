%Genetic algorithm for gene selection

%parameters of the GA
numprogenie=10000;
numgenes=300;
numgeneraciones=30;
numparentales=50;
tasamutacion=1.07;
sizetranscriptoma=19628;

%F0 beginning
Factual=zeros(numprogenie,numgenes);
Dactual=zeros(numprogenie,10);
for i=1:numprogenie
    Factual(i,:)=randperm(sizetranscriptoma,numgenes);
    Dactual(i,:)=pdist(cellexpr(Factual(i,:),:)','cosine');
end
DIFactual=sum(abs(Dactual-repmat(fitness15b,numprogenie,1)),2);
[B, Ind]=sort(DIFactual,'ascend');

figure,hold on
plot(0,B(1),'ok')
plot(0, B(numparentales),'or')
drawnow
%succesive generations
for j=1:numgeneraciones
    j
    Fparental=Factual(Ind(1:numparentales),:);
    Fnueva=zeros(numprogenie,numgenes);
    Dnueva=zeros(numprogenie,10);
    for k=1:numprogenie
      %  k
        parentales=[Fparental(randperm(numparentales,1),:);Fparental(randperm(numparentales,1),:)];
        reparto=randi(2,numgenes,1);
        hijo=zeros(1,numgenes);
        for kk=1:numgenes
            hijo(1,kk)=parentales(reparto(kk),kk);
        end
        %de novo mutations
        nummut=randi(numgenes-round(numgenes/tasamutacion));
        ind_mutated=randperm(numgenes,nummut);
        for q=1:size(ind_mutated,2)
            
           resttranscriptoma=setdiff(1:sizetranscriptoma,hijo);
           hijo(1,ind_mutated(q))= resttranscriptoma(randperm(size(resttranscriptoma,2),1));
        end
        Fnueva(k,:)=hijo;
        Dnueva(k,:)=pdist(cellexpr(Fnueva(k,:),:)','cosine');
    end
   % for k=numprogenie-numparentales+1:numprogenie
    %    Fnueva(k,:)=Fparental(k-numprogenie+numparentales,:);
    %    Dnueva(k,:)=pdist(cellexpr(Fnueva(k,:),:)','cosine');
    %end
    
DIFnueva=sum(abs(Dnueva-repmat(fitness15b,numprogenie,1)),2);
[B, Ind]=sort(DIFnueva,'ascend');
plot(j,B(1),'ok')
plot(j, B(numparentales),'or')
drawnow
Factual=Fnueva;
end
