function ouput = label_gen(data)% to generate the label with state
data = edfread(data);
fga =data.("ft_ghostarousal")
for i=1:size(fga,1)
    fga1 = fga{i,1};
    fga2 = fga1(1);
    fgad(i) = fga2;
end
off_set=find(fgad~=0);% find the trace only section
fa = data.("ft_arousal");% extract arousal data
for i=1:size(fa,1)
    fa1 = fa{i,1};
    fa2 = fa1(1);
    fad(i) = fa2;
end
fa_t = find(fad~=0);
fa_t = setdiff(fa_t,off_set);
fv = data.("ft_valance");% extract valence data
for i=1:size(fv,1)
    fv1 = fv{i,1};
    fv2 = fv1(1);
    fvd(i) = fv2;
end
fv_t = find(fvd~=0);
fv_t = setdiff(fv_t,off_set);
oset_arou=mean(fad(off_set));
oset_val= mean(fvd(off_set));
fad = fad-oset_arou; %set as the offset point
fvd = fvd-oset_val; %set as the offset point
fad = fad(fa_t);
fvd = fvd(fv_t);

for i=1:size(fad,2)
feeltrace(i,:) = [fa_t(i) fad(i) fvd(i)];
end
% Tranfer the range same as Paper[-4 4] and Label into 4 state with time series
num=1;
for i =1:size(feeltrace,1)
    if feeltrace(i,2) > 0 & feeltrace(i,3)>0
       sa(num,:) =[feeltrace(i,1), 1];
        num =num+1;
    else if  feeltrace(i,2) < 0 & feeltrace(i,3)> 0
            sa(num,:) = [ feeltrace(i,1),2];
            num =num+1;
        else if  feeltrace(i,2) < 0 & feeltrace(i,3)< 0
                sa(num,:) = [ feeltrace(i,1),3];
                num =num+1;
            else if  feeltrace(i,2) > 0 & feeltrace(i,3)< 0
                    sa(num,:) = [ feeltrace(i,1),4];
                    num =num+1;
                end
            end
        end
    end
end
ouput = sa;% output is [time state] matrix