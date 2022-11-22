target_im1 = imread('gundu.jpg');
target_im1 = imresize(target_im1, [1000 NaN]);
Size = 65;
result1 = photomosaic(target_im1, Size);

target_im2 = imread('lion.jpg');
target_im2 = imresize(target_im2, [1000 NaN]);
Size = 50;
result2 = photomosaic(target_im2, Size);

target_im3 = imread('cnn.jpg');
target_im3 = imresize(target_im3, [1000 NaN]);
Size = 45;
result3 = photomosaic(target_im3, Size);

target_im4 = imread('polar.jpg');
target_im4 = imresize(target_im4, [1000 NaN]);
Size = 45;
result4 = photomosaic(target_im4, Size);

target_im5 = imread('mustang.jpg');
target_im5 = imresize(target_im5, [1000 NaN]);
Size = 55;
result5 = photomosaic(target_im5, Size);

figure; montage({target_im1, result1});
figure; montage({target_im2, result2});
figure; montage({target_im3, result3});
figure; montage({target_im4, result4});
figure; montage({target_im5, result5});


function result = photomosaic(target_im, Size)

    corpus = dir('corpus/*.jpg'); 
    num_im = length(corpus);

    avg_corpus_red = zeros([num_im 1]);
    avg_corpus_green = zeros([num_im 1]);
    avg_corpus_blue = zeros([num_im 1]);

    for i = 1:num_im
       current_filename = corpus(i).name;


       current_im = imread(strcat('corpus/', current_filename));


       [~, ~, dim] = size(current_im);

       if dim == 1
           avg_corpus_red(i, 1) = 5000;
           avg_corpus_green(i, 1) = 5000;
           avg_corpus_blue(i, 1) = 5000;
       else
           avg_corpus_red(i, 1) = mean(current_im(:, :, 1), 'all');
           avg_corpus_green(i, 1) = mean(current_im(:, :, 2), 'all');
           avg_corpus_blue(i, 1) = mean(current_im(:, :, 3), 'all');
       end

    end

    [rows, cols, ~] = size(target_im);

    morerows = false;
    if rows > cols
        morerows = true;
    end

    % set k-val

    if morerows
        k = cols / Size;
    else
        k = rows / Size;
    end

    % if k is even, make it odd

    k = round(k);

    if mod(k,2)==0
        k = k + 1;
    end

    % resize the image according to more rows or more cols

    if morerows
        small_im = imresize(target_im, [NaN cols/k]);
    else
        small_im = imresize(target_im, [rows/k NaN]);
    end

    % create mosaic array

    [grid_rows, grid_cols, ~] = size(small_im);
    mosaic = cell(grid_rows, grid_cols);

    for i = 1:grid_rows
            for j = 1:grid_cols

                try
                    subsection = target_im(i*k:(i*k)+k, j*k:(j*k)+k, :);
                catch
                    subsection = target_im(i*k:end, j*k:end, :);
                end

                avg_subsection_red = mean(subsection(:, :, 1), 'all');
                avg_subsection_green = mean(subsection(:, :, 2), 'all');
                avg_subsection_blue = mean(subsection(:, :, 3), 'all');

                index = find_match(avg_subsection_red, avg_subsection_green, avg_subsection_blue, avg_corpus_red, avg_corpus_green, avg_corpus_blue);

                match_filename = corpus(index).name;
                matched_im = imread(strcat('corpus/', match_filename));
                matched_im = imresize(matched_im, [k k]);

                mosaic{i, j} = matched_im;

            end
    end

    result = cell2mat(mosaic);
    result = result(1+k:end-k, 1+k:end-k, :);

end


function index = find_match(sr, sg, sb, cr, cg, cb)

    differences = sqrt( (cr - sr).^2 + (cg - sg).^2 + (cb - sb).^2 );
    
    for i = 1:randi(15)
        
        [~,I] = min(differences);
        differences(I, 1) = 50000;
        index = I;
    
    end
    
end



