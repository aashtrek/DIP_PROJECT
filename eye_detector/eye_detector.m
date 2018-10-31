clear all   
clf('reset');

cam=webcam(); 

detector = vision.CascadeObjectDetector(); 
detector1 = vision.CascadeObjectDetector('EyePairSmall');

while true
    
    vid=snapshot(cam);  
    vid = rgb2gray(vid);   
    img = flip(vid, 2);
    
     bbox = step(detector, img); 
      
     if isempty(bbox)== 0  
         biggest_box=1;  
         i=1;
         while i <= rank(bbox) 
             if bbox(i,3)>bbox(biggest_box,3)
                 biggest_box=i;
             end
             i=i+1;
         end
        
         
         subplot(2,2,1),imshow(img); hold on; 
         for i=1:size(bbox,1)    
             rectangle('position', bbox(i, :), 'lineWidth', 2, 'edgeColor', 'y');
         end
         
     end
         faceImage = imcrop(img,bbox(biggest_box,:)); 
         bboxeyes = step(detector1, faceImage); 
         
         subplot(2,2,3),imshow(faceImage);    
                 
         if ~ isempty(bboxeyes) 
             
             biggest_box_eyes=1;
             i=1;
             
             while i<=rank(bboxeyes) 
                 if bboxeyes(i,3)>bboxeyes(biggest_box_eyes,3)
                     biggest_box_eyes=i;
                 end
                 i=i+1;
             end
             
             bboxeyeshalf=[bboxeyes(biggest_box_eyes,1),bboxeyes(biggest_box_eyes,2),bboxeyes(biggest_box_eyes,3)/3,bboxeyes(biggest_box_eyes,4)];   %resize the eyepair width in half
             
             eyesImage = imcrop(faceImage,bboxeyeshalf(1,:));    
             eyesImage = imadjust(eyesImage);   
             r = bboxeyeshalf(1,4)/4;
             [centers, radii, metric] = imfindcircles(eyesImage, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', 0.93); % Hough Transform
             [M,I] = sort(radii, 'descend');
                 
             eyesPositions = centers;
                 
             subplot(2,2,2),imshow(eyesImage); hold on;
              
             viscircles(centers, radii,'EdgeColor','b');
             
             right=imread('RIGHT.jpg');
             left=imread('LEFT.jpg');
             noface=imread('no_face.jpg');
             straight=imread('STRAIGHT.jpg');
             
             if ~isempty(centers)
                pupil_x=centers(1);
                disL=abs(0-pupil_x);    
                disR=abs(bboxeyes(1,3)/3-pupil_x);
                subplot(2,2,4);
                if disL>disR+16
                    imshow(right);
                else if disR>disL
                    imshow(left);
                    else
                       imshow(straight); 
                    end
                end
     
             end          
         end
     else
        subplot(2,2,4);
        imshow(noface);
     end
     set(gca,'XtickLabel',[],'YtickLabel',[]);

   hold off;
 end

