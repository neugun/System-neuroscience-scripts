% % Create figures and axes;
% Plot behaviors
%     maxX = 0;
%     h = NaN(2,1); % Handles for making legend in single axes
%     disp('Plotting');
%     for i=1:numLogs
%         disp(['Log ',num2str(i),' of ',num2str(numLogs),': ',files{i},...
%             '...']);
%         %open log
%         log=open([directory,files{i}]);
%         if ~isfield(log.info,'vfpsoi')
%             warning('prettyrasters:oldlog',[files{i},...
%                 ' is too old for this script.  Convert and try again.']);
%         else 
%             maxX=max(maxX,(log.markslog.framenum(log.markslog.endindex)-...
%                 log.markslog.framenum(log.markslog.startindex))/...
%                 log.info.vfpsoi/60); % keep track of longest log
%             
%             for j=1:numBehavs
%                 behavChar=behavChars(j);
%                 if choice == 2 % axes per log
%                     htmp = plotline(axesHandles(i),log,behavChar,j,...              %plotline
%                         colors{j});
%                 else
%                     htmp = plotline(axesHandles,log,behavChar,i,colors{j});
%                 end
%                 if ~isnan(htmp)
%                     h(j)=htmp(1);
%                 end
%             end
%         end
%     end
%     clear i j behavChar log colors htmp
%     clear behavChars
%     %% Modify plots (colors, axes limits, tick marks, etc)
%     % If there's only one set of axes, yticklabels will be filenames and a
%     % legend to the behaviors will put in a separate figure.  If there the
%     % behaviors are on separate lines, the titles of the axes will be the
%     % filenames and the behaviors will be the yticklabels.
%     
%     set(figHandles,'color',bgcolor,'inverthardcopy','off');
%     set(axesHandles,'color',bgcolor,'xcolor',fgcolor,'ycolor',fgcolor);
%     linkaxes(axesHandles);
%     set(axesHandles,'xlim',[0,maxX],'fontsize',12);
%     clear maxX
%     if choice == 2 % axes per log
%         set(axesHandles,'ylim',[0,numBehavs+1],...
%             'ytick',1:numBehavs,'yticklabel',behavDesc);
%         cellfun(@(x,y) set(get(x,'title'),'string',strrep(y,'_','\_')...
%             ,'fontsize',12,'color',fgcolor),num2cell(axesHandles),files);
%         legendFig=NaN;
%     else % one set of axes, one line per log
%         set(axesHandles,'ylim',[0,numLogs+1],...
%             'ytick',1:numLogs,'yticklabel',...
%             files);
%             %cellfun(@(y) strrep(y,'_','\_'),files,'UniformOutput',false));
%         set(get(axesHandles,'title'),'string','Rasters','fontsize',14,...
%             'color',fgcolor);
%         lh = legend(h,behavDesc,'textcolor',fgcolor,'fontsize',14,...
%             'color','none','box','off','units','pixels');
%         p = get(lh,'position');
%         legendFig = figure('units','pixels','menubar','none',...
%             'position',[100,300,p(3),p(4)],'color',bgcolor,...
%             'inverthardcopy','off');
%         set(lh,'parent',legendFig,'position',[0,0,p(3),p(4)]);
%         clear lh p
%     end
%     
% %% Save plots (optional)
%     answer = questdlg('Save rasters?','Save','Yes','No','Yes');
%     if strcmpi('Yes',answer)
%             d = cd;
%             newdir = ['Rasters',datestr(clock,'yyyymmdd-HHMMSS')];
%             mkdir(newdir);
%             cd(newdir);
%             filePref = numberedList('Raster',1:length(figHandles));
%             figHandles=figHandles(:)';
%             for i = find(ishandle(figHandles))
%                 print(figHandles(i),'-dpng',[filePref{i},'.png']);
%             end
%             if ishandle(legendFig)
%                 print(legendFig,'-dpng','Legend.png');
%             end
%             cd(d);
%             clear d newdir filePref i
%     end
%     clear answer
%     
% %% Close plots (optional)
%     answer = questdlg('Close raster figures?','Close','Yes','No','Yes');
%     if strcmpi('Yes',answer)
%             close(figHandles(ishandle(figHandles)));
%             close(legendFig(ishandle(legendFig)));
%     end
%     clear answer
%     
% %% Return handles of open axes
%     axesHandles=axesHandles(ishandle(axesHandles));
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    