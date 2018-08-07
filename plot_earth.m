% This script plots Earth's surface. Data file earth_topo.mat 
% has the earth topographical data. The axes are normalized by 10^6 m.

Re = 6.37e6;
load('earth_topo.mat'); 
figure(1);
[x,y,z] = sphere(50);
s = surf(Re*x/1e6,Re*y/1e6,Re*z/1e6); % create a sphere
s.CData = topo;                % set color data to topographic data
s.FaceColor = 'texturemap';    % use texture mapping
s.EdgeColor = 'none';          % remove edges
s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
s.SpecularStrength = 0.4;      % change the strength of the reflected light
grid on; box on; axis equal;
axis(8*[-1 1 -1 1 -1 1]);
xlabel('x (10^6 m)'); ylabel('y (10^6 m)'); zlabel('z (10^6 m)'); title('Earth');
set(gca,'LineWidth',1,'FontSize',14, ...
        'Xtick',[-8:4:10],'Ytick',[-8:4:10],'Ztick',[-8:4:8]);
