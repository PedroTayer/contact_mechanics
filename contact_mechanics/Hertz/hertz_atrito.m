function mult=hertz_atrito(mi)
  coeficientes=[0,1/12,1/9,1/6,1/3];
  x=[0:0.001:0.4];
  
  sigma_tracao=[0,2/12,2/9,2/6,2/3]
  sigma_compressao=[-1, -1.09, -1.13, -1.19, -1.40];
  cis_max=[0.3, 0.308, 0.310, 0.339, 0.435];
  cis_oct_max=[0.272, 0.265, 0.255, 0.277, 0.368];
  
  y1=interp1(coeficientes, sigma_tracao, x, "pchip", 'EXTRAP');
  y2=interp1(coeficientes, sigma_compressao, x, "pchip", 'EXTRAP');
  y3=interp1(coeficientes, cis_max, x, "pchip", 'EXTRAP');
  y4=interp1(coeficientes, cis_oct_max, x, "pchip", 'EXTRAP');
  
  coef_desejado=find(x==round(1000*mi)/1000);
  
  mult.sig_tracao=y1(coef_desejado);
  mult.sig_comp=y2(coef_desejado);
  mult.cisalhamento_maximo=y3(coef_desejado);
  mult.cisalhamento_octaedrico_maximo=y4(coef_desejado);
  
##  figure
##  plot(coeficientes,sigma_tracao,'ko','LineWidth',2, 'DisplayName', 'Dados')
##  grid on
##  hold on
##  plot(x,y1,'b-','LineWidth',2, 'DisplayName', 'Interoplação')
##  xlabel('Coeficiente de atrito', 'Fontsize',16)
##  ylabel('Tensão de tração principal máxima / \sigma_{ref}', 'Fontsize',16)
##  set(gca, "linewidth", 4, "fontsize", 16)
##
##  figure
##  plot(coeficientes,sigma_compressao,'ko','LineWidth',2, 'DisplayName', 'Dados')
##  grid on
##  hold on
##  plot(x,y2,'b-','LineWidth',2, 'DisplayName', 'Interoplação')
##  xlabel('Coeficiente de atrito', 'Fontsize',16)
##  ylabel('Tensão de compressão principal máxima / \sigma_{ref}', 'Fontsize',16)
##  set(gca, "linewidth", 4, "fontsize", 16)
##
##  figure
##  plot(coeficientes,cis_max,'ko','LineWidth',2, 'DisplayName', 'Dados')
##  grid on
##  hold on
##  plot(x,y3,'b-','LineWidth',2, 'DisplayName', 'Interoplação')
##  xlabel('Coeficiente de atrito', 'Fontsize',16)
##  ylabel('Tensão de corte máxima / \sigma_{ref}', 'Fontsize',16)
##  set(gca, "linewidth", 4, "fontsize", 16)
##
##  figure
##  plot(coeficientes,cis_oct_max,'ko','LineWidth',2, 'DisplayName', 'Dados')
##  grid on
##  hold on
##  plot(x,y4,'b-','LineWidth',2, 'DisplayName', 'Interoplação')
##  xlabel('Coeficiente de atrito', 'Fontsize',16)
##  ylabel('Tensão de corte octaédroca máxima / \sigma_{ref}', 'Fontsize',16)
##  set(gca, "linewidth", 4, "fontsize", 16)

endfunction

