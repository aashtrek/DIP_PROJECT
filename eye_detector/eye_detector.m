cam=webcam();  

detector = vision.CascadeObjectDetector(); 


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

 end
