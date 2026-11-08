"""Reject missing source images and placeholders in the compiled guide."""
import argparse
from pathlib import Path
import re
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--pdf', type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    images = set()
    for source in (root / 'src').rglob('*.tex'):
        text = re.sub(r'(?<!\\)%[^\n]*', '', source.read_text())
        images.update(re.findall(r'\{([^{}\n]+\.(?:jpg|jpeg|png|pdf))\}', text, re.I))
    missing = sorted(name for name in images if not (root / 'fig' / name).is_file())
    if missing:
        raise SystemExit('Missing guide images: ' + ', '.join(missing))
    print(f'All {len(images)} referenced images are present.')
    if args.pdf:
        text = subprocess.run(['pdftotext', str(args.pdf), '-'], check=True,
                              capture_output=True, text=True).stdout
        if 'imagem não encontrada' in text.lower():
            raise SystemExit('PDF contains missing-image placeholders.')
        print('PDF contains no missing-image placeholders.')


if __name__ == '__main__':
    main()
