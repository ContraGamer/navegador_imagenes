clc
close all, clear all

im_in = imread('laberinto3.png');

im_bw = im2bw(rgb2gray(im_in));

im_skel = bwmorph(im_bw,'skel',Inf);

im_caminos = bitand(im_bw,imcomplement(im_skel));

% figure()
% subplot(1,3,1),imshow(im_in)
% subplot(1,3,2),imshow(im_skel)
% subplot(1,3,3),
% imshow(im_caminos)
dimen = size(im_bw);

pxy = [0,0];

pbranch = [0,0];

% im_endpoints = bwmorph(im_skel,'endpoints');
im_branchpoint= bwmorph(im_skel,'branchpoints');
% for R = 1:dimen(1)
%     for C = 1:dimen(2)
%                 if  (im_branchpoint(R,C)==1)
%                     pbranch = [pbranch; R,C]; 
%                 end
%     end 
% end

for(i=1:dimen(1))
   [p,im_skel]=endpoint(im_skel,im_branchpoint);
end
im_endpoints = bwmorph(im_skel,'endpoints');

% % % Esta parte encuentra los point branch

% dim_pend = size(pend);
% 
% for I= 1: dim_pend(1)
%     paux(I)  = find (pxy(:,1) == pend(I,1) &  pxy(:,2) == pend(I,2));
% end

im_caminos = bitand(im_bw,imcomplement(im_skel));

% figure()
% imshow(im_caminos)
% figure()
% imshow(im_endpoints);
% figure()
% imshow(im_branchpoint);


figure()
imshow(im_bw)
[x1,y1]=ginput(1);
[x2,y2]=ginput(1);
x1 = floor(x1);
y1 = floor(y1);
x2 = floor(x2);
y2 = floor(y2);

ds1 = zeros((size(im_bw,1)),(size(im_bw,2)));
ds2 = zeros((size(im_bw,1)),(size(im_bw,2)));
distancia1=100;
distancia2=100;

punto1=[dimen(1),dimen(2)];
punto2=[dimen(1),dimen(2)];

for R = 1:dimen(1)
    for C = 1:dimen(2)
        if  (im_skel(R,C)==1)
%           pxy = [pxy; R,C]; 
            dist1=sqrt(((y1-R)^2)+((x1-C)^2));
            dist2=sqrt(((y2-R)^2)+((x2-C)^2));
            ds1(R,C)=dist1;
            ds2(R,C)=dist2;
            if (dist1<=distancia1)
                distancia1=dist1;
                puntoy1=R;
                puntox1=C;
            end
            if (dist2<=distancia2)
                distancia2=dist2;
                puntoy2=R;
                puntox2=C;
            end
        end
    end 
end

L = bwlabel(im_skel,8);
[r, c] = find(L==1); rc = [c r];

dimen=size(rc);

%find(rc(:)==puntox2 & rc(dimen(2)+:)==puntoy2)
% valor1X=0;
% valor1Y=0;
% 
% valor2X=0;
% valor2Y=0;
% for(i=1:dimen(1))
%     for(j=1:dimen(2))
%         if(rc(i)==puntox1 & rc(dimen(1)+j)==puntoy1)
%            valor1X=i
%            valor1Y=j
%         end
%         if(rc(i)==puntox2 & rc(dimen(1)+j)==puntoy2)
%            valor2X=i
%            valor2Y=j
%         end
%     end
% end
d=size(im_skel);
punto1=[puntox1,puntoy1];
punto2=[puntox2,puntoy2];

for(i=1:dimen(1))
    im_skel=separar(punto1,punto2,im_skel);
end
    
im_caminos = bitand(im_bw,imcomplement(im_skel));
% for(i=1:d(1))
%     for(j=1:d(2))
%         if(im_skel(i,j)==1)
%             if(puntox1==j & puntoy1==i)
%                 punto1=[puntox1 puntoy1]
%             end
%             if(puntox2==j & puntoy2==i)
%                 punto2=[puntox2 puntoy2]
%             end
%             if(punto1(1)~=0 & punto1(2)~=0 & punto2(1)~=0 & punto2(2)~=0)
% %                 separar(punto1,punto2,im_skel);
%             end
%         end
%     end
% end

% im_endpoints = bwmorph(im_skel,'endpoints');
% figure()
% imshow(im_endpoints);
% 
% im_branchpoint= bwmorph(im_skel,'branchpoints');
% figure()
% imshow(im_branchpoint);
% 
% im_branch =bwmorph(im_skel-im_branchpoint,'branchpoints');
% figure()
% imshow(im_skel-im_branch-im_branchpoint);

figure()
imshow(im_caminos)
x = [x1 puntox1];
y = [y1 puntoy1];
pl = line(x,y);
x2 = [x2 puntox2];
y2 = [y2 puntoy2];
pl2 = line(x2,y2);

function [pend,imagen]=endpoint(imagen,img_branch)
pend = [0,0];
dimen = size(imagen);
im_endpoints = bwmorph(imagen,'endpoints');
    for R = 1:dimen(1)
        for C = 1:dimen(2)
                    if  (im_endpoints(R,C)==1 & im_endpoints(R,C)~=img_branch(R,C))
                         pend = [pend; R,C];
                         imagen(R,C)=0;
                    end
        end 
    end
end

function im_skel = separar(punto1,punto2,im_skel)
dimen = size(im_skel);
im_endpoints = bwmorph(im_skel,'endpoints');
    for R = 1:dimen(1)
        for C = 1:dimen(2)
                    if  (im_endpoints(R,C)==1)
                         im_skel(R,C)=0;
                         if(im_skel(punto1(2),punto1(1))==0)
                             im_skel(punto1(2),punto1(1))=1;
                         end
                         if(im_skel(punto2(2),punto2(1))==0)
                             im_skel(punto2(2),punto2(1))=1;
                         end
                    end
        end 
    end
end