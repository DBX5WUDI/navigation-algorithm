function invM = invbc(M)
% An alogrithm for matrix inversion to avoid 'bad condition number' warning.
%
% Prototype: invM = invbc(M)
% Input: M - input square matrix
% Output: invM - the inversion of input M
%
% See also  kfupdate.

    D = sqrt(diag(M));
    K = max(D)./D;
    K = diag(K);
    invM = K/(K*M*K)*K;
    return