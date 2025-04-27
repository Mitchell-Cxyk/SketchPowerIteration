classdef Sketch < handle
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
        Y % Sketch matrix m\times s
        W % Sketch matrix d\times n
        C % Sketch matrix m\times l
        Psi
        Omega
        Phi
        mixedPrecision %0: double, 1: single, 2: half
        fixedW %0: W is set double to solve equality, 1: W is set to single to solve equality
        Y_in_C %0: Y is not in C, 1: Y is in C
    end
    
    methods
        function obj = Sketch(varargin)
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
                        case 'fixedw'
                            obj.fixedW = varargin{i+1};
                        case 'yinc'
                            obj.Y_in_C = varargin{i+1};
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
            obj.Psi=constructTestMatrix(obj.d,obj.m,obj.distribution);
            obj.Omega=constructTestMatrix(obj.n,obj.s,obj.distribution);
            % obj.Omega=constructTestMatrix(obj.l,obj.s,obj.distribution);
            obj.Phi=constructTestMatrix(obj.n,obj.l,obj.distribution);
            obj.Y = zeros(obj.m, obj.s);
            obj.W = zeros(obj.d, obj.n);
            obj.C = zeros(obj.m, obj.l);
            %Construct Sketch
            if ~isempty(obj.A)
                [obj.m,obj.n] = size(obj.A);
                [obj.Y, obj.W, obj.C] =obj.constructSketch();
            end
        end
        
        function [Y, W, C] = constructSketch(SketchObj)
            if isempty(SketchObj.Psi)
                error('No Psi exist.');
            end
            if SketchObj.mixedPrecision==1
                if SketchObj.Y_in_C==0
                    Y=single(SketchObj.A*SketchObj.Omega);
                end
                W=single(SketchObj.Psi*SketchObj.A);C=single(SketchObj.A*SketchObj.Phi);
            elseif SketchObj.mixedPrecision==2
                if SketchObj.Y_in_C==0
                    Y=half(SketchObj.A*SketchObj.Omega);
                end
                W=half(SketchObj.Psi*SketchObj.A);C=half(SketchObj.A*SketchObj.Phi);
            else
                if SketchObj.Y_in_C==0
                    Y=double(SketchObj.A*SketchObj.Omega);
                end
                W=SketchObj.Psi*SketchObj.A;C=SketchObj.A*SketchObj.Phi;
            end
            if SketchObj.Y_in_C==1
                Y=C*SketchObj.Omega(1:size(C,2),SketchObj.s);
            end
        end
        
        function obj1 = updateSketch(SketchObj, A)
            SketchObj1=SketchObj.copy();SketchObj1.A=A;
            [Y0,W0,C0]=Sketch.constructSketch(A, SketchObj1);
            Y1=SketchObj.Y+Y0;
            W1=SketchObj.W+W0;
            C1=SketchObj.C+C0;
            obj1=SketchObj;
            obj1.A=SketchObj1.A+obj1A;
            obj1.Y=Y1;
            obj1.W=W1;
            obj1.C=C1;
        end
        
        % function obj1=update(SketchObj)
        %     obj1=SketchObj.copy();
        % end
        
        function obj1=ModifySketch(SketchObj)
            obj1=SketchObj;
            if obj1.mixedPrecision==0
                obj1.Y=double(obj1.Y);
                obj1.W=double(obj1.W);
                obj1.C=double(obj1.C);
            elseif obj1.mixedPrecision==1
                obj1.Y=single(obj1.Y);
                obj1.W=single(obj1.W);
                obj1.C=single(obj1.C);
            elseif obj1.mixedPrecision==2
                obj1.Y=half(obj1.Y);
                obj1.W=half(obj1.W);
                obj1.C=half(obj1.C);
            end
            if SketchObj.s > size(SketchObj.Y,2)
                addpart=constructTestMatrix(SketchObj.n,SketchObj.s-size(SketchObj.Y,2),SketchObj.distribution);
                SketchObj.Omega=[SketchObj.Omega,addpart];
                if SketchObj.mixedPrecision==1
                    obj1.Y=[obj1.Y,single(SketchObj.A*addpart)];
                elseif SketchObj.mixedPrecision==2
                    obj1.Y=[obj1.Y,half(SketchObj.A*addpart)];
                else
                    obj1.Y=[obj1.Y,SketchObj.A*addpart];
                end
            elseif SketchObj.s < size(SketchObj.Y,2)
                obj1.Omega=SketchObj.Omega(:,1:SketchObj.s);
                obj1.Y=SketchObj.Y(:,1:SketchObj.s);
            end
            if SketchObj.l > size(SketchObj.C,2)
                addpart=constructTestMatrix(SketchObj.n,SketchObj.l-size(SketchObj.C,2),SketchObj.distribution);
                obj1.Phi=[obj1.Phi,addpart];
                if SketchObj.mixedPrecision==1
                    obj1.C=[obj1.C,single(SketchObj.A*addpart)];
                elseif SketchObj.mixedPrecision==2
                    obj1.C=[obj1.C,half(SketchObj.A*addpart)];
                else
                    obj1.C=[obj1.C,SketchObj.A*addpart];
                end
            elseif SketchObj.l < size(SketchObj.C,2)
                obj1.Phi=SketchObj.Phi(:,1:SketchObj.l);
                obj1.C=SketchObj.C(:,1:SketchObj.l);
            end
            if SketchObj.d > size(SketchObj.W,1)
                addpart=constructTestMatrix(SketchObj.d-size(SketchObj.Psi,1),SketchObj.m,SketchObj.distribution);
                obj1.Psi=[SketchObj.Psi;addpart];
                if SketchObj.mixedPrecision==1
                    obj1.W=[obj1.W;single(addpart*SketchObj.A)];
                elseif SketchObj.mixedPrecision==2
                    obj1.W=[obj1.W;half(addpart*SketchObj.A)];
                else
                    obj1.W=[obj1.W;addpart*SketchObj.A];
                end
            elseif SketchObj.d < size(SketchObj.W,1)
                obj1.Psi=SketchObj.Psi(1:SketchObj.d,:);
                obj1.W=SketchObj.W(1:SketchObj.d,:);
            end
        end
        function newObj = copy(obj)
            newObj = Sketch(obj.A, obj.r, obj.s, obj.l, obj.d, obj.iterationNum,obj.distribution, obj.mixedPrecision,obj.fixedW,obj.Y_in_C);
            newObj.Omega = obj.Omega;
            newObj.Y = obj.Y;
            newObj.Phi = obj.Phi;
            newObj.C = obj.C;
            newObj.Psi = obj.Psi;
            newObj.W = obj.W;
        end
    end
end