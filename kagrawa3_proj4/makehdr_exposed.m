function hdr = makehdr_exposed( ldrs, exposures )
%MAKEHDR_EXPOSED Summary of this function goes here

    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    [imh,imw,layers,numImages] = size(ldrs(:,:,:,:));
    
    for i = 1:numImages
        ldrs_norm(:,:,:,i) = ldrs(:,:,:,i)./exposures(:,:,1,i);
    end
    
    ldrs = im2uint8(ldrs);
    
    w = @(z) double(128-abs(z - 128));
    
    hdr = zeros(imh, imw, layers);
    
    for i = 1:imh
        for j = 1:imw
            for k = 1:layers
         
                weight_sum = 0;
                
                for t = 1:numImages
                    weight = w(ldrs(i, j, k, t));
                    hdr(i, j, k) = hdr(i, j, k) + ldrs_norm(i, j, k, t) * weight;
                    weight_sum = weight_sum + weight;
                end
                
                hdr(i, j, k) = hdr(i, j, k) / weight_sum;
            end
        end
    end

end

