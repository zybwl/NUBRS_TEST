%定义path类
classdef trajectory
    properties
        oneMiniPath ;
        kconstraint = zeros(1,3);
        tvs_param = zeros(3,7);
        tsum = 0;
        path_length =0 ;
        vs = 0;
        ve = 0;
        ts  = 0; 
        ce = 0;
        time_begin = 0;
        time_end = 0;
        interpolation_time_begin = 0;
        interpolation_time_end = 0;
        beginTangent = [];
        endTangent = [];
        beginCurvature = 0;
        endCurvature = 0;
        intp_num = 1;
        pre_u = 0;
        pre_s = 0;
        max_u = 0;
        now_point;
        next_point;
        u_intp = [];
    end
    methods
        function obj = trajectory(one_path, kconstraint, ts, ce)
            obj.oneMiniPath = one_path;
            obj.kconstraint = kconstraint;
            obj.path_length = one_path.getTotalLength();
            obj.beginTangent = one_path.getBeginTangent();
            obj.endTangent = one_path.getEndTangent();
            obj.beginCurvature = one_path.getBeginCurvature();
            ki = one_path.getEndCurvature();
            vm = kconstraint(1);
            am = kconstraint(2);
            jm = kconstraint(3);
            if ki > 0
                v1 = 2/ts * sqrt(2*ce/ki - ce^2);
                v2 = sqrt(am/ki);
                v3 = (jm/ki^2)^(1/3);
                obj.ve = min([v1,v2,v3, vm]);
            else
                obj.ve = vm;
            end
            obj.ts  = ts;
            obj.ce = ce;
            obj.endCurvature = ki;
            obj.pre_u = one_path.beginParameter;
            obj.max_u = one_path.endParameter;
        end
        
        function obj = plan(obj)
            obj = obj.compute_start_stop_time();
        end
        
        function obj = interpolation(obj)
                    
            obj.intp_num = obj.intp_num + 1;
            now_u  = obj.u_intp(1, obj.intp_num);
            obj.now_point = obj.oneMiniPath.calculateCurvePts(now_u);
            
        end
        
        function obj = setVs(obj, vs)
            obj.vs = vs;
        end
        
        function obj = setVe(obj, ve)
            obj.ve = ve;
        end
        
        function vs = getVs(obj)
            vs = obj.vs;
        end
        
        function ve = getVe(obj)
            ve = obj.ve;
        end
        function tl = getLength(obj)
            tl = obj.path_length;
        end
        
        function obj = compute_start_stop_time(obj)

            v_max = obj.kconstraint(1);
            A = obj.kconstraint(2);
            J = obj.kconstraint(3);
            v_start = obj.vs;
            v_end = obj.ve;
            L = obj.path_length;
            if v_max < v_start || v_max < v_end
                return;
            end
            %
            t = obj.compute_7_time(v_max, v_start, v_end, J ,A, L);
            t_sum = sum(t);
            is_half_cycle = sum(t > 0) <= 3;
            if is_half_cycle
                low = 1;
                high = 1.2;
                t_int_ts = floor(t_sum * 1000) / 1000;
            else
                low = 0.8;
                high = 1;
                t_int_ts = ceil(t_sum * 1000) / 1000;
            end
            avg = (low + high) / 2;
            
            while (abs(t_sum - t_int_ts) > 1e-8)
               t = compute_7_time(v_max, v_start, v_end, J * avg ,A, L);
               t_sum = sum(t);
               if t_sum > t_int_ts
                   low = avg;
               else
                   high = avg;
               end     
               avg = (low + high) / 2;
            end
            
            J = avg * J;
            obj.kconstraint(3) = J; 

            %时间取整后的调整速度和距离，最后根据返回系数同比例缩放
            v = zeros(1,7);
            v(1) = v_start;
            v(2) = v_start + 1/2* J *t(1)^2;
            v(3) = v(2) + J * t(1) * t(2);
            v(4) = v(3) + J * t(1) * t(3) - 1/2 * J * t(3)^2;
            v(5) = v(4);
            v(6) = v(5) - 1/2* J *t(5)^2;
            v(7) = v(6) - J *t(5)*t(6); 

            s = zeros(1,7);
            s(2) = v_start * t(1) + 1/6 * J * t(1)^3;
            s(3) = s(2) + v(2) * t(2) + 1/2 * J * t(1) * t(2)^2;
            s(4) = s(3) + v(3) * t(3) + 1/3 * J * t(3)^3;  %这里论文中有错误，在t(2)或者t(4)为零的情况下有问题
            s(5) = s(4) + v(4) * t(4);
            s(6) = s(5) + v(5) * t(5) - 1/6 * J * t(5)^3; %这里论文中有错误，在t(2)或者t(4)为零的情况下有问题
            s(7) = s(6) + v(6) * t(6) - 1/2 * J * t(5) * t(6)^2;
            
            L_error = abs(L - s(7) - v(7) * t(7) + 1/2 * J * t(5) * t(7)^2 - 1/6 * J * t(7)^3);
%             if abs(L_error) > 1e-3
%                 bbb = 1;
%             end

            %获取时间，速度，长度信息    
            T = cumsum(t);
            Tn = round(T(end)*1000);
            obj.time_end = Tn/1000;
            obj.tvs_param = [T;v;s];    
             
            now_s = 0;
            now_u = obj.pre_u;
            u_array = zeros(1,Tn +1);
            u_array(1,1) = now_u;
            for k = 1: Tn
                now_t = k / 1000;
                s = obj.compute_time_to_length(now_t);
                delta_s = s - now_s;
                dsdt_vec = obj.oneMiniPath.calculateCurveVec(now_u);
                dsdtdt_vec = obj.oneMiniPath.calculateCurveAcc(now_u);
%                 if k == 180
%                     jjjj = 1;
%                 end
                dtds = 1/norm(dsdt_vec);
                dtdsds = -dot(dsdt_vec, dsdtdt_vec)/ norm(dsdt_vec)^4;     
                now_u = now_u + dtds * delta_s + 0.5 * dtdsds * delta_s^2;
                if now_u > obj.max_u
                    now_u = obj.max_u;
                end
                now_s = s;
                u_array(1,k+1) = now_u   ;
            end
            k_para = (obj.max_u - obj.pre_u)/ (u_array(1,end) - obj.pre_u);
            
%             if abs(k_para - 1) > 1e-3
%                 bbb = 1;
%             end
            obj.u_intp = k_para * (u_array - u_array(1,1)) + obj.pre_u ;
           
        end
        
        function s_l = compute_time_to_length(obj, t)
            
            T = obj.tvs_param(1,:);
            v = obj.tvs_param(2,:);
            s = obj.tvs_param(3,:);
            J = obj.kconstraint(3);
            if t <= T(1)
                dt = t; 
                s_l = s(1) + v(1) * dt + 1/6 * J * dt^3;  
            elseif t <= T(2)
                dt = t - T(1);
                s_l = s(2) + v(2) * dt + 1/2 * J * T(1) * dt^2;  
            elseif t <= T(3)
                dt = t - T(2);
                s_l = s(3) + v(3) * dt + 1/2 *  J * T(1) * dt^2 - 1/6 *J* dt^3;
            elseif t <= T(4)
              dt = t - T(3);
                s_l = s(4) + v(4) * dt; 
            elseif t <= T(5)
                dt = t - T(4);
                s_l = s(5) + v(5) * dt - 1/6 * J * dt^3;
            elseif t <= T(6)
                dt = t - T(5);
                s_l = s(6) + v(6)* dt - 1/2 * J * (T(5) - T(4)) * dt^2;
            else
                dt = t - T(6);
                s_l = s(7) + v(7) * dt - 1/2 * J * (T(5) - T(4)) * dt ^ 2 + 1/6 *J * dt^3;
            end
        end
        
        function t = compute_7_time(~, v_max, v_start, v_end, J ,A , L)
            TOL = 1e-8;
             %%求出启动距离和刹车距离，如果能够满足，则一切都好说
             t = zeros(1,7);
            if (v_max - v_start) >A^2/J 
                s1 = (v_max  + A^2/J - v_start)*(v_max + v_start)/2/A;
                t(1) = A/J; 
                t(2) = (v_max - v_start)/A - t(1);
                t(3) = t(1);
            else
            %     s1 = sqrt((v_max^3 + v_start * v_max^2 - v_start^2 * v_max - v_start^3)/J);
                s1 = (v_max + v_start)*sqrt((v_max - v_start)/J);
                t(1) = sqrt((v_max - v_start)/J);
                t(2) = 0;
                t(3) = t(1);
            end

            if (v_max - v_end) >A^2/J 
                s3  = (v_max  + A^2/J - v_end)*(v_max + v_end)/2/A;
                t(5) = A/J; 
                t(6) = (v_max - v_end)/A - t(5);
                t(7) = t(5);
            else
            %     s3 = sqrt((v_max^3 + v_end * v_max^2 - v_end^2 * v_max - v_end^3)/J);
                s3 = (v_max + v_end)*sqrt((v_max - v_end)/J);
                t(5) = sqrt((v_max - v_end)/J);
                t(6) = 0;
                t(7) = t(5);
            end

            if s1 + s3 <= L
                %这符合论文的1-9种情形
                s2 = L - s1 - s3;
                t(4) = s2 / v_max;
            else
                t = zeros(1,7);
                %代表达不到最大速度就需要减速，最大速度失效，符合10-17种情形
                if abs(v_end - v_start) <= A^2 /J
                    pow2s = abs(v_end^3 + v_start * v_end^2 - v_start^2 * v_end - v_start^3)/J;
                    s1 = sqrt(pow2s);
                else
                    s1 = (abs(v_end - v_start) +  A^2/J)*(v_end + v_start)/2/A;
                end
                if s1 - L > 1e-8 
                     %情形一  如果直接加速或减速过去还是刹不住车，则输入中的v_end不可信，需要调整v_end
                    return;
                end

                % 这里就只能采用二分法的方式去查取最大速度了
                v1 = v_max;
                v0  = max(v_start , v_end);
                v = v0;
                sa=0;
                sd=0;
                while true
                    if (v-v_start)<=((A^2)/J)
                        sa=(v + v_start)*sqrt((v-v_start)/J);
                    end
                    if (v - v_start)>((A^2)/J)
                        sa=(0.5)*(v + v_start)*((A/J)+(v-v_start)/A);
                    end
                    if (v-v_end)<=((A^2)/J)
                        sd=(v_end+v)*sqrt((v-v_end)/J);
                    end
                    if (v-v_end)>((A^2)/J)
                        sd=(0.5)*(v_end+v)*((A/J)+(v-v_end)/A);
                    end
                    if abs(sa+sd-L)<=TOL
                        v_new_max = v;
                        break
                    end
                    if (sa+sd-L)>TOL
                        v1=v;
                        v=(v0+v)/2;
                    end
                    if (sa+sd-L)<(-TOL)
                        v0=v;
                        v=(v+v1)/2;
                    end
                end

                if v_start<v_new_max && (v_new_max-v_start)<=((A^2)/J)
                    t(1)=sqrt((v_new_max-v_start)/J); 
                    t(2) = 0;
                    t(3)=sqrt((v_new_max-v_start)/J);   
                end
                if v_start<v_new_max && (v_new_max-v_start)>((A^2)/J)
                    t(1)=A/J;
                    t(2)=((v_new_max-v_start)/A)-(A/J);
                    t(3)=A/J;
                end
                if v_new_max>v_end && (v_new_max-v_end)<=((A^2)/J)
                    t(5)=sqrt((v_new_max-v_end)/J);   
                    t(6) = 0;
                    t(7)=sqrt((v_new_max-v_end)/J);    
                end
                if v_new_max>v_end && (v_new_max-v_end)>((A^2)/J)
                    t(5)=A/J;
                    t(6)=((v_new_max-v_end)/A)-(A/J);
                    t(7)=A/J;
                end
            end
        end
    end
end