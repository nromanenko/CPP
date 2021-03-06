

# Gets chemical counts for each disease
getChemByDiseaseContingency <- function(pmids, con) {
  pmids <- paste0("'",pmids,"'", collapse = ",")
  
  qry <- paste0("SELECT 
  distinct DT.Term AS Disease, CT.Term as Chemical, Frequency
  FROM
  (SELECT 
  TT.Disease AS Disease,
  TT.Chem AS Chem,
  COUNT(TT.Chem) AS Frequency
  FROM
  (SELECT 
  PubChem.PMID AS PMID,
  PubChem.MeshID AS Chem,
  PubMesh.MeshID AS Disease
  FROM
  PubChem
  INNER JOIN PubMesh ON PubMesh.PMID = PubChem.PMID
  WHERE
  PubChem.PMID IN (", pmids,  ")) AS TT
  GROUP BY TT.Disease, TT.Chem) AS R
  inner join MeshTerms as DT ON DT.MeshID = R.Disease
  inner join PharmActionTerms as CT ON CT.MeshID = R.Chem
  where DT.TreeID like 'C04.%'
  ;")
  
  runQuery(con, qry, "Chem by Disease query:")
  
}


#mutations by disease (cancer only)
getMutByDiseaseContingency <- function(pmids, con) {
  pmids <- paste0("'",pmids,"'", collapse = ",")
  qry <- paste0("SELECT 
distinct DT.Term AS Disease, R.Mutation as Mutation, Frequency
FROM
(SELECT 
  TT.Disease AS Disease,
  TT.Mutation AS Mutation,
  COUNT(TT.Mutation) AS Frequency
  FROM
  (SELECT 
    PubMut.PMID AS PMID,
    PubMut.MutID AS Mutation,
    PubMesh.MeshID AS Disease
    FROM
    PubMut
    INNER JOIN PubMesh ON PubMesh.PMID = PubMut.PMID
    WHERE
    PubMut.PMID IN (", pmids,  ")) AS TT
  GROUP BY TT.Disease , TT.Mutation) AS R
  inner join MeshTerms as DT ON DT.MeshID = R.Disease
  where DT.TreeID like 'C04.%'
  ;")
  runQuery(con, qry, "Chem by Disease query:")
}


# Gets cancer term counts for each disease
getCancerTermsByDiseaseContingency <- function(pmids, con) {
  pmids <- paste0("'",pmids,"'", collapse = ",")
  
  qry <- paste0("SELECT 
  distinct DT.Term AS Disease, CT.Term as Term, Frequency
  FROM
  (SELECT 
    TT.Disease AS Disease,
    TT.Term AS Term,
    COUNT(TT.Term) AS Frequency
    FROM
    (SELECT 
      PubCancerTerms.PMID AS PMID,
      PubCancerTerms.TermID AS Term,
      PubMesh.MeshID AS Disease
      FROM
      PubCancerTerms
      INNER JOIN PubMesh ON PubMesh.PMID = PubCancerTerms.PMID
      WHERE
 PubCancerTerms.PMID IN (", pmids,  ")) AS TT
    GROUP BY TT.Disease, TT.Term) AS R
  inner join MeshTerms as DT ON DT.MeshID = R.Disease
  inner join CancerTerms as CT ON CT.TermID = R.Term
  where DT.TreeID like 'C04.%'
                ;")
  runQuery(con, qry, "CancerTerm by Disease query:")
  
}

# Gets gene counts for each disease
getGenesByDiseaseContingency <- function(pmids, con) {
  pmids <- paste0("'",pmids,"'", collapse = ",")
  
  qry <- paste0("SELECT 
  distinct DT.Term AS Disease, CT.SYMBOL as Gene, Frequency
  FROM
  (SELECT 
    TT.Disease AS Disease,
    TT.Term AS Term,
    COUNT(TT.Term) AS Frequency
    FROM
    (SELECT 
      PubGene.PMID AS PMID,
      PubGene.GeneID as Term,
      PubMesh.MeshID AS Disease
      FROM
      PubGene
      INNER JOIN PubMesh ON PubMesh.PMID = PubGene.PMID
      WHERE
 PubGene.PMID IN (", pmids,  ")) AS TT
    GROUP BY TT.Disease, TT.Term) AS R
  inner join MeshTerms as DT ON DT.MeshID = R.Disease
  inner join Genes as CT ON CT.GeneID = R.Term
  where DT.TreeID like 'C04.%'
                ;")
  runQuery(con, qry, "Genes by Disease query:")
  
}



