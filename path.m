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
        critical_u = [];
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
            u_in = [];
            [obj.path_length, obj.critical_u]  = obj.calculateCurveLength(us , ue, u_in);
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
        
        function [L, u_out] = calculateCurveLength(obj, u_s, u_e, u_in)
            if nargin < 2
                u_s = obj.beginParameter;
                u_e = obj.endParameter;
            end
            u_v = [u_s , (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e];
            v = obj.calculateCurveVec(u_v);
            d = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);
            L1 = (u_e - u_s)/6 * (d(1) + 4 * d(3) + d(5));
            L2 = (u_e - u_s)/12 * (d(1) + 4*d(2) + 2*d(3) + 4*d(4) + d(5));

            if abs(L1 - L2) < 1e-6 && (u_s - u_e) < 1e-2;
                L = L2;
                u_out = [u_in, u_e];
            else
                [L_left, u_left_out] = obj.calculateCurveLength(u_s , (u_s + u_e)/2, u_in);
                [L_right, u_right_out]= obj.calculateCurveLength((u_s + u_e)/2 , u_e, u_in); 
                L = L_left + L_right;
                u_out = [u_left_out , u_right_out];
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
        
         function curv_driv= calculateCurveCurvatureDriv(obj, u_array)
            
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
            Aw = zeros( 4 , n);
            for i = 1 : obj.p + 1
                Aw = Aw + bsxfun(@times, N(:, i , 3)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w2 = Aw(4,:);
            accw = Aw - 2 * bsxfun(@times, w1 , vel) -  bsxfun(@times, w2 , pts);
            acc = bsxfun(@rdivide, accw, w);
            a = acc(1:3,:); 
            
            %再求三阶导数
            Jw = zeros( 4,  n);
            for i = 1 : obj.p + 1
                Jw = Jw + bsxfun(@times, N(:, i , 4)' , obj.CtrlPts(:, Idx - obj.p + i - 1));
            end
            w3 = Jw(4,:);
            jerkw = Jw - 3 * bsxfun(@times, w1 , acc) - 2 * bsxfun(@times, w2 , vel) -  bsxfun(@times, w3 , pts);
            jerk = bsxfun(@rdivide, jerkw, w);
            J = jerk(1:3,:);
            vn = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);
            cv = bsxfun(@rdivide, cross(v , a) , vn.^3); 
            cj = bsxfun(@rdivide, cross(v , J) , vn.^3);
            cc = dot(v , a) ./ vn.^2;
            cl = cj - 3 * bsxfun(@times, cv , cc); 
            curv_driv = cl(3,:);
         end
        
         function bku = findCurvatureBreakU(obj, a, b, flag)

            if flag
                low = a;
                high = b;

            else
                high = a;
                low = b;
            end
            mid = (low + high)/2;
            e = obj.calculateCurveCurvatureDriv(mid);
            while abs(e) > 1e-6 && abs(high - low) > 1e-6
                if e > 1e-6               
                    high = mid;
                else
                    low = mid;
                end
                mid = (low + high)/2;
                e = nurbs_curve_curvature_driv(kv,cpts,mid);
            end
            bku = mid;
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
        
        function  bku_array = get_curvature_peak(obj)

            bku_array = [];
            c = obj.critical_u;
            cvh = obj.calculateCurveCurvature(c);
            cvp = obj.calculateCurveCurvatureDriv(c);
            
            for i = 2:length(cvp)
                a = cvp(i-1) ;
                b = cvp(i);
                flag = false;
                if a < -1e-6 && b > 1e-6
                    bku = obj.findCurvatureBreakU(c(i-1),c(i), true);
                    flag = true;
                elseif a > 1e-6 && b < -1e-6
                    bku = obj.findCurvatureBreakU(c(i-1),c(i), false);
                    flag = true;
                else
                    %pass;
                end 

                if flag
                    temp_cur = obj.calculateCurveCurvature(bku);
                    if (temp_cur > cvh(i-1)) && (temp_cur > cvh(i))
                        bku_array = [bku_array; bku,0];
                    elseif (temp_cur < cvh(i-1)) && (temp_cur < cvh(i))
                        bku_array = [bku_array; bku,1];
                    else
                        %pass
                    end
                end
            end       
        end
    end    
end
        