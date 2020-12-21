function [data, data_txt,raw]=read_input_excel()
  
  [raw,data_txt]=xlsread('input_data.xlsx');
  
  # Identify Infs
  cols_infs=data_txt(:,2);
  for i=1:length(cols_infs);
    if (strcmpi(cols_infs{i,1},'inf'));
      raw(i-1,1)=Inf;
    endif
  endfor
  
 
  # Table of values
  data.Rx1 = raw(1,1);
  data.Ry1 = raw(2,1);
  data.Rx2 = raw(3,1);
  data.Ry2 = raw(4,1);
  data.L = raw(5,1);
  
  data.E1 = raw(8,1);
  data.E2 = raw(9,1);
  data.poisson1 = raw(10,1);
  data.poisson2 = raw(11,1);
  
  data.C1 = raw(12,1);
  data.C2 = raw(13,1);
  data.K1 = raw(14,1);
  data.K2 = raw(15,1);
  data.ro1 = raw(16,1);
  data.ro2 = raw(17,1);
  
  data.Fn = raw(20,1);
  data.Po = raw(21,1);
  data.Tf = raw(22,1)+273;
  
  data.n1 = raw(25,1);
  data.n2 = raw(26,1);
  data.V1 = raw(27,1);
  data.V2 = raw(28,1);
  
  data.alfa = raw(1,5);
  data.k = raw(2,5);
  data.eta = raw(3,5);
  data.beta = raw(4,5);
  data.visc_cin = raw(5,5);
  
  data.T0 = raw(7,5)+273;
  data.eta0 = raw(8,5);
  data.T1 = raw(9,5)+273;
  data.eta1 = raw(10,5);
  data.SpecGrav = raw(11,5);
  data.a_lub = raw(12,5);
  data.s = raw(13,5);
  data.t = raw(14,5);
  
  data.amp1 = raw(4,9);
  data.wavelength1 = raw(5,9);
  data.sq1 = raw(7,9);
  
  data.amp2 = raw(11,9);
  data.wavelength2 = raw(12,9);
  data.sq2 = raw(14,9);
  
  # If Fn value is valid, disconsider Po, otherwise, disconsider Fn
  # Script will verify which is disconsidered and calculate from considered
  if (isnumeric(data.Fn) && ~isnan(data.Fn) && data.Fn>0)
    data.Po=0;
  else
    data.Fn=0;
  end
  
  # Read the Xs
  # Position of each X in order (i.e. txtdata1 is on line3 and column10)
  linha = [20, 3, 10, 2, 3, 4, 5, 6];
  coluna = [8, 10, 10, 14, 14, 14, 14, 14];
  nvar = length(linha);
  booleano = zeros(nvar,1);
  
  for i=1:nvar
    if strcmpi(data_txt(linha(i), coluna(i)), 'x')
      booleano(i)=1;
    end
  end
  
  # Condição múltipla
  data.multiple = booleano(1);
  data.varstr = data_txt(21,8);
  data.resstr = data_txt(24,8);
  data.vector = linspace(raw(22,5), raw(22,7), raw(22,9));
  
  # Outros X
  data.txtdata1 = booleano(2);
  data.txtdata2 = booleano(3);
  data.plot_kandconstants = booleano(4);
  data.plot_txtdata = booleano(5);
  data.plot_surfaces = booleano(6);
  data.plot_stresses = booleano(7);

  # Caso for multiplo, não plotar nada
  if data.multiple
      data.plot_kandconstants = 0;
      data.plot_txtdata = 0;
      data.plot_surfaces = 0;
      data.plot_stresses = 0;
      end
  
  return