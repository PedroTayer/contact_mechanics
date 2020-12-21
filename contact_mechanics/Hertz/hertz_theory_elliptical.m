function hertz=hertz_theory_elliptical(v1, E1, v2, E2, Rx1, Rx2, Ry1, Ry2, Fn, Po, toplot)
  
  % Information extract from Apostila 3 - Problemas Propostos, Formulários, Folha de Cálculo e Aplicações MatLab
  
  hertz.Rx = 1/((1/2)*(1/Rx1+1/Rx2)); % Apostila 3 pg 61
  hertz.A=1/hertz.Rx;  % Apostila 3 pg 61
  hertz.Ry=1/((1/2)*(1/Ry1+1/Ry2));  % Apostila 3 pg 61
  hertz.B=1/hertz.Ry;  % Apostila 3 pg 61
  
  if hertz.Rx<=hertz.Ry
    fprintf('Vx ESTÁ NA DIREÇÃO DE A (A=1/RX)\n')
    hertz.A=1/hertz.Rx;  % Apostila 3 pg 61
    hertz.B=1/hertz.Ry;  % Apostila 3 pg 61
    hertz.inverted = false;
  else
    fprintf('Vx ESTÁ NA DIREÇÃO DE B (B=1/RX)\n')
    # B está na direção de X
    hertz.inverted = true;
    hertz.A=1/hertz.Ry;  % Apostila 3 pg 61
    hertz.B=1/hertz.Rx;  % Apostila 3 pg 61
  endif
  
  # Elliptical constants
  [hertz.k, hertz.Ca, hertz.Cdelta, hertz.Csigma, hertz.Ctau, hertz.CZs, hertz.Ctau0, hertz.CZ0, hertz.elips] = hertz_elliptical_constants(hertz.A/hertz.B, hertz.inverted, toplot);
  
  % Combined elastic modulus
  hertz.Ecomb = 1 / (((1 - v1**2) / E1) + ((1 - v2**2) / E2)); % Apostila 3 pg 57
  
  # If entry is from Po
  if Fn==0
    hertz.Fn = (hertz.Ca**2 * Po * 2 * pi/(3*hertz.k))**3*1/(hertz.Ecomb*(hertz.A+hertz.B))**2;
    Fn=hertz.Fn;
  else
    hertz.Fn=Fn;
  end
  
  
  # Smaller semi_length from ellipse (a)
  hertz.a=hertz.Ca*(Fn/((hertz.A+hertz.B)*hertz.Ecomb))^(1/3); % Apostila 3 pg 65
  # Bigger semi_length from ellipse (a)
  hertz.b=hertz.a/hertz.k;
  # Penetration
  hertz.delta=hertz.Cdelta*Fn/(pi*hertz.a*hertz.Ecomb); % Apostila 3 pg 65
  # Pressures
  hertz.pm=hertz.Fn/(pi*hertz.a*hertz.b); % Apostila 3 pg 65
  hertz.po=(3/2)*hertz.pm; % Apostila 3 pg 65
  # Reference pressure
  hertz.pr=hertz.a*(hertz.A+hertz.B)*hertz.Ecomb; % Apostila 3 pg 67
  hertz.sigma_max=hertz.Csigma*hertz.pr; % Apostila 3 pg 65
  
  
  # Contact length is the length on direction perpendicular to movement
  hertz.L=2*hertz.b;
  # If B is on X direction
  # Ctau0 for e>1, contact length is 2a
  if hertz.inverted
    hertz.L=2*hertz.a;
  end
  
  hertz.tau_max=hertz.Ctau*hertz.pr;
  hertz.Zs=hertz.CZs*hertz.a;
  
  hertz.delta_tau0=hertz.Ctau0*hertz.b*(hertz.A+hertz.B)*hertz.Ecomb;
  hertz.tau0=hertz.delta_tau0/2;
  hertz.Z0=hertz.CZ0*hertz.b;
  endfunction