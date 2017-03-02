EVT01=EVT01(:,1);
S=length(EVT01);
Evt=zeros(S,1);
Stim_F=1/10;
 for j=2:1:S-1
if EVT01(j)-EVT01(j-1)>Stim_F&&EVT01(j+1)-EVT01(j)<Stim_F/2
    Evt(j)=EVT01(j);
end
 end
  Evt(1)=EVT01(1);
 EVt=nonzeros(Evt);
  
