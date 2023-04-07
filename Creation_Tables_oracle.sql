CREATE TABLE APPARTIENT_A (
  id_objet NUMBER(8),
  id_liste NUMBER(8),
  descriptif_objet_liste VARCHAR(300),
  PRIMARY KEY (id_objet, id_liste)
);

CREATE TABLE APPARTIENT_A_ARCHIVE (
  id_objet NUMBER(8),
  id_liste_ar NUMBER(8),
  descriptif_objet_liste_ar VARCHAR(300),
  PRIMARY KEY (id_objet, id_liste_ar)
);


CREATE TABLE COMMENTE (
  id_objet NUMBER(8),
  id_user NUMBER(8),
  texte_commentaire VARCHAR(300),
  date_commentaire DATE,
  PRIMARY KEY (id_objet, id_user)
);

CREATE TABLE LISTE (
  id_liste NUMBER(8),
  nom_liste VARCHAR(42),
  descriptif_liste VARCHAR(42),
  description_cat VARCHAR(42),
  id_user NUMBER(8),
  PRIMARY KEY (id_liste)
);

CREATE TABLE LISTE_ARCHIVEE (
  id_liste_ar NUMBER(8),
  nom_liste_ar VARCHAR(60) NOT NULL,
  descriptif_liste_ar VARCHAR(300) NOT NULL,
  date_archivage DATE NOT NULL,
  description_cat VARCHAR(300) NOT NULL,
  id_user NUMBER(8),
  PRIMARY KEY (id_liste_ar)
);

CREATE TABLE NOTE (
  id_objet NUMBER(8),
  id_user NUMBER(8),
  note NUMBER(8) NOT NULL,
  date_note DATE NOT NULL,
  PRIMARY KEY (id_objet, id_user)
);

CREATE TABLE OBJET (
  id_objet NUMBER(8),
  nom_objet VARCHAR(60) NOT NULL,
  description_cat VARCHAR(300) NOT NULL,
  date_ajout DATE NOT NULL,
  PRIMARY KEY (id_objet)
);

CREATE TABLE POSSEDE (
  id_objet NUMBER(8),
  id_user NUMBER(8),
  PRIMARY KEY (id_objet, id_user)
);

CREATE TABLE PREVOIT_ACHAT (
  id_objet NUMBER(8),
  id_user NUMBER(8),
  PRIMARY KEY (id_objet, id_user)
);

CREATE TABLE UTILISATEUR (
  id_user NUMBER(8),
  login VARCHAR(42),
  nom VARCHAR(42),
  prenom VARCHAR(42),
  adresse VARCHAR(42),
  email VARCHAR(42),
  motdepasse VARCHAR(42),
  date_naiss DATE,
  date_inscript DATE,
  PRIMARY KEY (id_user)
);
CREATE TABLE LISTE_MOIS_ANNEE (
  id_user NUMBER(8),
  id_objet NUMBER(8),
  nom_objet VARCHAR(100) DEFAULT NULL,
  description_cat VARCHAR(300) DEFAULT NULL,
  date_ajout DATE  DEFAULT NULL,
  PRIMARY KEY (id_user,id_objet)
);

ALTER TABLE APPARTIENT_A ADD FOREIGN KEY (id_liste) REFERENCES LISTE (id_liste) ON DELETE CASCADE;
ALTER TABLE APPARTIENT_A ADD FOREIGN KEY (id_objet) REFERENCES OBJET (id_objet);
ALTER TABLE APPARTIENT_A_ARCHIVE ADD FOREIGN KEY (id_liste_ar) REFERENCES LISTE_ARCHIVEE (id_liste_ar);
ALTER TABLE APPARTIENT_A_ARCHIVE ADD FOREIGN KEY (id_objet) REFERENCES OBJET (id_objet);
ALTER TABLE COMMENTE ADD FOREIGN KEY (id_user) REFERENCES UTILISATEUR (id_user);
ALTER TABLE COMMENTE ADD FOREIGN KEY (id_objet) REFERENCES OBJET (id_objet);
ALTER TABLE LISTE ADD FOREIGN KEY (id_user) REFERENCES UTILISATEUR (id_user);
ALTER TABLE LISTE_ARCHIVEE ADD FOREIGN KEY (id_user) REFERENCES UTILISATEUR (id_user);
ALTER TABLE NOTE ADD FOREIGN KEY (id_user) REFERENCES UTILISATEUR (id_user);
ALTER TABLE NOTE ADD FOREIGN KEY (id_objet) REFERENCES OBJET (id_objet);
ALTER TABLE POSSEDE ADD FOREIGN KEY (id_user) REFERENCES UTILISATEUR (id_user);
ALTER TABLE POSSEDE ADD FOREIGN KEY (id_objet) REFERENCES OBJET (id_objet);
ALTER TABLE PREVOIT_ACHAT ADD FOREIGN KEY (id_user) REFERENCES UTILISATEUR (id_user);
ALTER TABLE PREVOIT_ACHAT ADD FOREIGN KEY (id_objet) REFERENCES OBJET (id_objet);
