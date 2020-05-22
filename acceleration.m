[m,n] = size(accod);
for i = 1:m
    accod(i,4) = i*0.01;
end
figure;plot(accod(:,4),accod(:,3));