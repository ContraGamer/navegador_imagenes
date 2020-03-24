clc
close all, clear all

im_in = imread('laberinto3.png');

im_bw = im2bw(rgb2gray(im_in));

im_skel = bwmorph(im_bw,'skel',Inf);

im_caminos = bitand(im_bw,imcomplement(im_skel));

figure()
% subplot(1,3,1),imshow(im_in)
% subplot(1,3,2),imshow(im_skel)
% subplot(1,3,3),
imshow(im_caminos)
dimen = size(im_bw);

pxy = [0,0];
for R = 1:dimen(1)
    for C = 1:dimen(2)
                if  (im_skel(R,C)==1)
                    pxy = [pxy; R,C]; 
                end
    end 
end


im_endpoints = bwmorph(im_skel,'endpoints');

pend = [0,0];
for R = 1:dimen(1)
    for C = 1:dimen(2)
                if  (im_endpoints(R,C)==1)
                    pend = [pend; R,C]; 
                end
    end 
end
dim_pend = size(pend);

for I= 1: dim_pend(1)
    paux(I)  = find (pxy(:,1) == pend(I,1) &  pxy(:,2) == pend(I,2))
end


figure()
imshow(im_endpoints);
