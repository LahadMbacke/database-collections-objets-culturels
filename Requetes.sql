--1. Les UTILISATEURs ayant créé une liste pour chacun des types d'objets culturels existant.
SELECT U.id_user,prenom,nom
FROM UTILISATEUR U
WHERE NOT EXISTS (
  SELECT 1 FROM OBJET O
  WHERE NOT EXISTS (
    SELECT 1 FROM LISTE L
    WHERE upper(L.description_cat) = upper(O.description_cat)
    AND L.id_user = U.id_user
  )
);


--2. Les objets culturels appartenant à plus de 20 collections et dont la moyenne des évaluations est supérieure à 14.
SELECT nom_objet ,A.id_objet
                    FROM objet O JOIN APPARTIENT_A A ON O.id_objet = A.id_objet
                    GROUP BY nom_objet,A.id_objet
                    HAVING count(A.id_objet )> 20 
                    and A.id_objet in (SELECT N.id_objet from OBJET O JOIN NOTE N ON O.id_objet = N.id_objet
                                         GROUP BY N.id_objet 
                                         HAVING avg(N.note) > 14);


--3. Les UTILISATEURs n'ayant jamais mis une note inférieure à 8 à un objet culturel.
  -- TOUS LES 2 requetes fontionnees
SELECT distinct prenom , Nom,id_user FROM UTILISATEUR
MINUS(SELECT distinct prenom, Nom,U.id_user 
                    FROM UTILISATEUR U JOIN NOTE N ON U.id_user = N.id_user
                    WHERE note < 8);       
                    
--4. L'objet culturel le plus commenté au cours de la dernière semaine.
SELECT nom_objet,C.date_commentaire,count(texte_commentaire) AS nb_Comment_Week
 FROM COMMENTE C join Objet O ON C.id_objet=O.id_objet
 WHERE  C.date_commentaire >= trunc(sysdate -7, 'IW')
  AND C.date_commentaire  < trunc(sysdate, 'IW')
   GROUP BY nom_objet,C.date_commentaire
   HAVING count(texte_commentaire) >= all(SELECT count(texte_commentaire)
                                        FROM COMMENTE
                                             WHERE  COMMENTE.date_commentaire >= trunc(sysdate -7, 'IW')
                                             AND COMMENTE.date_commentaire  < trunc(sysdate, 'IW')
                                             GROUP by id_objet
                                        );
                                        

--5. Pour chaque UTILISATEUR ayant au moins noté des objets sur 3 mois consécutifs au cours de
     --l’annéee précédente (par exemple, une note a été ajoutée en juin, en juillet et en aout),
     --indiquer son nombre d’objets possédés, son nombre d’objets à acheter, la longueur minimale, maximale et moyenne de ses collections.
    
SELECT U.prenom,U.nom,P.nbr_obj_possed, PA.nbr_obj_a_aheter,min_collection,max_collection,moyenn_collection
FROM (
  SELECT id_user, COUNT(id_objet) AS nbr_obj_possed
  FROM POSSEDE
  GROUP BY id_user
) P
JOIN (
  SELECT id_user,prenom,nom
  FROM UTILISATEUR
  GROUP BY id_user,prenom,nom
) U ON U.id_user = P.id_user
JOIN 
 (
  SELECT id_user, COUNT(id_objet) AS nbr_obj_a_aheter
  FROM PREVOIT_ACHAT
  GROUP BY id_user
) PA
ON U.id_user = PA.id_user
JOIN(
  SELECT id_user, MIN(id_liste) AS min_collection, 
    MAX(id_liste) AS max_collection, 
    AVG(id_liste) AS moyenn_collection
  FROM LISTE
  GROUP BY id_user
) L
ON  U.id_user = L.id_user
WHERE U.id_user IN (
SELECT id_user
  FROM NOTE
  WHERE
   EXTRACT(YEAR FROM date_note) = EXTRACT(YEAR FROM SYSDATE) - 1
        GROUP BY id_user
        HAVING COUNT(DISTINCT EXTRACT(MONTH FROM date_note)) >= 3
  )
