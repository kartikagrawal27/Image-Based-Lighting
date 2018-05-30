function fball = mirrorball2latlon( mirrorball )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    [imh, imw, layers] = size(mirrorball);

    normals = double(zeros(imh, imw, 3));
    
    reflections = zeros(imh, imw, 3);
    
    V = [0,0,-1];
    mh = double(imh/2);
    mw = double(imw/2);
    phis = zeros(imh,imw);
    thetas = zeros(imh,imw);
    %i = y
    %j = x
    for i = 1:imh
        
        t_i = double(((i-mh)/mh));
        
        for j = 1:imw
            t_j = double(((j-mw)/mw));
            t_z = double(sqrt(1-(t_i^2) - (t_j^2)));
            if isreal(t_z)
                normals(i, j, 1) = double(t_j);
                normals(i, j, 2) = double(t_i);
                normals(i, j, 3) = double(t_z);
                N = [t_j, t_i, t_z];
                reflections(i, j, :) = V - 2 .* dot(V,N) .* N;
                phis(i,j) = atan2(reflections(i,j,1),reflections(i,j,3)); 
                thetas(i,j) = acos(reflections(i,j,2));
            end
        end
    end
    
    % Visualiztion of phis and thetas
    t = zeros(imh,imw,3);
    t(:,:,2) = phis + pi;
    t(:,:,1) = thetas;
    
    
%     phis = phis+pi/2;
%     phis(phis > pi) = phis(phis > pi) -2*pi;
%     phis(phis < -pi) = phis(phis < -pi) +2*pi;
    
%     phis = -1 * phis;
    phis(phis ~= 0) = phis(phis ~= 0) + pi;
    thetas(thetas ~= 0) = pi - thetas(thetas ~= 0);
    normals(normals~=0) = ((normals(normals~=0) + 1)/2);
    reflections(reflections~=0) = ((reflections(reflections~=0) + 1)/2);

    
    [l_phis, l_thetas] = meshgrid([pi:pi/360:2*pi 0:pi/360:pi], 0:pi/360:pi);
    phis = reshape(phis, [imw*imh, 1]);
    thetas = reshape(thetas, [imw*imh, 1]);
    [l_h, l_w] = size(l_phis);
    fball = zeros(l_h, l_w, 3);
    
%     X = [phis, thetas];
    for i = 1:layers
%         V = reshape(mirrorball(:, :, i), [imh*imw, 1]);
        F = scatteredInterpolant(double(phis), double(thetas), double(reshape(mirrorball(:,:, i), [imh*imw, 1])));
        fball(:,:,i) = F(l_phis, l_thetas);
    end
end

