function [rfr,err,rmse,r2,Y_fit,delta] = ...
    fit_rfr(X_mod,Y_mod,idx_vars,idx_group,headers)

% set parameters for random forest
nTrees = 20;
minLeafSize = 5;
numpredictors = 6;

% pre-allocate error stats
err = nan(max(idx_group),1);
rmse = nan(max(idx_group),1);
r2 = nan(max(idx_group),1);

% for each cluster
for c = 1:max(idx_group)

    % cluster label
    clab = ['c' num2str(c)];
    
    % define X and Y datasets for each cluster
    X_temp = X_mod(idx_group==c,idx_vars);
    Y_temp = Y_mod(idx_group==c);
    
        % set up cross-validation
        numFolds = 5;
        sz = length(Y_temp);
        ints = randperm(length(Y_temp))';

        % pre-allocate
        Y_fit.(clab) = nan(sz,1);
        delta.(clab) = nan(sz,1);

        % for each fold
        for f = 1:numFolds

            % fold label
            flab = ['f' num2str(f)];
        
            % index for cross-validation training and test
            idx_test = ints > (f-1) * (sz/numFolds) & ints <= f * (sz/numFolds);
            idx_train = ~idx_test;
            
            % get train and test data for this fold
            X_train = X_temp(idx_train,:);
            Y_train = Y_temp(idx_train);
            X_test = X_temp(idx_test,:);
            Y_test = Y_temp(idx_test);

            % construct random forest
            rfr_cv.(clab).(flab) = ...
                TreeBagger(nTrees,X_train,Y_train,'Method','regression',...
                    'OOBPrediction','off','OOBPredictorImportance','off');
        
            % test random forest
            Y_fit.(clab)(idx_test) = ...
                predict(rfr_cv.(clab).(flab),X_test);
            delta.(clab)(idx_test) = Y_fit.(clab)(idx_test)-Y_test;
        
        end

        % save network error statistics for each fold
        err(c) = mean(delta.(clab));
        rmse(c) = sqrt(mean(delta.(clab).^2));
        r2(c) = corr(Y_fit.(clab),Y_temp).^2;

        % construct random forest with all data
        rfr.(clab) = ...
            TreeBagger(nTrees,X_temp,Y_temp,'Method','regression',...
                'OOBPrediction','on','OOBPredictorImportance','on');

        % Plot Out-of-Bag MSE based on tree number
        figure;
        plot(sqrt(oobError(rfr.(clab))),'k','LineWidth',2);
        xlabel('Number of Grown Trees');
        ylabel('Out-of-Bag Root Mean Squared Error');
        
        % Plot importance of each predictor
        figure;
        set(gcf,'units','normalized','outerposition',[0 0 0.5 0.5]);
        set(gca,'fontsize',22);
        bar(rfr.(clab).OOBPermutedPredictorDeltaError,'k');
        set(gca,'fontsize',16);
        xlabel('Predictors');
        ylabel('Out-of-Bag Feature Importance');
        xticklabels(headers(idx_vars));

end

% end function
end