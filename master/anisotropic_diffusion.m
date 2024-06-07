function output = anisotropic_diffusion(I, num_iter, kappa, lambda)
    % I - input image
    % num_iter - number of iterations
    % kappa - conductance parameter
    % lambda - integration constant (usually between 0 and 1)
    figure;
    imshow(I, []);
    colormap(gray);
    title('Original');

    % Convert the image to double precision
    I = double(I);
    


    % Preallocate output image
    output = I;

    % Create a kernel for the gradient calculation
    % [dx, dy] = gradient(output);

    % Iterate over the number of iterations
    for i = 1:num_iter
        % Calculate gradients
        [dx, dy] = gradient(output);
        
        % Calculate the diffusion coefficient
        c = exp(-(dx.^2 + dy.^2) / (kappa^2));
        
        % Update the image
        output = output + lambda * (divergence(c .* dx, c .* dy));

        figure;
        subplot(2,2,1);
        imshow(uint8(I), []);
        colormap(gray);
        title('Original');

        subplot(2,2,2);
        imshow(dx, []);
        colormap(gray);
        title('dx');
        
        subplot(2,2,3);
        imshow(dy, []);
        colormap(gray);
        title('dy');
        
        subplot(2,2,4);
        imshow(output, []);
        colormap(gray);
        title('output');
    end
end

function div = divergence(dx, dy)
    % Calculate the divergence of the gradient
    [dxx, ~] = gradient(dx);
    [~, dyy] = gradient(dy);
    div = dxx + dyy;
end