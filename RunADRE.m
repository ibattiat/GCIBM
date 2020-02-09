clc
clear all
close all
% profile on

addpath(genpath('../'));

[StateVar,VARIABLES,DOMAIN,BC,IBM,LS] = setUpVariablesNonDim;

%% ==============================
% load 'initial at any time '


%% object location and IBM coefficients
% [IBM_coeffU,IBM_coeffV,IBM_coeffP]=IBMcoeffs(IBM,DOMAIN);

Flux = getDiffFlux(VARIABLES, DOMAIN,BC);

ControlVar = setUpControlVar(VARIABLES, DOMAIN);


%% Level set at time t = dt

[IBM_coeffU,IBM_coeffV,IBM_coeffP] = LSIBMcoeffs(IBM,DOMAIN,LS);

r= 0.5;
ang=0:0.01:2*pi;
xcir=r*cos(ang);
ycir=r*sin(ang);
xc = 3.5;
yc = 3.5;
r= IBM.diamcyl/2;
ang=0:0.01:2*pi;

xcir=r*cos(ang);
ycir=r*sin(ang);
xc = IBM.xc;
yc = IBM.yc;

for iTime = 1:20000
        
    ControlVar.resi=1;
    ControlVar.ii=0;
    ControlVar.time = ControlVar.time+VARIABLES.dt;
%% =======================================================================
%                       SOLVE FOR FLOW
% ========================================================================

    [StateVar,ControlVar] = ... 
        SolveUVP (ControlVar,Flux,DOMAIN,VARIABLES,StateVar,IBM,IBM_coeffU,...
        IBM_coeffV,IBM_coeffP,BC);    
    
    StateVar.U_old = StateVar.U;
    StateVar.V_old = StateVar.V;
    StateVar.P_old = StateVar.P;

%% ========================================================================
%                       SCALAR TRANSPORT            
%  ========================================================================
    
    if ControlVar.flow_steady == 0
        [StateVar] = SolveTransportADRE(ControlVar,DOMAIN,VARIABLES,... 
            StateVar,IBM,IBM_coeffP,BC,Flux);
    end
    
   
%% ========================================================================
%                       CurrentStateVar            
%  ========================================================================     
    
    CurrentStateVar =  struct('U',StateVar.U,'V',StateVar.V,...
            'P',StateVar.P,'phi',StateVar.phi);
    
  
    
%% ========================================================================
%                      LEVEL SET EQUATION            
%% ========================================================================

    if ~mod(iTime, 10)

        [LS] = LSeqSolve(LS,StateVar,VARIABLES,DOMAIN);
        [IBM_coeffU,IBM_coeffV,IBM_coeffP] = LSIBMcoeffs(IBM,DOMAIN,LS);
    end
    
%% ========================================================================
%                      PLOTS and SAVE            
%% ========================================================================
    
    
    if ~mod(iTime, 100)
        flowfilename = strcat('dataRDE',num2str(iTime),'dt.mat');
        matfile = strcat('Output/', flowfilename);
 
        save(matfile,'-v7.3','-struct','CurrentStateVar');




    end


end

% [StateVar.PSI,StateVar.VOR]=PlotFlowField(CurrentStateVar,IBM,DOMAIN);
% 
% 
% profile viewer