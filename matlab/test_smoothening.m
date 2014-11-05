v = ones(50,1);
v1 = -ones(50,1);
c_len = round(length(v)/5);
c = ones(c_len, 1) / c_len;
v = conv(v, c)
v1 = conv(v1,c)
% v = v(c_len:end);
