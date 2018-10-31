Willkommen beim INF-SWE Gitblit Server
======================================

Diese Repositories sind ausschließlich da, um im Rahmen von Lehrveranstalltungen Abgaben durchzuführen. Anleitungen finden Sie dazu in den jeweiligen Lehrveranstalltungen.

Anmeldung
---------

Bitte melden Sie sich mit Ihrem LDAP Account an.

Einstellungen für den Client
----------------------------

Die Kommunikation mit Gitblit findet über HTTPS statt. Das kann zu Problemen mit Ihrem git client führen. Sie haben zwei Optionen:

1. Sie installieren das SSL Zertifikat - siehe [GitSSLAusnahme.pdf](http://inf-swe.technikum-wien.at/git/GitSSLAusnahme.pdf)
2. Sie deaktivieren die SSL Prüfung - nicht empfohlen!

    git config --global http.sslverify 0
