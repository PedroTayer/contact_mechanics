function hertz=hertz_theory_linear(v1, E1, v2, E2, Rx1, Rx2, Fn, L, Po)
  % Information extract from Apostila 3 - Problemas Propostos, Formulários, Folha de Cálculo e Aplicações MatLab
  
  hertz.Ecomb = 1 / (((1 - v1**2) / E1) + ((1 - v2**2) / E2)); %pg 41
  hertz.A=(1/2)*(1/Rx1+1/Rx2); %pg 43
  hertz.Rx=1/hertz.A; %pg 43
  
  % Caso a entrada seja Po
  if Fn==0
    hertz.Fn=Po**2*pi*L*hertz.Rx/(2*hertz.Ecomb);
    Fn=hertz.Fn;
  else
  hertz.Fn=Fn;
end

  hertz.a=sqrt(2*Fn*hertz.Rx/(pi*L*hertz.Ecomb)); %pg 45
  hertz.delta=Fn/(pi*hertz.a*hertz.Ecomb); 
  hertz.pm=Fn/(2*hertz.a*L); %pg 45
  hertz.po=4/pi*hertz.pm; %pg 45

  hertz.taumax=0.3*hertz.po; %pg 45
  hertz.Zs=0.7861*hertz.a; %pg 45
  hertz.tau0=0.25*hertz.po; %pg 45
  hertz.deltaxz=2*hertz.tau0; %pg 45
  hertz.zo=0.42*hertz.a; %pg 45
  hertz.x0=0.85*hertz.a; %pg 45
  hertz.L=L;
  
endfunction
