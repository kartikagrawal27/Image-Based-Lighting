function hdr = makehdr_gsolve(ldrs, exposures)

    samples = 100
    
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    [imh, imw, channels, numImages] = size(ldrs); 
    
    for i = 1:numImages
        B(i) = log(exposures(:,:,1,i));
    end
    
    ldrs = im2uint8(ldrs);
    
    w = @(z) double(128-abs(z - 128));
    
    Zr = zeros(samples, numImages);
    Zg = zeros(samples, numImages);
    Zb = zeros(samples, numImages);
    
    for i = 1:samples
        y = randi(imh)
        x = randi(imw)
        for j = 1:numImages
            Zr(i, j) = ldrs(y, x, 1, j);
            Zg(i, j) = ldrs(y, x, 2, j);
            Zb(i, j) = ldrs(y, x, 3, j);
        end
    end
    
    [gZ_red, lE] = gsolve(Zr, B, 100, w);
    [gZ_green, lE] = gsolve(Zg, B, 100, w);
    [gZ_blue, lE] = gsolve(Zb, B, 100, w);

    
    hdr = zeros(imh, imw, channels);
    
    for i = 1:imh
        for j = 1:imw
                
                num_red = 0; den_red = 0;
                num_green = 0; den_green = 0;
                num_blue = 0; den_blue = 0;
                
                for image = 1:numImages
                    
                    num_red = num_red + w(ldrs(i, j, 1, image)) * (gZ_red(ldrs(i, j, 1, image) + 1) - B(image));
                    den_red = den_red + w(ldrs(i, j, 1, image));
                    
                    num_green = num_green + w(ldrs(i, j, 2, image)) * (gZ_green(ldrs(i, j, 2, image) + 1) - B(image));
                    den_green = den_green + w(ldrs(i, j, 2, image));
                    
                    num_blue = num_blue + w(ldrs(i, j, 3, image)) * (gZ_blue(ldrs(i, j, 3, image) + 1) - B(image));
                    den_blue = den_blue + w(ldrs(i, j, 3, image));
                    
                end
                
                hdr(i, j, 1) = (exp(num_red / den_red));
                hdr(i, j, 2) = (exp(num_green / den_green));
                hdr(i, j, 3) = (exp(num_blue / den_blue));
        end
    end
    
    Z = zeros(imh, imw, 3, numImages);
    
    for i = 1:numImages
        for c = 1:3
            % we know which g to use
            if c == 1
                g = gZ_red;
            elseif c == 2
                g = gZ_green;
            else
                g = gZ_blue;
            end
            
            % iterate through each pixel
            for x = 1:imh
                for y = 1:imw
                    Z(x,y,c,i) = g(ldrs(x,y,c,i)+1) - log(exposures(:,:,1,i));
                end
            end
        end
    end
    
    for i = 1:numImages
        curr_Z = Z(:, :, :, i);
        for c = 1:3
            curr_Z_c = curr_Z(:,:,c);
            min_z = min(min(min(curr_Z_c(~isinf(curr_Z_c)))));
            max_z = max(max(max(curr_Z_c)));
            for x = 1:imh
                for y = 1:imw
                    if(~(isinf(curr_Z_c(x, y))))
                        curr_Z_c(x,y) = (curr_Z_c(x,y) - min_z)/(max_z - min_z);
                    else
                        curr_Z_c(x,y) = 0;
                    end
                    
                end
            end
            curr_Z(:,:,c) = curr_Z_c;
        end
        Z(:,:,:,i) = curr_Z;
        
    end
    
    r_resp = zeros(256,1);    
    g_resp = zeros(256,1);
    b_resp = zeros(256,1);
    vals = zeros(256,1);
    for i = 1:256
        vals(i) = i-1;
        r_resp(i) = gZ_red(i);
        g_resp(i) = gZ_green(i);
        b_resp(i) = gZ_blue(i);
    end

    figure
    plot(vals,r_resp, 'r', vals, g_resp, 'g', vals, b_resp, 'b');
   
    
    
end