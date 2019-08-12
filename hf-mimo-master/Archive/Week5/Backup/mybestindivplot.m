function state = mybestindivplot(options, state,flag)

if(strcmp(flag,'init'))
    xlim([1,options.MaxGenerations]);
    hold on;
    xlabel Generation
end

if state.Generation == 0
else
    [~,i] = min(state.Score);
    best = state.Population(i,:);
    display(best(1))
    plot(state.Generation, double(best(1)), '-','LineWidth',1.5);
end

end