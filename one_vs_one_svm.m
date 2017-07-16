
function  er = one_vs_one_svm( train_x, train_y, test_x, test_y, c )

%    1��1�ķ���ʵ�ֶ����svm
%    ���ߣ������� 
%    ���ڣ�2017��6��3��

[~, d] = size( train_x );
[test_num, n] = size( test_y );
weight = zeros( d, n-1, n );
bias = zeros( 1, n-1, n );
yy =  zeros( test_num, n-1, n );

%% ����n*(n-1)/2��svm������
for i = 1 : n-1
    for j = i+1 : n        
        [idx1,~] = find(train_y(:, i) == 1);
        [idx2,~] = find(train_y(:, j) == 1);
        
        train_x1 = [train_x(idx1,:); train_x(idx2,:)] ;         
        [n1,~] = size(idx1);
        [n2,~] = size(idx2);
        train_y1 = ones(n1+n2,1);
        train_y1(n1+1 : n1+n2) = -1;
        
        [weight(:,i,j), bias(1,i,j), ~] = trainSVM( train_x1, train_y1, c );
        yy(:,i,j) = test_x * weight(:,i,j) + bias(1,i,j);
    end
end

%% �����˶��svm�������󣬽���ͶƱ
vote = zeros(test_num, n);
for i = 1 : n-1
    for j = i+1 : n  
        for k = 1:test_num            
            if yy(k,i,j) >= 0
               vote(k,i) = vote(k,i)+1;
            else
               vote(k,j) = vote(k,j)+1;
            end            
        end        
    end
end
%% ѵ��������
[~ , C1] = max(vote');
[~ , C2] = max(test_y');
err_num = sum(C1-C2 ~= 0);
er = err_num / test_num;








