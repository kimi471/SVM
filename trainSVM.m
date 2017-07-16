
function [ weight, bias, SV  ] = trainSVM( x, y, c )
%    ����������SVM�㷨
%    ���ߣ������� 
%    ���ڣ�2017��6��3��

H = (x*x').*sparse(y*y');
f = -ones(size(y'));
Aeq = y';
beq = 0;
lb = zeros(size(y'));
ub = c*ones(size(y'));
alpha = quadprog(H,f,[],[],Aeq,beq,lb,ub);
weight = x'*(alpha.*y);   %���Ȩֵ

alpha = roundn(alpha,-4);           %��alphaȡ4λ��Ч���� 
SV = find((alpha~=0) & (alpha~=c)); %�ҵ�֧������
bias = y(SV) - x(SV,:)*weight;
bias = mean(bias);  %��֧���������ƫ�ã����ȡƽ��ֵ
end

