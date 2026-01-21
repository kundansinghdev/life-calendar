
import sys
import pypdf

def extract_text():
    try:
        with open("Life_Wallpaper_Final_Documentation.pdf", "rb") as f:
            reader = pypdf.PdfReader(f)
            text = ""
            for page in reader.pages:
                text += page.extract_text() + "\n"
            print("--- EXTRACTED TEXT ---")
            print(text)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    extract_text()
