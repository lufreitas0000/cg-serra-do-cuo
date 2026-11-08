"""Record source provenance for an edition; no credentials or local paths."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import re


def git(*args):
    return subprocess.check_output(['git', *args], text=True).strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    sha = git('rev-parse', 'HEAD')
    version = git('describe', '--tags', '--always', '--dirty')
    version = re.sub(r'[^A-Za-z0-9.+-]', '-', version)
    date = datetime.fromtimestamp(int(git('show', '-s', '--format=%ct', 'HEAD')), timezone.utc).date().isoformat()
    manifest = Path('fig.dvc').read_text()
    image_hash = re.search(r'md5:\s*(\S+)', manifest).group(1)
    metadata = dict(commit=sha, version=version, source_date=date,
                    images=image_hash, engine=git('rev-parse', 'HEAD:infra/engine'))
    args.out.mkdir(parents=True, exist_ok=True)
    (args.out / 'edition.tex').write_text(
        f'\\def\\GuideEdition{{{version}}}\n\\def\\GuideSourceDate{{{date}}}\n')
    (args.out / 'edition.json').write_text(json.dumps(metadata, indent=2) + '\n')


if __name__ == '__main__':
    main()
