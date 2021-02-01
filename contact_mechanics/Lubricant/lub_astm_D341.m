function lub=lub_astm_D341(a, eta0, eta1, T1, T0, Tf)
  % ASTM D341 
  % m
  m_cima = log10(log10(eta0+a)/log10(eta1+a)); % Apostila 2 pg 36
  m_baixo = log10(T1/T0); % Apostila 2 pg 36
  lub.m =  m_cima/m_baixo; % Apostila 2 pg 36
  
  % n
  lub.n = log10(log10(eta0+a)) + lub.m*log10(T0); % Apostila 2 pg 36
  
  % v
  lub.visc_cin = 10^(10^(lub.n-lub.m*log10(Tf))) - a; % Apostila 2 pg 35
  
  % beta
  lub.beta = lub.m/Tf*(lub.visc_cin+a)/lub.visc_cin*log(lub.visc_cin+a); % Apostila 2 pg 37
end
