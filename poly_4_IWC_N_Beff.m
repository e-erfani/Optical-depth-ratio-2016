clear
clc
plot_control
  grey = [0.4,0.4,0.4] ;
  pink = [1.0,0.4,0.6] ;
  purple = [0.5,0,0.5] ;

    fnames = dir('Beff2*.txt') ;

        fig_name = '3_poly_dot_fit_Beff';
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,8.8,8.8]);
      set(fig_dum,'paperpositionmode','auto');
    

for kk=1:size(fnames)

   id = fopen(fnames(kk).name);
   if (kk==1)    
       data = textscan(id,'%f %f %f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,8};        
       N_IWC1 = data{1,6} ./ data{1,3};
   else
       data = textscan(id,'%f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,6};        
       N_IWC1 = data{1,5} ./ data{1,3};       
   end
    
   if (kk == 1) 
        Beff = Beff1 ;
        N_IWC = N_IWC1 ;
    else
        Beff = [Beff ; Beff1] ;
        N_IWC = [N_IWC ; N_IWC1] ;
   end
    
%%%% plot %%%%
if (kk==1)
    h=scatter(Beff1,N_IWC1,'o');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',0.6)
elseif (kk==2)
    h=scatter(Beff1,N_IWC1,'s');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.6)
elseif (kk==3)
    h=scatter(Beff1,N_IWC1,'d');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.6)
end
hold on

end

set(gca, 'YScale', 'log')

B_crv = 0.5:0.05:1.7 ;
p = polyfit(Beff(isnan(N_IWC)==0),N_IWC(isnan(N_IWC)==0),4);
f = polyval(p,B_crv);

% crvft = p(1).*B_crv.^2 + p(2).*B_crv + p(3) ;
plot(B_crv,f,'-k','LineWidth',2)
  
[ffit,gof2] = fit(Beff(isnan(N_IWC)==0),N_IWC(isnan(N_IWC)==0),'poly4') ;

cor=sprintf('R^2=%g',gof2.rsquare);
cor2=sprintf('RMSE=%g',gof2.rmse);
equation=sprintf('y=%gx^4+%gx^3+%gx^2+%gx+%g',p(1),p(2),p(3),p(4),p(5));
str = {equation , cor, cor2};
rrr=annotation('textbox', [.24 .33, .1, .1], 'String', str);
set(rrr,'Fontsize',15)

%set(gca, 'XScale', 'log')
xlabel('\beta_e_f_f (unitless)','fontSize',h_axis+6);
ylabel('N / IWC (g^-^1)','fontSize',h_axis+6);
box on
ylim([1E5 1E9])
xlim([1 1.6])

set(gca,'XMinorTick','on','YMinorTick','on');
set(gca,'Fontsize',25,'linewidth',1.5)
  set(gca,'XMinorTick','on','YMinorTick','on','fontsize',h_tick+4);
     legend('Anvil Cirrus, SPARTICUS' ,'Aged Anvil Cirrus, TC4',...
             'Fresh Anvil Cirrus, TC4','curve fit'...
         ,'fontsize',h_legend-4,'location','southeast');
     set(gca,'fontsize',h_axis+6,'LineWidth',2);
    eval(['print -r600 -djpeg ', fig_name,'.jpg']);       
