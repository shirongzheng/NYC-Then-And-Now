%% CSC47100-Computer Vision Project: NYC Then And Now


%% Read in two images 
imgl = imread('NYC_Old.jpg');
imgr = imread('NYC_New.jpg');


%% display image pair side by side
[ROWS COLS CHANNELS] = size(imgl);
disimg = [imgl imgr];
image(disimg);

Nc = 12;
% Total Number of test points
Nt = 4;

%% After several runs, you may want to save the point matches 
%% in files (see below and then load them here, instead of 
%% clicking many point matches every time you run the program

 %load pl.mat pl;
 %load pr.mat pr;

%% interface for picking up both the control points and 
%% the test points

cnt = 1;
hold;

while(cnt <= Nc+Nt)

%% size of the rectangle to indicate point locations
dR = 50;
dC = 50;

%% pick up a point in the left image and display it with a rectangle....
%%% if you loaded the point matches, comment the point picking up (3 lines)%%%
[X, Y] = ginput(1);
Cl = X(1); Rl = Y(1);
pl(cnt,:) = [Cl Rl 1];


%% and draw it 
Cl= pl(cnt,1);  Rl=pl(cnt,2); 
rectangle('Curvature', [0 0], 'Position', [Cl Rl dC dR]);

%% and then pick up the correspondence in the right image
%%% if you loaded the point matches, comment the point picking up (three lines)%%%

[X, Y] = ginput(1);
Cr = X(1); Rr = Y(1);
pr(cnt,:) = [Cr-COLS Rr 1];

%% draw it
Cr=pr(cnt,1)+COLS; Rr=pr(cnt,2);
rectangle('Curvature', [0 0], 'Position', [Cr Rr dC dR]);
plot(Cr+COLS,Rr,'r*');
drawnow;
display(pl);
display(pr);
cnt = cnt+1;
end
save pr.mat pr;
save pl.mat pl;

%% NORMALIZATION: Page 156 of the textbook and Ex 7.6
%% --------------------------------------------------------------------
%% Normalize the coordinates of the corresponding points so that
%% the entries of A are of comparable size
%% You do not need to do this, but if you cannot get correct
%% result, you may want to use this 




%% END NORMALIZATION %%

%% Implement EIGHT_POINT algorithm, page 156
%% --------------------------------------------------------------------
%% Generate the A matrix
[a b] = size(pl);
%% Singular value decomposition of A
for i=1:a
  
    x1 = pl(i,1);
    y1 = pl(i,2);
    x2 = pr(i,1);
    y2 = pr(i,2);
    A(i,:) = [x1*x2 y1*x2 x2 x1*y2 y1*y2 y2 x1 y1 1];
    
end
[U D V] = svd(A);
%% the estimate of F
f = V(:,9);
F = [f(1) f(2) f(3); f(4) f(5) f(6); f(7) f(8) f(9)];

[FU FD FV]= svd (F);
FDnew = FD;
FDnew(3,3) = 0;
FM = FU*FDnew*FV';

F = FM;
display(F);
% Undo the coordinate normalization if you have done normalization



%% END of EIGHT_POINT

%% Draw the epipolar lines for both the controls points and the test
%% points, one by one; the current one (* in left and line in right) is in
%% red and the previous ones turn into blue

%% I suppose that your Fundamental matrix is F, a 3x3 matrix

%% Check the accuray of the result by 
%% measuring the distance between the estimated epipolar lines and 
%% image points not used by the matrix estimation.
%% You can insert your code in the following for loop

for cnt=1:1:Nc+Nt,
  an = F*pl(cnt,:)';
  x = 0:COLS; 
  y = -(an(1)*x+an(3))/an(2);

  x = x+COLS;
  plot(pl(cnt,1),pl(cnt,2),'r*');
  line(x,y,'Color', 'r');
  [X, Y] = ginput(1); %% the location doesn't matter, press mouse to continue...
  plot(pr(cnt,1),pr(cnt,2),'b*');
  line(x,y,'Color', 'b');

end 

%% Save the corresponding points for later use... see discussions above
save pr.mat pr;
save pl.mat pl;

%% Save the F matrix in ascii
save F.txt F -ASCII

% Find epipoles using the EPIPOLES_LOCATION algorithm page. 157
%% --------------------------------------------------------------------

figure(1);    
[left_x, left_y] = ginput(1);
hold on;
plot(left_x,left_y,'r*');

left_P = [left_x; left_y; 1];

right_P = FM*left_P;

right_epipolar_x=1:2*ROWS;
right_epipolar_y=(-right_P(3)-right_P(1)*right_epipolar_x)/right_P(2);
figure(2);
hold on;
plot(right_epipolar_x,right_epipolar_y,list(mod(i,8)+1));

left_epipole = FV(:,3);
left_epipole = left_epipole/left_epipole(3);

left_epipolar_x = 1:2*ROWS;
left_epipolar_y = left_y + (left_epipolar_x-left_x)*(left_epipole(2)-left_y)/(left_epipole(1)-left_x);
figure(1);
hold on;
plot(left_epipolar_x,left_epipolar_y,list(mod(i,8)+1));


%% save the eipoles 

save eR.txt eRv -ASCII; 
save eL.txt eRv -ASCII; 


