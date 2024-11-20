function event = eyelink_extract_event(filename)

% addpath ../../fieldtrip-20210209
% ft_defaults

hdr = ft_read_header(filename);
msg = hdr.orig.msg; 
msg = msg(find(contains(msg,'Event')));

% load event_shell.mat

for l = 1:length(msg)
    
    text = strsplit(msg{l},{' ','\t'}); 
    
    event(l).type       = 'MSG';    
    event(l).sample     = round((str2num(text{2}) - hdr.FirstTimeStamp)/hdr.TimeStampPerSample + 1);
    event(l).timestamp  = str2num(text{2});
    event(l).value      = str2num(text{6});
    event(l).duration   = 1;
    event(l).offset     = 0;
    
end