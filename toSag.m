dcmdir = uigetdir('select dicom dir');
homedir = cd;
cd(dcmdir);
mkdir('sag')
files = dir(dcmdir);
dcm_files = dir('*.dcm');
first_dcm = dicomread(dcm_files(1).name);
brain = uint16(zeros(length(dcm_files),size(first_dcm,1),size(first_dcm,2)));

for dcm_ind = 1:length(dcm_files)
    cur_file = dicomread(dcm_files(dcm_ind).name);
    brain(length(dcm_files)-dcm_ind+1,:,:) = cur_file;
    dcm_ind
end

for slice = 1:size(first_dcm,2)
    cur_slice = reshape(brain(:,:,slice),...
        length(dcm_files) ,size(first_dcm,1));
    if(slice < 30)%length(dcm_files))
        info = dicominfo(dcm_files(slice).name);
    else
        info.InstanceNumber = slice;
        info.SliceLocation = slice;
    end
    info.ImagePresentationGroupLength = 224;
    dicomwrite(cur_slice, ['sag/' sprintf('%04d',slice)],info);
end
cd(homedir)