clc;
clear all;

Data_dir = ['E:\Under_water_Segmentation_data\Dataset_creation\sample_dataset_for_testing\fullsampledata'];
MyFolderInfo = dir(Data_dir);
pwd
len = length(MyFolderInfo);
TrainImgNo = 0;
% c=0;
TestImgNo = 0;
for cor=1:len
    dataset = MyFolderInfo(cor).name;
    if strcmp(dataset,'.') || strcmp(dataset,'..')        
        continue;
    end
    display([num2str(cor,'%d'),' ',dataset]);
    GreenDir = [Data_dir,'/',dataset,'/data'];
    RedDir = [Data_dir,'/',dataset,'/mask'];
    
    FolderGreen = dir(GreenDir);
    FolderRed = dir(RedDir);
    
    lenGreen = length(FolderGreen);
    lenRed= length(FolderRed);
    
    if lenGreen ~= lenRed
	   continue;
    end
    for idx=1:lenGreen
%         c=c+1;
            img1 = FolderGreen(idx).name;
            img2 = FolderRed(idx).name;
            if strcmp(img1,'.') || strcmp(img1,'..') || strcmp(img1,'Thumbs.db')      
                continue;
            end
            img_Tiles = FolderGreen(idx).name;
            img_mask = FolderRed(idx).name;
            
            
            
            
            
            
            rgb1 = imread([GreenDir,'/',img_Tiles]);
%             rgb1=uint8(rgb1);
           
            mask1 = imread([RedDir,'/',img_mask]);
%             mask1 = uint8(mask1);
%              s=sum(sum(mask1(:,:,4)));
%              [a b c]=size(mask1);
%              if a<512 || b<512 || s==0
%                   continue;
%              end
  
%             rgb1 = imread([GreenDir,'/',img_green]);
% %             size(GreenImage)
%             mask1 = imread([RedDir,'/',img_red]);
            rgb = imresize(rgb1,[256 480]);
            mask = imresize(mask1(:,:,1),[256 480]);
            
            if rand()>0.1
             TrainImgNo = TrainImgNo+1;
             
             
             xtrain(:,:,:,TrainImgNo) = permute(rgb,[2 1 3]);
             ytrain(:,:,TrainImgNo) = permute(mask,[2 1]);
             filename = ['train_images\train\rgb\train_' num2str(TrainImgNo) '.jpg'];
             imwrite(rgb, filename);
             filename = ['train_images\train\mask\train_' num2str(TrainImgNo) '.jpg'];
             imwrite(mask, filename);
             %%%%%%%%%%%%%%%FLIP%%%%%%%%%%%%%%%%
             flip_rgb = fliplr(rgb);   
             flip_mask = fliplr(mask);
             TrainImgNo = TrainImgNo+1;
             
             xtrain(:,:,:,TrainImgNo) = permute(flip_rgb,[2 1 3]);
             ytrain(:,:,TrainImgNo) = permute(flip_mask,[2 1]);
             filename = ['train_images\train\rgb\train_' num2str(TrainImgNo) '.jpg'];
             imwrite(flip_rgb, filename);
             filename = ['train_images\train\mask\train_' num2str(TrainImgNo) '.jpg'];
             imwrite(flip_mask, filename);
             %%%%%%%%%%%%%%%%%%%GAUSSIAN NOISE%%%%%%%%%%%%%%%%%%%%%%%
             noise_rgb = noise(rgb, 0 , 0.008);   
             noise_mask = mask;
             TrainImgNo = TrainImgNo+1;
             
             xtrain(:,:,:,TrainImgNo) = permute(noise_rgb,[2 1 3]);
             ytrain(:,:,TrainImgNo) = permute(noise_mask,[2 1]);
             filename = ['train_images\train\rgb\train_' num2str(TrainImgNo) '.jpg'];
             imwrite(noise_rgb, filename);
             filename = ['train_images\train\mask\train_' num2str(TrainImgNo) '.jpg'];
             imwrite(noise_mask, filename);
             
            else
             TestImgNo = TestImgNo+1;
             xtest(:,:,:,TestImgNo) = permute(rgb,[2 1 3]);
             ytest(:,:,TestImgNo) = permute(mask,[2 1]);
             filename = ['train_images\test\rgb\test_' num2str(TestImgNo) '.jpg'];
             imwrite(rgb, filename);
             filename = ['train_images\test\mask\test_' num2str(TestImgNo) '.jpg'];
             imwrite(mask, filename);
            end
            

    end
end

% % [ss1,ss2,ss3,ss4]=size( xtrain);
% % rand_row=randperm(ss4);
% % for i=1:ss4
% %     xtrain1(:,:,:,i)= xtrain(:,:,:,rand_row(i));
% %     ytrain1(:,:,i) = ytrain(:,:,rand_row(i));
% % end
 hdf5write('TrainDataset_noise2.h5','xtrain',xtrain,'ytrain',ytrain);
% % 
% % [ss1,ss2,ss3,ss4]=size( xtest);
% % rand_row=randperm(ss4);
% % for i=1:ss4
% %     xtest1(:,:,:,i)= xtest(:,:,:,rand_row(i));
% %     ytest1(:,:,i) = ytest(:,:,rand_row(i));
% % end
 hdf5write('TestDataset_noise2.h5','xtest',xtest,'ytest',ytest);
% % % 
