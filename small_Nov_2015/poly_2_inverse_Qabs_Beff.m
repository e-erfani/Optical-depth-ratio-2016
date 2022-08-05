clear
clc
plot_control
  grey = [0.4,0.4,0.4] ;
  pink = [1.0,0.4,0.6] ;
  purple = [0.5,0,0.5] ;

    fnames = dir('Beff2*.txt') ;

        fig_name = '2_poly_inverese_Qeff_Beff';
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,8.8,8.8]);
      set(fig_dum,'paperpositionmode','auto');
    

for kk=1:size(fnames)

   id = fopen(fnames(kk).name);
   if (kk==1)    
       data = textscan(id,'%f %f %f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,7};        
       inv_Qeff1 = data{1,8};
   else
       data = textscan(id,'%f %f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,6};        
       inv_Qeff1 = data{1,7};
   end
    
   if (kk == 1) 
        Beff = Beff1 ;
        inv_Qeff = inv_Qeff1 ;
    else
        Beff = [Beff ; Beff1] ;
        inv_Qeff = [inv_Qeff ; inv_Qeff1] ;
   end
    
%%%% plot %%%%
if (kk==1)
    h=scatter(Beff1,inv_Qeff1,'o');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',0.6)
elseif (kk==2)
    h=scatter(Beff1,inv_Qeff1,'s');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.6)
elseif (kk==3)
    h=scatter(Beff1,inv_Qeff1,'d');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.6)
end
hold on

end

%set(gca, 'YScale', 'log')

B_crv = 1:0.0005:1.7 ;
p = polyfit(Beff(isnan(inv_Qeff)==0),inv_Qeff(isnan(inv_Qeff)==0),2);
f = polyval(p,B_crv);

plot(B_crv,f,'-k','LineWidth',2)
  
[ffit,gof2] = fit(Beff(isnan(inv_Qeff)==0),inv_Qeff(isnan(inv_Qeff)==0),'poly2') ;

cor=sprintf('R^2=%g',gof2.rsquare);
cor2=sprintf('RMSE=%g',gof2.rmse);
equation=sprintf('y=%gx^2%gx+%g',p(1),p(2),p(3));
str = {equation , cor, cor2};
rrr=annotation('textbox', [.5071 .791, .1, .1], 'String', str);
set(rrr,'Fontsize',15)

%set(gca, 'XScale', 'log')
xlabel('\beta_e_f_f','fontSize',h_axis+6);
ylabel('2/Q_a_b_s_,_e_f_f(12\mum)','fontSize',h_axis+6);
box on
%ylim([1E5 1E9])
xlim([1 1.6])

set(gca,'XMinorTick','on','YMinorTick','on');
set(gca,'Fontsize',25,'linewidth',1.5)
  set(gca,'XMinorTick','on','YMinorTick','on','fontsize',h_tick+4);
     legend('Cirrus, SPARTICUS' ,'Aged Anvil Cirrus, TC4',...
             'Fresh Anvil Cirrus, TC4','curve fit'...
         ,'fontsize',h_legend-4,'location','southwest');
     set(gca,'fontsize',h_axis+6,'LineWidth',2);
    eval(['print -r600 -djpeg ', fig_name,'.jpg']);       
