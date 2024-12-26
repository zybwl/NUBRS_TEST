function t = compute_7_time(v_max, v_start, v_end, J ,A , L)
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
        if s1 > L 
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