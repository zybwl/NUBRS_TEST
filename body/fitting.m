function  [kv, controls_points] = fitting(points, num_cpts)

num_dpts = size(points,1);

%参考书中的9.5-9.6式，use_centripetal代表是用弦长参数法，还是向心参数法计算节点矢量
use_centripetal = false;
uk = compute_params_curve(points, use_centripetal);

%例如有51个数据，我们用30个数据拟合控制点
degree = 4;
%num_cpts = 100;
kv = compute_knot_vector2(degree, num_dpts, num_cpts, uk);

%Compute matrix N
n0p = zeros(1,num_dpts - 2);
nnp = zeros(1,num_dpts - 2);
matrix_n = [];
for i = 2 : num_dpts - 1   
    m_temp = zeros(1, num_cpts - 2);
    span = findspan(num_cpts -1 , degree , uk(i) ,kv ); 
    N  = basisfun( span , uk(i) ,degree ,kv );
    for j = span - degree: span
        if j == 0
            n0p(i - 1) = N(1);
        elseif j == num_cpts - 1
            nnp(i - 1) = N(end);
        else
            m_temp(j) = N(j - span + degree + 1);       
        end                 
    end
    matrix_n = [matrix_n ; m_temp];   
end

% Compute NT
matrix_nt = matrix_n';
% Compute NTN matrix
matrix_ntn = matrix_nt * matrix_n;
% LU-factorization
[matrix_l, matrix_u ] = lu_decomposition(matrix_ntn);

pt0 = points(1,:);
ptm = points(end,:);
[m,n] = size(points);
rk = zeros(m - 2 ,n);
for i = 2: (num_dpts - 1)
    ptk = points(i,:);   
    ptk = ptk - n0p(i - 1) * pt0 - nnp(i -1) * ptm;
    rk(i - 1,:) = ptk;
end

vector_r = matrix_nt * rk;

controls_points = zeros(num_cpts , n);
controls_points(1,:) = pt0 ;
controls_points(end,:) = ptm ;
for i = 1:n
    b = vector_r(:,i);
    y = forward_substitution(matrix_l, b);
    x = backward_substitution(matrix_u, y);
    controls_points(2:(num_cpts-1) ,i) = x;
end
%plot3(controls_points(:,1), controls_points(:,2),controls_points(:,3),'.r');
% hold on

%找出最大误差点的位置，并标记出来
% error = matrix_n * controls_points(2:end - 1,:) - rk ;
% error_l = sqrt(error(:,1).^2 + error(:,2).^2 + error(:,3).^2);
% max(error_l)


