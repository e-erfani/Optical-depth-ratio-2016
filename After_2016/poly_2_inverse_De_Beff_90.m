clear
clc
cd /homes/eerfani/Beff/revision
plot_control
  grey = [0.4,0.4,0.4] ;
  pink = [1.0,0.4,0.6] ;
  purple = [0.5,0,0.5] ;

    fnames = dir('Beff3*.txt') ;

        fig_name = '2_poly_inverese_De_Beff_90';
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,8.8,8.8]);
      set(fig_dum,'paperpositionmode','auto');
    

for kk=1:size(fnames)

   id = fopen(fnames(kk).name);
   if (kk==1)    
       data = textscan(id,'%f %f %f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,7};        
       inv_De1 = 1 ./ data{1,2};
   elseif (kk==2)    
       data = textscan(id,'%f %f %f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,7};        
       inv_De1 = 1 ./ data{1,2};       
   else
       data = textscan(id,'%f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,6};        
       inv_De1 = 1 ./ (1E4 .* data{1,2});       
   end
    
   if (kk == 1) 
        Beff = Beff1 ;
        inv_De = inv_De1 ;
    else
        Beff = [Beff ; Beff1] ;
        inv_De = [inv_De ; inv_De1] ;
   end
    
%%%% plot %%%%
%yyaxis left
if (kk==1)
    h=scatter(Beff1,inv_De1,'o');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',0.6)
elseif (kk==2)
    h=scatter(Beff1,inv_De1,'s');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.6)
elseif (kk==3)
    h=scatter(Beff1,inv_De1,'d');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.6)
end
hold on

end

set(gca, 'YScale', 'log')

B_crv = 1:0.0005:1.7 ;
p = polyfit(Beff(1./inv_De<=90),inv_De(1./inv_De<=90),2);
f = polyval(p,B_crv);

plot(B_crv,f,'-k','LineWidth',2)
  
[ffit,gof2] = fit(Beff(1./inv_De<=90),inv_De(1./inv_De<=90),'poly2') ;

cor=sprintf('R^2=%g',gof2.rsquare);
cor2=sprintf('RMSE=%g',gof2.rmse);
equation=sprintf('y=%gx^2+%gx%g',p(1),p(2),p(3));
str = {equation , cor, cor2};
rrr=annotation('textbox', [.44 .42, .1, .1], 'String', str);
set(rrr,'Fontsize',15)

%set(gca, 'XScale', 'log')
xlabel('\beta_e_f_f','fontSize',h_axis+6);
%ylabel('D_e^-^1 (\mum^-^1)','fontSize',h_axis+6);
box on
ylim([1E-3 1E-1])
xlim([1 1.3])

hold on
[hAx,hLine1,hLine2] = plotyy(Beff1(1),inv_De1(1),Beff1(1),0/inv_De1(1),'scatter') ;
    %set(hAx,'color','w','MarkerFaceColor','w','LineWidth',0.1)

set(gca,'XMinorTick','on','YMinorTick','on');
set(gca,'Fontsize',20,'linewidth',1.5)
  set(gca,'XMinorTick','on','YMinorTick','on','fontsize',h_tick+4);
     legend('Synoptic Cirrus, SPARTICUS' ,'Anvil Cirrus, SPARTICUS'...%'Aged Anvil Cirrus, TC4','Fresh Anvil Cirrus, TC4','curve fit'...
         ,'fontsize',h_legend-8,'location','southeast');
     set(gca,'fontsize',h_axis+2,'LineWidth',2);
     set(hAx(2),'fontsize',h_axis+2,'LineWidth',2);
xlim(hAx(2), [1 1.3])

a2 = axes('XAxisLocation', 'Top')
set(a2, 'color', 'none')
set(a2, 'XTick', [],'LineWidth',2)
%set(a2, 'XLim', [1 1.3])
set(hAx(2),'Ydir','reverse')
ylabel(hAx(1),'D_e^-^1 (\mum^-^1)','fontSize',h_axis+6) % left y-axis 
ylabel(hAx(2),'D_e (\mum)','fontSize',h_axis+6) % right y-axis 
ylim(hAx(1), [1E-3 1E-1])
ylim(hAx(2), [10 1000])
xlim(hAx(1), [1 1.3])
xlim(hAx(2), [1 1.3])

eval(['print -r600 -djpeg ', fig_name,'.jpg']);       
