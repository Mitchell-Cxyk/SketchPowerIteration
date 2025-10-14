%% ===== Two-part timing (no shared steps) with warmup + median-of-N =====
format short g; rng default;

% ---------- Config ----------
N = 20;  % 每个步骤重复次数（预热 1 次 + 计时 N 次，取中位数）

% ---------- Problem/setup (不计入两部分计时) ----------
m = 20000; n = 30000;
A = randn(m, n);
 % l = 400; s = 110; r = 100;d=800;s1=s;d1=d;
 l = 1000; s = 510; r = 100;d=800;s1=s;d1=d;

 spar_lv = 0.05;

%% ---------------- Part 1 ----------------
[tPhi1,   Phi]    = timeit_step(@() rademacher_sparse(n, l, spar_lv*n*l), N);
[tOm1,    Omega1] = timeit_step(@() rademacher_sparse(n, s, spar_lv*n*s), N);

[tZ1,     Z]      = timeit_step(@() A * Phi, N);
[tY1,     Y1]     = timeit_step(@() A * Omega1, N);


[tY2,     Y2]     = timeit_step(@() Z' * Y1, N);
[tQRY2,   Qp1, ~] = timeit_step(@() qr(Y2, 'econ'), N);
[tY3,     Y3]     = timeit_step(@() Z * Qp1, N);

[tY4,     Y4]     = timeit_step(@() Z' * Y3, N);
[tQRY21,   Qp2, ~] = timeit_step(@() qr(Y4, 'econ'), N);
[tY5,     Y5]     = timeit_step(@() Z * Qp2, N);

[tY6,     Y6]     = timeit_step(@() Z' * Y5, N);
[tQRY22,   Qp3, ~] = timeit_step(@() qr(Y6, 'econ'), N);
[tY7,     Y7]     = timeit_step(@() Z * Qp3, N);




[tQRY3,   Q1,  ~] = timeit_step(@() qr(Y7, 'econ'), N);

[tPsi1,   Psi1]   = timeit_step(@() rademacher_sparse(d,  m, 0.1*d*m), N);
[tW1,     W1]     = timeit_step(@() Psi1 * A, N);
[tB1,     B1]     = timeit_step(@() (Psi1 * Q1) \ W1, N);
[tPreSVD1,QU1,RU1]=timeit_step(@() qr(B1','econ'),N);
[tTSVD1,  U1, S1, V1] = timeit_step(@() tsvd(RU1, r), N);
tTSVD1=tPreSVD1+tTSVD1;
[tUup1,   UU1]     = timeit_step(@() Q1 * V1, N); 
[tUup11,   V1]     = timeit_step(@() QU1 * U1, N); 
tUup1=tUup1+tUup11;


%% ---------------- Part 2 ----------------
[tOm2,    Omega]  = timeit_step(@() rademacher_sparse(n, s1, spar_lv*n*s1), N);
[tY,      Y]      = timeit_step(@() A * Omega, N);

[tQRY,    Qp2, ~] = timeit_step(@() qr(Y, 'econ'), N);

[tPsi2,   Psi2]   = timeit_step(@() rademacher_sparse(d1, m, 0.1*d1*m), N);
[tW,      W]      = timeit_step(@() Psi2 * A, N);
[tB2,     B2]     = timeit_step(@() (Psi2 * Qp2) \ W, N);


% [tTSVD2,  U2, S2, V2] = timeit_step(@() tsvd(B2, r), N);
% [tUup2,   U2]     = timeit_step(@() Qp2 * U2, N);

[tPreSVD2,QU2,RU2]=timeit_step(@() qr(B2','econ'),N);
[tTSVD2,  U2, S2, V2] = timeit_step(@() tsvd(RU2, r), N);
tTSVD2=tPreSVD2+tTSVD2;
[tUup2,   UU2]     = timeit_step(@() Qp2 * V2, N); 
[tUup21,   V2]     = timeit_step(@() QU2 * U2, N); 
tUup2=tUup2+tUup21;

%% ---------------- Assemble comparison table ----------------
Step = [
    "Phi (n×l) generation";
    "Omega generation";
    "Z = A * Phi";
    "Y = A * Omega";
    "Y2 = Z' * Y (or Y1)";
    "QR on Y2";
    "Y3 = Z * Q (from Y2)";
    "QR on Y or Y3";
    "Psi (⋅×m) generation";
    "W = Psi * A";
    "Solve B = (Psi*Q)\\W";
    "TSVD: [U,S,V] = tsvd(B,r)";
    "U ← Q*U (or Q1*U)";
    "TOTAL (sum of medians)";
];



Time_Part1 = [
    NaN;
    tOm2;
    NaN;
    tY;
    NaN;
    NaN;
    NaN;
    tQRY;
    tPsi2;
    tW;
    tB2;
    tTSVD2;
    tUup2;
    NaN
];
Time_Part2 = [
    tPhi1;
    tOm1;
    tZ1;
    tY1;
    tY2;
    tQRY2;
    tY3;
    tQRY3;
    tPsi1;
    tW1;
    tB1;
    tTSVD1;
    tUup1;
    NaN
];

Time_Part3 = [
    tPhi1;
    tOm1;
    tZ1;
    tY1;
    tY2+tY4;
    tQRY2+tQRY21;
    tY3+tY5;
    tQRY3;
    tPsi1;
    tW1;
    tB1;
    tTSVD1;
    tUup1;
    NaN
];
Time_Part4 = [
    tPhi1;
    tOm1;
    tZ1;
    tY1;
    tY2+tY4+tY6;
    tQRY2+tQRY21+tQRY22;
    tY3+tY5+tY7;
    tQRY3;
    tPsi1;
    tW1;
    tB1;
    tTSVD1;
    tUup1;
    NaN
];


Time_Part1(end) = nansum(Time_Part1(1:end-1));
Time_Part2(end) = nansum(Time_Part2(1:end-1));
Time_Part3(end) = nansum(Time_Part3(1:end-1));
Time_Part4(end) = nansum(Time_Part4(1:end-1));

T = table(Step, Time_Part1, Time_Part2,Time_Part3,Time_Part4);
disp(T);

%% ===== Helper: warmup + median-of-N timer with output capture =====
function [tmed, varargout] = timeit_step(fh, N)
    if nargin < 2 || isempty(N), N = 5; end
    % 预热
    fh();
    ts = zeros(N,1);
    for i = 1:N
        t0 = tic;
        if nargout > 1 && i == N
            [varargout{1:nargout-1}] = fh(); % 最后一次把结果带出来（含多个输出）
        else
            fh();
        end
        ts(i) = toc(t0);
    end
    tmed = mean(ts);
end
