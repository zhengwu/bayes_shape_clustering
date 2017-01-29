function d = GeodesicElasticClosedinner(p1,p2)

% input p1 and p2 as 2xn matrices
% to turn off figures set figs=0
% the output is the distance between p1 and p2


stp = 6;

p1 = ReSampleCurve(p1,60);
p2 = ReSampleCurve(p2,60);

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

d = InnerProd_Q(q1,q2n);