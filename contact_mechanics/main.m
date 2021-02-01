clear all
close all
clc
format long

addpath('./Read_input')

% 2020 Contact Mechanics
% UTFPR - Professor Tiago Cousseau
% Development: Pedro Del Negro Tayer
# pedro.negro.tayer@gmail.com

%%%%%%%%%%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%%%%%%
% Read input data and allocate on variables
[data,data_txt,raw]=read_input_excel();

% If there is .txt roughness data, process it before
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

% If there is no parameter variation, run for unique case
if ~data.multiple
  [data, hertz, lubricant, cin, thickness, friction, thermal, rough]=contact_mechanics(data, 0);
  results=cell2struct({data, hertz, lubricant, cin, thickness, friction, thermal, rough}',{'data','hertz','lubricant','cin','thickness','friction','thermal','rough'});
else
  % Definição 
  pct=0;
  fprintf('\n')
  for i=1:length(data.vector)
    
    % Show percentages of conclusion
    pctnew=i/length(data.vector)-pct;
    if pctnew>0.1
      pct=i/length(data.vector);
      sprintf('%.2f%% concluded...', 100*pct)
    end
    
    % Change data structure variable with value from inputed vector
    data=substitute_values_on_structure(data.varstr, data.vector(i), data);
    
    % Call calculation for these values
    [data, hertz, lubricant, cin, thickness, friction, thermal, rough] = contact_mechanics(data, 0);
    results{i}={data, hertz, lubricant, cin, thickness, friction, thermal, rough};
  end
  sprintf('100%% concluded!')
  
  % Extract value from structure
  for i=1:length(results)
    value(i)=extract_values_from_structure(data.resstr, results{1,i});
  end
  value=cell2mat(value);
  
  %%% Plotar valores
  figure
  plot(data.vector,value,'b','LineWidth',3);
  grid on
  xlabel(strrep(data.varstr,'_',' '), 'Fontsize',16)
  ylabel(strrep(data.resstr,'_',' '), 'Fontsize',16)
  set(gca, "linewidth", 4, "fontsize", 16)
  
  rmpath('./Read_input')

  
end
