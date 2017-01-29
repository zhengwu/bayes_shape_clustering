
%author: Zhengwu Zhang
%email: zhengwustat@gmail.com
%date: Jan. 1, 2017


clear all; 
close all;

path('./Elastic_Shape_Analysis', path);
path('./DPclustering', path);
path('./Data', path);

%%%%%%%%%% load data %%%%%%%%%%
load Dataset.mat;
base=1:10;


%%%%%%%%%%% choose some shapes %%%%%%%%%%
slt = [14,17,16,10];
num=[];
for i=1:length(slt)
    num = [num (slt(i)-1)*10+base];
end;


%%%%%%%%%%calculate the inner product matrix %%%%%%%%%%
% or load from pre-calculated inner product matrix

N = length(num); %total number 
% S = zeros(N,N);
% for col=1:N
%     for row = col:N
%         S(col,row) = GeodesicElasticClosedinner(squeeze(Dataset(:,:,num(col))),squeeze(Dataset(:,:,num(row))));
%     end;
% end;
% 
% S = S + S';
% for i=1:N
%     S(i,i) = 1;
% end;

%or load pre-calculated inner product matrix
load S_tmp_40.mat;

%%%%%%%%%% display the inner product matrix %%%%%%%%%%
figure(1);
imagesc(S);colormap hot; axis tight; colorbar;



%%%%%%%%%% Bayesian clustering %%%%%%%%%%
%parameters
xi = 0.2; % for CRP

% prior of theta
% theta_vect = [0.5,1,2,5,8,10,15,20,25,30,35,40,50,80,100,200];
% theta_vect = 200:200:1000;
theta_vect = 0.2:0.2:1;
J = length(theta_vect);

[U,W,V] = svd(S);
for i=1:N
    ratio = sum(diag(W(1:i,1:i)))/sum(diag(W));
    if (ratio>0.95)
        d = i;
        break;
    end;
end;

% prior of d
d_vect = d;
Ld = length(d_vect);

r0 = 6/d;
s0 = 8/d;
iter= 1000;
M = 10; %initial number of clusters
 
tic
[final_c,final_cn]=WishartCluster(d,theta_vect,r0,s0,xi,iter,M,S);
toc


%%%%%%%%%%% show shapes %%%%%%%%%%
M = length(final_cn);
[final_ordered_cn,IX] = sort(final_cn,'descend');
cct(1) = 1;
new_order = [];
for i=1:M
    class{i} = find(final_c==IX(i));
    cct(i+1) = cct(i) +  length(class{i})-1;
    new_order = [new_order class{i}];
end;


for jj = 1:M
    figure(10+jj); clf;
    ha = tight_subplot(ceil(final_ordered_cn(jj)/10),10,0.01,0.03,0.03);
    classidx = class{jj};
    Ln = length(classidx);
    for i=1:Ln
        axes(ha(i))
        t = classidx(i);
        plot(Dataset(1,:,num(t)),Dataset(2,:,num(t)),'linewidth',2);
        axis off;
        axis equal;
     end
 end;
