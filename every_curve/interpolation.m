
classdef interpolation
    properties
        serveral_traj;
        traj_num ;
        tsum = 0;
        ts;
        now_time = 0;
        trajectry_run_num = 1;
        now_point;
        finish_flag
    end
    
    methods
        function obj = interpolation(ts)
            obj.traj_num = 0;
            obj.serveral_traj = cell(1,1000);
            obj.ts = ts;
            obj.now_time = -ts;
        end
        function obj = addTraj(obj, one_traj)
            obj.traj_num = obj.traj_num + 1;
            obj.serveral_traj{1, obj.traj_num} = one_traj;
        end
        
        function flag = isFinished(obj)
            flag = obj.finish_flag ;
        end
        
        function obj = run(obj)
            obj.now_time = obj.now_time + obj.ts;
            run_flag = 0;
            while( ~run_flag )
                run_flag =  obj.now_time >= (obj.serveral_traj{1, obj.trajectry_run_num}.time_begin - 1e-4) && ...
                            obj.now_time < (obj.serveral_traj{1, obj.trajectry_run_num}.time_end - 1e-4) && ...
                            obj.trajectry_run_num <= obj.traj_num;
                if (~run_flag)
                    obj.now_point = obj.serveral_traj{1, obj.trajectry_run_num}.next_point;
                    obj.trajectry_run_num = obj.trajectry_run_num + 1;
%                     obj.serveral_traj{1, obj.trajectry_run_num}.pre_u = obj.serveral_traj{1, obj.trajectry_run_num - 1}.pre_u;
%                     obj.serveral_traj{1, obj.trajectry_run_num}.pre_s = obj.serveral_traj{1, obj.trajectry_run_num - 1}.pre_s - obj.serveral_traj{1, obj.trajectry_run_num - 1}.path_length;
%                     kk = obj.trajectry_run_num
                end
                if obj.trajectry_run_num > obj.traj_num
                    obj.finish_flag = 1;
                    return;
                end
            end
            
            obj.serveral_traj{1, obj.trajectry_run_num} = obj.serveral_traj{1, obj.trajectry_run_num}.interpolation();
            obj.now_point = obj.serveral_traj{1, obj.trajectry_run_num}.now_point;
          
        end
        
        function obj = plan(obj)
            obj = obj.bidirection_scanning();
            for i= 1 : obj.traj_num
                planned_traj_number = i
                obj.serveral_traj{1, i} = obj.serveral_traj{1, i}.plan();
                if i ~= 1
                    obj.serveral_traj{1, i}.time_begin = obj.serveral_traj{1, i}.time_begin + obj.serveral_traj{1, i - 1}.time_end;
                    obj.serveral_traj{1, i}.time_end = obj.serveral_traj{1, i}.time_begin + obj.serveral_traj{1, i}.time_end; 
                end
                obj.serveral_traj{1, i}.interpolation_time_begin = round(obj.serveral_traj{1, i}.time_begin / obj.ts) * obj.ts;
                obj.serveral_traj{1, i}.interpolation_time_end = round(obj.serveral_traj{1, i}.time_end/ obj.ts) * obj.ts;
            end
            obj.serveral_traj = obj.serveral_traj(1, 1:obj.traj_num);
            obj.tsum = obj.serveral_traj{1,end}.time_end ;
        end
        
        function obj = bidirection_scanning(obj)
            
            first_traj = obj.serveral_traj{1, 1};
            vm = first_traj.kconstraint(1);
            am = first_traj.kconstraint(2);
            jm  = first_traj.kconstraint(3);
            ce  = first_traj.ce;
            % backward_scanning
            for i= obj.traj_num :-1: 2  
                now_traj = obj.serveral_traj{1, i};
                next_traj = obj.serveral_traj{1, i - 1};
                vs = now_traj.getVe();
                tl   = now_traj.getLength();
                v1 = obj.newton_iteration(jm ,am, vs, tl, ce); 
                v2 = vm;
                v3 = next_traj.getVe(); 
                v4 = now_traj.getVs();
                new_v = min([v1 v2 v3 v4]);
                obj.serveral_traj{1, i} = obj.serveral_traj{1, i }.setVs(new_v);
                obj.serveral_traj{1, i - 1} = obj.serveral_traj{1, i - 1}.setVe(new_v);
            end

            % forward_scanning
            for i=1: obj.traj_num -1 
                now_traj = obj.serveral_traj{1, i};
                next_traj = obj.serveral_traj{1, i + 1};
                vs = now_traj.getVs();
                tl = now_traj.getLength();
                v1 = obj.newton_iteration(jm ,am, vs, tl, ce); 
                v2 = vm;
                v3 = next_traj.getVs();
                v4 = now_traj.getVe();
                new_v = min([v1 v2 v3 v4]);
                obj.serveral_traj{1, i} = obj.serveral_traj{1, i}.setVe(new_v);
                obj.serveral_traj{1, i + 1} = obj.serveral_traj{1, i + 1}.setVs(new_v);
            end
        end
        
        function v_e =  newton_iteration(~, Ja ,Acc, v_s, L, TOL)

            v_next = v_s + TOL/5;
            F= v_next^3+ v_s * v_next^2- v_s^2 * v_next - v_s^3 - Ja* L^2;
            dF=3 * v_next^2+ 2*v_s* v_next -v_s^2;
            while true
                %截距
                intercpt = F/dF;
                if abs(intercpt)<TOL
                    v_e = v_next - intercpt;
                    break
                else
                    v_next = v_next - intercpt;
                    F= v_next^3+ v_s * v_next^2- v_s^2 * v_next - v_s^3-Ja* L^2;
                    dF=3 * v_next^2+ 2*v_s* v_next -v_s^2;
                end
            end

            %如果v_e超出了界限，重新求
            if v_e > (Acc^2/Ja + v_s)
                a = Ja;
                b = Acc^2;
                c = Acc^2 * v_s - Ja * v_s^2 - 2 * Acc * Ja * L;
                delta = sqrt(b^2 - 4 * a * c);
                v_e = (-b + delta)/2.0/a;
            end
        end
    end
end