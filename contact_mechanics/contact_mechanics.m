function [data, hertz, lubricant, cin, thickness, friction, thermal, rough] = contact_mechanics(data, toshow)

addpath('./Hertz');
addpath('./Thickness');
addpath('./Lubricant');
addpath('./Roughness');
addpath('./Thermal');


################## CÁLCULOS ##########################
type=hertz_detect_type(data.Rx1,data.Rx2,data.Ry1,data.Ry2);   % 0 linear % 1 elliptical

## HERTZ
if type==0 % Contact is linear
  if toshow
printf('\nContact is linear\n')
end
hertz=hertz_theory_linear(data.poisson1, data.E1, data.poisson2, data.E2, data.Rx1, data.Rx2, data.Fn, data.L, data.Po);
else % Contact is elliptical
if toshow
printf('\nContact is elliptical\n')
end
hertz=hertz_theory_elliptical(data.poisson1, data.E1, data.poisson2, data.E2, data.Rx1, data.Rx2, data.Ry1, data.Ry2, data.Fn, data.Po, data.plot_kandconstants);
end

## CINEMATICS
cin.W1 = 2*pi*data.n1/60; % Conversion rpm->rad/s
cin.W2 = 2*pi*data.n2/60; % Conversion rpm->rad/s
cin.U1 = data.V1 + cin.W1*data.Rx1; % Tangential velocity of contact point = V+W*r
cin.U2 = data.V2 + cin.W2*data.Rx2; % Tangential velocity of contact point = V+W*r
cin.Vrol = cin.U1+cin.U2; % Apostila 3 pg 43
cin.Vslid = abs(cin.U1-cin.U2); % Apostila 3 pg 43
cin.Ve = cin.Vslid/cin.Vrol; % Apostila 3 pg 43

## LUBRICANT
if (data.k>0 && data.eta>0 && data.beta>0 && data.visc_cin>0)
lubricant.k = data.k;
lubricant.eta = data.eta;
lubricant.beta = data.beta;
lubricant.visc_cin = data.visc_cin;
else
# Determination of viscosity on operation temperature (Tf) by ASTM D341
lubricant=lub_astm_D341(data.a_lub, data.eta0, data.eta1, data.T1, data.T0, data.Tf);
# Determination of dynamic viscosity
lubricant.eta = lubricant.visc_cin * data.SpecGrav / 1000; % Relation between cinematic viscosity(cSt) and dynamic (Pa.s)
# Determination of thermal condutibility
lubricant.k = 0.12*(1-0.0005*(data.Tf-273)/3)/data.SpecGrav; % Apostila 2 pg 46
end
# Determination of piezoviscosity using Gold equation
if data.alfa>0
  lubricant.alfa=data.alfa;
else
lubricant.alfa=lub_piezoviscosity_Gold(data.s, data.t, lubricant.visc_cin);
end


## ROUGHNESS
[rough.sup1, rough.sq1, rough.sa1, rough.Tz1, text1]=rough_parametrize(1, data.Rx1, data.sq1, data.amp1, data.wavelength1, data.Tz1, hertz.a);
[rough.sup2, rough.sq2, rough.sa2, rough.Tz2, text2]=rough_parametrize(2, data.Rx2, data.sq2, data.amp2, data.wavelength2, data.Tz2, hertz.a);
rough.rqcomb=sqrt(rough.sq1**2+rough.sq2**2);
rough.x = linspace(-hertz.a*1.2,hertz.a*1.2,701);
    if data.plot_surfaces
    figure
    plot (rough.x/hertz.a,1000*(-(rough.sup1)+max(rough.sup1)),'b','DisplayName',text1);
    hold on
    plot (rough.x/hertz.a,1000*(rough.sup2-max(rough.sup2)),'k','DisplayName',text2);
    xlabel('x/a', 'Fontsize',16)
    ylabel('Surfaces (mm)', 'Fontsize',16)
    set(gca, "linewidth", 4, "fontsize", 16)
    h = legend();
    set(h, 'fontsize', 16)
    end

## FRICTION
friction.kelley=0.0127*log10((0.02966*hertz.Fn) / (lubricant.eta*hertz.L*cin.Vslid*cin.Vrol^2));
friction.eng_iso=0.0254*((hertz.Fn*rough.rqcomb) / (lubricant.eta * hertz.L * hertz.Rx * cin.Vrol))^0.25;
friction.eng_michaelis=0.0778 * (hertz.Fn/(hertz.L*hertz.Rx*cin.Vrol))^0.2 * (1/lubricant.eta)^0.05 * (rough.rqcomb/sqrt(2))^0.25;
friction.coef=friction.kelley;

## LUBRICANT FILM THICNESS
if type==0 # Linear
thickness = thickness_EHL_linear(hertz.Fn, hertz.L, hertz.Rx, hertz.Ecomb, lubricant.eta, lubricant.alfa, cin.Vrol);
else # Elliptical
thickness = thickness_EHL_elliptical(hertz.Fn, hertz.Rx, hertz.Ry, hertz.Ecomb, lubricant.eta, lubricant.alfa, cin.Vrol);
end

# Lambda
thickness.lambda_without_correction = thickness.h0_without_correction/rough.rqcomb; % Apostila 3 página 51
# Thermal correction
[thickness.fi_t, thickness.L_term, thickness.lambda_corr, thickness.h0_corr, thickness.hm_corr] = thickness_thermal_correction(lubricant.beta, lubricant.eta, lubricant.k, cin.Vrol, cin.Ve, thickness.lambda_without_correction, thickness.h0_without_correction, thickness.hm_without_correction);
thickness.lambda = thickness.lambda_without_correction*thickness.fi_t; 
thickness.h0 = thickness.h0_without_correction*thickness.fi_t; 
thickness.hm = thickness.hm_without_correction*thickness.fi_t; 
# Temperatura in center
thickness.deltaT=(1-thickness.fi_t^(1/0.727))/lubricant.beta; % Apostila 3 página 51
thickness.Tcenter=data.Tf-273+thickness.deltaT; % Apostila 3 página 51


lambda_corr=thickness.lambda_corr;

## THERMAL PARAMETERS
thermal=thermal_of_contact(data.C1,data.C2,data.K1,data.K2,data.ro1,data.ro2,friction.coef,cin.Vslid,cin.U1,cin.U2,hertz.Fn,hertz.L,hertz.Ecomb,hertz.Rx,lubricant.alfa,lubricant.eta,thickness.h0_corr,lubricant.k,data.Tf, hertz.pm, lubricant.beta);

rmpath('./Hertz');
rmpath('./Thickness');
rmpath('./Lubricant');
rmpath('./Roughness');
rmpath('./Thermal');

return
