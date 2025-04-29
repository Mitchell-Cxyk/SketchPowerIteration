classdef LowRankApproxmation < handle
    properties
       iterationNum;
       Q;
       B;
       r;
       U;
       S;
       V;
    end
    
    methods
        function obj = LowRankApproxmation(SketchObj)
            obj.iterationNum=SketchObj.iterationNum;
            Y=LowRankApproxmation.sketchPower(SketchObj.Y,SketchObj.C,SketchObj.iterationNum);
            Y=double(Y);
            [obj.Q,~]=qr(Y,0);
            if SketchObj.fixedW==1
                obj.B=(double(SketchObj.Psi*obj.Q))\single(SketchObj.W);
            else
                obj.B=(double(SketchObj.Psi*obj.Q))\double(SketchObj.W);
            end
            obj.r=SketchObj.r;
            [obj.U,obj.S,obj.V]=LowRankApproxmation.tsvd(double(obj.B),obj.r); 
            obj.U=obj.Q*obj.U;
            end
    end

    methods(Static)
        function output=sketchPower(Y0,C,iterationNum)
            classY=class(Y0);classC=class(C);
            MixedFlag=[classY(1),classC(1)];
            Ym=size(Y0,1);Yn=size(Y0,2);
            if iterationNum>0
                Cn=size(C,2);
                S=EstimateSpectrum(Y0);
                % Estimate the decay spectrum of Y to consider if use
                % mixed-precision multiplication.
                if ~isempty(find(S<sqrt(Ym)*eps(classY), 1))
                    % disp('Using Mixed-Precision Multiplication!');
                    if strcmp(classY,'single')
                        MixedFlag='sd';
                    elseif strcmp(classY,'half')
                        MixedFlag='hs';
                    else
                        MixedFlag='dd';
                end
                end
            end
            for i=1:iterationNum
                %Y1 is C'*Y,which is very small l*s matrix, thus 
                %supports to high-precision orthogonization.
                Y1=mixedPrecisionMTIMES(C',Y0,MixedFlag,'d');   % only size l*s
                 [Q,~]=qr(Y1,'econ');
                 % handleY=str2func(classY);Q=handleY(Q);
                 %Y0 is larger m*s matrix, so output low-precision.
                Y0=mixedPrecisionMTIMES(C,Q,MixedFlag);
            end
            output=Y0;
        end
        function [U,S,V]=tsvd(A,r)
            [U,S,V]=svd(A,'econ');
            U=U(:,1:r);
            S=S(1:r,1:r);
            V=V(:,1:r); 
        end
    end
end
