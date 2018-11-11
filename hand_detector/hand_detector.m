clear;
% vid = videoinput('linuxvideo',1);
% %preview(vid);
% figure(1);
% set(vid,'ReturnedColorspace','rgb')
% pause(2);
% img1 = getsnapshot(vid);
% subplot(2,2,1);
% imshow(img1);
% title('Background image');
% pause(2);
% img2 = getsnapshot(vid);
% subplot(2,2,2);
% imshow(img2);
% title('hand gesture');
% img3 = img2-img1;

%img3 = imread('index.jpeg');
%img21 = imresize(img21,[512,512]);
% i_ycbcr = rgb2ycbcr(img3);
%     cb = i_ycbcr(:,:,2);   %%% threshold for 95 - 120
%     cr = i_ycbcr(:,:,3);   %%%% threshold value 135 - 155
%     [m,n] = size(cr);
%     subplot(2,2,1);
%     imshow(img3);
%     img2 = zeros(m,n);
% for i=1:m
%     for j=1:n
%         if cr(i,j)>=125 && cr(i,j)<=165 && cb(i,j)>=85 && cb(i,j)<=120
%             img2(i,j)=256;
%         else
%             img2(i,j)=0;
%         end
%     end
% end
% img2 = imimg2arize(img2,0.5);
% subplot(2,2,2);
% imshow(img2);
% properties = regionprops(img2,'BoundingBox');  %% return a vector [left,top,width,height] of box
% for k=1:length(properties)
%     thisBB = properties(1).BoundingBox;
%     rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','r','LineWidth',1);
% end
%%   Input recorded video
 vid= VideoReader('video.mp4');
 v = read(vid,[1 Inf]);
 [m,n,r,frames] = size(v);
 fm =1;
 
%% segmentation 
while fm<frames
    filename = read(vid,fm);
    %Read the image, and capture the dimensions
    img_orig = uint8(filename);
    height = size(img_orig,1);
    width = size(img_orig,2);
  
    out = img_orig;
    img2 = zeros(height,width);
    img = grayworld(img_orig);               %%  Grayworld Algorithm for illumination compensation   
    img_ycbcr = rgb2ycbcr(img);
    Cb = img_ycbcr(:,:,2);
    Cr = img_ycbcr(:,:,3);
    [r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
    numind = size(r,1);
    for i=1:numind
        out(r(i),c(i),:) = [0 0 255];
        img2(r(i),c(i)) = 1;
    end
    img2 = bwareaopen(img2,100);
    img2 = imfill(img2,'holes');
    subplot(2,2,1)
    imshow(img_orig);
    subplot(2,2,2)
    imshow(out);
    subplot(2,2,3)
    imshow(img2);
    img = img2;
    [m,n] = size(img);
    properties = regionprops(img,'BoundingBox');  %% return a vector [left,top,width,height] of box
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
    for i=1:m                       %%%%% horizonatal image 
        if img2(i,1)==1
            o2 = o2+1;
        end
    end
    if o2==0 && o1==0
        img2 = flip(img2,2);
        o2 = 50;
    end

%     if o1~=0 && o2~=0
%         disp('Adjust your hand');
%         exit;
%     end
%% feature extraction
    Mx=0;My=0;M=0;

    for i=1:m
        for j=1:n
            if img2(i,j)==1
                Mx = Mx + j;
                My = My +i;
                M=M+1;
            end
        end
    end
        
    Cx = Mx/M;
    Cy = My/M;
    p=0;
    count=0;
    count2=0;
    thumb=0;
    n1 = round(thisBB(1));
    n2 = n1+round(thisBB(3))-1;
    m1 = round(thisBB(2));
    m2 = m1+round(thisBB(4))-1;
    fm=fm+50;
    pause(2);
end

% if o2==0  %% vertical image
%     for j=n1:n2
%         for i=m1:Cx
%             if img2(j,i)==1
%                 p=p+1;
%                 idx(p)=i;
%                 idy(p)=j;
%                 break;
%             end
%         end
%     end
%     for i=n1:n1+round(thisBB(4)/5)+10
%         for j=m1:m
%             if img2(i,j)==1
%                 count2=count2+1;
%             end
%         end
%     end
%     if count2/count<=0.00069
%         thumb=1;
%     else
%         thumb=0;
%     end
%     q=0;
%     for i=2:p-1
%         if idx(i)<idx(i-1) && idx(i)<idx(i+1)
%             q=q+1;
%             tipx(q)=idx(i);
%             tipy(q)=idy(i);
%         end
%     end 
% %     mini = min(tipx);
% %     margin = (Cx-min)*0.5; 
%     img2 = (n2-n1)/5;
%     r = 0;
%     coutx = zeros(100);
%     couty = zeros(100);
%     for i=1:q-1
%         if (tipy(i+1)-tipy(i))>=img2
%             r=r+1;
%             coutx(r)=tipx(i);
%             couty(r)=tipy(i);
%         end
%     end
% elseif orient==1
%     for i=m1:m1+round(thisBB(4)/5)+10
%         for j=n1:n2
%             if img2(i,j)==1
%                 count2=count2+1;
%             end
%         end
%     end
%     if count2/count<=0.00069
%         thumb=2;
%     else
%         thumb=3;
%     end
%     for i=m1:m2
%         for j=n2:-1:Cy
%             if img2(i,j)==1
%                 p=p+1;
%                 idx(p)=i;
%                 idy(p)=j;
%                 break;
%             end
%         end
%     end
%     q=0;
%     for i=2:p-1
%         if idy(i)>=idy(i-1) && idy(i)>idy(i+1)
%             q=q+1;
%             tipx(q)=idx(i);
%             tipy(q)=idy(i);
%         end
%     end
% else
%     return;
% end
% 
% dismat = (coutx-Cx).*(coutx-Cx)+(couty-Cy).*(couty-Cy);
% dismat = sqrt(dismat);
% maximum = max(dismat);
% th = 0.7*maximum;
% for i=1:r-1
%     if dismat(i)<th
%         dismat(i)=0;
%     end
% end
% for i=1:r-1
%     if dismat(i)==0
%         cout(i+1)=0;
%     else
%         cout(i+1)=1;
%     end
% end
% if thumb==0
%     cout(1)=0;
% else
%     cout(1)=1;
% end
