SET SERVEROUTPUT ON

--1. Définir une fonction qui retourne pour une œuvre dont l'identifiant est passé en
--paramètre et si elle a plus de 20 évaluations, le score moyen des notes pour cette œuvre.
--Si l'oeuvre a moins de 20 appréciations ou si elle n'existe pas, la fonction renverra un score nul.

CREATE OR REPLACE function fonc_evaluation(id_v OBJET.id_objet%TYPE) 
  RETURN OBJET.id_objet%TYPE
    IS
         nbrEvaluation_v numeric;
         scoreMoyen_v numeric;
          BEGIN
            select count(note),avg(note) INTO nbrEvaluation_v,scoreMoyen_v
              from Objet,NOTE
               where NOTE.id_objet = Objet.id_objet AND
                     Objet.id_objet = id_v;

            IF nbrEvaluation_v > 20 THEN
                return scoreMoyen_v;
            ELSE
                return 0;
            END IF;

          END;
/


--2. Ecrire une procédure qui génère pour un utilisateur la liste de ses 10 films préférés, la
--liste de ses 10 livres préférés et la liste de ces 10 jeux vidéos préférés. Pour chacun des
--objets, en cas d’égalité, la priorité sera donné aux objets dont l’ajout est le plus récent.
--Si une liste n'a pas au moins 10 éléments elle ne sera pas générée.
CREATE OR REPLACE PROCEDURE ListPreferances(id_utilisateur number)
 IS
 nbLivre_v number; -- cette variable va contenir le nombre de livre prefere
 --CURSEUR POUR LES LIVRES PREFERES
    CURSOR Livres_curs IS
       select nom_objet
       from NOTE N,utilisateur U,Objet O
        where U.id_user = N.id_user and
               N.id_objet = O.id_objet and
                LOWER(O.description_cat) = 'livre' and
                N.id_user = id_utilisateur
                ORDER BY note DESC ,date_note DESC
                FETCH FIRST 10 ROWS ONLY;

   nbFilm_v number; -- cette variable va contenir le nombre de film prefere
  --CURSEUR POUR LES FILMES PREFERES
    CURSOR Films_curs IS
      select nom_objet
       from NOTE N,utilisateur U,Objet O
        where U.id_user = N.id_user and
               N.id_objet = O.id_objet and
                LOWER(O.description_cat) = 'film' and
                N.id_user = id_utilisateur
                ORDER BY note DESC ,date_note DESC
                FETCH FIRST 10 ROWS ONLY;

    nbJeuVideo_v number; -- cette variable va contenir le nombre de jeu video prefere
   --CURSEUR POUR LES JEU VIDEO PREFERES
    CURSOR JeuVideo_curs IS
     select nom_objet
       from NOTE N,utilisateur U,Objet O
        where U.id_user = N.id_user and
               N.id_objet = O.id_objet and
                LOWER(O.description_cat) = 'jeu video' and
                N.id_user = id_utilisateur
                ORDER BY note DESC ,date_note DESC
                FETCH FIRST 10 ROWS ONLY;

      BEGIN
        --PARCOUR CURSEUR LIVRES
            FOR livre_row IN  Livres_curs
             LOOP             
              nbLivre_v := Livres_curs%ROWCOUNT;
            END LOOP;
                  IF nbLivre_v = 10 THEN
                       DBMS_OUTPUT.PUT_LINE('Les LIVRES preferes sont: ');
                     FOR livre_row IN  Livres_curs
                         LOOP
                          DBMS_OUTPUT.PUT_LINE(livre_row.nom_objet);
                        END LOOP;    
                  END IF;
                  
                 IF nbLivre_v < 10 THEN
                     DBMS_OUTPUT.PUT_LINE('Desole on ne peut pas afficher une liste de moins de 10 elements');
                  END IF;
                  
                  
        --PARCOUR CURSEUR FILMES
            FOR film_row IN  Films_curs
             LOOP
              nbFilm_v := Films_curs%ROWCOUNT;
            END LOOP;
                  IF nbFilm_v = 10 THEN
                       DBMS_OUTPUT.PUT_LINE('Les FILMES preferes sont: ');
                     FOR film_row IN  Films_curs
                         LOOP
                          DBMS_OUTPUT.PUT_LINE(film_row.nom_objet);
                        END LOOP;    
                  END IF;
                IF nbLivre_v < 10 THEN
                        DBMS_OUTPUT.PUT_LINE('Desole on ne peut pas afficher une liste de moins de 10 elements');
                END IF;
                  
            --PARCOUR CURSEUR JEU VIDEO
            FOR jeuvideo_row IN  JeuVideo_curs
             LOOP
              nbJeuVideo_v := JeuVideo_curs%ROWCOUNT;
            END LOOP;
                  IF nbJeuVideo_v = 10  THEN
                       DBMS_OUTPUT.PUT_LINE('Les JEU VIDEOS prefers sont: ');
                     FOR jeuvideo_row IN  JeuVideo_curs
                         LOOP
                          DBMS_OUTPUT.PUT_LINE(jeuvideo_row.nom_objet);
                        END LOOP;    
                  END IF;
                IF nbLivre_v < 10 THEN
                    DBMS_OUTPUT.PUT_LINE('Desole on ne peut pas afficher une liste de moins de 10 elements');
               END IF;


  END;
/


--3. Ecrire le code PL/SQL permettant de générer des suggestions pour un utilisateur, c’est
--dire les X objets dont le score moyen est le plus élevé pour les objets communs à au
--moins Y utilisateurs, ces utilisateurs ayant mis la même note que l’utilisateur courants
--pour au moins Z objets (ces objets culturels ne sont pas déjà dans une liste de l’utilisateur).
--Il s’agit d’identifier les objets de personnes ayant des gouts similaires que l’utilisateur
--courant, et de prendre les objets les mieux évalués de cet ensemble.

DECLARE
  -- Déclarez les variables pour les paramètres d'entrée
  v_user_id NUMBER(8);
  v_num_suggestions NUMBER(8);
  v_min_common_users NUMBER(8);
  v_min_common_objects NUMBER(8);
  
  -- Déclarez le curseur pour sélectionner les objets qui répondent aux critères
  CURSOR c_suggestions IS
    SELECT o.id_objet, AVG(n.note) AS avg_note
    FROM UTILISATEUR u
    JOIN NOTE n ON n.id_user = u.id_user
    JOIN OBJET o ON o.id_objet = n.id_objet
    WHERE u.id_user <> v_user_id -- exclure l'utilisateur actuel
    AND n.note IN (SELECT note FROM NOTE WHERE id_user = v_user_id) -- inclure uniquement les objets avec la même note que l'utilisateur actuel
    AND o.id_objet NOT IN (SELECT id_objet FROM APPARTIENT_A WHERE id_liste IN (SELECT id_liste FROM LISTE WHERE id_user = v_user_id)) -- exclure les objets déjà dans les listes de l'utilisateur actuel
    AND o.id_objet IN (SELECT id_objet FROM NOTE WHERE id_user IN (SELECT id_user FROM NOTE WHERE id_objet IN (SELECT id_objet FROM NOTE WHERE id_user = v_user_id) GROUP BY id_user HAVING COUNT(*) >= v_min_common_objects)) -- inclure uniquement les objets notés par des utilisateurs ayant des goûts similaires
    GROUP BY o.id_objet, o.nom_objet
    HAVING COUNT(DISTINCT u.id_user) >= v_min_common_users -- inclure uniquement les objets notés par un nombre minimum d'utilisateurs
    ORDER BY avg_note DESC;
  -- Déclarez le registre pour stocker les données de suggestion
  rec_suggestion c_suggestions%ROWTYPE;
BEGIN
  -- Initialisez les paramètres d'entrée
  v_user_id := 1;
  v_num_suggestions := 3;
  v_min_common_users := 2;
  v_min_common_objects := 2;

  -- Ouvrez le curseur et parcourez les X premières suggestions
  OPEN c_suggestions;
  LOOP
    FETCH c_suggestions INTO rec_suggestion;
    EXIT WHEN c_suggestions%NOTFOUND OR v_num_suggestions = 0;
    -- Affichez les informations de suggestion
    DBMS_OUTPUT.PUT_LINE('ID de l''objet: ' || rec_suggestion.id_objet);
    DBMS_OUTPUT.PUT_LINE('Note moyenne: '|| rec_suggestion.avg_note);
    v_num_suggestions := v_num_suggestions - 1;
  END LOOP;
  CLOSE c_suggestions;
END;
