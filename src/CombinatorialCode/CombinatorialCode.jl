###################### This is the type that defines combinatorial codes
type CombinatorialCode <: FiniteSetCollection
                words::Array{CodeWord,1}   # the codewords, these are ordered by the weights (in the increasing order)
                weights::Array{Int,1} # the sizes of the codewords in the same order as the words
                MaximumWeight::Int  #
                Minimumweight::Int  #
                Nwords::Int       	# total number of codewords in the code
                neurons::CodeWord 	# the set of all neurons that show up in the code
  ## this is the constructor for the CombinatorialCode type. It takes a list of Integer arrays, where each array represents a codeword
  ## codewords are checked for duplication
  function CombinatorialCode(ListOfWords::Array{Any,1})
           if length(ListOfWords)<1; println("WARNING: Empty code passed!!");
               return new([], Array{Int,1}([]),-1,-1,0,emptyset)
           end
           neurons=emptyset # keep track of all the vertices here
           # First, compute the weights
           weights=zeros(Int,length(ListOfWords))
           for i=1:length(ListOfWords)
            weights[i]=length(unique(ListOfWords[i]))
           end
           MaximumWeight=maximum(weights)
           Minimumweight=minimum(weights)
           # next we figure out if there are any duplicate words in the list and populate the list of sets named words
           words=Set[];
           ThereWereDuplicates=false
           for w= Minimumweight:MaximumWeight
               Ind=find(weights.==w);
               L=length(Ind);
                if L>0
               	   CurrentListOfWords=Set[];
               # if there was more than one word with the same weights we check the repeated words
               	  for j=1:L
               	  	    CurrentSet=CodeWord((ListOfWords[Ind[j]]))
                        CurrentSetIsDuplicated=false
                        for k=1:length(CurrentListOfWords) # check the previous words of the same weight is duplicated, if yes, then discard the CurrentSet
                        	if CurrentListOfWords[k]==CurrentSet
                        		CurrentSetIsDuplicated=true
                                ThereWereDuplicates=true
                        		break
                        	end
                        end
                        if ~CurrentSetIsDuplicated
                        push!(CurrentListOfWords,CurrentSet)
                        push!(words,CurrentSet)
                        neurons=union(neurons,CurrentSet)
                        end
               	    end
                 end
            end
            Nwords=length(words)
            # now we recompute the weights for possibly reduced list, since we removed all the duplicates
            weights=zeros(Int,Nwords)
            for i=1:Nwords ; weights[i]=length(words[i]); end
           if ThereWereDuplicates println("Warning: There were duplicated words") end
           new(words,weights,MaximumWeight,Minimumweight,Nwords,neurons)
        end
    end
###############################################################################################


# This is a function that detects if the code has the empty set:
HasEmptySet(code::CombinatorialCode)=in(emptyset,code)

# This function detects if the code is null, i.e. has no codewords whatsoever
# Since "null" and "void" are used interchangeably throughout the documentation, here are two ways to check the same thing.
isNull(code::CombinatorialCode)=(length(code.words)==0)
isVoid(code::CombinatorialCode)=isNull(code)