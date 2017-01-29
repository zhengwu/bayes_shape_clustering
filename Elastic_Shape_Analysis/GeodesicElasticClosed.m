function d = GeodesicElasticClosed(p1,p2)

% input p1 and p2 as 2xn matrices
% to turn off figures set figs=0
% the output is the distance between p1 and p2

figs=0;

stp = 6;

if figs
figure(1); clf; hold on;
plot(p1(1,:),p1(2,:),'b','LineWidth',2);
plot(p2(1,:),p2(2,:),'r','LineWidth',2);
axis equal;
axis xy off;
end

p1 = ReSampleCurve(p1,100);
p2 = ReSampleCurve(p2,100);

q1 = curve_to_q(p1);
q2 = curve_to_q(p2);

tic
[q2n,R] = Find_Rotation_and_Seed_unique_fast(q1,q2,1);
q2n = q2n/sqrt(InnerProd_Q(q2n,q2n));
q2=curve_to_q(p2);
q2 = ProjectC(q2);
p2=q_to_curve(q2);
p2n=R*p2;
toc

d = acos(InnerProd_Q(q1,q2n));
if figs
alpha = geodesic_sphere_Full(q1,q2n,stp);
Path_Plot(alpha,p2n,10,'b',[73,6]);
axis xy; view([1 90]);
end