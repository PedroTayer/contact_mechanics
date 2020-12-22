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
  # Definição 
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

################## VARIÁVEIS ##########################
#### Estrutura 'data' (todos as variáveis que são inseridas pelo usuário)
## data.Rx1 :  Raio do corpo 1 na direção x (m)
## data.Ry1 :  Raio do corpo 1 na direção y (m)
## data.Rx2 :  Raio do corpo 2 na direção x (m)
## data.Ry2 :  Raio do corpo 2 na direção y (m)
## data.L :  Comprimento do contato (para contato linear) (m)
## data.E1 :  Módulo de elasticidade do corpo 1 (Pa)
## data.E2 :  Módulo de elasticidade do corpo 2 (Pa)
## data.poisson1 :  Módulo de poisson do corpo 1 (1)
## data.poisson2 :  Módulo de poisson do corpo 2 (1)
## data.C1 :  Calor específico do corpo 1 (J/Kg K)
## data.C2 :  Calor específico do corpo 2 (J/Kg K)
## data.K1 :  Condutibilidade térmica do corpo 1 (W/mk)
## data.K2 :  Condutibilidade térmica do corpo 2 (W/mk)
## data.ro1 :  Densidade do corpo 1 (kg/m3)
## data.ro2 :  Densidade do corpo 2 (kg/m3)
## data.Fn :  Força normal (N)
## data.Po : Pressão máxima de Hertz alvo (Pa)
## data.Tf :  Temperatura de operação (K
## data.n1 :  Rotação do corpo 1 (rpm)
## data.n2 :  Rotação do corpo 2 (rpm)
## data.V1 : Velocidade do corpo 1 (m/s)
## data.V2 : Velocidade do corpo 2 (m/s)
## data.T0 :  Temperatura 0 para viscosidade (K)
## data.eta0 :  Viscosidade dinâmica para T0 (mm2/s)
## data.T1 :  Temperatura 1 para viscosidade (K)
## data.eta1 :  Viscosidade dinâmica para T1 (mm2/s)
## data.GE :  Gravidade específica do lubrificante
## data.a :  Fator a para lubrificante (norma ASTM D341)
## data.s :  Fator s para coeficiente de piezoviscosidade de Gold
## data.t :  Fator t para coeficiente de piezoviscosidade de Gold
## data.rug1 :  Rugosidade do corpo 1 (m)
## data.rug2 :  Rugosidade do corpo 2 (m)

#### Estrutura 'cin' (variáveis referentes {à cinemática)
## cin.W1 :  Rotação do corpo 1 em rad/s
## cin.W2 :  Rotação do corpo 2 em rad/s
## cin.U1 :  Velocidade tangencial no contato do corpo 1 (m/s)
## cin.U2 :  Velocidade tangencial no contato do corpo 2 (m/s)
## cin.Vrol :  Velocidade de rolamento (U1+U2) (m/s)
## cin.Vesc :  Velocidade de escorregamento (|U1-U2|) (m/s)
## cin.Ve :  Velocidade de entrada (Vesc/somaU) (1)

#### Estrutura 'hertz' (calculadas pela teoria de Hertz)
## hertz.Rx :  Raio combinado na direção x (m)
## hertz.Ry :  Raio combinado na direção y (m)
## hertz.A :  Curvatura maior do contato (1/m)
## hertz.B :  Curvatura menor do contato (1/m)
## hertz.L : Largura do contato (m)
## hertz.invertido : Caso A esteja na direção Y, invertido será true
## hertz.k : Fator de elipcidade (1)
## hertz.elips : Fator de elipsidade para cálculo do tau0 (1)
## hertz.Ca : Coeficiente para a (1)
## hertz.Cdelta : Coeficiente para delta (1)
## hertz.Csigma : Coeficiente para sigma (1)
## hertz.Ctau : Coeficiente para tau (1)
## hertz.CZs : Coeficiente para Zs (1)
## hertz.Ctau0 : Coeficiente para tau0 (1)
## hertz.CZ0 : Coeficiente para CZ0 (1)
## hertz.Ecomb : Módulo elástico combinado (Pa)
## hertz.Fn : Força normal para cálculo (N)
## hertz.a :  Semi largura menor do contato (m)
## hertz.b :  Semi largura maior do contato (m)
## hertz.delta :  Penetração (m)
## hertz.pm :  Pressão média de Hertz (Pa)
## hertz.po :  Pressão máxima de Hertz (Pa)
## hertz.pr : Pressão de referência (Pa)
## hertz.sigma_max : Tensão máxima de Hertz (Pa)
## hertz.tau_max :  Tensão de cisalhamento máxima de Hertz (Pa)
## hertz.Zs :  Profundidade de taumax (m)
## hertz.delta_tau0 :  Amplitude da tensão de corte ortogonal (Pa)
## hertz.tau0 :  Amplitude da tensão de corte ortogonal (Pa)
## hertz.Z0 :  Profundidade de tau0 (m)
## hertz.x0 :  Localização em x de tau0 (m)

#### Estrutura 'lub' (referentes ao lubrificante)
## lub.m :  Parâmetro m da norma ASTM D341
## lub.n :  Parâmetro n da norma ASTM D341
## lub.v :  Viscosidade do lubrificante na temperatura de operação (mm2/s)
## lub.beta :  Coeficiente de termoviscosidade (K-1)
## lub.alfa :  Coeficiente de piezoviscosidade de Gold (Pa-1)
## lub.eta :  Viscosidade dinâmica na temperatura de operação (Pa*s)
## lub.k : Coeficiente de condutibilidade térmica (W/mK)

#### Estrutura 'esp' (referentes à espessura de filme lubrificante)
## esp.Uadm :  Parâmetro adimensional U
## esp.Gadm :  Parâmetro adimensional G
## esp.Wadm :  Parâmetro adimensional W
## esp.Co : Fator de correção de h0 para elíptico
## esp.h0_cru :  Espessura mínima de filme sem correção (m)
## esp.Cm : Fator de correção de hm para elíptico
## esp.hm_cru :  Espessura média de filme sem correção (m)
## esp.lambda_cru :  Espessura específica sem correção (1)
## esp.fi_t :  Fator de correção térmico para espessura de filme
## esp.L :  Fator L para correção térmica
## esp.h0_corr :  Espessura mínima de filme com correção térmica (1) (m)
## esp.hm_corr :  Espessura média de filme com correção térmica (1) (m)
## esp.lambda_corr :  Espessura específica com correção térmica (1)
## esp.deltaT :  Diferença de temperatura
## esp.Tcentro :  Temperatura no centro (°C)

#### Estruturo 'atrito' (referentes aos coeficientes de atrito calculados)
## atrito.kelley : atrito Kelley
## atrito.eng_iso : atrito ISO para engrenagens
## atrito.eng_michaelis : atrito Michaelis para engrenagens

#### Estrutura 'term' (referentes à térmica do contato)
## term.t1 : Parâmetro térmico do sólido 1 (N/mKs^0.5)
## term.t2 : Parâmetro térmico do sólido 2 (N/mKs^0.5) 
## term.Tflash : Temperatura Flash (aumento de temperatura das superfícies) (°C)
## term.deltacrook : Aumento de temperatura Crook do lubrificante (aumento de temperatura do lubrificante) (°C)
## term.Tcrook : Temperatura Crook (°C) (T0 + TFlash + deltacrook)
## term.exp_roelands_temperatura : Expoente da viscosidade de Roelands devido à temperatura
## term.exp_roelands_pressao : Expoente da viscosidade de Roelands devido à pressão
## term.eta_roelands : Viscosidade de Roelands à pressão p (Pa*s)
## term.deltaroelands : Aumento de temperatura Roelands do lubrificante (°C)
## term.Tmax_sup : Temperatura máxima das superfícies (T0 + TFlash) (°C)
## term.Tmax_lub : Temperatura máxima do lubrificante (Tmax_sup + deltaroelands) (°C)
