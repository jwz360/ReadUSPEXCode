function output = latConverter(input)
if size(input,1) ==3
output = zeros(6,1);
output(1,1) = sqrt(sum(input(1,:).^2)); 
output(2,1) = sqrt(sum(input(2,:).^2)); 
output(3,1) = sqrt(sum(input(3,:).^2)); 
output(6,1) = acos(sum(input(1,:).*input(2,:))/(output(1,1)*output(2,1)));
output(5,1) = acos(sum(input(1,:).*input(3,:))/(output(1,1)*output(3,1)));
output(4,1) = acos(sum(input(2,:).*input(3,:))/(output(2,1)*output(3,1)));
else
output = zeros(3);
output(1,1) = input(1);
output(2,1) = input(2)*cos(input(6));
output(2,2) = input(2)*sin(input(6));
output(3,1) = input(3)*cos(input(5));
output(3,2) = input(3)*cos(input(4))*sin(input(6))-((input(3)*cos(input(5))-input(3)*cos(input(4))*cos(input(6)))/tan(input(6)));
output(3,3) = sqrt(input(3)^2 -output(3,1)^2 - output(3,2)^2);
end
if ~isreal(output)
du =1;
end
