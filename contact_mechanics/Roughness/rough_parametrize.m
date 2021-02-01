function [sup, sq, sa, Tz, texto] = rough_parametrize(body, Rx, sq_inputed, amp, wavelength, Tz, length_a)
  
  x_i=-length_a*1.2;                           % Inferior bound of discretized field
  x_f=-x_i;                               % Superior bound of discretized field
  discr_x=701;                          % Number of discretization points
  x=linspace(x_i,x_f,discr_x); 
  z=0.5*((sqrt(Rx^2-x.^2))+(sqrt(Rx^2-x.^2)));
  
  if Tz~=0
    %% ENTRY IS FROM TXT
    % Calculus zone (x=2a)
    roughness = Tz(50,1:702).*10;
    method_input='txt file';
    
  else
    if amp > 0 && wavelength>0
      %% ENTRY IS FROM WAVELENGTH AND AMPLITUDE
      method_input='amplitude and wavelength';
      n=length_a/wavelength;
      roughness=(-amp*cos(pi*n*(x./(length_a))));
    else
      %% ENTRY IF FROM SQ
      z=0.5*((sqrt(Rx^2-x.^2))+(sqrt(Rx^2-x.^2)));
      roughness=(-sqrt(2)*sq_inputed*cos(pi*4*(x./(length_a))));
      method_input='Sq value';
    end 
  end
  sq=rms(roughness);
  sa=sq*sqrt(2);
  texto=sprintf('Calculated with %s',method_input);  
  sup=z+roughness;
end