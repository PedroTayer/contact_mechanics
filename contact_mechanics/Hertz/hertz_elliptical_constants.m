function [k, Ca, Cdelta, Csigma, Ctau, CZs, Ctau0, CZ0, elips ]=hertz_elliptical_constants(AaboutB, inverted, toplot)
  
  % Two decimal in A/B
  AaboutB=round(100*AaboutB)/100;
  
  
  % Calculate k
  k = (AaboutB)^(-2/3);
  calc_error=1;
  it=0;
  while calc_error>1e-6
    e = sqrt(1-k^2); % Apostila 1 pg 72
    [K, E]  =  ellipke (e^2); % Apostila 1 pg 72
    kcalc  =  sqrt(E/(K+(AaboutB)*(K-E))); % Apostila 1 pg 73
    k = (k + kcalc)/2;
    calc_error = abs(kcalc-k)/k;
    it=it+1;
  end
  k=k;
  
  % Determine constants
  Ca=(3*k*E/(2*pi))^(1/3); % Apostila 1 pg 75
  Cdelta = 3*k*K/2; % Apostila 1 pg 80
  Csigma = 3*k/(2*pi*Ca^2);
  
  if AaboutB>20
    Ctau=0.3;
    CZs=0.7861;
    y_ctau=ones(xabs,1)*0.3;
    y_czs=ones(xabs,1)*0.7861;
  else
    
    % Create interpolations
    % Base for Ctau and CZs
    AaboutB_dado=[1, 1.5, 2, 2.5, 3, 3.5, 4, 6, 8, 10, 20];
    xabs=[1:0.01:20];
    % Table values
    ctau=[21, 24, 26, 27, 28, 28.5, 29, 30, 30, 30, 30]./100;
    czs=[47, 54, 60, 63.5, 65.5, 68, 69, 73, 75, 76, 78.61]./100;
    % Interpolations
    y_ctau=interp1(AaboutB_dado, ctau, xabs, "pchip", 'EXTRAP');
    y_czs=interp1(AaboutB_dado, czs, xabs, "pchip", 'EXTRAP');
  end
  
  % Same for e
  es=[0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4];
  xes=[0:0.001:4];
  ctau0=[0.5, 0.4, 0.22, 0.18, 0.14, 0.11, 0.085, 0.07, 0.06];
  cz0=[0.42, 0.325, 0.25, 0.18, 0.145, 0.12, 0.1, 0.08, 0.065];
  y_ctau0=interp1(es, ctau0, xes, "pchip", 'EXTRAP');
  y_cz0=interp1(es, cz0, xes, "pchip", 'EXTRAP');
  
  % Find A/B value
  index=find(100*xabs==100*AaboutB);
  Ctau=y_ctau(index);
  CZs=y_czs(index);
  
  
  % Find e value
  if inverted
    elips=1/k;
  else
    elips=k;
  end
  elips=round(100*elips)/100;
  index_orto=find(100*xes==100*elips);
  Ctau0=y_ctau0(index_orto);
  CZ0=y_cz0(index_orto);
  
  
  if toplot
    figure
    loglog(AaboutB_dado,ctau,'ko')
    grid on
    hold on
    loglog(xabs,y_ctau,'-','LineWidth',3, 'DisplayName', 'C\tau')
    loglog(AaboutB_dado,czs,'ko')
    loglog(xabs,y_czs,'-','LineWidth',3, 'DisplayName', 'CZs')
    xlabel('A/B', 'Fontsize',16)
    ylabel('Coeficcients', 'Fontsize',16)
    set(gca, "linewidth", 4, "fontsize", 16)
    h= legend()
    set(h, 'FontSize',16)
    
    figure
    plot(es,ctau0,'ko','LineWidth',2, 'DisplayName', 'Dados')
    grid on
    hold on
    plot(xes,y_ctau0,'b-','LineWidth',2, 'DisplayName', 'Interoplação')
    xlabel('e', 'Fontsize',16)
    ylabel('C\tau0', 'Fontsize',16)
    set(gca, "linewidth", 4, "fontsize", 16)
    
    figure
    plot(es,cz0,'ko','LineWidth',2, 'DisplayName', 'Dados')
    grid on
    hold on
    plot(xes,y_cz0,'b-','LineWidth',2, 'DisplayName', 'Interoplação')
    xlabel('e', 'Fontsize',16)
    ylabel('Cz0', 'Fontsize',16)
    set(gca, "linewidth", 4, "fontsize", 16)
    
    % Calculate k, Csigma, Ca, e Cdelta for many values
    AaboutBsplot = [1:1:100];
    xplot = AaboutBsplot;
    
    for i = 1:length(AaboutBsplot)
      AaboutBplot = AaboutBsplot(i);
      
      BsobreAplot = 1/AaboutBplot; 
      kplot(i) = AaboutBplot^(-2/3);
      k_iniplot(i) = kplot(i);
      
      % Determinar k  % Apostila 1 pg 73
      calc_error(i)=1;
      it(i)=0;
      while calc_error(i)>1e-8
        e = sqrt(1-k_iniplot(i)^2); % Apostila 1 pg 72
        [K, E]  =  ellipke (e^2); % Apostila 1 pg 72
        kcalcplot(i)  =  sqrt(E/(K+(AaboutBplot)*(K-E))); % Apostila 1 pg 73
        kplot(i) = (kplot(i) + kcalcplot(i))/2;
        calc_error(i) = abs(kcalcplot(i)-kplot(i))/kplot(i);
        it(i)=it(i)+1;
      end
      
      
      % Determine constants
      Caplot(i) = (3*k_iniplot(i)*E/(2*pi))^(1/3); % Apostila 1 pg 75
      Cdeltaplot(i)  =  3*k_iniplot(i)*K/2; % Apostila 1 pg 80
      Csigmaplot(i)  =  3*k_iniplot(i)/(2*pi*Caplot(i)^3);
    end
    figure
    semilogx(xplot,k_iniplot,'ok','DisplayName','K','LineWidth',2)
    grid on
    hold on
    semilogx(xplot,Caplot,'ob','DisplayName','Ca','LineWidth',2)
    semilogx(xplot,Cdeltaplot,'og','DisplayName','Cdelta','LineWidth',2)
    semilogx(xplot,Csigmaplot,'or','DisplayName','Csigma','LineWidth',2)
    legend()
  end
  
end
