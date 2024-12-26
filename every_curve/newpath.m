%定义path类
classdef newpath
    properties
        dimension = 0;
        curveType = 0;
        beginParameter = 0;
        endParameter = 1;
        path_length = 0;
        CtrlPts = [];
        knots = [];
        p = 0;
        beginPoint = [];
        endPoint = [];
        beginTangent = [];
        endTangent = [];
        beginCurvature = 0;
        endCurvature = 0;
        NCtrlPts = 0;
    end
    methods
        function obj = newpath(cpts, kv, us, ue)
            if nargin == 2
                us = 0;
                ue = 1;
            elseif nargin ~= 4
                obj = 0;
                return;
            end             
            obj.CtrlPts = cpts;
            obj.knots = kv;
            obj.dimension = size(obj.CtrlPts ,1);
            obj.NCtrlPts = size(obj.CtrlPts,2);
            obj.p = length(obj.knots) - obj.NCtrlPts - 1;
            obj.beginPoint = obj.calculateCurvePts(us);
            obj.endPoint = obj.calculateCurvePts(ue);
            obj.beginTangent = obj.calculateCurveVec(us);
            obj.endTangent = obj.calculateCurveVec(ue);
            obj.path_length = obj.calculateCurveLength(us , ue);
            kbe = obj.calculateCurveCurvature([us,  ue]);
            obj.beginCurvature = kbe(1);
            obj.endCurvature = kbe(2);  
        end       
        
        function dm = getDimension(obj)
            dm = obj.dimension;
        end
        function ct = getCurveType(obj)
            ct = obj.curveType;
        end
        function bpm = getBeginParameter(obj)
            bpm = obj.beginParameter;
        end
        function epm = getEndParameter(obj)
            epm = obj.endParameter;
        end
        function bpt = getBeginPoint(obj)
            bpt = obj.beginPoint;
        end
        function ept = getEndPoint(obj)
            ept = obj.endPoint;
        end
        function btg = getBeginTangent(obj)
            btg = obj.beginTangent;
        end
        function etg = getEndTangent(obj)
            etg = obj.endTangent;
        end
        function tl = getTotalLength(obj)
            tl = obj.path_length;
        end
        function bct = getBeginCurvature(obj)
            bct = obj.beginCurvature;
        end
        function ect = getEndCurvature(obj)
            ect = obj.endCurvature;
        end 
        
        function L = calculateCurveLength(obj, u_s, u_e)
            if nargin < 2
                u_s = obj.beginParameter;
                u_e = obj.endParameter;
            end
            u_v = [u_s , (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e];
            v = obj.calculateCurveVec(u_v);
            d = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);

            L1 = (u_e - u_s)/6 * (d(1) + 4 * d(3) + d(5));
            L2 = (u_e - u_s)/12 * (d(1) + 4*d(2) + 2*d(3) + 4*d(4) + d(5));

            if abs(L1 - L2) < 1e-6
                L = L2;
            else
                L = obj.calculateCurveLength(u_s , (u_s + u_e)/2) + obj.calculateCurveLength((u_s + u_e)/2 , u_e);  
            end
        end
        
        function points = calculateCurvePts(obj, u_array)
            
            kv{1} = obj.knots;
            Cw = BsplineEval(kv , obj.CtrlPts, {u_array});
            w = Cw(4, :);
            points_w = bsxfun(@rdivide, Cw, w);
            points = points_w(1:3,:);
        end
        
        function vel = calculateCurveVec(obj, u_array)

            Idx = FindSpan(obj.NCtrlPts , obj.p , u_array , obj.knots);
            N = DersBasisFuns(Idx, u_array , obj.p , 1, obj.knots);
            n = length(u_array);
            %先求原始点是多少
            Cw = zeros( obj.dimension ,  n);
            for i = 1 : obj.p + 1
                Cw = Cw + bsxfun(@times, N(:, i , 1)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w = Cw(4, :);
            pts = bsxfun(@rdivide, Cw, w);

            %再求原始点基础上的导数
            Dw = zeros( obj.dimension ,  n);
            for i = 1 : obj.p + 1
                Dw = Dw + bsxfun(@times, N(:, i , 2)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w1 = Dw(4, :);
            velw = Dw - bsxfun(@times, w1 , pts);
            vel = bsxfun(@rdivide, velw , w);
            vel = vel(1:3,:);
        end
        
        function acc = calculateCurveAcc(obj, u_array)
            
            Idx = FindSpan(obj.NCtrlPts , obj.p , u_array , obj.knots);
            N = DersBasisFuns(Idx, u_array , obj.p , 2, obj.knots);
            n = length(u_array);
            %先求原始点是多少
            Cw = zeros( obj.dimension ,  n);
            for i = 1 : obj.p + 1
                Cw = Cw + bsxfun(@times, N(:, i , 1)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w = Cw(4, :);
            pts = bsxfun(@rdivide, Cw, w);

            %再求原始点基础上的导数
            Dw = zeros( obj.dimension ,  n);
            for i = 1 : obj.p + 1
                Dw = Dw + bsxfun(@times, N(:, i , 2)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w1 = Dw(4, :);
            velw = Dw - bsxfun(@times, w1 , pts);
            vel = bsxfun(@rdivide, velw , w);

            %在求二阶导数是多少
            Aw = zeros( obj.dimension ,  n);
            for i = 1 : obj.p + 1
                Aw = Aw + bsxfun(@times, N(:, i , 3)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w2 = Aw(4,:);
            accw = Aw - 2 * bsxfun(@times, w1 , vel) -  bsxfun(@times, w2 , pts);
            acc = bsxfun(@rdivide, accw, w);
            acc = acc(1:3,:);
        end
        
        function curvature = calculateCurveCurvature(obj, u_array)
            
            Idx = FindSpan(obj.NCtrlPts , obj.p , u_array , obj.knots);
            N = DersBasisFuns(Idx, u_array , obj.p , 2, obj.knots);
            n = length(u_array);
            %先求原始点是多少
            Cw = zeros( obj.dimension ,  n);
            for i = 1 : obj.p + 1
                Cw = Cw + bsxfun(@times, N(:, i , 1)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w = Cw(4, :);
            pts = bsxfun(@rdivide, Cw, w);

            %再求原始点基础上的导数
            Dw = zeros( obj.dimension ,  n);
            for i = 1 : obj.p + 1
                Dw = Dw + bsxfun(@times, N(:, i , 2)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w1 = Dw(4, :);
            velw = Dw - bsxfun(@times, w1 , pts);
            vel = bsxfun(@rdivide, velw , w);
            v = vel(1:3,:);

            %在求二阶导数是多少
            Aw = zeros( obj.dimension , n);
            for i = 1 : obj.p + 1
                Aw = Aw + bsxfun(@times, N(:, i , 3)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w2 = Aw(4,:);
            accw = Aw - 2 * bsxfun(@times, w1 , vel) -  bsxfun(@times, w2 , pts);
            acc = bsxfun(@rdivide, accw, w);
            a = acc(1:3,:);
            vn = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);
            cv = bsxfun(@rdivide, cross(v , a) , vn.^3); 
            curvature = sqrt(cv(1,:).^2 + cv(2,:).^2 + cv(3,:).^2);       
        end
        
    end
    methods
        function kcr = calculateThresholdCurvature(vm, am, jm, ts, ce)
            v1 = 8 * ce / (vm^2 * ts^2 + 4 * ce^2);
            v2 = am / vm^2;
            v3 = sqrt(jm / vm^3);
            kcr = min( [v1,v2,v3]);
        end
    end
        
end
        