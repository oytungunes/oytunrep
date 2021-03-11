function [ Tree ] = find_tree( data,treshold, numberofiteration,numberofsamplestoiterate )


%% Contruct first node
Tree = struct('entropy',{},'feature',{},'splitvalue',{},'data',{},'left',{},'right',{},'label',{},'ispure',{},'classdis',{},'isfinished',{});
balanced_data=data;
[leftdata,rightdata, entropy_of_features,min_entropy_of_node,feature,split_of_node]=find_split( balanced_data);
Tree(1).data=balanced_data;
Tree(1).left=leftdata;
Tree(1).right=rightdata;
Tree(1).entropy=min_entropy_of_node;
Tree(1).feature=feature;
Tree(1).splitvalue=split_of_node;
[ label, numberofclasses,ispure ] = find_classes( balanced_data);
Tree(1).label=label;
Tree(1).classdis=numberofclasses;
Tree(1).ispure=ispure;
Tree(1).isfinished=false;

% Iteratively find the Decision Tree
%----------1--------
%----2----------3---
%%4-----5 ----6---7-
treshold=0.12;
numberofiteration=60;
numberofsamplestoiterate=2;
for i=1:numberofiteration     
   if(Tree(i).entropy>treshold   & sum(Tree(i).classdis)>numberofsamplestoiterate)
        Tree(i).isfinished=false;
        Tree(2*i).data=Tree(i).left;
        Tree(2*i+1).data=Tree(i).right;

        %check purity for left
        if(isempty(Tree(i).left)==0)
            [ label, numberofclasses,ispure ] = find_classes( Tree(2*i).data); 
            Tree(2*i).label=label;
            Tree(2*i).classdis=numberofclasses;
            Tree(2*i).ispure=ispure;
            %if not pure find the split
                if (ispure==0)    
                    [Tree(2*i).left,Tree(2*i).right, entropy_of_features,Tree(2*i).entropy,Tree(2*i).feature,Tree(2*i).splitvalue]=find_split( Tree(2*i).data);
                else
                    Tree(2*i).entropy=0;
                end;
        end;
         %check purity for right
        if(isempty(Tree(i).right)==0)
            [ label, numberofclasses,ispure ] = find_classes( Tree(2*i+1).data);
            Tree(2*i+1).label=label;
            Tree(2*i+1).classdis=numberofclasses;
            Tree(2*i+1).ispure=ispure;
                if (ispure==0)    
                    [Tree(2*i+1).left,Tree(2*i+1).right, entropy_of_features,Tree(2*i+1).entropy,Tree(2*i+1).feature,Tree(2*i+1).splitvalue]=find_split( Tree(2*i+1).data);
                else
                    Tree(2*i+1).entropy=0;
                end;
        else 
        end;
   else
       % if the entropy is empty do not label as finished
       if(isempty(Tree(i).entropy))
           
       else
            Tree(i).isfinished=true;
       end;
   end; 


end;
 
Tree=Tree(1:60);




end
