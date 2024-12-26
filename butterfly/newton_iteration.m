%�����㷨����Ҫ������ȡ3�η��̵ĸ�
function v_e =  newton_iteration(Ja ,Acc, v_s, L, TOL)

    v_next = v_s + TOL/5;
    F= v_next^3+ v_s * v_next^2- v_s^2 * v_next - v_s^3 - Ja* L^2;
    dF=3 * v_next^2+ 2*v_s* v_next -v_s^2;
    while true
        %�ؾ�
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
    
    %���v_e�����˽��ޣ�������
    if v_e > (Acc^2/Ja + v_s)
        a = Ja;
        b = Acc^2;
        c = Acc^2 * v_s - Ja * v_s^2 - 2 * Acc * Ja * L;
        delta = sqrt(b^2 - 4 * a * c);
        v_e = (-b + delta)/2.0/a;
    end
