# **KONTRAKT: Docker Swarm**

## **1. Metryczka**

* **Nazwa zespołu:** CZ08-2v2 
* **Opis/nazwa aplikacji:** Aplikacja do rezerwacji miejsc w kinie Okino
* **Repozytorium GitHub:** [Project-Cinema](https://github.com/JJv222/Project-Cinema)
* **Tablica zadań (GitHub Project):** [Tablica zadań](https://github.com/orgs/pwr-twwo/projects/15) 


## **2. Cel i efekty projektu**

### **Główny cel**

Uruchomienie aplikacji trójwarstwowej (Frontend \+ Backend \+ Baza Danych) w klastrze Docker Swarm.

### **Wsad (Input)**

1. **Aplikacja (Wkład własny):** Kod źródłowy aplikacji studentów (Frontend, Backend, Baza). Aplikacja musi być funkcjonalna na poziomie kodu.  
2. **Infrastruktura (Dostarczone przez prowadzącego):**  
   * Plik Vagrantfile definiujący maszyny wirtualne.  
   * Skrypty konfiguracyjne (provisioning) dla węzłów Manager i Worker.  
   * Skrypt uruchamiający narzędzie Portainer.

### **Rezultaty (Deliverables)**

1. **Działający klaster:** Skonfigurowane środowisko (min. 1 Manager, 2 Workery) na VirtualBox.  
2. **Lokalny Rejestr (Local Registry):** Uruchomiona usługa rejestru obrazów kontenerowych, działająca wewnątrz klastra.  
3. **Kod wdrożeniowy:**  
   * Pliki Dockerfile dla własnej aplikacji (wykorzystanie funkcji budowania obrazów multi-stage w celu optymalizacji).  
   * Plik docker-compose.yml  budujący aplikację w najprostszej wersji.  
   * Plik docker-stack.yml definiujący pełen stos Swarm: serwisy, sieci overlay, wolumeny i replikację.  
   * Plik build.sh budujący obrazy kontenerów.  
   * Plik deploy-compose.sh instalujący aplikację przy użyciu polecenia compose.  
   * Plik deploy-stack.sh instalujący aplikację jako stos.  
4. **Zarządzanie:** Działająca aplikacja Portainer wizualizująca stan klastra.  
5. **Dokumentacja:** Plik README.md z instrukcją uruchomienia.

### **Czego projekt NIE obejmuje**

* Rozwijania nowych, funkcjonalności w aplikacji (skupiamy się na warstwie operacyjnej).  
* Publikowania obrazów w publicznych rejestrach (Docker Hub) – cały cykl życia obrazu odbywa się w sieci lokalnej/wirtualnej.
* Użycia innych systemów typu Kubernetes.
## **3. Role i Odpowiedzialności**

*Podział sugerowany – można go zmienić, ale każdy obszar musi mieć swojego właściciela.*

| Rola wiodąca | Odpowiedzialność główna |
| :---- | :---- |
| **JA** | Uruchomienie maszyn (Vagrant), konfiguracja sieci między węzłami, weryfikacja czy workery widzą managera. Konfiguracja daemon.json dla insecure-registry. |
| **MP** | Uruchomienie usługi Local Registry w Swarmie. Konfiguracja tagowania i procesu wypychania (push) obrazów do rejestru lokalnego. |
| **MP** | Dostosowanie kodu aplikacji (zmienne środowiskowe), optymalizacja Dockerfile, zapewnienie, że aplikacja "wstaje" w kontenerze. |
| **JA** | Złożenie docker-stack.yml, konfiguracja bazy danych (wolumeny/persystencja), healthchecki, zarządzanie sekretami. |

## **4. Harmonogram prac (3 tygodnie)**

| Etap | Kamień milowy / Rezultat do osiągnięcia |
| :---- | :---- |
| **Tydzień 1** | Zatwierdzenie kontraktu. Uruchomienie maszyn wirtualnych i Portainera. |
| **Tydzień 2** | **Infrastruktura gotowa.** Działający Local Registry. Aplikacja skonteneryzowana. Budowa obrazów i  wypychanie do lokalnego rejestru (w klastrze). |
| **Tydzień 3** | **Deploy.** Aplikacja uruchomiona jako Stack. Działająca komunikacja Frontend \-\> Backend \-\> Baza (Service Discovery). |
| **Finał** | **Demo.** Prezentacja, testy odporności (restart węzła), finalizacja dokumentacji. |

## **5. Dokumentowanie pracy, współpraca i komunikacja**

* **Śledzenie zadań:** GitHub Projects (Kanban). Każde zadanie musi być zdefiniowane jako Issue. Każdy commit musi odnosić się do konkretnego zadania \- nr  Issue (np. “fix: Fix database connection \#12”).  
* **Przepływ pracy:** pracujemy na gałęziach (`feature/nazwa-funkcji`). Ukończone funkcje dołączamy przez Pull Request \- musi być zatwierdzony przez innego członka zespołu. PR nie powinien być zbyt duży: ok. 100-200 linii zmian.  
* **Ukończenie zadania**: Zadanie jest zakończone gdy:  
  * Kod jest w repozytorium.  
  * Kod działa.  
  * Code Review (Pull Request) został zatwierdzony przez innego członka zespołu.  
* **Struktura repozytorium:** Kod aplikacji i pliki infrastrukturalne są w jednym repozytorium.  
* **Decyzje:** Kluczowe wybory techniczne muszą być opisane w dokumentacji (np. wybór obrazu bazowego).

## **6. Użycia sztucznej inteligencji (AI)**

* **Dozwolone:** Generowanie konfiguracji YAML, skryptów Bash, Dockerfile.  
* **Wymagane:** Pełne zrozumienie kodu w repozytorium przez wszystkich w zespole. "AI tak wygenerowało" nie jest usprawiedliwieniem błędu lub brakiem zrozumienia kodu i skutkuje brakiem punktów za daną część.

## **7. System oceniania**

Ocena końcowa studenta jest wyliczana według wzoru:  
Ocena Końcowa \= Ocena projektu × Ocena zespołowa

### **A. Ocena projektu (zespołowa)**

1. **Infrastruktura i rejestr (20%):** Poprawność klastra Swarm, działający Lokalny Rejestr (obrazy są pobierane z wewnątrz sieci klastra), Portainer.  
2. **Podstawowa aplikacja (20%):** Uruchomienie aplikacji w kontenerach w najprostszej wersji (compose).   
3. **Orkiestracja (30%):** Poprawny plik Stack, działająca aplikacja, skalowanie (zwiększenie liczby replik działa), trwałość danych.  
4. **Jakość (30%):** Optymalizacja obrazów (rozmiar), brak haseł w kodzie (użycie Docker Secrets/Config), czytelna dokumentacja.

### **B. Ocena indywidualna (mnożnik indywidualny)**

Ankieta przeprowadzana w formie **papierowej lub elektronicznej** na ostatnich zajęciach. Każdy student ocenia zaangażowanie pozostałych członków zespołu.

| Wynik ankiety | Mnożnik | Skutek |
| :---- | :---- | :---- |
| Lider / Wyróżniający się | **1.1 \- 1.2** | Podwyższenie oceny. |
| Standardowa praca | **1.0** | Ocena równa ocenie projektu. |
| Nierówne zaangażowanie | **0.8 \- 0.9** | Obniżenie oceny. |
| Brak wkładu | **\< 0.7** | Niezaliczenie przedmiotu. |

## **9. Zmiany i zarządzanie ryzykiem**

| Ryzyko | Plan mitygacji |
| :---- | :---- |
| **Problem z zasobami (RAM)** | Praca na komputerach laboratoryjnych (jeśli laptopy są za słabe). Użycie lżejszych obrazów (Alpine Linux). |
| **Problem z "Insecure Registry"** | Konfiguracja Daemona Dockera w maszynach wirtualnych (/etc/docker/daemon.json), aby akceptował rejestr HTTP. |

## **10. Prezentacja**

* **Prezentacja:** Demo na żywo. Środowisko (maszyny wirtualne) musi być uruchomione PRZED rozpoczęciem demonstracji.   
* **Wymagany scenariusz demo:**  
  1. Pokazanie działającej aplikacji.  
  2. Zmiana w kodzie (np. zmiana koloru tła) \-\> Build \-\> Push do lokalnego rejestru.  
  3. Aktualizacja stosu (Rolling Update) bez przerywania działania usługi.  
  4. Wyłączenie jednego kontenera/węzła i pokazanie, że Swarm go podnosi (Self-healing).

## **11. Deklaracja zespołu**

* Akceptując ten kontrakt (poprzez Pull Request), zobowiązuję się do równego zaangażowania w projekt.
* Rozumiem, że ocena końcowa składa się z wyniku zespołu oraz oceny indywidualnego wkładu (historia commitów \+ review).