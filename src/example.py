import sys

def main():
    text = sys.stdin.read()  # read entire input
    if not text.strip():
        print("No input", file=sys.stderr)
        return 1

    # Convert whole input to UPPERCASE
    print(text.upper())
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
