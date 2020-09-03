# Manuale di installazione

Questo manuale fornisce tutte le indicazioni utili per l'installazione e la configurazione dell'applicazione RNDT.

I requisiti minimi per eseguire il software sono i seguenti:

- Sistema operativo (Linux o Windows)
- Java JDK 1.8
- Apache Tomcat 8.5
- DBMS MySQL 5.7.18
- OpenLDAP

## Contenuto

La cartella di distribuzione contiene i seguenti file e cartelle:

- DB
  - [```Database.sql```](../DB/Database.sql)
    Script SQL di creazione del database dei metadati
- LDAP
  - [```Ente.ldif```](../LDAP/Ente.ldif)
    Esempio di alcuni enti. Va caricata in LDAP con un programma adatto, ad esempio Apache Directory Studio.
  - [```Users.ldif```](../LDAP/Users.ldif)
    Esempio di alcuni utenti. Va caricata in LDAP con un programma adatto, ad esempio Apache Directory Studio.
  - [```Groups.ldif```](../LDAP/Groups.ldif)
    Gruppi (Ruoli) per gli utenti.
- [```Sorgenti```](../Sorgenti/)
    Sorgenti java comuni alle webapp geoportalRNDTPA e geoportalRNDTAdm
- Webapp
  - [```geoportalRNDTPA```](../geoportalRNDTPA/)
    Webapp per la gestione delle PA (ruolo di tipo &quot;publisher&quot;)
  - [```geoportalRNDTAdm```](../geoportalRNDTAdm/)
    Webapp per la gestione amministrativa (ruolo di tipo &quot;administrator&quot;)

**NOTA**: tutte le applicazioni sono in formato leggibile (PHP, Javascript, XML) quindi gli unici sorgenti necessari sono quelli java che costituiscono la libreria ```geoportalRNDT*/WEB-INF/lib/geoportalRNDT.jar```.

## Creazione DB metadati

La creazione del DB dei metadati viene effettuata tramite esecuzione degli script SQL di installazione del DB presenti nella cartella [```DB```](../DB/).

Gli script includono la creazione del database con nome **geoportal**; questo nome può essere modificato facendo attenzione che deve essere modificato coerentemente anche nel file delle webapp.

Si consiglia di creare un utente specifico per il DB dei metadati, ad esempio un utente _geoportaluser_ con permessi &quot;full&quot; sullo schema. L&#39;utente e la password devono poi essere inserite nella configurazione delle webapp.

**NOTA**: per funzionare correttamente, il database sistema deve contenere almeno un Ente e un Tipo Ente.
