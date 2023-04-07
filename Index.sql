--1 Pour la première requête, vous pouvez créer un index sur la colonne description_cat de la table LISTE en utilisant la commande suivante :
CREATE INDEX index_description_cat ON LISTE (description_cat);

--Pour la deuxième requête, vous pouvez créer un index sur la colonne id_objet de la table APPARTIENT_A en utilisant la commande suivante :
CREATE INDEX index_id_objet_appartient_a ON APPARTIENT_A (id_objet);

--Vous pouvez également créer un index sur la colonne id_objet de la table NOTE en utilisant la commande suivante :
CREATE INDEX index_id_objet_note ON NOTE (id_objet);

--Vous pouvez également créer un index sur la colonne id_user de la table NOTE en utilisant la commande suivante :
CREATE INDEX index_id_user_note ON NOTE (id_user);

--Pour la quatrième requête, vous pouvez créer un index sur la colonne date_commentaire de la table COMMENTE en utilisant la commande suivante :
CREATE INDEX index_date_commentaire ON COMMENTE (date_commentaire);


