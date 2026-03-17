  
# Projekt: Rozbudowa infrastruktury serwerowej o realistyczne rozwiązania

#### Autorzy:
- Jakub Marcin Andrzejewski
- Maciej Puchalski

# Treść zadania:
  
## Cel
Celem drugiego projektu jest uzupełnienie infrastruktury serwerowej o bardziej realistyczne rozwiązania.

## Wymagania wstępne

Działająca infrastruktura z Projektu 1.
 #### Bazowe repozytorium: https://github.com/pwr-twwo/devops2025-p1-cz08-2

## Założenia projektu

Przygotować środowisko, uzupełnione o następujące elementy (użyte nazwy są przykładowe, możecie użyć innych):

Maszyna RevProxy - maszyna ukrywająca za sobą frontend i backend. Można użyć np. HAproxy, nginx lub Apache.

Maszyna Build - maszyna, na której odbywa się budowanie aplikacji (zarówno dla frontendu jak i backendu)

Maszyna Artifact - maszyna przechowująca artefakty powstające w wyniku budowania aplikacji (np. pliki .jar lub spakowane foldery aplikacji webowej) Można użyć np. Nexus lub JFrog Artifactory.

Skrypt build.sh (uruchamiany na maszynie Build) pobierający na maszynę Build repozytorium z aplikacją, budujący obie części aplikacji i umieszczający wynik w repozytorium artefaktów.

Skrypt deploy.sh (uruchamiany na maszynie Build) instalujący zbudowane aplikacje na maszynach Front i Back.

## Uwagi i wskazówki

Ze względu na budowanie aplikacji na osobnej maszynie możecie zmniejszyć rozmiary maszyn Front i Back.

Ansible będzie wykorzystywany zgodnie z założeniami (tzn. do konfiguracji infrastruktury, a nie budowy aplikacji).

Maszyna Build może teraz trzymać zawartość cache dla narzędzi budujących (np. maven) co powinno przyspieszyć kolejne przebudowania aplikacji.

Do pobierania repozytorium z GitHub wykorzystajcie Fine-grained personal access tokens: możecie określić ich zakres (np. tylko repozytorium z tego projektu), datę ważności, itd.

W razie problemów z brakiem zasobów możecie zrezygnować z maszyny Artifact, i przechowywać artefakty w folderach na maszynie Build, choć nie jest to rozwiązanie preferowane.

## Efekt końcowy

Po pobraniu repozytorium przez git clone i wykonaniu polecenia vagrant up, narzędzie Vagrant powinno od zera zbudować całe środowisko (bez aplikacji).

Po połączeniu się z maszyną Build i ręcznym uruchomieniu skryptu build.sh w repozytorium powinny znaleźć się artefakty obu aplikacji.

Po połączeniu się z maszyną Build i ręcznym uruchomieniu skryptu deploy.sh aplikacja powinna zacząć działać.

## Wyniki

Repozytorium Git z konfiguracją środowiska i aplikacją webową.

Sprawozdanie omawiające przygotowaną konfigurację (plik README.md w repozytorium).
  

# Wnioski – napotkane problemy i obserwacje

#### Obserwacje
Jako ciekawą obserwacje podczas realizacji projektu odkryliśmy, że podczas definiowania sekcji environment i ustawiania zmiennych środowiskowych w pliku build.yml mysleliśmy że te zmienne w konfiguracji są dostępne już w obrębie danej maszyny a okazuje się, że z poziomu ansible musimy je wy-exportować i dopiero są widoczne z poziomu maszyny.

#### W trakcie realizacji zadania, napotkaliśmy parę trudności, które znacząco wydłużyły proces jego wykonania: 
1.  **Integracja z JFrog Artifactory**

Pierwszą z nich był nasz błąd na w zasadzie instalacyjnym etapie. Podczas instalacji wersji Artifactory pomyłkowo pobraliśmy komercyjną wersję Artifactory, co spowodowało, że poświęcilismy wiele godzin niepotrzebnie próbując różnych rozwiązań, które były ograniczone ze względu na brak licencji. Niestety te ograniczenia licencyjne spowodowały, że musieliśmy przejść na Nexus co wymagało dodatkowej konfiguracji i ponownej weryfikacji środowiska - przełożyło sie to oczywiście na czas realizacji.

2.  **Złożoność konfiguracji repozytorium**

Konfiguracja repozytorium wymagała wielokrotnych prób, dostosowywania reguł proxy i zarządzania zależnościami. Okazało się znacznie bardziej skomplikowane niż się spodziewaliśmy, co również przełożyło sie na poświęcony czas.

3.  **Długi czas uruchamiania Nexus Repository**

Po przejściu na Nexus Repository przekonalismy się, że czas wstawania Nexusa jest znacznie dłuższy i wahał się w granicach 10 minut. Ten wydłużony czas wstawania nexua, spowodował, że wiele razy myśleliśmy, że proces się zawiesił - myśleliśmy, że nie powinien tak długo trwać. Resetowanie wstawania procesu wydłużyło czas implementacji zadania i spowodowało to, że dopiero za którymś razem kiedy "odpuściliśmy na chwilę robiąc przerwę" daliśmy mu tym czas, aby wstał i okazało się, że to tak po prostu długo trwa. Przy tych dłuższych inicjalizacjach poświęcony czas na oczekiwanie i zmiany w plikach również utrudnił i wydłużył proces.

4.  **Brak doświadczenia i wiedzy odnośnie środowiska angular**

Brak wcześniejszego doświadczenia z Angular CLI oraz środowiskiem Angulara sprawił, że mieliśmy trudność w przygotowaniu kofniguracji produkcyjnej. Problemy wynikały z różnic pomiędzy działaniem aplikacji w trybie "deweloperskim", a sposobem jak buduje się środowisko produkcyjne. W rezultacie musieliśmy poświecić dużo czasu aby poprawnie skonfigurować to srodowisko i poprawnie zdefiniować endpoint backendowy w buildzie produkcyjnym tak aby sie mógł komunikować.

5. **Zła interpretacja**

Źle zinterpretowaliśmy cel skryptu deploy.sh prez co odpalaliśmy manualnie proces przez ssh. W momencie restartu maszyny serwis należało ponownie manualnie uruchomić po przez skrypt deploy.sh . W zwiazku z tym poprawiliśmy skrypt, aby bezpośrednio pobierał repozytoria już na wskazane maszyny, zamiast lokalnie je przechowywać na maszynie build i kopiowanie na docelową maszynę, oraz serwisy uruchamiany jest po przez systemd tak jak to było w 1. projekcie, a deploy jedynie przeładowuje artefakt, który wykorzystuje. Dzięki temu podczas vagrant reload serwis działa pomyślnie i jest dostępny.
