function [Tz,Sq,Sa]=rough_read_txt(body, toplot)
  wtitle=sprintf('Selecionar .txt para CORPO %d', body);
  [name,path_name]=uigetfile('*.txt',wtitle);
  fullname={fullfile(path_name, name)};
  
  aux_name = fullname{:,:};
  T1 = importdata(aux_name, '\t');
  
  MatrizSize1 = find(T1(:,1)==0); % Size in pixels
  MatrizSize2 = find(T1(:,2)==0); % Size in pixels
  th1=length(MatrizSize1);
  th2=length(MatrizSize2);
  Tx = zeros(th1,th2);
  Ty = zeros(th1,th2);
  Tz = zeros(th1,th2);
  a_test=0;
  b_test=1;
  cont=0;
  
  for i1=1:length(T1)
    if (mod(cont,th2)==0)
      a_test=a_test+1;
      b_test=1;
    end
    Ty(a_test,b_test)=T1(i1,1)./1000000;
    Tx(a_test,b_test)=T1(i1,2)./1000000;
    Tz(a_test,b_test)=T1(i1,3)./1000000;
    b_test=b_test+1;
    cont=cont+1;
  end
  
  Sa = mean(mean(abs(Tz)));
  Sq = mean(rms(Tz));
  
  if toplot
    figure
    plot (Tx(:,50),Tz(:,50)*1000000,'b','DisplayName','Direção X');
    hold on
    plot (Ty(50,:),Tz(50,:)*1000000,'k','DisplayName','Direção Y');
    h = legend();
    xlabel('Position', 'Fontsize',16)
    ylabel('Heigh (um)', 'Fontsize',16)
    set(gca, "linewidth", 4, "fontsize", 16)
    set(h, 'FontSize', 16)
  end
endfunction
