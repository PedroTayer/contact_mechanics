function thickness =thickness_EHL_elliptical(Fn, Rx, Ry, Ecomb, eta, alfa, somaU)
  if Rx<Ry
    value=Ry/Rx;
  else
    value=Rx/Ry;
  end
  
  % Parameter U
  thickness.Uadm = eta*(somaU)/(2*Rx*Ecomb); % Apostila 3 pg 51
  % Parameter G
  thickness.Gadm = 2*alfa*Ecomb; % Apostila 3 pg 51
  % Parameter W
  thickness.Wadm = 2*Fn/(Rx**2*Ecomb); % Apostila 3 pg 51
  % Parameter Co
  thickness.Co=1-0.61*exp(-0.752*(value)^0.64);
  % h0
  thickness.h0_without_correction = 1.345*Rx *thickness.Co* thickness.Uadm**0.67 * thickness.Gadm**0.53 * thickness.Wadm**-0.067;  % Apostila 3 pg 51
    % Parameter Cm
  thickness.Cm=1-exp(-0.7*(value)^0.64);
  % hm
  thickness.hm_without_correction = 1.815*Rx *thickness.Cm* thickness.Uadm**0.68 * thickness.Gadm**0.49 * thickness.Wadm**-0.073;  % Apostila 3 pg 51
endfunction
