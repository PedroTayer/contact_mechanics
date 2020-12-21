function term=thermal_of_contact(C1,C2,k1,k2,ro1,ro2,coef_atrito,Vesc,U1,U2,Fn,l,Ecomb,Rx,piezo,eta,h0,k_lub,T0,pressao_media,beta)
  
  % Thermal parameters of solids
  term.param_term1 = sqrt(C1*k1*ro1); % (sqr(N/mK) ap 3 pg 53)
  term.param_term2 = sqrt(C2*k2*ro2); % (sqr(N/mK) ap 3 pg 53)
  
  % Flash temperature
  term.Tflash = 0.91 * (coef_atrito*(Vesc)/(term.param_term1*sqrt(U1)+term.param_term2*sqrt(U2)) * (Fn/l)^0.75 * (Ecomb/Rx)^0.25); % (sqr(N/mK) ap 3 pg 53)

  % Rise in temperature Crook
  term.deltacrook = sqrt(pi/128) * sqrt(Fn*Ecomb/(l*Rx)) * coef_atrito*Vesc*h0/k_lub; % (ap 3 pg 53)
  term.Tcrook = term.deltacrook + term.Tflash + (T0 - 273) ;% (ap 3 pg 53)
  
  % Roelands expoents
  term.exp_roelands_temperatura = beta*(T0-138)/(log(eta)+9.67) ;% aula 4 slide 38
  term.exp_roelands_pressao = 0.196*10^9*piezo/(log(eta)+9.67) ;% (ap 3 pg 49, Z)
  term.eta_roelands=exp((log(eta)+9.67)*(1+pressao_media/196000000)^term.exp_roelands_pressao-9.67) ;% (ap 3 pg 49)

  % Rise in temperature Roelands
  term.deltaroelands = 1/beta * log((beta*Vesc^2*term.eta_roelands) / (8*k_lub) + 1) ;% (ap 3 pg 53)
  
  % Surfaces temperatures
  term.Tmax_sup = T0 - 273 + term.Tflash; % (°C)
  term.Tmax_lub = term.Tmax_sup + term.deltaroelands; % (°C)
  #term.tspecific = term.tmax/tlim
endfunction
