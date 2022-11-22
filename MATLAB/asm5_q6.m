
close all
clear all
format long
global iParallel

iParallel = input('Do you wish to run the code in parallel? (1=yes) ');

if (iParallel == 1),
    N=input('Enter number of workers: ');
    parpool('local', N);
end

% here is the integrand
f = @(x,y) y.^2.*sin(x)+x.^2.*cos(y).^2;

Npts = input('Enter number of points per dimension: ');
area = 1;

q = zeros(Npts,1);
tic
if (iParallel == 1),
    parfor i=1:Npts,
        q(i) = innerMCLoop(f,Npts); 
    end
else
    for i=1:Npts,
        q(i) = innerMCLoop(f,Npts);
    end
end
toc


MC = sum(q)/(Npts^2)*area
fun =@(x,y) y.^2.*sin(x)+x.^2.*cos(y).^2;
exact = integral2(fun,0,pi,0,pi)
errorMC = exact - MC

if (iParallel == 1),

    delete(gcp)

end

% for 4 worker the time is 0.293442s
% for 3 worker the time is 0.236925s
% for 2 worker the time is 0.266470s
% for 1 worker the time is 0.269956s
% with number of the workers decrease, the time it takes decreases too
% it is exactly what I expeected. With smaller workers per parpool means
% that the more processor run at the same time. That make less time to
% compute