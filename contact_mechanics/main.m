clear all
close all
clc
format long

addpath('./Read_input')

# 2020 Contact Mechanics
# UTFPR - Professor Tiago Cousseau
# Development: Pedro Del Negro Tayer


################ INITIALIZATION ######################
# Read input data and allocate on variables
[data,data_txt,raw]=read_input_excel();

# If there is .txt roughness data, process it before
if data.txtdata1
  [data.Tz1,data.sq1,data.sa1]=rough_read_txt(1, data.plot_txtdata);
else
  data.Tz1=0;
end
if data.txtdata2
  [data.data.Tz2,data.sq2,data.sa2]=rough_read_txt(1, data.plot_txtdata);
else
  data.Tz2=0;
end

# If there is no parameter variation, run for unique case
if ~data.multiple
  [data, hertz, lubricant, cin, thickness, friction, thermal, rough]=contact_mechanics(data, 0);
  results=cell2struct({data, hertz, lubricant, cin, thickness, friction, thermal, rough}',{'data','hertz','lubricant','cin','thickness','friction','thermal','rough'});
else
  # Defini��o 
  pct=0;
  fprintf('\n')
  for i=1:length(data.vector)
    
    # Show percentages of conclusion
    pctnew=i/length(data.vector)-pct;
    if pctnew>0.1
      pct=i/length(data.vector);
      sprintf('%.2f%% concluded...', 100*pct)
    end
    
    # Change data structure variable with value from inputed vector
    data=substitute_values_on_structure(data.varstr, data.vector(i), data);
    
    # Call calculation for these values
    [data, hertz, lubricant, cin, thickness, friction, thermal, rough] = contact_mechanics(data, 0);
    results{i}={data, hertz, lubricant, cin, thickness, friction, thermal, rough};
  end
  sprintf('100%% concluded!')
  
  # Extract value from structure
  for i=1:length(results)
    value(i)=extract_values_from_structure(data.resstr, results{1,i});
  end
  value=cell2mat(value);
  
  ### Plotar valores
  figure
  plot(data.vector,value,'b','LineWidth',3);
  grid on
  xlabel(strrep(data.varstr,'_',' '), 'Fontsize',16)
  ylabel(strrep(data.resstr,'_',' '), 'Fontsize',16)
  set(gca, "linewidth", 4, "fontsize", 16)
  
  rmpath('./Read_input')

  
end

################## VARI�VEIS ##########################
#### Estrutura 'data' (todos as vari�veis que s�o inseridas pelo usu�rio)
## data.Rx1 :  Raio do corpo 1 na dire��o x (m)
## data.Ry1 :  Raio do corpo 1 na dire��o y (m)
## data.Rx2 :  Raio do corpo 2 na dire��o x (m)
## data.Ry2 :  Raio do corpo 2 na dire��o y (m)
## data.L :  Comprimento do contato (para contato linear) (m)
## data.E1 :  M�dulo de elasticidade do corpo 1 (Pa)
## data.E2 :  M�dulo de elasticidade do corpo 2 (Pa)
## data.poisson1 :  M�dulo de poisson do corpo 1 (1)
## data.poisson2 :  M�dulo de poisson do corpo 2 (1)
## data.C1 :  Calor espec�fico do corpo 1 (J/Kg K)
## data.C2 :  Calor espec�fico do corpo 2 (J/Kg K)
## data.K1 :  Condutibilidade t�rmica do corpo 1 (W/mk)
## data.K2 :  Condutibilidade t�rmica do corpo 2 (W/mk)
## data.ro1 :  Densidade do corpo 1 (kg/m3)
## data.ro2 :  Densidade do corpo 2 (kg/m3)
## data.Fn :  For�a normal (N)
## data.Po : Press�o m�xima de Hertz alvo (Pa)
## data.Tf :  Temperatura de opera��o (K
## data.n1 :  Rota��o do corpo 1 (rpm)
## data.n2 :  Rota��o do corpo 2 (rpm)
## data.V1 : Velocidade do corpo 1 (m/s)
## data.V2 : Velocidade do corpo 2 (m/s)
## data.T0 :  Temperatura 0 para viscosidade (K)
## data.eta0 :  Viscosidade din�mica para T0 (mm2/s)
## data.T1 :  Temperatura 1 para viscosidade (K)
## data.eta1 :  Viscosidade din�mica para T1 (mm2/s)
## data.GE :  Gravidade espec�fica do lubrificante
## data.a :  Fator a para lubrificante (norma ASTM D341)
## data.s :  Fator s para coeficiente de piezoviscosidade de Gold
## data.t :  Fator t para coeficiente de piezoviscosidade de Gold
## data.rug1 :  Rugosidade do corpo 1 (m)
## data.rug2 :  Rugosidade do corpo 2 (m)

#### Estrutura 'cin' (vari�veis referentes {� cinem�tica)
## cin.W1 :  Rota��o do corpo 1 em rad/s
## cin.W2 :  Rota��o do corpo 2 em rad/s
## cin.U1 :  Velocidade tangencial no contato do corpo 1 (m/s)
## cin.U2 :  Velocidade tangencial no contato do corpo 2 (m/s)
## cin.Vrol :  Velocidade de rolamento (U1+U2) (m/s)
## cin.Vesc :  Velocidade de escorregamento (|U1-U2|) (m/s)
## cin.Ve :  Velocidade de entrada (Vesc/somaU) (1)

#### Estrutura 'hertz' (calculadas pela teoria de Hertz)
## hertz.Rx :  Raio combinado na dire��o x (m)
## hertz.Ry :  Raio combinado na dire��o y (m)
## hertz.A :  Curvatura maior do contato (1/m)
## hertz.B :  Curvatura menor do contato (1/m)
## hertz.L : Largura do contato (m)
## hertz.invertido : Caso A esteja na dire��o Y, invertido ser� true
## hertz.k : Fator de elipcidade (1)
## hertz.elips : Fator de elipsidade para c�lculo do tau0 (1)
## hertz.Ca : Coeficiente para a (1)
## hertz.Cdelta : Coeficiente para delta (1)
## hertz.Csigma : Coeficiente para sigma (1)
## hertz.Ctau : Coeficiente para tau (1)
## hertz.CZs : Coeficiente para Zs (1)
## hertz.Ctau0 : Coeficiente para tau0 (1)
## hertz.CZ0 : Coeficiente para CZ0 (1)
## hertz.Ecomb : M�dulo el�stico combinado (Pa)
## hertz.Fn : For�a normal para c�lculo (N)
## hertz.a :  Semi largura menor do contato (m)
## hertz.b :  Semi largura maior do contato (m)
## hertz.delta :  Penetra��o (m)
## hertz.pm :  Press�o m�dia de Hertz (Pa)
## hertz.po :  Press�o m�xima de Hertz (Pa)
## hertz.pr : Press�o de refer�ncia (Pa)
## hertz.sigma_max : Tens�o m�xima de Hertz (Pa)
## hertz.tau_max :  Tens�o de cisalhamento m�xima de Hertz (Pa)
## hertz.Zs :  Profundidade de taumax (m)
## hertz.delta_tau0 :  Amplitude da tens�o de corte ortogonal (Pa)
## hertz.tau0 :  Amplitude da tens�o de corte ortogonal (Pa)
## hertz.Z0 :  Profundidade de tau0 (m)
## hertz.x0 :  Localiza��o em x de tau0 (m)

#### Estrutura 'lub' (referentes ao lubrificante)
## lub.m :  Par�metro m da norma ASTM D341
## lub.n :  Par�metro n da norma ASTM D341
## lub.v :  Viscosidade do lubrificante na temperatura de opera��o (mm2/s)
## lub.beta :  Coeficiente de termoviscosidade (K-1)
## lub.alfa :  Coeficiente de piezoviscosidade de Gold (Pa-1)
## lub.eta :  Viscosidade din�mica na temperatura de opera��o (Pa*s)
## lub.k : Coeficiente de condutibilidade t�rmica (W/mK)

#### Estrutura 'esp' (referentes � espessura de filme lubrificante)
## esp.Uadm :  Par�metro adimensional U
## esp.Gadm :  Par�metro adimensional G
## esp.Wadm :  Par�metro adimensional W
## esp.Co : Fator de corre��o de h0 para el�ptico
## esp.h0_cru :  Espessura m�nima de filme sem corre��o (m)
## esp.Cm : Fator de corre��o de hm para el�ptico
## esp.hm_cru :  Espessura m�dia de filme sem corre��o (m)
## esp.lambda_cru :  Espessura espec�fica sem corre��o (1)
## esp.fi_t :  Fator de corre��o t�rmico para espessura de filme
## esp.L :  Fator L para corre��o t�rmica
## esp.h0_corr :  Espessura m�nima de filme com corre��o t�rmica (1) (m)
## esp.hm_corr :  Espessura m�dia de filme com corre��o t�rmica (1) (m)
## esp.lambda_corr :  Espessura espec�fica com corre��o t�rmica (1)
## esp.deltaT :  Diferen�a de temperatura
## esp.Tcentro :  Temperatura no centro (�C)

#### Estruturo 'atrito' (referentes aos coeficientes de atrito calculados)
## atrito.kelley : atrito Kelley
## atrito.eng_iso : atrito ISO para engrenagens
## atrito.eng_michaelis : atrito Michaelis para engrenagens

#### Estrutura 'term' (referentes � t�rmica do contato)
## term.t1 : Par�metro t�rmico do s�lido 1 (N/mKs^0.5)
## term.t2 : Par�metro t�rmico do s�lido 2 (N/mKs^0.5) 
## term.Tflash : Temperatura Flash (aumento de temperatura das superf�cies) (�C)
## term.deltacrook : Aumento de temperatura Crook do lubrificante (aumento de temperatura do lubrificante) (�C)
## term.Tcrook : Temperatura Crook (�C) (T0 + TFlash + deltacrook)
## term.exp_roelands_temperatura : Expoente da viscosidade de Roelands devido � temperatura
## term.exp_roelands_pressao : Expoente da viscosidade de Roelands devido � press�o
## term.eta_roelands : Viscosidade de Roelands � press�o p (Pa*s)
## term.deltaroelands : Aumento de temperatura Roelands do lubrificante (�C)
## term.Tmax_sup : Temperatura m�xima das superf�cies (T0 + TFlash) (�C)
## term.Tmax_lub : Temperatura m�xima do lubrificante (Tmax_sup + deltaroelands) (�C)
