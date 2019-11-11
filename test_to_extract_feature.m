clear all;
tic;
caffe.set_mode_gpu();
gpu_id = 0;  % we will use the first gpu in this demo
caffe.set_device(gpu_id);
load ilsvrc_2012_mean.mat; % load mean
% create net and load weights
net = caffe.Net('deploy.prototxt', 'bvlc_reference_caffenet.caffemodel', 'test');
net.blobs('data').reshape([227 227 3 1]);
choose_to_delete_zero=1; % Set this to 1 to delete zero(padding zero) in the proposals
                         % If this is 0, it means that padding zero will remain in the proposals 
                         
% load image and forward (do this on each image)
im_data = caffe.io.load_image('000001.jpg'); % load image in caffe's data format
im_data = imresize(im_data, [256 256]) - mean_data; % resize to 256 x 256 and subtract mean
im_data = im_data(15:241, 15:241, :); % take 227 x 227 center crop
res = net.forward({im_data}); % run forward
feat = net.blobs('conv5').get_data();%conv5

patch_size=11;
patch_stride=3;
row_num=(227-patch_size)/patch_stride+1;
col_num=(227-patch_size)/patch_stride+1;

for i=1:row_num
    for j=1:col_num
    test_data=im_data;
    test_data((i-1)*patch_stride+1:(i-1)*patch_stride+patch_size,(j-1)*patch_stride+1:(j-1)*patch_stride+patch_size,:)=0;
    res_patch_image = net.forward({test_data}); % run forward
    feat_patch_image = net.blobs('conv5').get_data();%conv5
    divide_abs=abs(feat-feat_patch_image);% Here I use the absolute value and maybe it remains to change. 
    mean_abs_patch_image(i,j)=mean(mean(mean(divide_abs)));% absolute mean
    std_abs_patch_image(i,j)=std(divide_abs(:));% std of the absolute divide
    temp=cov(feat(:),feat_patch_image(:));
    cov_patch_image(i,j)=temp(1,2);% covariace of feat and feat_patch_image
    temp2=corrcoef(feat,feat_patch_image);
    corr(i,j)=temp2(1,2);% corrcoefficient of feat and feat_patch_image
    end
end

rf_stride=16; %conv5
feature_size=13;%conv5
rf_size=84;%conv5
Im_data_ori=imread('000014.jpg');% notice here when changing different picture.
Im_data_ori=imresize(Im_data_ori,[256,256]);% This following two lines is in correspondence with the above crop pre-processing in feature extraction step 
Im_data_ori=Im_data_ori(15:241, 15:241, :);%
total_size=rf_stride*(feature_size-1)+rf_size;
im_pad=zeros(total_size,total_size,3);
im_pad=im2uint8(im_pad);
im_pad((total_size+1-227+1)/2:(total_size+227)/2,(total_size+1-227+1)/2:(total_size+227)/2,:)=Im_data_ori;% Because the zero padding step in the former layer, 
                                                                                                          % here I pad the same amount of zero around the original image.
                                                                                                          % Maybe there is another solution : scale.

[c,d]=sort(feat(:),'descend');

k=400;% get the top 15 activated 
for i=1:k
    [x(i),y(i),z(i)]=ind2sub([size(feat,1),size(feat,2),size(feat,3)],d(i));
end

figure;
for j=1:k
    subplot(3,5,j);
    a=(x(j)-1)*rf_stride+1;
    b=(x(j)-1)*rf_stride+rf_size;
    c=(y(j)-1)*rf_stride+1;
    d=(y(j)-1)*rf_stride+rf_size;
    if choose_to_delete_zero
        a=max((total_size+1-227+1)/2,a);
        b=min((total_size+227)/2,b);
        c=max((total_size+1-227+1)/2,c);
        d=min((total_size+227)/2,d);
    end
    im_back=im_pad(a:b,c:d,:);
    imshow(im_back);
end
toc;
