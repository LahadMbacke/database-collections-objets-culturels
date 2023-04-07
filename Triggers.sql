----------------------------CONTRAINTES--------------------
      
-- Un trigger qui empêche la modification de la catégorie d'un objet s'il appartient à une collection:
CREATE OR REPLACE TRIGGER empecher_modif_categorie
BEFORE UPDATE ON OBJET
FOR EACH ROW
  DECLARE 
   nbr integer;
BEGIN
  SELECT COUNT(*) INTO nbr FROM APPARTIENT_A WHERE id_objet = :OLD.id_objet;
  IF nbr > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Impossible de modifier la catégorie de l''objet car il appartient à une collection');
  END IF;
END;
/

--Le trigger verifie_categorie a pour objectif de vérifier 
--que l'objet culturel à ajouter à une liste appartient à la même catégorie
--que la liste et que la catégorie de l'objet est correcte.

CREATE OR REPLACE TRIGGER verifie_categorie
BEFORE INSERT ON APPARTIENT_A 
FOR EACH ROW
  DECLARE
   App_descObj_v APPARTIENT_A.descriptif_objet_liste%TYPE;
   descObj_v OBJET.description_cat%TYPE;
   descList_v LISTE.description_cat%TYPE;
  BEGIN 
     select description_cat into descObj_v  FROM OBJET WHERE id_objet = :new.id_objet;
     select description_cat into descList_v  FROM LISTE WHERE id_liste = :new.id_liste;
     IF LOWER(:new.descriptif_objet_liste) != LOWER(descObj_v) THEN
      RAISE_APPLICATION_ERROR(-20004,'Objet et la liste ne sont pas compatible');
      END IF;
    IF LOWER(:new.descriptif_objet_liste) != LOWER(descList_v) THEN
      RAISE_APPLICATION_ERROR(-20004,'Objet et la liste ne sont pas compatible');
    END IF;
  END;
/
 --1. Définir les listes des ajouts du mois 'xxx' pour l'année 'yyy' pour un utilisateur
--« nouveauté ».
--Chaque nouvel objet culturel ajouté dans la base de donées au courant du mois 'xxx'
--de l’année 'yyy' est ajouté à la liste correspondante.
CREATE OR REPLACE TRIGGER ajout_liste_mois_annee
AFTER INSERT ON UTILISATEUR
 FOR EACH ROW
  DECLARE
   CURSOR objets_mois_annee IS
    SELECT * FROM OBJET WHERE SUBSTR(TO_CHAR(date_ajout, 'MM'), 1, 2)= SUBSTR(TO_CHAR(SYSDATE, 'MM'), 1, 2)
                          AND SUBSTR(TO_CHAR(date_ajout, 'YYYY'), 1, 4)= SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 1, 4);
    objet_res objet%ROWTYPE;
 BEGIN
    FOR objet_res IN objets_mois_annee LOOP
     INSERT INTO LISTE_MOIS_ANNEE VALUES (:new.id_user,objet_res.id_objet, NULL,NULL,NULL);
     UPDATE LISTE_MOIS_ANNEE SET id_objet= objet_res.id_objet,nom_objet=objet_res.nom_objet, description_cat=objet_res.description_cat,
                          date_ajout = objet_res.date_ajout
                          WHERE id_user=:new.id_user and id_objet=objet_res.id_objet;
    END LOOP;
END;
/

--2. Archiver les listes supprimées dans une table d’archivage.
CREATE OR REPLACE TRIGGER tri_Archivage 
BEFORE DELETE ON LISTE FOR EACH ROW
   BEGIN
        INSERT INTO LISTE_ARCHIVEE VALUES (:old.id_liste,:old.nom_liste,:old.descriptif_liste,sysdate,:old.description_cat,:old.id_user); 
   END;  
/
CREATE OR REPLACE TRIGGER tri_Appa_Archivage 
BEFORE DELETE ON APPARTIENT_A FOR EACH ROW
   BEGIN
        INSERT INTO APPARTIENT_A_ARCHIVE VALUES(:old.id_objet,:old.id_liste,:old.descriptif_objet_liste);
   END;
/ 
 


 
 
 
 
