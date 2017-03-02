%size(onenex,2)
%behavior=[1:size(onenex,2)];
%onenex=onenex;
%testrasterunits(onenex,behavior);
function [a]=testrasterunits(onenex,behavior)
behavior=behavior(2);
for i=1:size(onenex(1, behavior).timestamps,2)
rasterparaName=onenex(1, behavior).timestamps(1, i).origin;
 plot_raster(rasterparaName);
end
