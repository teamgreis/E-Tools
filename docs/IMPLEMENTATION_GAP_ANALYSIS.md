# E-Tools – Erweiterungs- und Lückenanalyse

**Status:** Technische Bestandsaufnahme und Vorschlag für die weitere Entwicklung  
**Geltungsbereich:** Flutter-/Dart-Anwendung, Android-Plattform, 16 registrierte Module  
**Ziel:** Vorhandene Funktionen von geplanten, eingeschränkten und noch fehlenden Funktionen trennen und daraus eine umsetzbare Entwicklungsreihenfolge ableiten.

> Diese Datei ergänzt die bestehende Dokumentation. Sie ersetzt weder die Modul-Spezifikationen noch die Sicherheitsanforderungen. Die Einordnung bezieht sich auf den geprüften Repository-Stand; vor jeder Release-Freigabe müssen die Aussagen erneut anhand des aktuellen Codes und realer Geräte verifiziert werden.

---

## 1. Zusammenfassung

E-Tools besitzt bereits eine tragfähige Flutter-Grundlage, eine modulare Struktur, mehrere tatsächlich implementierte Werkzeuge, technische Spezifikationen und eine CI-Pipeline. Besonders greifbar sind Netzwerkdiagnose, Subnetting, Elektrotechnik-Berechnungen, ausgewählte Developer-Tools und ein lesender Modbus-TCP-Prototyp.

Die größten nächsten Schritte liegen nicht darin, noch mehr Module lediglich im Menü anzulegen. Entscheidend ist, die Plattform und die gemeinsamen Grundlagen so auszubauen, dass die Werkzeuge zuverlässig, offline-fähig, testbar und auf realer Android-Hardware nutzbar werden.

**Höchste Priorität:**
1. Android-Projekt und reproduzierbare APK-/AAB-Builds vervollständigen.
2. Persistente Datenhaltung und einheitliche Projekt-/Anlagenmodelle etablieren.
3. Native USB-Host-Integration und eine getestete Adapter-Kompatibilitätsmatrix entwickeln.
4. Netzwerkplanung, technische Dokumentation und Hardwaretests zu durchgängigen Arbeitsabläufen verbinden.
5. Tests, Fehlerbehandlung, Berechtigungen und Sicherheitsgrenzen systematisch ausbauen.

## 2. Bestandsaufnahme: Was bereits vorhanden ist

Die folgenden Punkte sind im geprüften Quellstand erkennbar. „Vorhanden“ bedeutet nicht automatisch, dass die Funktion bereits produktionsreif oder auf allen Android-Geräten verfügbar ist.

| Bereich | Erkennbarer Stand | Einordnung |
|---|---|---|
| Flutter-App und Modulnavigation | App-Shell, Routing und Modulregistrierung | Vorhanden |
| Dashboard und Modulübersicht | Modulkarten und Navigation | Vorhanden |
| Netzwerk | Interface-Informationen, Subnetting, TCP-Erreichbarkeit, DNS-/HTTP-/TLS-Werkzeuge | Teilweise implementiert |
| Netzwerkplanung | Subnetz-/VLSM-Logik | Grundfunktionen vorhanden |
| Elektrotechnik | Ohmsches Gesetz, AC-/Drehstromberechnungen, Spannungsfall, Querschnittsabschätzung, Energiekosten | Teilweise implementiert |
| Industrial Technology | Modbus-TCP-Lesezugriff auf Register | Prototyp, read-only |
| Hardware Center | Interface-Informationen und manuelle Kompatibilitätsberichte | Grundgerüst |
| Wartung/Betrieb | Erste Logik und Moduloberfläche | Grundfunktionen |
| Developer-/Security-Werkzeuge | Mehrere eigenständige Hilfsfunktionen | Teilweise implementiert |
| Dateien/Produktivität/Automation | Moduloberflächen und ausgewählte Grundfunktionen | Funktionsumfang prüfen und vervollständigen |
| Tests | Tool- und Widget-Tests | Vorhanden, Abdeckung ausbauen |
| CI | Flutter-Analyse und Tests laufen über GitHub Actions | Vorhanden; Android-Artefakt-Build ergänzen |

### Wichtige Abgrenzungen

- Das Hardware Center erkennt noch nicht nativ alle USB-Geräte. Eine manuelle Kompatibilitätsliste ist kein Nachweis für funktionierende Hardware.
- USB-Ethernet, USB-Serial, RS232, RS485 und CAN benötigen je nach Chipsatz, Android-Version und Adapter native Unterstützung und reale Gerätetests.
- Modbus TCP ist derzeit als lesender Prototyp angelegt. Modbus RTU über RS485 ist davon getrennt zu betrachten.
- Eine erfolgreiche CI-Pipeline belegt die geprüften Analyse- und Testschritte, aber nicht automatisch einen installierbaren Android-Build oder die Funktion auf einem konkreten Tablet.
- Ein registriertes Modul oder eine vorhandene Oberfläche ist nicht gleichbedeutend mit einem vollständig implementierten Arbeitsablauf.

## 3. Kritische technische Lücken

### 3.1 Android-Plattform und Release-Builds

**Fehlt bzw. ist zu ergänzen:**
- Vollständiges, versioniertes Android-Projekt mit Gradle-Konfiguration.
- Festgelegte Mindest- und Ziel-SDK-Versionen.
- Manifest-Konfiguration für Netzwerk, USB-Host und erforderliche Berechtigungen.
- Reproduzierbarer Debug- und Release-Build.
- Signierungsprozess für Release-Artefakte über geschützte Secrets.
- APK-/AAB-Erstellung als CI-Artefakt.
- Installations- und Smoke-Tests auf mindestens einem realen Tablet.

**Abnahmekriterien:**
- Ein sauberer Checkout kann nach dokumentierten Schritten gebaut werden.
- CI erzeugt bei geeigneten Commits ein installierbares Android-Artefakt.
- Berechtigungen werden erst am tatsächlichen Nutzungspunkt angefordert.
- Build- und Geräteanforderungen sind dokumentiert.

### 3.2 Persistente Datenhaltung und gemeinsame Datenmodelle

**Zu ergänzen:**
- Einheitliche lokale Datenbank mit versionierten Migrationen.
- Datenmodelle für Projekte, Standorte, Kunden, Geräte, Anlagen, Netzwerke, Kabel, Ports, Messungen, Wartungen und Prüfberichte.
- Repository-Schicht statt direkter Datenbankzugriffe aus UI-Komponenten.
- Import und Export mit dokumentierten Formaten.
- Backup- und Wiederherstellungsstrategie.
- Datenintegrität, Dublettenbehandlung und nachvollziehbare Zeitstempel.

**Abnahmekriterien:**
- Daten bleiben nach App-Neustart erhalten.
- Datenbankmigrationen sind automatisiert getestet.
- Ein Projekt kann exportiert und auf einem anderen Gerät wieder importiert werden.
- Sensible Zugangsdaten werden getrennt von normalen Projektdaten geschützt gespeichert.

### 3.3 Native Hardware- und USB-Integration

**Zu ergänzen:**
- Kotlin-basierter USB-Host-Dienst mit Flutter-Anbindung.
- Geräteerkennung mit Vendor-ID, Product-ID, Interfaces und Endpoints.
- Expliziter Permission- und Gerätelebenszyklus.
- Erkennung von An- und Abstecken sowie sauberer Wiederverbindung.
- Adapter-Abstraktionen für Ethernet, USB-Serial und später weitere Schnittstellen.
- Fehlerdiagnose für nicht unterstützte Chipsätze, fehlende Berechtigungen und Verbindungsabbrüche.
- Hardware-Kompatibilitätsdatenbank mit Modell, Chipsatz, Android-Version, Firmware und Testergebnis.

**Wichtig:** VID/PID oder ein erkannter USB-Gerätename allein beweisen keine Funktionsfähigkeit. Ein Adapter darf erst dann als unterstützt gelten, wenn der konkrete Datenpfad auf einem dokumentierten Gerät erfolgreich getestet wurde.

### 3.4 Qualität, Tests und Wartbarkeit

**Zu ergänzen:**
- Unit-Tests für alle Berechnungen und Parser.
- Grenzwert-, ungültige Eingabe- und Fehlerfalltests.
- Widget-Tests für die wichtigsten Arbeitsabläufe.
- Integrationstests für Datenbank, Netzwerk und native Plattformkanäle.
- Android-Instrumentationstests für USB- und Berechtigungsabläufe.
- Statische Analyse ohne vermeidbare Warnungen.
- Abhängigkeitsprüfung und nachvollziehbare Aktualisierungsstrategie.
- Einheitliches Logging ohne Passwörter, Tokens oder private Schlüssel.
- Fehlerberichte mit verständlicher Ursache und Handlungsempfehlung.

## 4. Modulweise Erweiterungen

### 4.1 Network & Connectivity

**Erweitern:**
- IPv4 und IPv6 umfassend validieren und analysieren.
- DNS-Abfragen mit A, AAAA, MX, TXT, CNAME, NS und PTR.
- TCP-, HTTP- und TLS-Diagnose mit Zeitmessung und verständlichen Ergebnissen.
- Traceroute nur über tatsächlich verfügbare Plattformfunktionen; Einschränkungen transparent anzeigen.
- Lokale Interface- und Gateway-Informationen.
- WLAN-Informationen nur im Rahmen der Android-Berechtigungen und Plattform-APIs.
- Exportierbare Diagnoseberichte.

**Hinzufügen:**
- DHCP-Client-/Server-Diagnose, soweit technisch und rechtlich zulässig.
- Paketmitschnitt nur über explizit unterstützte und berechtigte Verfahren.
- Gezielte LAN-Inventarisierung mit Rate-Limits und ausdrücklicher Nutzeraktion.

### 4.2 Network Design

**Erweitern:**
- IP-Adressverwaltung mit Subnetzen, Reservierungen und Konfliktprüfung.
- VLAN-Planung mit IDs, Namen, Zweck und zugeordneten Ports.
- Netzwerkgeräte-Inventar mit Standort, Modell, Management-IP und Firmware.
- Port- und Patchpanel-Belegung.
- Rack- und Höheneinheitenplanung.
- Kabelverfolgung von Dose über Patchpanel bis Switchport.

**Hinzufügen:**
- Visueller Netzwerk-Topologieeditor mit verschiebbaren Geräten und Verbindungen.
- Dokumentation von Netzwerkdosen und Anschlusskennungen.
- Export als PDF, CSV und maschinenlesbares Projektformat.
- Plausibilitätsprüfungen für doppelte IPs, ungültige VLAN-Zuordnungen und unvollständige Verbindungen.

### 4.3 Electrical Engineering

**Erweitern:**
- Ein- und mehrphasige Berechnungen mit klaren Eingangsannahmen.
- Spannungsfall mit Material, Temperatur, Verlegeart und Leitungslänge als expliziten Parametern.
- Leistungs-, Energie- und Kostenberechnungen.
- Kabel- und Stromkreisverwaltung.
- Stücklisten und Materialbedarf.
- Schaltplan-PDFs mit Markierungen und Kommentaren.

**Hinzufügen:**
- Stromlauf- und Verteiler-Dokumentation.
- Messprotokolle mit Messgerät, Prüfdatum, Umgebung und verantwortlicher Person.
- Dokumentation von Schutzorganen und RCDs.
- Projektbezogene Stromkreis- und Verteilerpläne.

**Sicherheitsanforderung:** Berechnungen müssen Annahmen und Grenzen sichtbar machen. Querschnitts- oder Schutzorganvorschläge dürfen keine normgerechte Planung oder Prüfung vortäuschen. Keine direkte Verbindung des Tablets mit gefährlichen Stromkreisen ohne dafür zugelassene, galvanisch geeignete Messhardware und fachkundige Bedienung.

### 4.4 Hardware Center

**Erweitern:**
- Native USB-Geräteerkennung.
- Adapterprofile und Kompatibilitätsstatus.
- Verbindungstests mit nachvollziehbaren Ergebnissen.
- Stromversorgungs- und Link-Informationen nur soweit vom Betriebssystem bzw. Adapter tatsächlich bereitgestellt.
- Liste getesteter Tablet-/Android-/Adapter-Kombinationen.

**Hinzufügen:**
- USB-C-Ethernet: Interface- und Linkprüfung, IP-Konfiguration und Durchsatztests.
- USB-Serial: zunächst ausgewählte Chipsätze wie FTDI, CP210x und CH340 nach konkreter Implementierung und Test.
- RS232- und RS485-Kommunikationsprofile.
- Später CAN-Adapter mit dokumentiertem Treiber- und Protokollumfang.
- Adapter-Testassistent mit Schritt-für-Schritt-Prüfung.

### 4.5 Industrial Technology

**Erweitern:**
- Modbus TCP: robuste Antwortvalidierung, Timeouts, Transaction IDs, Registertypen und Datentypdekodierung.
- Registerprofile mit Skalierung, Einheit, Byte-/Word-Reihenfolge und Dokumentation.
- Messwertverlauf und CSV-Export.
- Verbindungsprofile für bekannte Geräte.

**Hinzufügen:**
- Modbus RTU über USB-RS485.
- MQTT-Client mit TLS und sicherer Zugangsdatenverwaltung.
- OPC UA zunächst lesend und mit Zertifikatsprüfung.
- BACnet/IP als späteres Integrationsziel.
- CAN erst nach Auswahl und Test konkreter Adapter.

**Sicherheitsgrenze:** Standardmäßig lesender Betrieb. Schreiboperationen oder Steuerbefehle benötigen eine separate Sicherheits- und Berechtigungsprüfung, klare Bestätigung und gerätespezifische Schutzmechanismen. Keine sicherheitsgerichteten Steuerfunktionen versprechen.

### 4.6 Maintenance & Operations

**Erweitern:**
- Anlagen-, Maschinen- und Standortverwaltung.
- Wartungsintervalle und Fälligkeiten.
- Störungsmeldungen mit Priorität, Status und Verlauf.
- Checklisten und Arbeitsberichte.
- Ersatzteil- und Materialverwaltung.
- Fotos, Dokumente und Messwerte pro Anlage.

**Hinzufügen:**
- QR-/NFC-Zuordnung von Anlagen und Komponenten.
- Offlinefähige Wartungsaufträge.
- Unterschrift bzw. Bestätigung und PDF-Bericht.
- Wiederkehrende Wartungspläne und Eskalationshinweise.
- Änderungsprotokoll für wichtige Anlageninformationen.

### 4.7 Server Administration und IT

**Erweitern:**
- SSH-Verbindungsprofile und sichere Schlüsselverwaltung.
- Serverinventar und Dienststatus.
- Docker-Containerübersicht, Logs und kontrollierte Aktionen.
- SNMP-Abfragen mit Versionen, Berechtigungen und sicheren Defaults.
- REST-/HTTP-API-Tester und TLS-Zertifikatsübersicht.
- Linux-Diagnose und Log-Filter.

**Hinzufügen:**
- RDP über eine geeignete, gepflegte Bibliothek oder externe Integration.
- Konfigurations- und Backup-Prüfberichte.
- Geräte- und Softwareinventar.
- Rollen- und Berechtigungskonzepte für spätere Teamnutzung.

**Sicherheitsanforderung:** Keine unsichere Speicherung von Zugangsdaten, keine ungeprüften Hostkeys, keine ungeschützte Docker-Socket-Freigabe und keine unbestätigten destruktiven Aktionen.

## 5. Plattformweite Funktionen, die ergänzt werden sollten

| Funktion | Nutzen |
|---|---|
| Projektverwaltung | Alle Werkzeuge arbeiten auf gemeinsamen Projekten |
| Kunden- und Standortverwaltung | Technische Arbeit vor Ort strukturieren |
| Globale Suche | Geräte, Anlagen, Ports, Dokumente und Werkzeuge finden |
| Favoriten und Verlauf | Häufige Werkzeuge schnell öffnen |
| Einheitlicher Export | PDF, CSV und JSON |
| Offline-first | Arbeit ohne Internetverbindung |
| QR-/NFC-Verknüpfung | Anlagen und Anschlüsse schnell identifizieren |
| Messwert- und Ereignisverlauf | Veränderungen und Fehler nachvollziehen |
| Rollen und Berechtigungen | Grundlage für Team- und Firmenbetrieb |
| Internationalisierung | Mindestens Deutsch und Englisch |
| Barrierefreiheit | Skalierbare Schrift, Kontrast und Screenreader |
| In-App-Diagnose | App-Version, Plattformstatus und Fehlerberichte |

## 6. Empfohlene Entwicklungsreihenfolge

### Phase 0 – Fundament absichern
- Android-Projekt vervollständigen.
- Build-Konfiguration und CI-APK/AAB erstellen.
- Architektur- und Modulkommentare aktualisieren.
- Test- und Release-Prozess dokumentieren.

### Phase 1 – Gemeinsame Datenbasis
- Datenbank und Migrationen.
- Projekt-, Standort-, Geräte- und Anlagenmodelle.
- Repository-Schicht und Export/Import.
- Einheitliche Fehler- und Loggingstrategie.

### Phase 2 – Netzwerk-Field-Toolkit
- USB-C-Ethernet-Unterstützung.
- Interface-, IP-, Gateway- und Linkdiagnose.
- TCP-/DNS-/HTTP-/TLS-Prüfabläufe.
- Netzwerkprojekt, Ports und Kabel dokumentieren.

### Phase 3 – Hardware Center
- Native USB-Erkennung.
- Adapterprofile und Berechtigungsabläufe.
- USB-Serial für ausgewählte Chipsätze.
- Reale Kompatibilitätstests und Testmatrix.

### Phase 4 – Planung und Elektrotechnik
- Visueller Netzwerkplaner.
- Rack-, Patchpanel- und Kabelplanung.
- Stromkreis- und Verteilerverwaltung.
- Erweiterte Berechnungen und Messprotokolle.

### Phase 5 – Betrieb und Industrie
- Anlagen- und Wartungsverwaltung.
- Modbus RTU über RS485.
- MQTT und OPC UA zunächst lesend.
- QR-/NFC-gestützte Anlagenakten.

### Phase 6 – IT-Administration und Produktreife
- Server- und Geräteinventar vervollständigen.
- Sichere Remote-Administration.
- Rollen, Berechtigungen und Teamfunktionen.
- Performance-, Geräte- und Release-Tests.

## 7. Release- und Qualitätskriterien

Ein Modul gilt erst dann als implementiert, wenn alle zutreffenden Kriterien erfüllt sind:

- [ ] Die Funktion ist im UI erreichbar und nicht nur im Registry-Eintrag vorhanden.
- [ ] Eingaben werden validiert; ungültige Werte erzeugen verständliche Fehler.
- [ ] Grenzwerte und Fehlerfälle sind getestet.
- [ ] Berechtigungen werden nachvollziehbar und sparsam angefordert.
- [ ] Plattformabhängigkeiten und Einschränkungen werden offen angezeigt.
- [ ] Ergebnisse lassen sich bei Bedarf speichern oder exportieren.
- [ ] Die Funktion funktioniert auf den dokumentierten Zielgeräten.
- [ ] Keine sensiblen Daten gelangen in Logs oder ungeschützte Dateien.
- [ ] Dokumentation und Tests entsprechen dem tatsächlichen Funktionsumfang.

Ein Hardware-Adapter gilt erst nach einem erfolgreichen Test des tatsächlichen Datenpfads als unterstützt. Ein erfolgreicher Build gilt erst nach Installation und Smoke-Test auf einem realen Android-Gerät als gerätevalidiert.

## 8. Vorgeschlagene Prioritäten

| Priorität | Arbeitspaket | Begründung |
|---|---|---|
| P0 | Android-Build und Release-Pipeline | Voraussetzung für installierbare Tests |
| P0 | Datenhaltung und gemeinsame Modelle | Voraussetzung für Projekte und Dokumentation |
| P0 | Sicherheits- und Fehlerkonzept | Voraussetzung für professionelle Nutzung |
| P1 | USB-Host-Grundlage | Voraussetzung für Tablet-Hardwareintegration |
| P1 | USB-C-Ethernet | Hoher unmittelbarer Nutzen für Netzwerktechniker |
| P1 | Netzwerkprojekt und Dokumentation | Verbindet Planung und Diagnose |
| P1 | Tests und reale Gerätevalidierung | Verhindert nur scheinbar funktionierende Features |
| P2 | USB-Serial / RS232 / RS485 | Erweitert industrielle und technische Einsatzfälle |
| P2 | Wartung und Anlagenverwaltung | Erschließt Betriebstechnik |
| P2 | Elektrotechnische Dokumentation | Erweitert die vorhandenen Berechnungen |
| P3 | MQTT / OPC UA / BACnet / CAN | Größerer Integrationsaufwand, gezielt nach Hardwareauswahl |
| P3 | Team- und Firmenfunktionen | Sinnvoll nach stabiler lokaler Datenbasis |

## 9. Architekturleitlinien für die Erweiterung

- Fachlogik bleibt unabhängig von Flutter-Widgets und Plattformcode.
- Hardwarezugriffe laufen über klar definierte Schnittstellen und Adapter.
- Android-spezifische Implementierungen liegen in Kotlin und werden über typisierte Plattformkanäle angebunden.
- Gemeinsame Datenmodelle werden nicht pro Modul dupliziert.
- Netzwerk- und Industriekommunikation erhalten Timeouts, Größenlimits und saubere Abbruchmechanismen.
- Alle externen Verbindungen werden nur nach expliziter Nutzeraktion gestartet.
- Lesende Funktionen sind der sichere Standard.
- Normen, elektrische Sicherheitsprüfungen und industrielle Steuerungsfunktionen werden nicht simuliert oder als zertifiziert dargestellt.
- Plattformgrenzen und Adapterkompatibilität werden anhand realer Tests dokumentiert.

## 10. Fazit

E-Tools sollte zunächst seine vorhandenen Funktionen zu einem zuverlässigen, integrierten Werkzeugkasten verbinden. Der größte Mehrwert entsteht durch gemeinsame Projekte, persistente technische Dokumentation, echte USB-Hardwareanbindung und reproduzierbare Android-Builds.

Die empfohlene Leitentscheidung lautet daher:

**Erst Plattform und Datenbasis stabilisieren, dann Tablet-Hardware und Netzwerk-Field-Toolkit liefern, anschließend Elektrotechnik, Betriebstechnik und industrielle Protokolle systematisch ausbauen.**

So wächst E-Tools nicht nur in der Anzahl seiner Werkzeuge, sondern in der Zuverlässigkeit und im praktischen Nutzen für Elektriker, Netzwerktechniker, Betriebstechniker und IT-Administratoren.
