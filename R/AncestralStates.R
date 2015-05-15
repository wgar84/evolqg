#'Fast estimation of ML ancestral stated for multivariate continous traits
#'
#'This function is a wrapper for using phytools::fastAnc on multivariate data. 
#'
#'@param tree phylogenetic tree
#'@param x list of tip nodes data. Expects one vector for each terminal.
#'@param ... aditional arguments for phytools::fastAnc
#'@note Each trait is estimated independently. Parcimony estimation can be made by setting tree brach lengths to 1.
#'@return list with calculated ancestral states, using labels or numbers from tree
#'@export
#'@importFrom ape reorder.phylo 
#'@importFrom phytools fastAnc 
#'@import plyr
#'@examples
#'
#'data(dentus)
#'data(dentus.tree)
#'mean.list <- dlply(dentus, .(species), numcolwise(mean))
#'names(mean.list) <- dentus.tree$tip.label
#'AncestralStates(dentus.tree, mean.list)
AncestralStates <- function(tree, x, ...){
  p <- length(x[[1]])
  if(any(laply(x, length) != p)) stop("all tip vectors must have the same length")
  anc = vector("list", p)
  if(is.null(trait_names <- names(x[[1]]))) trait_names = paste(trait, 1:p, sep = "_")
  for(i in 1:p){
    tip_traits = laply(x, function(x) x[[i]])
    anc[[i]] = fastAnc(tree, tip_traits, ...)
  }
  names(anc) <- trait_names
  n = length(anc[[1]])
  if(class(anc[[1]]) == 'numeric'){
    ancestral_states <- unidimension_df_format(anc)
    return(ancestral_states)
  }
  if(n == 3){
    anc = alply(1:n, 1, function(i) llply(anc, function(x) x[[i]]), .dims = T)
    ancestral_states <- unidimension_df_format(anc[[1]])
    variances <- unidimension_df_format(anc[[2]])
    confidence_intervals <- bidimension_df_format(anc[[3]])
    return(list(ace = ancestral_states,
                vars = variances,
                CI = confidence_intervals))
  }
  if(n == 2){
    anc = alply(1:n, 1, function(i) llply(anc, function(x) x[[i]]), .dims = T)
    ancestral_states <- unidimension_df_format(anc[[1]])
    if(is.null(dim(anc[[2]][[1]]))){
      variances <- unidimension_df_format(anc[[2]])
      return(list(ace = ancestral_states,
                  vars = variances))
    }
    else{
      idence_intervals <- bidimension_df_format(anc[[2]])
      return(list(ace = ancestral_states,
                  CI = confidence_intervals))
    }
  }
}

#'@import plyr
#'@importFrom tidyr gather spread 
#'@importFrom magrittr %>% 
unidimension_df_format <- function(x) x %>%
  ldply(.id = 'traits') %>%
  gather(nodes, estimate, -traits) %>% 
  spread(traits, estimate)
#'@import plyr
#'@importFrom tidyr gather spread 
#'@importFrom magrittr %>% 
bidimension_df_format <- function(x) x %>% 
  ldply(.fun = function(x) data.frame(nodes = rownames(x), 
                                      upper = x[,2],
                                      lower = x[,1]), .id = 'traits') %>%
  gather(bound, estimate, -c(traits:nodes)) %>%
  spread(bound, estimate)