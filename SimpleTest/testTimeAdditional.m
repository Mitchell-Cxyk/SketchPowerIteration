%% Two-part timing with grouped comparable ops
format short g; rng default;

% Sizes
m = 10000; n = 20000; l = 1000; s = 500; r = 400;

% ---------- Common steps (execute ONCE) ----------
tic; A  = randn(m, n);                         tA   = toc;

tic; S  = rademacher_sparse(n, l, 0.01*n*l);   tS   = toc;  % 注意这里用 l（非 s）
tic; Z  = A * S;                               tZ   = toc;

tic; S1 = rademacher_sparse(n, s, 0.01*n*s);   tS1  = toc;
tic; Y0 = A * S1;                              tY0  = toc;

% ---------- Part 2 pre-QR steps (unique to Part 2) ----------
tic; T1 = Z' * Y0;                             tT1    = toc;
tic; [T1, ~] = qr(T1, 'econ');                 tQRT1  = toc;
tic; Y2 = Z * T1;                              tY2    = toc;

% ---------- Comparable block (aligned rows) ----------
% Part 1: QR on Y0, then B1, tsvd(B1)
tic; [Q1, ~] = qr(Y0, 'econ');                 tQR1    = toc;
tic; B1 = Q1' * A;                             tB1     = toc;
tic; [U1, Ssvd1, V1] = tsvd(B1, r); U1=Q1*U1;  tTSVD1  = toc; %#ok<NASGU,ASGLU>

% Part 2: QR on Y2, then B2, tsvd(B2)
tic; [Q2, ~] = qr(Y2, 'econ');                 tQR2    = toc;
tic; B2 = Q2' * A;                             tB2     = toc;
tic; [U2, Ssvd2, V2] = tsvd(B2, r); U2=Q2*U2;  tTSVD2  = toc; %#ok<NASGU,ASGLU>

% ---------- Build table (group comparable rows) ----------
Step = [                                   % 列向量
    "A = randn(m,n)";
    "S (n×l) generation";
    "Z = A * S";
    "S1 (n×s) generation";
    "Y0 = A * S1";
    "T1 = Z' * Y0 (Part2)";
    "[T1,~] = qr(T1,'econ') (Part2)";
    "Y2 = Z * T1 (Part2)";
    "QR(Y):  Y0 (P1)  vs  Y2 (P2)";
    "B = Q' * A:  B1 (P1)  vs  B2 (P2)";
    "tsvd(B,r); U=Q*U:  P1  vs  P2";
    "TOTAL";
];

% Part 1（公共步骤同值；Part2 专有步骤填 NaN；可比较步骤填各自时间）
Time_s_Part1 = [
    tA;
    NaN;
    NaN;
    tS1;
    tY0;
    NaN;
    NaN;
    NaN;
    tQR1;
    tB1;
    tTSVD1;
    NaN  % 占位，稍后回填总计
];

% Part 2
Time_s_Part2 = [
    tA;
    tS;
    tZ;
    tS1;
    tY0;
    tT1;
    tQRT1;
    tY2;
    tQR2;
    tB2;
    tTSVD2;
    NaN  % 占位，稍后回填总计
];

% Totals (ignore NaN)
Time_s_Part1(end) = nansum(Time_s_Part1(1:end-1));
Time_s_Part2(end) = nansum(Time_s_Part2(1:end-1));

% Print to console
T = table(Step, Time_s_Part1, Time_s_Part2);
disp(T);

% 如需把 NaN 显示为 0，可追加：
% T0 = T; T0.Time_s_Part1(isnan(T0.Time_s_Part1)) = 0; T0.Time_s_Part2(isnan(T0.Time_s_Part2)) = 0; disp(T0);
