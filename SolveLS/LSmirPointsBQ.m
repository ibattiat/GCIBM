function [landa,landa_g_1,landa_g_2,landa_g_3,landa_g_4,A1_g,I_e,J_e,...
    I1,J1,I2,J2,I3,J3,I4,J4,numg,landa_g_5,landa_g_6,I5,J5,I6,J6,nx_g,ny_g] = ...
    LSmirPointsBQ(x,y,alpha,beta,q,X_g,Y_g,BQ,dx,dy,I_g,J_g,LS)

psi = LS.psi;
nx = LS.nx;
ny = LS.ny;

numg = size(X_g,2);
[X_e_g,Y_e_g,landa_g_1,landa_g_2,landa_g_3,landa_g_4,landa_g_5,...
landa_g_6,A1_g,nx_g,ny_g,...
    I_e,J_e,I0,J0,I1,J1,I2,J2,I3,J3,I4,J4,I5,J5,I6,J6,fI6,fJ6,sI6,sJ6]=...
    deal(zeros(1,numg));

landanu=4+2*BQ;

landa = zeros(numg,landanu);

for i=1:numg
        Delta=sqrt(2)*dx;
%         Delta =  round(abs (psi(I_g(i),J_g(i)))*1e5)/1e5;
%         Delta =  abs (psi(I_g(i),J_g(i)));
        
%         if abs(Delta)<1e-8
%             Delta = dx/2;
%         end
        
                
%         nx_g(i) = (psi(I_g(i)+1,J_g(i))-psi(I_g(i)-1,J_g(i)))/(2*dx);
%         ny_g(i) = (psi(I_g(i),J_g(i)+1)-psi(I_g(i),J_g(i)-1))/(2*dy);
%         
%         grad = sqrt(nx_g(i)^2 + ny_g(i)^2);
        
%         nx_g(i) = nx_g(i)/grad;
%         ny_g(i) = ny_g(i)/grad;
        nx_g(i) = nx(I_g(i),J_g(i));
        ny_g(i) = ny(I_g(i),J_g(i));       


        

        %% find Virtual Points
        X_ib_g = X_g(i) + nx_g(i)* Delta;
        X_e_g(i) = X_ib_g + nx_g(i)*Delta;
        
        
        Y_ib_g = Y_g(i) + ny_g(i)* Delta;
        Y_e_g(i) = Y_ib_g + ny_g(i)*Delta;
        
        I=find(x<X_e_g(i));
        J=find(y<Y_e_g(i));

        
        I=I(end);
        J=J(end);



        if BQ == 1 
            if nx_g(i)>0
                I0(i)=I;
                I1(i)=I0(i)+1;
                I2(i)=I0(i)+2;
                I5(i)=I0(i)+1;
                fI6(i)=I0(i)+1;
                sI6(i)=I0(i)+2;
            else
                I0(i)=I+1;
                I1(i)=I0(i)-1;
                I2(i)=I0(i)-2;
                I5(i)=I0(i)-1;
                fI6(i)=I0(i)-1;
                sI6(i)=I0(i)-2;
            end
            I3(i)=I0(i);
            I4(i)=I0(i);
        
            if ny_g(i)>0
                J0(i)=J;
                J3(i)=J0(i)+1;
                J4(i)=J0(i)+2;
                J5(i)=J0(i)+1;
                fJ6(i)=J0(i)+2;
                sJ6(i)=J0(i)+1;
            else
                J0(i)=J+1;
                J3(i)=J0(i)-1;
                J4(i)=J0(i)-2;
                J5(i)=J0(i)-1;
                fJ6(i)=J0(i)-2;
                sJ6(i)=J0(i)-1;
            end
            J1(i)=J0(i);
            J2(i)=J0(i);
        
            df=sqrt( (X_e_g(i)-x(fI6(i)))^2 + (Y_e_g(i)-y(fJ6(i)))^2 );
            ds=sqrt( (X_e_g(i)-x(sI6(i)))^2 + (Y_e_g(i)-y(sJ6(i)))^2 );
        
            if df<ds
                I6(i)=fI6(i);
                J6(i)=fJ6(i);
            else
                I6(i)=sI6(i);
                J6(i)=sJ6(i);
            end
            
            x_m = X_e_g(i)-x(I0(i));
            y_m = Y_e_g(i)-y(J0(i));
            
        elseif BQ == 0
                I1(i)=I;
                I2(i)=I1(i)+1;
                I4(i)=I1(i)+1;
                I3(i)=I1(i);
        
            
                J1(i)=J;
                J3(i)=J1(i)+1;
                J4(i)=J1(i)+1;
                J2(i)=J1(i);
            
                
                x_m = X_e_g(i)-x(I1(i));
                y_m = Y_e_g(i)-y(J1(i));
         
        end
        
        
        
        r_g = abs (psi(I_g(i),J_g(i)));
        
       %%%%%%% so far we have found x1-x6

        d = Delta;
        B = (2*alpha+2*beta*r_g+beta*d^(-1)*r_g^2)/(2*alpha-beta*d);
        E = (-alpha*Delta-beta*d*r_g+(alpha/d-beta)*r_g^2)/(2*alpha-beta*d);
        
        if BQ == 1
            
        
            x1=x(I1(i))-x(I0(i));
            y1=y(J1(i))-y(J0(i));
        
            x2=x(I2(i))-x(I0(i));
            y2=y(J2(i))-y(J0(i));
        
            x3=x(I3(i))-x(I0(i));
            y3=y(J3(i))-y(J0(i));
        
            x4=x(I4(i))-x(I0(i));
            y4=y(J4(i))-y(J0(i));
        
            x5=x(I5(i))-x(I0(i));
            y5=y(J5(i))-y(J0(i));
        
            x6=x(I6(i))-x(I0(i));
            y6=y(J6(i))-y(J0(i));
        
            A = [ 1 x1 y1 x1*y1 x1^2 y1^2; 1 x2 y2 x2*y2 x2^2 y2^2;...
              1 x3 y3 x3*y3 x3^2 y3^2; 1 x4 y4 x4*y4 x4^2 y4^2;...
              1 x5 y5 x5*y5 x5^2 y5^2; 1 x6 y6 x6*y6 x6^2 y6^2];
%         A1=A;  
            A = A^(-1);
        
        
        
            b = A(1,:) + A(2,:)*x_m + A(3,:)*y_m + A(4,:)*x_m*y_m + ...
                A(5,:)*x_m^2 + A(6,:)*y_m^2;
        
            e = nx_g(i) * ( A(2,:)+A(4,:)*y_m+2*A(5,:)*x_m ) + ...
                ny_g(i) * ( A(3,:)+A(4,:)*x_m+2*A(6,:)*y_m );
        
        
            A1_g(i) = 4*Delta*q/(-beta*Delta+2*alpha);
            
            landa(i,:) = B*b+E*e;
        
            landa_g_1(i) = landa(i,1);
            landa_g_2(i) = landa(i,2);
            landa_g_3(i) = landa(i,3);
            landa_g_4(i) = landa(i,4);
            landa_g_5(i) = landa(i,5);
            landa_g_6(i) = landa(i,6);
            
        elseif BQ == 0
            
            x1=x(I1(i))-x(I1(i));
            y1=y(J1(i))-y(J1(i));
            
            x2=x(I2(i))-x(I1(i));
            y2=y(J2(i))-y(J1(i));
                        
            x3=x(I3(i))-x(I1(i));
            y3=y(J3(i))-y(J1(i));
                   
            x4=x(I4(i))-x(I1(i));
            y4=y(J4(i))-y(J1(i));
        
            
        
            A = [ 1 x1 y1 x1*y1; 1 x2 y2 x2*y2;...
              1 x3 y3 x3*y3; 1 x4 y4 x4*y4];
%         A1=A;  
            A = A^(-1);
            
            
            b = A(1,:) + A(2,:)*x_m + A(3,:)*y_m + A(4,:)*x_m*y_m ;
        
            e = nx_g(i) * ( A(2,:)+A(4,:)*y_m ) + ...
                ny_g(i) * ( A(3,:)+A(4,:)*x_m );
        
            

%             A1_g(i) = 4*Delta*q/(-beta*Delta+2*alpha);
            A1_g(i) = q*(d+2*r_g+d^(-1)*r_g^2)/(2*alpha-beta*d);
            landa(i,:) = B*b+E*e;
        
            landa_g_1(i) = landa(i,1);
            landa_g_2(i) = landa(i,2);
            landa_g_3(i) = landa(i,3);
            landa_g_4(i) = landa(i,4);
            
            
            
        end
   
        I_e(i)=I;
        J_e(i)=J;
end


