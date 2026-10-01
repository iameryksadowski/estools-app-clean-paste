# Clean Paste - instalacja i obsługa

Clean Paste wkleja tekst bez tła, kolorów i obcych fontów. Zostają pogrubienia, listy, linki i entery, a tekst przyjmuje styl miejsca, do którego wklejasz: Mail, Gmail, Slack, Notatki, Word.

## 1. Instalacja

**Sposób A - plik DMG (od Eryka)**

1. Otwórz plik CleanPaste-1.0.0.dmg i przeciągnij Clean Paste na folder Aplikacje.
2. Uruchom Clean Paste z Aplikacji. macOS pokaże komunikat, że nie może sprawdzić aplikacji - kliknij "Gotowe" (nie "Przenieś do Kosza").
3. Otwórz Ustawienia systemowe > Prywatność i ochrona, przewiń w dół i przy "Clean Paste" kliknij "Otwórz mimo to", potem potwierdź hasłem lub Touch ID.
4. To jest potrzebne tylko przy pierwszej instalacji. Aktualizacje instalują się już bez tego.

**Sposób B - jedna komenda (bez żadnych ostrzeżeń macOS)**

1. Otwórz aplikację Terminal (Cmd+Spacja, wpisz "Terminal", Enter).
2. Wklej poniższą linię i naciśnij Enter:

   curl -fsSL https://github.com/iameryksadowski/estools-app-clean-paste/releases/latest/download/install.sh | sh

3. Gotowe: Clean Paste jest w Aplikacjach i działa. Ikona pojawia się w pasku menu u góry ekranu.

## 2. Jedno pozwolenie: Dostępność

Clean Paste sam naciska Cmd+V, dlatego macOS raz pyta o zgodę.

1. Przy pierwszym uruchomieniu otworzy się okno Clean Paste. Kliknij "Allow Accessibility".
2. W Ustawieniach systemowych włącz przełącznik przy "Clean Paste".
3. Wróć do okna Clean Paste - zobaczysz "Allowed".

## 3. Używanie

- Skopiuj tekst jak zwykle (Cmd+C) - z przeglądarki, czatu, dokumentu.
- Zamiast Cmd+V naciśnij **Control+Option+Command+V**. Tekst wklei się czysty.
- Albo kliknij ikonę w pasku menu > **Paste Clean**.
- **Repair Clipboard** czyści tylko schowek - potem wklejasz zwykłym Cmd+V, gdzie chcesz.

## 4. Ustawienia (ikona w pasku menu > Settings...)

- **Shortcuts** - własne skróty dla Paste Clean i Repair Clipboard.
- **Formatting** - zamiana długich myślników na "-", zamiana cudzysłowów na proste, rozmiar tekstu (domyślnie 12 px, jak w Apple Mail).
- **Open at login** - Clean Paste startuje razem z Makiem.
- **Updates** - gdy wyjdzie nowa wersja, Clean Paste pokaże listę zmian i zapyta, czy zainstalować.

**Po aktualizacji:** macOS może ponownie poprosić o Dostępność. Clean Paste sam otworzy wtedy swoje okno - kliknij "Allow Accessibility" i w Ustawieniach systemowych wyłącz, a potem włącz przełącznik przy Clean Paste.

Gdy okno ustawień jest otwarte, Clean Paste ma ikonę w Docku. Po zamknięciu okna zostaje tylko w pasku menu.

## 5. Odinstalowanie

Ikona w pasku menu > Quit Clean Paste, potem przeciągnij Clean Paste z Aplikacji do Kosza.

---

ES Tools by Eryk Sadowski · eryksadowski.com
