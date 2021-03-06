# initializeGeneTable


GeneTable <- read.csv("data/human_genes.csv")
GeneTable$SYMBOL <- as.character(GeneTable$SYMBOL)

dups <- (GeneTable %>% count(SYMBOL) %>% filter(n > 1))$SYMBOL
GeneTable <- GeneTable %>% filter(!SYMBOL %in% dups)
rownames(GeneTable) <- GeneTable$SYMBOL

geneSymbolToID <- function(symbols, GeneTable) {
  m <- match(symbols, GeneTable$SYMBOL)
  data.frame(Symbol = as.character(symbols), ID = as.character(GeneTable$GeneID)[m],
             stringsAsFactors = FALSE)
}


geneIDs <- GeneTable$GeneID
names(geneIDs) <- GeneTable$SYMBOL


id <- geneSymbolToID(CONFIG$DEFAULT.GENE, GeneTable)$ID

if (is.na(id)) {
   msg <- paste0("invalid default gene: ", CONFIG$DEFAULT.GENE)
   alert(msg)
   id <- 178
}
updateSelectizeInput(session, "geneInput", choices = geneIDs, selected = id, server = TRUE)

#  toggleModal(session, "welcomeModal")

