[![Open in Codespaces](https://classroom.github.com/assets/launch-codespace-2972f46106e565e64193e422d61a12cf1da4916b45550586e14ef0a7c637dd04.svg)](https://classroom.github.com/open-in-codespaces?assignment_repo_id=20986037)
# Projekt: Budowa infrastruktury serwerowej dla aplikacji webowej


Autorzy:
- Jakub Marcin Andrzejewski
- Maciej Puchalski

# Cel projektu

Zbudowanie infrastruktury serwerowej dla własnej aplikacji webowej.

# Założenia projektu

1. Maszyny wirtualne są uruchamiane w środowisku VirtualBox.
2. Maszyny komunikują się ze sobą przez sieć wewnętrzną VirtualBox (Internal, domyślny adres 192168.56.0/24, patrz: Uwagi dotyczące konfiguracji ) 
3. Budowa maszyn odbywa się przy pomocy narzędzia Vagrant.
4. Konfiguracja  i ustawienia maszyn są wykonane przy pomocy skryptów powłoki i narzędzia Ansible.
5. W środowisku są co najmniej 3 maszyny wirtualne: dla frontendu, backendu i bazy danych.
6. Aplikacja działa bezpośrednio w maszynie (bare-metal) - nie używamy Dockera ani innych podobnych narzędzi.
7. Wstawienie wszystkie ustawienia konfiguracyjne (konta, hasła, adresy, porty itp) do osobnego pliku. Wskazówka: użyj zmiennych środowiskowych i zaimportuj plik z ustawieniami poleceniem source.


# Aplikacja

Projektowana aplikacja jest prostym systemem webowym do obsługi strony internetowej kina.
System został podzielony na trzy logiczne komponenty:

Frontend (port 4300) – aplikacja kliencka wyświetlająca dane z backendu.

Backend (port 8080) – serwis obsługujący logikę biznesową i komunikację z bazą danych.

Database (port 5432) – baza danych PostgreSQL przechowująca informacje o filmach i seansach.

# Przygotowana architektura

W środowisku utworzono trzy maszyny wirtualne:

- frontend (192.168.56.13)
- backend (192.168.56.11)
- database (192.168.56.12)

Każda maszyna została zdefiniowana w pliku Vagrantfile, który automatycznie uruchamia środowisko i przypisuje odpowiedni adres IP


Pliki frontend.yml, backend.yml i database.yml definiują konfigurację usług dla każdej z maszyn:

- instalacja potrzebnych pakietów (Node.js, Python, PostgreSQL),
- kopiowanie plików aplikacji,
- uruchamianie serwisów na zadanych portach.

# Schemat połączeń:
<img width="741" height="81" alt="architektura" src="https://github.com/user-attachments/assets/82be35fc-1276-410d-9513-aafa4498470c" />

# Refleksje i wnioski

Nauczyliśmy się tworzyć środowiska wirtualne przy użyciu Vagranta i Ansible, konfigurować komunikację między maszynami, stosować zmienne środowiskowe. Manualne zarządzenie środowiskami jest ciężkie, wymagające znajomości poszczególnych komend dla danego systemu, a Ansible znacząco ułatwia ten proces, zapewniając ustruktyrozwaną konfigurację.  
