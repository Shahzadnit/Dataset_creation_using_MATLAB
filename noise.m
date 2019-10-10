function [b] = noise(I, m , var)

[r c ch]=size(I);

b=zeros(r,c,ch);
J1= I(:,:,1);
J2= I(:,:,2);
J3= I(:,:,3);
      p3= m;
      p4 = var;
      J1= im2double(J1);
      J2= im2double(J2);
      J3= im2double(J3);
      b1 = J1 + sqrt(p4)*randn(size(J1)) + p3;
      b2 = J2 + sqrt(p4)*randn(size(J2)) + p3;
      b3 = J3 + sqrt(p4)*randn(size(J3)) + p3;
      b(:,:,1)=b1;
      b(:,:,2)=b2;
      b(:,:,3)=b3;
      b=uint8(b*255);

end

