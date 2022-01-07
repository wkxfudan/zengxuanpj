% 手工建立的差分放大器的电路方程

function F = Famp(X,Vin)
    Id1=0.012075*(1.65-X(3)-0.7)*(1.65-X(3)-0.7)*(1+0.1*(X(1)-X(3)));
    Id2=0.012075*(Vin-X(3)-0.7)*(Vin-X(3)-0.7)*(1+0.1*(X(2)-X(3)));
    F = [Id1+(X(1)-3.3)/80000;Id2+(X(2)-3.3)/80000;-Id1-Id2+20*(1e-6)];
    
end    
    