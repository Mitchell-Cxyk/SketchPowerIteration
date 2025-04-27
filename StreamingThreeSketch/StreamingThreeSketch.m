classdef StreamingThreeSketch < handle
    % Sketch Class for sketch-based matrix computations
    %   This class implements sketch-based algorithms for matrix operations
    
    properties
        % input parameters
        A      % Input matrix
        m  % Size of the matrix
        n
        r %target rank
        s %small sketch size
        l %large sketch size
        d %embedding dimension
        iterationNum %number of iterations
        distribution %sketch distribution
        % Sketch object properties
        YR % Sketch matrix m\times s
        YL % Sketch matrix s\times n
        W % Sketch matrix d\times n
        CR % Sketch matrix m\times l
        CL % Sketch matrix l\times m
        PsiL % Sketch matrix d\times m
        PsiR % Sketch matrix n\times d
        OmegaR % Sketch matrix l\times s
        OmegaL % Sketch matrix s\times l
        PhiR % Sketch matrix n\times l
        PhiL % Sketch matrix l\times n
        mixedPrecision %0: double, 1: single, 2: half
        fixedW %0: W is set double to solve equality, 1: W is set to single to solve equality
        Y_in_C %0: Y is not in C, 1: Y is in C
    end
    
    methods
        function obj = StreamingThreeSketch(varargin)
            % Constructor with flexible input patterns
            % Usage:
            %   obj = Sketch(A)                    - Only input matrix
            %   obj = Sketch(A, r)                 - Input matrix and target rank
            %   obj = Sketch(A, r, s)              - Input matrix, rank, and sketch size
            %   obj = Sketch('A', A, 'r', 10, ...) - Name-value pair inputs
            
            % Default values
            obj.r = 10;
            obj.s = 20;
            obj.l = 30;
            obj.d = 30;
            obj.iterationNum = 1;
            obj.distribution = 'Gaussian';
            obj.mixedPrecision = 1;
            obj.fixedW = 0;
            obj.Y_in_C = 0;
            
            if nargin == 0
                return;
            end
            
            % Check if first argument is name-value pair style
            if ischar(varargin{1})
                % Process name-value pairs
                for i = 1:2:length(varargin)
                    switch lower(varargin{i})
                        case 'a'
                            obj.A = varargin{i+1};
                            [obj.m, obj.n] = size(obj.A);
                        case 'r'
                            obj.r = varargin{i+1};
                        case 's'
                            obj.s = varargin{i+1};
                        case 'l'
                            obj.l = varargin{i+1};
                        case 'd'
                            obj.d = varargin{i+1};
                        case 'iterationnum'
                            obj.iterationNum = varargin{i+1};
                        case 'distribution'
                            obj.distribution = varargin{i+1};
                        case 'mixedprecision'
                            obj.mixedPrecision = varargin{i+1};
                    end
                end
            else
                % Process positional arguments
                obj.A = varargin{1};
                
                
                if nargin >= 2
                    obj.r = varargin{2};
                end
                if nargin >= 3
                    obj.s = varargin{3};
                end
                if nargin >= 4
                    obj.l = varargin{4};
                end
                if nargin >= 5
                    obj.d = varargin{5};
                end
                if nargin >= 6
                    obj.iterationNum = varargin{6};
                end
                if nargin >=7
                    obj.distribution = varargin{7};
                end
                if nargin >= 8
                    obj.mixedPrecision = varargin{8};
                end
                if nargin >= 9
                    obj.fixedW = varargin{9};
                end
                if nargin >= 10
                    obj.Y_in_C = varargin{10};
                end
            end
            
            % Construct the Sketch object
            %init
            [obj.m, obj.n] = size(obj.A);
            obj.PsiL=constructTestMatrix(obj.d,obj.m,obj.distribution);
            obj.PsiR=constructTestMatrix(obj.n,obj.d,obj.distribution);
            obj.OmegaR=constructTestMatrix(obj.n,obj.s,obj.distribution);
            obj.OmegaL=constructTestMatrix(obj.s,obj.m,obj.distribution);
            % obj.Omega=constructTestMatrix(obj.l,obj.s,obj.distribution);
            obj.PhiR=constructTestMatrix(obj.n,obj.l,obj.distribution);
            obj.PhiL=constructTestMatrix(obj.l,obj.m,obj.distribution);
            obj.YR = zeros(obj.m, obj.s);
            obj.YL = zeros(obj.s, obj.n);
            obj.W = zeros(obj.d, obj.d);
            obj.CR = zeros(obj.m, obj.l);
            obj.CL = zeros(obj.l, obj.n);
            %Construct Sketch
            if ~isempty(obj.A)
                [obj.m,obj.n] = size(obj.A);
                [obj.YR,obj.YL, obj.W, obj.CR,obj.CL] =obj.constructSketch();
            end
        end
        
        function [YR, YL, W, CR, CL] = constructSketch(SketchObj)

            if SketchObj.mixedPrecision == 1
                if SketchObj.Y_in_C == 0
                    YR = single(SketchObj.A * SketchObj.OmegaR);
                    YL = single(SketchObj.OmegaL * SketchObj.A);
                end
                W = single(SketchObj.PsiL * SketchObj.A*SketchObj.PsiR);
                CR = single(SketchObj.A * SketchObj.PhiR);
                CL = single(SketchObj.PhiL * SketchObj.A);
            elseif SketchObj.mixedPrecision == 2
                if SketchObj.Y_in_C == 0
                    YR = half(SketchObj.A * SketchObj.OmegaR);
                    YL = half(SketchObj.OmegaL * SketchObj.A);
                end
                W = half(SketchObj.PsiL * SketchObj.A*SketchObj.PsiR);
                CR = half(SketchObj.A * SketchObj.PhiR);
                CL = half(SketchObj.PhiL * SketchObj.A);
            else
                if SketchObj.Y_in_C == 0
                    YR = double(SketchObj.A * SketchObj.OmegaR);
                    YL = double(SketchObj.OmegaL * SketchObj.A);
                end
                W = SketchObj.PsiL * SketchObj.A*SketchObj.PsiR;
                CR = SketchObj.A * SketchObj.PhiR;
                CL = SketchObj.PhiL * SketchObj.A;
            end
            
            if SketchObj.Y_in_C == 1
                YR = CR * SketchObj.OmegaR(1:size(CR, 2), SketchObj.s);
                YL = CL * SketchObj.OmegaL(1:size(CL, 2), SketchObj.s);
            end
        end
        
        function obj1 = updateSketch(SketchObj, A)
            SketchObj1 = SketchObj.copy();
            SketchObj1.A = A;
            [YR0, YL0, W0, CR0, CL0] = SketchObj1.constructSketch();
            
            if SketchObj.Y_in_C == 0
                YR1 = SketchObj.YR + YR0;
                YL1 = SketchObj.YL + YL0;
            end
            
            W1 = SketchObj.W + W0;
            CR1 = SketchObj.CR + CR0;
            CL1 = SketchObj.CL + CL0;

            if SketchObj.Y_in_C == 1
                YR1 = CR1 * SketchObj.OmegaR(1:size(CR1, 2), SketchObj.s);
                YL1 = CL1 * SketchObj.OmegaL(1:size(CL1, 2), SketchObj.s);
            end
            
            obj1 = SketchObj;
            obj1.A = SketchObj1.A+obj1.A;
            obj1.YR = YR1;
            obj1.YL = YL1;
            obj1.W = W1;
            obj1.CR = CR1;
            obj1.CL = CL1;
        end
        
        % function obj1=update(SketchObj)
        %     obj1=SketchObj.copy();
        % end
        
        function obj1 = ModifySketch(SketchObj)
            obj1 = SketchObj;
            
            % Adjust precision
            if obj1.mixedPrecision == 0
                obj1.YR = double(obj1.YR);
                obj1.YL = double(obj1.YL);
                obj1.W = double(obj1.W);
                obj1.CR = double(obj1.CR);
                obj1.CL = double(obj1.CL);
            elseif obj1.mixedPrecision == 1
                obj1.YR = single(obj1.YR);
                obj1.YL = single(obj1.YL);
                obj1.W = single(obj1.W);
                obj1.CR = single(obj1.CR);
                obj1.CL = single(obj1.CL);
            elseif obj1.mixedPrecision == 2
                obj1.YR = half(obj1.YR);
                obj1.YL = half(obj1.YL);
                obj1.W = half(obj1.W);
                obj1.CR = half(obj1.CR);
                obj1.CL = half(obj1.CL);
            end
            
            % Adjust size of OmegaR and YR
            if SketchObj.s > size(SketchObj.YR, 2)
                addpart = constructTestMatrix(SketchObj.n, SketchObj.s - size(SketchObj.YR, 2), SketchObj.distribution);
                SketchObj.OmegaR = [SketchObj.OmegaR, addpart];
                if SketchObj.mixedPrecision == 1
                    if SketchObj.Y_in_C == 0
                        obj1.YR = [obj1.YR, single(SketchObj.A * addpart)];
                    else
                        obj1.YR = [obj1.YR, single(SketchObj.CR * addpart(1:size(SketchObj.CR, 2), :))];
                    end
                elseif SketchObj.mixedPrecision == 2
                    if SketchObj.Y_in_C == 0
                        obj1.YR = [obj1.YR, half(SketchObj.A * addpart)];
                    else
                        obj1.YR = [obj1.YR, half(SketchObj.CR * addpart(1:size(SketchObj.CR, 2), :))];
                    end
                else
                    if SketchObj.Y_in_C == 0
                        obj1.YR = [obj1.YR, SketchObj.A * addpart];
                    else
                        obj1.YR = [obj1.YR, SketchObj.CR * addpart(1:size(SketchObj.CR, 2), :)];
                    end
                end
            elseif SketchObj.s < size(SketchObj.YR, 2)
                obj1.OmegaR = SketchObj.OmegaR(:, 1:SketchObj.s);
                obj1.YR = SketchObj.YR(:, 1:SketchObj.s);
            end
            
            % Adjust size of OmegaL and YL
            if SketchObj.s > size(SketchObj.YL, 1)
                addpart = constructTestMatrix(SketchObj.s - size(SketchObj.YL, 1), SketchObj.m, SketchObj.distribution);
                SketchObj.OmegaL = [SketchObj.OmegaL; addpart];
                if SketchObj.mixedPrecision == 1
                    if SketchObj.Y_in_C == 0
                        obj1.YL = [obj1.YL; single(addpart * SketchObj.A)];
                    else
                        obj1.YL = [obj1.YL; single(addpart(:, 1:size(SketchObj.CL, 2)) * SketchObj.CL)];
                    end
                elseif SketchObj.mixedPrecision == 2
                    if SketchObj.Y_in_C == 0
                        obj1.YL = [obj1.YL; half(addpart * SketchObj.A)];
                    else
                        obj1.YL = [obj1.YL; half(addpart(:, 1:size(SketchObj.CL, 2)) * SketchObj.CL)];
                    end
                else
                    if SketchObj.Y_in_C == 0
                        obj1.YL = [obj1.YL; addpart * SketchObj.A];
                    else
                        obj1.YL = [obj1.YL; addpart(:, 1:size(SketchObj.CL, 2)) * SketchObj.CL];
                    end
                end
            elseif SketchObj.s < size(SketchObj.YL, 1)
                obj1.OmegaL = SketchObj.OmegaL(1:SketchObj.s, :);
                obj1.YL = SketchObj.YL(1:SketchObj.s, :);
            end
            
            % Adjust size of PhiR and CR
            if SketchObj.l > size(SketchObj.CR, 2)
                addpart = constructTestMatrix(SketchObj.n, SketchObj.l - size(SketchObj.CR, 2), SketchObj.distribution);
                obj1.PhiR = [obj1.PhiR, addpart];
                if SketchObj.mixedPrecision == 1
                    obj1.CR = [obj1.CR, single(SketchObj.A * addpart)];
                elseif SketchObj.mixedPrecision == 2
                    obj1.CR = [obj1.CR, half(SketchObj.A * addpart)];
                else
                    obj1.CR = [obj1.CR, SketchObj.A * addpart];
                end
            elseif SketchObj.l < size(SketchObj.CR, 2)
                obj1.PhiR = SketchObj.PhiR(:, 1:SketchObj.l);
                obj1.CR = SketchObj.CR(:, 1:SketchObj.l);
            end
            
            % Adjust size of PhiL and CL
            if SketchObj.l > size(SketchObj.CL, 1)
                addpart = constructTestMatrix(SketchObj.l - size(SketchObj.CL, 1), SketchObj.m, SketchObj.distribution);
                obj1.PhiL = [obj1.PhiL; addpart];
                if SketchObj.mixedPrecision == 1
                    obj1.CL = [obj1.CL; single(addpart * SketchObj.A)];
                elseif SketchObj.mixedPrecision == 2
                    obj1.CL = [obj1.CL; half(addpart * SketchObj.A)];
                else
                    obj1.CL = [obj1.CL; addpart * SketchObj.A];
                end
            elseif SketchObj.l < size(SketchObj.CL, 1)
                obj1.PhiL = SketchObj.PhiL(1:SketchObj.l, :);
                obj1.CL = SketchObj.CL(1:SketchObj.l, :);
            end

            % Adjust size of PsiL, PsiR and W
            if SketchObj.d > size(SketchObj.W, 1)
                addpart = constructTestMatrix(SketchObj.d - size(SketchObj.W, 1), SketchObj.m, SketchObj.distribution);
                obj1.PsiL = [SketchObj.PsiL; addpart];
                addpart = constructTestMatrix( SketchObj.m,SketchObj.d - size(SketchObj.W, 1), SketchObj.distribution);
                obj1.PsiR = [SketchObj.PsiR, addpart];
                obj1.W=obj1.PsiL*SketchObj.A*obj1.PsiR;
            elseif SketchObj.d < size(SketchObj.W, 1)
                obj1.PsiL=obj1.PsiL(1:SketchObj.d,:);
                obj1.PsiR=obj1.PsiR(:,1:SketchObj.d);
                obj1.W=obj1.W(1:SketchObj.d,1:SketchObj.d);
            end
        end
        
        function newObj = copy(obj)
            newObj = StreamingThreeSketch(obj.A, obj.r, obj.s, obj.l, obj.d, obj.iterationNum, obj.distribution, obj.mixedPrecision);
            newObj.OmegaR = obj.OmegaR;
            newObj.OmegaL = obj.OmegaL;
            newObj.YR = obj.YR;
            newObj.YL = obj.YL;
            newObj.PhiR = obj.PhiR;
            newObj.PhiL = obj.PhiL;
            newObj.CR = obj.CR;
            newObj.CL = obj.CL;
            newObj.PsiL = obj.PsiL;
            newObj.PsiR = obj.PsiR;
            newObj.W = obj.W;
        end
    end
end