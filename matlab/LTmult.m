function w = LTmult(v)

w = [v(end) - v(1) ; -diff(v)];

end