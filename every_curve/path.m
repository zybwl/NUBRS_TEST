%定义path类
classdef path
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
        function obj = path(cpts, kv, us, ue)
            if nargin == 2
                us = 0;
                ue = 1;
            elseif nargin ~= 4
                obj = 0;
                return;
            end      
            obj.beginParameter = us;
            obj.endParameter = ue;
            obj.CtrlPts = cpts;
            obj.knots = kv;
            obj.dimension = size(obj.CtrlPts ,1);
            obj.NCtrlPts = size(obj.CtrlPts,2);
            obj.p = length(obj.knots) - obj.NCtrlPts - 1;
            obj.beginPoint = obj.calculateCurvePts(us);
            obj.endPoint = obj.calculateCurvePts(ue);
            obj.beginTangent = obj.calculateCurveVec(us + 1e-9);
            obj.endTangent = obj.calculateCurveVec(ue - 1e-9);
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

            if abs(L1 - L2) < 1e-8 && abs((u_s + u_e)/2 - 0.5) > 1e-6;
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
        function kcr = calculateThresholdCurvature(~ ,vm, am, jm, ts, ce)
            v1 = 8 * ce / (vm^2 * ts^2 + 4 * ce^2);
            v2 = am / vm^2;
            v3 = sqrt(jm / vm^3);
            kcr = min( [v1,v2,v3]);
        end
        
        function critical_u = divCurveToSegments(obj, vm, am, jm, ts, ce)
            
            if obj.p == 1
                critical_u = obj.knots(2:end-1);
                return;
            elseif obj.p == 2 
                uniq_index = diff(obj.knots) > 0;
                critical_u = [obj.knots(uniq_index) 1];
                return;
            end
            % 找出曲线中的1重节点
            one_critical_index = (1:length(obj.knots)) < 0;
            for i = obj.p + 2 : length(obj.knots) - 2 * obj.p
                check_array = obj.knots(i : i + obj.p - 1);
                check_value = sum(abs(diff(check_array)));
                if check_value < 1e-8
                    one_critical_index(1,i) = true;
                end
            end
            kk_critical_u = obj.knots(one_critical_index);
            kcr = obj.calculateThresholdCurvature(vm, am, jm, ts, ce);
            temp_critical_u = obj.get_curvature_peak(kcr);
            
            % 两个数列优先插补
            m = length(kk_critical_u);
            n = length(temp_critical_u);
            if m == 0
                old_critical_u = temp_critical_u;
            elseif n == 0
                old_critical_u = kk_critical_u;
            else
                m_b = 1;
                n_b = 1;
                old_critical_u = zeros(1, m+n);
                for i = 1: m + n
                    if  (m_b > m) || (temp_critical_u(n_b) < kk_critical_u(m_b))
                        old_critical_u(1,i) = temp_critical_u(n_b);
                        n_b = n_b + 1;
                    else
                        old_critical_u(1,i) = kk_critical_u(m_b);
                        m_b = m_b + 1;
                    end
                end
            end
                          
            crn = 1;
            if isempty(old_critical_u)
                critical_u = [0,1];
            else
                for i = 1: length(old_critical_u)
                    if i == 1
                        if  old_critical_u(i) < 0.01
                            critical_u(1) = 0; 
                            crn = crn + 1; 
                        else
                            critical_u = [0, old_critical_u(crn)];
                            crn = crn + 2; 
                        end    
                    elseif i == length(old_critical_u)
                        if old_critical_u(i) > 0.99
                            critical_u(crn) = 1;
                        else
                            critical_u = [critical_u ,old_critical_u(i), 1];
                        end
                    else
                        if old_critical_u(i+1) - old_critical_u(i) > 1e-4
                            critical_u(crn) = old_critical_u(i);
                            crn = crn + 1; 
                        end
                    end  
                end
            end
        end
        
        function  u_array = get_curvature_peak(obj, kcr, u_s, u_e, u_in)

            if nargin <3
                u_s = 0;
                u_e = 1;
                u_in = [];
            end

            u_v = [u_s , (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e];
            v = obj.calculateCurveVec(u_v);
            d = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);

            L1 = (u_e - u_s)/6 * (d(1) + 4 * d(3) + d(5));
            L2 = (u_e - u_s)/12 * (d(1) + 4*d(2) + 2*d(3) + 4*d(4) + d(5));
            zero_eps = 1e-6;

            if abs(L1 - L2) < 1e-6 && abs((u_s + u_e)/2 - 0.5) > 1e-6
                if u_s > 1e-6 && u_e < 1 - 1e-6
                    u_ts = [u_s - 1e-6 ,u_s, (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e , u_e + 1e-6];
                else
                    u_array = u_in;
                    return;
                end
                cuv = obj.calculateCurveCurvature(u_ts);    
                condition1 = cuv(2:6) > kcr;
                condition2 = (cuv(2:6) - cuv(1:5))>zero_eps;
                condition3 = (cuv(2:6) - cuv(3:7))>zero_eps;
                condition = condition1 & condition2 & condition3;
                satisfied_index = find(condition > 0, 1);
                if ~isempty(satisfied_index)
                    u_array = [ u_in, u_ts(satisfied_index + 1)];
                else
                    u_array = u_in;
                end       
            else
                u_array_begin = obj.get_curvature_peak(kcr,  u_s , (u_s + u_e)/2, u_in);
                u_array_end = obj.get_curvature_peak(kcr,  (u_s + u_e)/2 , u_e, u_in);  
                u_array = [u_array_begin, u_array_end];
            end
        end
    end    
end
        