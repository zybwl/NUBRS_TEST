function newxyd = findnextpoint( imdata, xyd)
   
    xindex = xyd(1);
    yindex = xyd(2);
    direction = xyd(3);
    
    isfindflag = false;
    i = xindex;
    j = yindex;
    switch direction
        
        case 1
            while ~isfindflag
                i = i - 1;
                sum_squa = imdata(i - 1,j-1) + imdata(i-1,j) + imdata(i,j-1) + imdata(i,j) ;
                sum_squa1 = imdata(i - 1,j-1) + imdata(i,j);
                sum_squa2 = imdata(i-1,j)  + imdata(i,j-1);
                if sum_squa == 1 
                    if imdata(i,j) 
                        newxyd = [i,j,4, 1];
                        isfindflag = true;
                    elseif imdata(i,j-1) 
                        newxyd = [i,j,3 , 1];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end
                elseif sum_squa == 3 
                    if ~imdata(i,j-1) 
                        newxyd = [i,j,3, 2];
                        isfindflag = true;
                    elseif ~imdata(i,j) 
                        newxyd = [i,j,4, 2];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end         
                elseif sum_squa1 == 2 
                        newxyd = [i,j,3, 2];
                        isfindflag = true;
                elseif sum_squa2 == 2
                         newxyd = [i,j,4, 2];
                        isfindflag = true;
                else
                    % do notiong
                end
            end
        case 2
            while ~isfindflag
                i = i + 1;
                sum_squa = imdata(i - 1,j-1) + imdata(i-1,j) + imdata(i,j-1) + imdata(i,j) ;
                sum_squa1 = imdata(i - 1,j-1) + imdata(i,j);
                sum_squa2 = imdata(i-1,j)  + imdata(i,j-1);
                if sum_squa == 1 
                    if imdata(i-1,j) 
                        newxyd = [i,j,4 , 1];
                        isfindflag = true;
                    elseif imdata(i-1,j-1) 
                        newxyd = [i,j,3 , 1];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end
                elseif sum_squa == 3 
                    if ~imdata(i-1,j-1) 
                        newxyd = [i,j,3, 2];
                        isfindflag = true;
                    elseif ~imdata(i-1,j) 
                        newxyd = [i,j,4, 2];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end         
                elseif sum_squa1 == 2 
                        newxyd = [i,j,4, 2];
                        isfindflag = true;
                elseif sum_squa2 == 2
                         newxyd = [i,j,3, 2];
                        isfindflag = true;
                else
                    % do notiong
                end
            end
        case 3
            while ~isfindflag
                j = j - 1;
                sum_squa = imdata(i - 1,j-1) + imdata(i-1,j) + imdata(i,j-1) + imdata(i,j) ;
                sum_squa1 = imdata(i - 1,j-1) + imdata(i,j);
                sum_squa2 = imdata(i-1,j)  + imdata(i,j-1);
                if sum_squa == 1 
                    if imdata(i-1,j) 
                        newxyd = [i,j,1, 1];
                        isfindflag = true;
                    elseif imdata(i,j) 
                        newxyd = [i,j,2, 1];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end
                elseif sum_squa == 3 
                    if ~imdata(i,j) 
                        newxyd = [i,j,2,2];
                        isfindflag = true;
                    elseif ~imdata(i-1,j) 
                        newxyd = [i,j,1,2];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end         
                elseif sum_squa1 == 2 
                        newxyd = [i,j,1,2];
                        isfindflag = true;
                elseif sum_squa2 == 2
                         newxyd = [i,j,2,2];
                        isfindflag = true;
                else
                    % do notiong
                end
            end
        case 4
            while ~isfindflag
                j = j + 1;
                sum_squa = imdata(i - 1,j-1) + imdata(i-1,j) + imdata(i,j-1) + imdata(i,j) ;
                sum_squa1 = imdata(i - 1,j-1) + imdata(i,j);
                sum_squa2 = imdata(i-1,j)  + imdata(i,j-1);
                if sum_squa == 1 
                    if imdata(i,j-1) 
                        newxyd = [i,j,2,1];
                        isfindflag = true;
                    elseif imdata(i-1,j-1) 
                        newxyd = [i,j,1,1];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end
                elseif sum_squa == 3 
                    if ~imdata(i,j-1) 
                        newxyd = [i,j,2,2];
                        isfindflag = true;
                    elseif ~imdata(i-1,j-1) 
                        newxyd = [i,j,1,2];
                        isfindflag = true;
                    else
                        newxyd = [0,0,0];
                        return;
                    end         
                elseif sum_squa1 == 2 
                        newxyd = [i,j,2,2];
                        isfindflag = true;
                elseif sum_squa2 == 2
                         newxyd = [i,j,1,2];
                        isfindflag = true;
                else
                    % do notiong
                end
            end
    end
end