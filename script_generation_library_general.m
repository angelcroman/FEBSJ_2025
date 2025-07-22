%this parameters control size and overlap of the ROIs
size_roi=[24 24];
step_size=8;
%%%
%this parameter recognizes a potential ROI as real (part of a cell)
thresh1=0.3;
%%%
img_size=[960 1280];
cd 'img_training';
e= dir;
num_img_cell=cell(size(e,1)-2,2);

for q=3:size(e,1)

 cd(e(q).name)   
 num_img_cell{q-2,1}=e(q).name;
 contador=0;
 mkdir(strcat('/media/angel/nov18/basalid/fig1_cellset/proc_img_training/',e(q).name,'b'));
 q-2
d=dir('*.tif');
for i=1:size(d,1)
img=imread(d(i).name);
%figure,imshow(img);
%close all
%end

I=rgb2gray(img);
I=imadjust(I);
I2=im2bw(I,graythresh(I));
I3=bwareaopen(~I2,10);

i
for j=1:step_size:img_size(1)-size_roi(1)
for k=1:step_size:img_size(2)-size_roi(2)
temp=I3(j:j+size_roi(1)-1,k:k+size_roi(2)-1);
if sum(temp(:))>=thresh1*size_roi(1)*size_roi(2)
    temp2=I(j:j+size_roi(1)-1,k:k+size_roi(2)-1);
    imwrite(temp2,fullfile(strcat('/media/angel/nov18/basalid/fig1_cellset/proc_img_training/',e(q).name,'b'),strcat('fig_',num2str(i),'_',num2str(j),'_',num2str(k),'.tif')));
    contador=contador+1;
  %  figure,imshow(temp2)
  % pause(0.5)
  % close all
  
end
end
end

end

cd ..
num_img_cell{q-2,2}=contador;

end

cd ..
