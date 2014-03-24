function w = Lmult(v)

w = [diff(v); v(end) - v(1)];

end