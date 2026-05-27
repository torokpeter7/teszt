-- ============================================================
-- NetKapocs – Referenciák adatbázis
-- Supabase SQL Editor-ba illeszd be és futtasd le!
-- ============================================================

-- Tábla létrehozása
CREATE TABLE IF NOT EXISTS referenciak (
  id                SERIAL PRIMARY KEY,
  icon              TEXT        NOT NULL,
  icon_bg           TEXT        NOT NULL,   -- 'blue' | 'green' | 'orange' | 'navy'
  badge_text        TEXT        NOT NULL,
  badge_color       TEXT        NOT NULL,   -- 'blue' | 'green' | 'orange' | 'navy'
  date_text         TEXT        NOT NULL,
  title             TEXT        NOT NULL,
  location          TEXT        NOT NULL,
  description       TEXT        NOT NULL,
  filters           TEXT[]      NOT NULL,   -- pl. '{ubiquiti}', '{tp-link,kabelez}'
  card_tags         JSONB       NOT NULL,   -- [{text, color}]
  stars             INTEGER     NOT NULL DEFAULT 5,
  -- Modal mezők
  modal_icon        TEXT        NOT NULL,
  modal_title       TEXT        NOT NULL,
  modal_location    TEXT        NOT NULL,
  modal_meta        JSONB       NOT NULL,   -- [{label, value}]
  modal_situation   TEXT        NOT NULL,
  modal_solution    TEXT        NOT NULL,
  modal_results     TEXT[]      NOT NULL,
  modal_tags        JSONB       NOT NULL,   -- [{text, color}]
  reviewer_text     TEXT        NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Row Level Security: nyilvános olvasás engedélyezése
ALTER TABLE referenciak ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Nyilvanos olvashato" ON referenciak
  FOR SELECT USING (true);

-- ============================================================
-- Adatok feltöltése
-- ============================================================

INSERT INTO referenciak
  (icon, icon_bg, badge_text, badge_color, date_text, title, location, description, filters, card_tags, stars,
   modal_icon, modal_title, modal_location, modal_meta, modal_situation, modal_solution, modal_results, modal_tags, reviewer_text)
VALUES

-- #1 – Kecskemét, UniFi
(
  '🏡', 'green', 'Ubiquiti UniFi', 'green', '2024. október',
  '200 m²-es családi ház – teljes hálózat', 'Kecskemét',
  'Kétszintes, 200 m²-es ház teljes hálózat kiépítése az alapoktól. 3 UniFi access point, strukturált Cat6 kábelezés, vendég WiFi és okosotthon szegmens kialakítása.',
  ARRAY['ubiquiti'],
  '[{"text":"UniFi AP","color":"green"},{"text":"Cat6","color":"navy"},{"text":"Mesh","color":"blue"},{"text":"IoT","color":"orange"}]'::jsonb,
  5,
  '🏡', '200 m²-es családi ház – teljes hálózat',
  'Kecskemét · 2024. október',
  '[{"label":"Helyszín","value":"Kecskemét"},{"label":"Alapterület","value":"200 m², 2 szint"},{"label":"Eszközök","value":"Ubiquiti UniFi"},{"label":"Munkaidő","value":"1 munkanap"}]'::jsonb,
  'Az ügyfélnek frissen átépített, kétszintes házában egyáltalán nem volt hálózat kiépítve – az internetszolgáltató csak az előszobába hozta be a kábelt, ahonnan az emelet és a kert szinte elérhetetlen volt WiFi szempontból.',
  'Helyszíni felmérés után 3 db UniFi U6 Lite access pointot terveztem be: egyet a nappaliba (fszt.), egyet az emeleti folyosóra, egyet a teraszra. Cat6 kábel futott mindhárom ponthoz, a UDM-SE (Dream Machine Special Edition) a kazánházba került, ahol patch panel és 8 portos PoE switch is helyet kapott. Vendég WiFi, IoT szegmens (okos TV, robot porszívó, okos izzók) és a főhálózat teljesen el van választva egymástól.',
  ARRAY['Minden szobában 500+ Mbps sebesség mérve','A kertben és teraszon is stabil WiFi 6 lefedettség','3 különálló hálózat: főhálózat, vendég, IoT','Teljes hálózati dokumentáció és betanítás átadva'],
  '[{"text":"UniFi U6 Lite ×3","color":"green"},{"text":"UDM-SE","color":"navy"},{"text":"Cat6 kábelezés","color":"blue"},{"text":"IoT szegmens","color":"orange"},{"text":"Vendég WiFi","color":"green"}]'::jsonb,
  '„Végre minden szobában megy a Netflix 4K-ban. Köszönöm!" – K. Péter, Kecskemét'
),

-- #2 – Kiskunhalas, TP-Link
(
  '🏢', 'blue', 'TP-Link Deco', 'blue', '2024. augusztus',
  'Lakásbővítés – WiFi holtpontok megszüntetése', 'Kiskunhalas',
  '80 m²-es lakás, ahol a nappali és a hálószoba között teljesen kiesett a WiFi jel. Mesh rendszer kiépítésével minden szobában stabil, 300+ Mbps sebesség lett elérhető.',
  ARRAY['tp-link'],
  '[{"text":"TP-Link Deco","color":"blue"},{"text":"Mesh","color":"green"},{"text":"WiFi 6","color":"navy"}]'::jsonb,
  5,
  '🏢', 'Lakásbővítés – WiFi holtpontok megszüntetése',
  'Kiskunhalas · 2024. augusztus',
  '[{"label":"Helyszín","value":"Kiskunhalas"},{"label":"Alapterület","value":"80 m², 1 szint"},{"label":"Eszközök","value":"TP-Link Deco XE75"},{"label":"Munkaidő","value":"3 óra"}]'::jsonb,
  'Az ügyfél panelban lakott, ahol a vastag beton falak miatt a hálóból és a fürdőszobából szinte nem lehetett elérni a szolgáltató routerét. Online meetingek közben állandóan szakadt a kapcsolat.',
  'A meglévő router megtartása mellett 2 db TP-Link Deco XE75 egységet telepítettünk mesh rendszerben – egyet a nappaliba, egyet a hálószoba és a fürdőszoba közé. Az egységek között powerline adaptert alkalmaztunk a megbízható backhaul érdekében, így nem volt szükség kábelezési munkára.',
  ARRAY['Minden helyiségben 300+ Mbps sebesség','Nulla leesett online meeting azóta','Gyors, fél napos beavatkozás – kábelezés nélkül'],
  '[{"text":"TP-Link Deco XE75 ×2","color":"blue"},{"text":"Powerline backhaul","color":"navy"},{"text":"WiFi 6E","color":"green"}]'::jsonb,
  '„Fél nap alatt megoldotta, amit én hónapokig nem tudtam." – V. Anna, Kiskunhalas'
),

-- #3 – Baja, MikroTik
(
  '🏠', 'orange', 'MikroTik', 'orange', '2024. május',
  'Home office hálózat – VPN + VLAN', 'Baja',
  'Otthonából dolgozó ügyvéd részére biztonságos home office hálózat kiépítése. MikroTik alapon VLAN szegmentálás, WireGuard VPN, tűzfal szabályok és sávszélesség prioritizálás.',
  ARRAY['mikrotik'],
  '[{"text":"MikroTik","color":"orange"},{"text":"VPN","color":"navy"},{"text":"VLAN","color":"blue"},{"text":"Tűzfal","color":"green"}]'::jsonb,
  5,
  '🏠', 'Home office hálózat – VPN + VLAN',
  'Baja · 2024. május',
  '[{"label":"Helyszín","value":"Baja"},{"label":"Felhasználás","value":"Home office (ügyvéd)"},{"label":"Eszközök","value":"MikroTik hAP ax³"},{"label":"Munkaidő","value":"4 óra"}]'::jsonb,
  'Az ügyfél ügyvédként otthonról dolgozik, és szükséges volt, hogy az irodai VPN-en keresztül biztonságosan csatlakozzon a munkahelyi rendszerekhez, miközben a privát és az irodai forgalom teljesen elkülönül egymástól.',
  'MikroTik hAP ax³ router telepítése RouterOS-sel. 3 VLAN kialakítása: munka (WireGuard VPN az irodai szerverhez), privát és vendég. Tűzfal szabályok beállítása, QoS konfiguráció a videóhívások prioritizálásához. Részletes dokumentáció és betanítás átadva.',
  ARRAY['Stabil WireGuard VPN az irodai szerverhez','Teljesen elkülönített munka és privát hálózat','Videóhívások megszakítás nélkül, prioritizált sávszélesség','Teljes dokumentáció és hozzáférési útmutató átadva'],
  '[{"text":"MikroTik hAP ax³","color":"orange"},{"text":"WireGuard VPN","color":"navy"},{"text":"3× VLAN","color":"blue"},{"text":"QoS","color":"green"},{"text":"Tűzfal","color":"orange"}]'::jsonb,
  '„Profi munka, elmagyarázott mindent érthetően." – Dr. S. László, Baja'
),

-- #4 – Kalocsa, Cat6 + UniFi
(
  '🔌', 'navy', 'Kábelezés + UniFi', 'navy', '2025. január',
  'Újépítésű ház – strukturált kábelezés', 'Kalocsa',
  'Építés közben, bevakolás előtt elvégzett teljes Cat6 UTP hálózat lefektetése. 8 helyiségbe kerültek fali RJ45 aljzatok, a kazánházban patch panel, a tetőn kültéri UniFi AP.',
  ARRAY['kabelez','ubiquiti'],
  '[{"text":"Cat6","color":"navy"},{"text":"UniFi","color":"green"},{"text":"Patch panel","color":"blue"}]'::jsonb,
  5,
  '🔌', 'Újépítésű ház – strukturált kábelezés',
  'Kalocsa · 2025. január',
  '[{"label":"Helyszín","value":"Kalocsa"},{"label":"Alapterület","value":"160 m², újépítés"},{"label":"Eszközök","value":"Cat6 UTP + UniFi"},{"label":"Munkaidő","value":"2 munkanap"}]'::jsonb,
  'Az ügyfél friss építkezésen hívott meg bevakolás előtt, hogy a falakba előre belefektessük a hálózati kábeleket. Így a kész házban nem lesz szükség látható kábelvezetékre sehol.',
  '8 helyiségbe fektettük be a Cat6 UTP kábeleket (összesen ~180 m kábel), minden szobában falas RJ45 aljzattal lezárva. A kazánházban 24 portos patch panel és PoE switch kapott helyet. A ház tetején kültéri UniFi U6 Mesh AP biztosítja az udvar és a garázs lefedettségét is.',
  ARRAY['8 szobában gigabites vezetékes csatlakozás','Kültéri WiFi a teraszon és a garázsban is','Teljesen rejtett kábelvezetés – esztétikus végeredmény','Jövőálló infrastruktúra: bővíthető switch-portra'],
  '[{"text":"Cat6 UTP ~180 m","color":"navy"},{"text":"24p Patch panel","color":"blue"},{"text":"UniFi U6 Mesh","color":"green"},{"text":"PoE switch","color":"orange"}]'::jsonb,
  '„Előre gondolkodott, minden pontosan lett megtervezve." – T. Gábor, Kalocsa'
),

-- #5 – Kiskunfélegyháza, Smart Home
(
  '📺', 'blue', 'TP-Link + Smart Home', 'blue', '2025. március',
  'Okosotthon integráció – Google Home + Zigbee', 'Kiskunfélegyháza',
  'Meglévő TP-Link hálózat bővítése okosotthon funkcionalitással. Zigbee hub integrálása, 14 okoseszköz (lámpák, termosztát, kamerák) hálózatba kötése, Google Home konfiguráció.',
  ARRAY['tp-link'],
  '[{"text":"TP-Link","color":"blue"},{"text":"Zigbee","color":"orange"},{"text":"Google Home","color":"navy"}]'::jsonb,
  5,
  '📺', 'Okosotthon integráció – Google Home + Zigbee',
  'Kiskunfélegyháza · 2025. március',
  '[{"label":"Helyszín","value":"Kiskunfélegyháza"},{"label":"Eszközök száma","value":"14 okoseszköz"},{"label":"Platform","value":"Google Home + TP-Link"},{"label":"Munkaidő","value":"5 óra"}]'::jsonb,
  'Az ügyfél saját maga vásárolt össze különböző gyártók okoseszközeit (Philips Hue lámpák, Tado termosztát, Tapo kamerák, Sonos hangszórók), de azok nem akartak együtt működni, és a WiFi is túlterhelt lett a sok eszköztől.',
  'A meglévő TP-Link Deco hálózaton egy külön IoT VLAN-t hoztam létre a Zigbee és WiFi okoseszközöknek. Conbee II Zigbee USB hub bekötése Raspberry Pi-re, Home Assistant telepítése és konfigurálása – így az összes eszköz egyetlen felületen kezelhető. Google Home integráció hangvezérléshez.',
  ARRAY['14 eszköz egyetlen appból és hangon vezérelhető','IoT forgalom teljesen el van választva a főhálózattól','A főhálózat sebessége javult (kevesebb eszköz rajta)','Automatizációk: jelenlét alapú fűtés, lefekvési jelenet'],
  '[{"text":"TP-Link IoT VLAN","color":"blue"},{"text":"Zigbee / Conbee II","color":"orange"},{"text":"Home Assistant","color":"navy"},{"text":"Google Home","color":"green"}]'::jsonb,
  '„Varázslat – most minden egyszerre, értelmesen működik." – M. Eszter, Kiskunfélegyháza'
),

-- #6 – Kiskunmajsa, IP kamera
(
  '📹', 'green', 'UniFi + IP kamera', 'green', '2025. február',
  'Biztonsági rendszer – 6 IP kamera + NVR', 'Kiskunmajsa',
  'Tanya és porta biztonsági kamera rendszerének kiépítése. 6 PoE kamera, dedikált NVR, éjszakai látás, mobilalkalmazás konfiguráció. Az UniFi hálózaton belül izolált kamera VLAN.',
  ARRAY['ubiquiti','kabelez'],
  '[{"text":"UniFi","color":"green"},{"text":"NVR","color":"navy"},{"text":"PoE","color":"orange"},{"text":"VLAN","color":"blue"}]'::jsonb,
  5,
  '📹', 'Biztonsági rendszer – 6 IP kamera + NVR',
  'Kiskunmajsa · 2025. február',
  '[{"label":"Helyszín","value":"Kiskunmajsa"},{"label":"Kamerák száma","value":"6 db PoE kamera"},{"label":"Eszközök","value":"UniFi Protect + NVR"},{"label":"Munkaidő","value":"1,5 munkanap"}]'::jsonb,
  'Tanyasi ingatlan, ahol a főépület, a porta és a gazdasági épület egyaránt kamerafelügyelet alá kellett kerüljön. Az ingatlan WiFi-vel nem lehetett lefedni, ezért kábeles PoE megoldás volt szükséges.',
  '6 db UniFi G4 Bullet kültéri PoE kamera telepítése Cat6 kábelen – összesen ~230 m kábel kiépítésével. UniFi Network Video Recorder (NVR) a fő épületben, 2 TB-os felvételi tárhellyel. A kamerák külön VLAN-ban futnak, az internettől is el vannak szeparálva. Mobilappból és böngészőből egyaránt élőben és visszajátszva nézhető.',
  ARRAY['Teljes ingatlan 24/7 kamerafelügyelet alatt','4K felbontású felvételek, éjszakai látással','Kamerák a nettől szeparálva – biztonságos','Mobilról bárhonnan élőben nézhető'],
  '[{"text":"UniFi G4 Bullet ×6","color":"green"},{"text":"NVR 2TB","color":"navy"},{"text":"PoE switch","color":"orange"},{"text":"Camera VLAN","color":"blue"},{"text":"Cat6 ~230 m","color":"navy"}]'::jsonb,
  '„Alapos, precíz munka – az egész tanyán rend van most." – F. József, Kiskunmajsa'
);
