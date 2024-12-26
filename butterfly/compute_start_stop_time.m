%�����ܹ�֧��1����-ƽ-�����̵Ļ��������
function [t_sum , s_param, s_delta_error] = compute_start_stop_time(A , J , v_start,  v_max ,  v_end , L)

    TOL = 1e-4;
    interpolation_cycle = 0.001;
    t = zeros(1,7);
    if v_max < v_start || v_max < v_end
        return;
    end

    %%������������ɲ�����룬����ܹ����㣬��һ�ж���˵
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
        %��������ĵ�1-9������
        s2 = L - s1 - s3;
        t(4) = s2 / v_max;
    else
        %����ﲻ������ٶȾ���Ҫ���٣�����ٶ�ʧЧ������10-17������
        if abs(v_end - v_start) <= A^2 /J
            pow2s = abs(v_end^3 + v_start * v_end^2 - v_start^2 * v_end - v_start^3)/J;
            s1 = sqrt(pow2s);
        else
            s1 = (abs(v_end - v_start) +  A^2/J)*(v_end + v_start)/2/A;
        end
        if s1 > L 
             %����һ  ���ֱ�Ӽ��ٻ���ٹ�ȥ����ɲ��ס�����������е�v_end�����ţ���Ҫ����v_end
            return;
        end

        % �����ֻ�ܲ��ö��ַ��ķ�ʽȥ��ȡ����ٶ���
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
    
    %ʱ��ȡ����ĵ����ٶȺ;��룬�����ݷ���ϵ��ͬ��������
    
    t_num = round(t/interpolation_cycle);
    t = t_num * interpolation_cycle;
    new_J = J;
%     new_J = compute_new_J(J , v_start,  t , L);
    
    v1 = v_start + 1/2* new_J *t(1)^2;
    v2 = v1 + new_J * t(1) * t(2);
    v3 = v2 + new_J * t(1) * t(3) - 1/2 * new_J * t(3)^2;
    v4 = v3;
    v5 = v4 - 1/2* new_J *t(5)^2;
    v6 = v5 - new_J *t(5)*t(6);
    v7 = v6 - new_J * t(5) * t(7) + 1/2 * new_J * t(7)^2;   
    
    sa1 = v_start * t(1) + 1/6 * new_J * t(1)^3;
    sa2 = sa1 + v1 * t(2) + 1/2 * new_J * t(1) * t(2)^2;
    sa3 = sa2 + v2 * t(3) + 1/3 * new_J * t(3)^3;  %�����������д�����t(2)����t(4)Ϊ��������������
    ss4 = sa3 + v4 * t(4);
    sd5 = ss4 + v4 * t(5) - 1/6 * new_J * t(5)^3; %�����������д�����t(2)����t(4)Ϊ��������������
    sd6 = sd5 + v5 * t(6) - 1/2 * new_J * t(5) * t(6)^2;
    sd7 = sd6 + v6 * t(7) - 1/2 * new_J * t(5) * t(7) ^ 2 + 1/6 * new_J * t(7)^3;
     
    s_error = sd7 - L;
    na1 = t_num(1);
    na2 = t_num(2);
    nd1 = t_num(5);
    nd2 = t_num(6);
    n_a = na1^2 + na1 * na2 + nd1^2 + nd1*nd2 + na1 + nd1;
    s_delta_error = s_error / n_a;
    
    compensation_n(1) = na1* ( na1 + 1)/2;
    compensation_n(2) = compensation_n(1) + na1 * na2;
    compensation_n(3) = compensation_n(2) + compensation_n(1);
    compensation_n(4) = compensation_n(3);
    compensation_n(5) = compensation_n(4) + nd1 * (nd1 + 1)/2;
    compensation_n(6) = compensation_n(5) + nd1 * nd2;
    compensation_n(7) = compensation_n(6) + nd1 * (nd1 + 1)/2;
   
    %��ȡʱ�䣬�ٶȣ�������Ϣ    
    t = cumsum(t);
    v = [v1,v2,v3,v4,v5,v6,v7];
    s = [sa1,sa2,sa3,ss4,sd5,sd6,sd7];
    s_param = [t;v;s;compensation_n];
    t_sum = t(end);      
end    


%     if v_start == v_end
%         s_min = 2*(A^3 + 2*v_start * J * A)/J^2;
%         if L > s_min
%             %��Ӧ�������еĵ�14�����,����ֹͣ���ְ��·�����������ٶȾ������ʱ��
%             new_vmax = rich_length_to_ve(A , J , v_start, L/2);
%             t(1) = A/J; 
%             t(2) = (new_vmax - v_start)/A - t(1);
%             t(3) = t(1);
%             t(4) = 0;
%             t(5) = A/J; 
%             t(6) = (new_vmax - v_start)/A - t(1);
%             t(7) = t(1);
%         else
%             %��Ӧ�������еĵ�17�����,����ֹͣ���ְ��·�����������ٶȾ������ʱ��
%             new_vmax = poor_length_to_ve(J , v_start, L/2);
%             t(1) = sqrt((new_vmax - v_start)/J); 
%             t(2) =  0;
%             t(3) = t(1);
%             t(4) = 0;
%             t(5) = sqrt((new_vmax - v_start)/J); 
%             t(2) =  0;
%             t(7) = t(1); 
%         end 
%     elseif v_start < v_end
%         s_min = (A^3 + 2*v_start * J * A)/J^2;
%         if L <= s_min
%             %��Ӧ�������еĵ�10�������֧�ֲ���1��ȫ����
%             new_vmax = poor_length_to_ve(J , v_start, L);
%             t(1) = sqrt((new_vmax - v_start)/J); 
%             t(2) =  0;
%             t(3) = t(1);
%             t(4) = 0;
%             t(5) = 0; 
%             t(2) =  0;
%             t(7) = 0;
%         else
%             
%             
%         end
%         
%         
%     else
%         s_min = (A^3 + 2*v_end * J * A)/J^2;
%         
%     end

% T = cumsum(t);
% judge_start_value = v_max - v_start - A^2/J;
% judge_end_value = v_max - v_end - A^2/J;
% judge_equal_value1 = v_max - v_start;
% judge_equal_value2 = v_max - v_end;
% 
% if abs(judge_start_value) < 1e-4     judge_start_value = 0;  end;
% if abs(judge_end_value) < 1e-4     judge_start_value = 0;  end;
% if abs(judge_equal_value1) < 1e-4     judge_start_value = 0;  end;
% if abs(judge_equal_value2) < 1e-4     judge_start_value = 0;  end;
%     
% if v_start > v_end
%     l4_long = (v_end  + A^2/J - v_start)*(v_end + v_start)/2/A;
%     l4_short = sqrt((v_end^3 + v_start * v_end^2 - v_start^2 * v_end - v_start^3)/J);
%     judge_start_value1 = v_start - v_end - A^2/J;
%     judge_end_valu1e1 = v_start - v_end - A^2/J;
% elseif v_start < v_end
%     l4_long = (v_end  + A^2/J - v_start)*(v_end + v_start)/2/A;
%     l4_short = sqrt((v_end^3 + v_start * v_end^2 - v_start^2 * v_end - v_start^3)/J);
%     judge_start_value1 = v_end - v_start - A^2/J;
%     judge_end_valu1e1 = v_end - v_start - A^2/J;
% end

    


    






    