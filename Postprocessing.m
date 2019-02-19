
 
 
%%%%%%%%%%%%%----POSTPROCESSING for Transient cases----%%%%%%%%%%%%%%
n = 4;             % No. of time plots of process.
it = interp;
Ttime = linspace(0,tEnd,npx);
xt = linspace(X(1,1),X(end,1),npx);

for i = ceil(linspace(1,ntStep,n))
    it = it+1;
if i==1
    tt=(i-1)*dt;
else
    tt = i*dt;
end

    figure(it+1)
    xx  = reshape(X(:,1), npx, npy)';
    yy  = reshape(X(:,2), npx, npy)';
    sol = reshape(p(:,i), npx, npy)';
    surf(xx,yy,sol,'FaceColor','interp','EdgeColor','none');
    xlabel('Distance x (m)','FontSize',12);
    ylabel('Distance y (m)','FontSize',12);
    zlabel('Pressure (kPa)','FontSize',12);
    title(['time = ',num2str(tt),' (s)'])
    grid on; %view(3)
%     
% 
%  
%     % For Pressure profiles at center of 'y' i.e. along x-axis
% 
%     figure(it+20)
%     p_Yc = sol(ceil(npy/2),:);
%     plot(xt,p_Yc)
%     xlabel('Distance x (m)','FontSize',12);
%     ylabel('Pressure (kPa)','FontSize',12)
%     title(['time = ',num2str(tt),' (s)'])
%     grid on;



end



% A video of treansient flow process
% fid = 500;
% wObj = VideoWriter('out.avi');
% wObj.FrameRate = 25;
% open(wObj)

% for i = 1:length(Ttime)
%     figure(fid)
%     clf
%     patch('faces',T,'vertices',[X(:,1) X(:,2) p(:,i)],'facevertexcdata',p(:,i),...
%           'FaceColor','interp','EdgeColor',[0.5,0.5,0.5]);
% %     colormap(jet(100));
%     zlim([min(min(p)) max(max(p))])
%     xlabel('x')
%     ylabel('y')
%     view(3)
%     pause(1/15)
%     %     frame = getframe(gcf);
%     %     writeVideo(wObj, frame);
% end

% close(wObj);

