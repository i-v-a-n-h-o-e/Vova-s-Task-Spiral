%
% ����-������� ��� �������������� �������������� ��������� Ro,Phi,Z  � ���������
% ������������� x,y,z
% [x,y,z] = cilnder2dec(Ro,Phi,Z)
%

function [x, y, z] = cilinder2decart(Ro,Phi,Z)
    x = Ro .* cos(Phi);
    y = Ro .* sin(Phi);
    z = Z;
end
