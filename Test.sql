-- ---------------------------------------------------TEST FONCTION --------------------------------------------------------
    SELECT fonc_evaluation(11) FROM DUAL;
    SELECT fonc_evaluation(1) FROM DUAL;
    
-- ---------------------------------------------------TEST PROCEDURE --------------------------------------------------------
    EXECUTE ListPreferances(1);
-- ------------------------------------------------TEST DES  TRIGGERS -----------------------------------------------------------

     --empecher_modif_categorie
     UPDATE OBJET SET description_cat='Film' where id_objet =1;
     
     --verifie_categorie
     INSERT INTO APPARTIENT_A VALUES (12,10,'Bijoux');
     
       --ajout_liste_mois_annee
     INSERT INTO UTILISATEUR VALUES(26,'DDiop', 'Diop', 'Diomasy', 'Esplanade Escale', 'diouma@example.com', 'dio2@Fall', '3/04/1999', '22/04/2021');
     select * from LISTE_MOIS_ANNEE;
     
     --Archivage
     DELETE FROM LISTE where id_liste = 2;
     DELETE FROM LISTE where id_liste = 4;
     select * from APPARTIENT_A_ARCHIVE;
     select * from LISTE_ARCHIVEE;
     
     
   


