N = 255;
ldr1 = imresize(im2double(imread('./Materials/10.jpg')), [N, N], 'bilinear');
ldr2 = imresize(im2double(imread('./Materials/40.jpg')), [N, N], 'bilinear');
ldr3 = imresize(im2double(imread('./Materials/160.jpg')), [N, N], 'bilinear');

% M = im2double(imread('./newResults/mask2.png'));
% E = im2double(imread('./newResults/empty2.png'));
% I = imresize(im2double(imread('./I.JPG')), [612, 816], 'bilinear');
% R = im2double(imread('./newResults/lit2.png'));
% c = 1;
% % 
% % % ldr4 = imresize(im2double(imread('./Materials/0205.jpg')), [N, N], 'bilinear');
% % % ldr5 = imresize(im2double(imread('./Materials/0553.jpg')), [N, N], 'bilinear');
% % 
ldrs = cat(4, ldr1, ldr2, ldr3);
% 
% % exposures = [1 / 24, 1 / 60, 1 /120, 1 / 205, 1 / 553];
exposures = [1/10, 1/40, 1/160];
% 
% %% Naive HDR Make
% % hdr_naive = makehdr_naive(ldrs, exposures);
% % hdr_naive = tonemap(hdr_naive);
% % figure(1), imshow(hdr_naive);
% % % 
% % % %% Exposed HDR Make
% % hdr_exposed = makehdr_exposed(ldrs, exposures);
% % hdr_exposed = tonemap(hdr_exposed);
% % figure(2), imshow(hdr_exposed);
% % 
% % %% GSolve MakeHDR 
hdr_gsolve = makehdr_gsolve(ldrs, exposures);
hdr_gsolve_viz = tonemap(hdr_gsolve);
figure(3), imshow(hdr_gsolve_viz);
% % 
% %%MirrorBall2latlon
% flattened = mirrorball2latlon(hdr_gsolve);
% flattened = tonemap(flattened);
% figure(4), imshow(flattened);

% result = composite(M, R, I, E, c);
% imshow(result)


