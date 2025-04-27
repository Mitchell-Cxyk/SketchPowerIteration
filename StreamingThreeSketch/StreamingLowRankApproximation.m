classdef StreamingLowRankApproximation < handle
    properties
       iterationNum;
       QL;
       QR;
       B;
       r;
       U;
       S;
       V;
    end
    
    methods
        function obj = StreamingLowRankApproximation(SketchObj)
            obj.iterationNum=SketchObj.iterationNum;
            YR=LowRankApproxmation.sketchPower(SketchObj.YR,SketchObj.CR,SketchObj.iterationNum);
            YR=double(YR);
            [obj.QR,~]=qr(YR,0);
            
            YL=LowRankApproxmation.sketchPower(SketchObj.YL',SketchObj.CL',SketchObj.iterationNum);
            YL=double(YL);
            [obj.QL,~]=qr(YL,0);
            
            if SketchObj.fixedW==1
                obj.B=((double(SketchObj.PsiL*obj.QR))\single(SketchObj.W))/double(obj.QL'*SketchObj.PsiR);
            else
                obj.B=((double(SketchObj.PsiL*obj.QR))\double(SketchObj.W))/double(obj.QL'*SketchObj.PsiR);
            end
            obj.r=SketchObj.r;
            [obj.U,obj.S,obj.V]=LowRankApproxmation.tsvd(double(obj.B),obj.r); 
            obj.U=obj.QR*obj.U; obj.V=obj.QL*obj.V;
            end
    end

    methods(Static)
        function Y1=sketchPower(Y0,C,iterationNum)
            for i=1:iterationNum
                Y0=C'*Y0;
                if isa(Y0,'half')
                    [Y0,~]=qr(single(Y0),0);
                    Y0=half(Y0);
                    Y0=C*Y0;
                else
                [Y0,~]=qr(Y0,0);
                Y0=C*Y0;
                end
            end
            Y1=Y0;
        end
        function [U,S,V]=tsvd(A,r)
            [U,S,V]=svd(A,0);
            U=U(:,1:r);
            S=S(1:r,1:r);
            V=V(:,1:r); 
        end
    end
end