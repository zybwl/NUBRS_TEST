
function scell = getIgsFileCells(file_name)

fid= fopen(file_name);

fgetl(fid);
line_number = 1;
expr1 = '126,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,';
expr2 = 'S[0-9]*G[0-9]*D[0-9]*P[0-9]*';
expr3 = '-?[0-9]*.[0-9]*D-?[0-9]*,';
cpts_num = 0;
s = '';
% scell = cell(1,10);
scell = {};
slen = 0;

get_data_start_flag = 0;
while ~feof(fid)
    tline = fgetl(fid);
    search_head = regexp(tline,expr1,'match');  
    search_end = regexp(tline,expr2,'match');
    
    if ~isempty(search_head) || ~isempty(search_end)
        if length(s) > 10
            slen = slen + 1;
            scell{slen}.s = s;
            scell{slen}.cpts_num = cpts_num + 1;
            scell{slen}.p = p; 
        end
        if ~isempty(search_end)
            break;
        end
        s = tline;
        head_data = strsplit(search_head{1},',');
        cpts_num = str2double(head_data{2});
        p = str2double(head_data{3});
        get_data_start_flag = 1;
        continue;
    end
    
    if get_data_start_flag
        s =  sprintf('%s %s', s, tline); 
    end
    
    line_number = line_number + 1;
end

% 最后总个数  
% 控制点个数  cpts_num * 3
% knot点个数  cpts_num + p + 1
% w个数       cpts_num
% vectorxd = zeros(1, 5 * cpts_num + p + 1);

if slen > 0
    for i = 1:slen
        search_data = regexp( scell{i}.s ,expr3 ,'match');
        data_num = length(search_data) - 5;
        cpts_num  = scell{i}.cpts_num ;
        p = scell{i}.p ;
        cpts = zeros(cpts_num,3);
        w = zeros(1, cpts_num);
        knot = zeros(1,cpts_num + p + 1);
        for j = 1:data_num
            one_result = search_data{j};         
            x12 = strsplit(one_result,'D');
            x1 = str2double(x12{1});
            x2 = str2double(x12{2}(1,1:end-1));
            if x2 == 0
                one_double = x1;
            else
                one_double = x1 * 10^(x2);
            end
                 
            if j <= cpts_num + p + 1
                knot(1,j) = one_double;
            elseif j <= 2*cpts_num + p + 1
                w(1, j - cpts_num - p - 1) = one_double;
            else
                index = j - (2*cpts_num + p + 1);
                row = ceil(index / 3);
                col = index - row* 3 + 3;
                cpts(row, col) = one_double;
            end
        end
        scell{i}.w = w;
        scell{i}.kv = knot;
        scell{i}.cpts = cpts;
    end  
end
fclose(fid);

