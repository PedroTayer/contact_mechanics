function thickness =thickness_EHL_linear(Fn, L, Rx, Ecomb, eta, alfa, somaU)
  # Parameter U
  thickness .Uadm = eta*(somaU)/(2*Rx*Ecomb); % Apostila 3 pg 51
  # Parameter G
  thickness .Gadm = 2*alfa*Ecomb; % Apostila 3 pg 51
  # Parameter W
  thickness .Wadm = Fn/(Rx*L*Ecomb); % Apostila 3 pg 51
  # h0
  thickness .h0_without_correction = 0.975*Rx * thickness .Uadm**0.727 * thickness .Gadm**0.727 * thickness .Wadm**-0.091;  % Apostila 3 pg 51
  # hm
  thickness .hm_without_correction = 1.325*Rx * thickness .Uadm**0.7 * thickness .Gadm**0.54 * thickness .Wadm**-0.13;  % Apostila 3 pg 51
endfunction
