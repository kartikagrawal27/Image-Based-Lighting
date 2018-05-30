function hdr = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    [imh,imw,layers,numImages] = size(ldrs(:,:,:,:));
    
    for i = 1:numImages
        ldrs(:,:,:,i) = ldrs(:,:,:,i)./exposures(:,:,1,i);;
    end
    
    hdr = squeeze(sum(ldrs, 4)) / numImages;
    
    
    Z = zeros(imh, imw, 3, numImages);
    
    for i = 1:numImages
        Z(:, :, :, i) = log(ldrs(:, :, :, i)) - log(exposures(:,:,1,i));
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
    
    
    
    
end
