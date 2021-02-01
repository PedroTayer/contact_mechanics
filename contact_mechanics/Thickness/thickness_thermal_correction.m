function [fi_t,L, lambda_corr, h0_corr, hm_corr] =thickness_thermal_correction(beta, eta, k, somaU, Ve, lambda, h0, hm)
  L = beta*eta*somaU^2/k;  % Apostila 3 pg 51
  fi_t = (1+0.1*((1+14.8*Ve^0.83)*L^0.64))^-1;  % Apostila 3 pg 51
  lambda_corr = lambda* fi_t; 
  h0_corr = h0* fi_t; 
  hm_corr = hm* fi_t; 
end
