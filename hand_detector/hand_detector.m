clear;
vid = videoinput('linuxvideo',1);
%preview(vid);
figure(1);
set(vid,'ReturnedColorspace','rgb')
pause(2);
img1 = getsnapshot(vid);
subplot(2,2,1);
imshow(img1);
title('Background image');
pause(2);
img2 = getsnapshot(vid);
subplot(2,2,2);
imshow(img2);
title('hand gesture');
img3 = img2-img1;

% img23 = imread('index.jpeg');
%img21 = imresize(img21,[512,512]);
i_ycbcr = rgb2ycbcr(img3);
    cb = i_ycbcr(:,:,2);   %%% threshold for 95 - 120
    cr = i_ycbcr(:,:,3);   %%%% threshold value 135 - 155
    [m,n] = size(cr);
    subplot(2,2,1);
    imshow(img3);
    img2 = zeros(m,n);
for i=1:m
    for j=1:n
        if cr(i,j)>=125 && cr(i,j)<=165 && cb(i,j)>=85 && cb(i,j)<=120
            img2(i,j)=256;
        else
            img2(i,j)=0;
        end
    end
end
img2 = imbinarize(img2,0.5);
subplot(2,2,2);
imshow(img2);
properties = regionprops(img2,'BoundingBox');  %% return a vector [left,top,width,height] of box
for k=1:length(properties)
    thisBB = properties(1).BoundingBox;
    rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','r','LineWidth',1);
end
o1 = 0; o2 = 0; 
for j=1:n                            %%%% vertical image
    if img2(m,j)==1
        o1 = o1+1;
    end
end

if o1==0                                %%%%% horizonatal image                            
    for i=1:m 
        if img2(i,1)==1
            o2 = o2+1;
        end
    end
end

if o2==0 && o1==0
    img2 = flip(img2,2);
    o1 = 50;
end

if o1~=0 && o2~=0
    disp('Adjust your hand');
    
end