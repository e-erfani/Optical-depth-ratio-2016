clear
clc
% define some colors
  grey = [0.4,0.4,0.4] ;
  pink = [1.0,0.4,0.6] ;
  purple = [0.5,0,0.5] ;

    fnames = dir('Beff2*.txt') ; % read input files

% define figure name, number, and size    
        fig_name = '2_poly_dot_fit_Beff';
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,8.8,8.8]);
      set(fig_dum,'paperpositionmode','auto');
    
% loop to read each input file and extract the variables
for kk=1:size(fnames) 

   id = fopen(fnames(kk).name);
   if (kk==1)    
       data = textscan(id,'%f %f %f %f %f %f %f %f','HeaderLines',3);  % scan the text for its data      
       Beff1 = data{1,8};  % read Beff      
       N_IWC1 = data{1,6} ./ data{1,3}; % read N / IWC
   else
       data = textscan(id,'%f %f %f %f %f %f','HeaderLines',3);        
       Beff1 = data{1,6};        
       N_IWC1 = data{1,5} ./ data{1,3};       
   end
    
   if (kk == 1) 
        Beff = Beff1 ;
        N_IWC = N_IWC1 ;
    else
        Beff = [Beff ; Beff1] ; % This adds the data from all 3 inputs into single vector
        N_IWC = [N_IWC ; N_IWC1] ;
   end
    
%%%% plot %%%%
if (kk==1)
    h=scatter(Beff1,N_IWC1,'o'); % scatter plot of input data, and the shape of marker
    set(h,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',0.6) % define color of marker body and marker edge
elseif (kk==2)
    h=scatter(Beff1,N_IWC1,'s');
    set(h,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.6)
elseif (kk==3)
    h=scatter(Beff1,N_IWC1,'d');
    set(h,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.6)
end
hold on

end

set(gca, 'YScale', 'log') % y scale is logarithmic

B_crv = 1:0.0005:1.7 ; % define a vector of Beff for curve fitting purpose
% calculate coefficients of 2nd-order polynomial curve fit:
p = polyfit(Beff(isnan(N_IWC)==0),N_IWC(isnan(N_IWC)==0),2); 
f = polyval(p,B_crv); % calculate the curve fit

plot(B_crv,f,'-k','LineWidth',2) % plot the curve fit

%another method of curve fit that calculates R squared and RMSE:
[ffit,gof2] = fit(Beff(isnan(N_IWC)==0),N_IWC(isnan(N_IWC)==0),'poly2') ; 

cor=sprintf('R^2=%g',gof2.rsquare); % define the string for R^2
cor2=sprintf('RMSE=%g',gof2.rmse);
equation=sprintf('y=%gx^2%gx+%g',p(1),p(2),p(3)); % define the string for the polynomial equation
str = {equation , cor, cor2}; % define the text for the box inside the figure
rrr=annotation('textbox', [.367 .33, .1, .1], 'String', str); % plot the box inside the figure
set(rrr,'Fontsize',15)

xlabel('\beta_e_f_f','fontSize',16+6); % label for x axis
ylabel('N / IWC (g^-^1)','fontSize',16+6);
box on % provide a closed rectangle around the plot
ylim([1E5 1E9]) % limits for Y axis
xlim([1 1.6])

set(gca,'XMinorTick','on','YMinorTick','on'); % minor tick is on
set(gca,'Fontsize',25,'linewidth',1.5)
  set(gca,'XMinorTick','on','YMinorTick','on','fontsize',12+4);
  % legend for the figure:
     legend('Cirrus, SPARTICUS' ,'Aged Anvil Cirrus, TC4',... 
             'Fresh Anvil Cirrus, TC4','curve fit'...
         ,'fontsize',12-4,'location','southeast');
     set(gca,'fontsize',16+6,'LineWidth',2);
    eval(['print -r600 -djpeg ', fig_name,'.jpg']); % print the figure as jpeg file      
