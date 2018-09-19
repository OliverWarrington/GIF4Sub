function [] = createGif( anat_dir )
%The function expects a path to the directory with the MP-RAGE file
%(sMP*.nii). It then saves to the same folder an animated GIF with the
%saggital slices ordered. 
% Matan Mazor 2018

%% dependencies: NIfTI toolbox (for load_nii)
addpath('D:\Documents\software\NIfTI_20140122')

%% OBTAIN FIVE 4D MAPS
file = dir(fullfile(anat_dir,'sMP*.nii'));
cur_map = load_nii(fullfile(anat_dir, file.name));
cur_map = flip(flip(permute(cur_map.img, [3,2,1]),1),2);
cur_map(isnan(cur_map(:))) = 0;
cur_map(isinf(cur_map(:))) = max(cur_map(~isinf(cur_map(:))));
cur_map = (double(cur_map)/max([double(cur_map(:));10^-10]))*256;

cur_map = cat(4, cur_map, cur_map, cur_map);
cur_map = max(cur_map,0);
cur_map = uint8(cur_map);

for n = 1:size(cur_map,3)
    im = squeeze(cur_map(:,:,n,:));
    [A,map] = rgb2ind(im,256,'nodither');
    if n == 1;
        imwrite(A,map,fullfile(anat_dir,'myBrain.gif'),'gif','LoopCount',Inf,'DelayTime',0.1);
    else
        imwrite(A,map,fullfile(anat_dir,'myBrain.gif'),'gif','WriteMode','append','DelayTime',0.1);
    end
end


end

