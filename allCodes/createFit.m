function fitresult = createFit(xs, ys)
% Fit: 
% close all
[xData, yData] = prepareCurveData( xs, ys );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.00598631971947078;

% Fit model to data.
fitresult = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 2' );
% h = plot( fitresult, xData, yData );
% legend( h, 'ys vs. xs', 'untitled fit 2', 'Location', 'NorthEast' );
% % Label axes
% xlabel xs
% ylabel ys
% grid on
% 

