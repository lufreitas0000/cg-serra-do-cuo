"""Build a static PDF companion from the same exported route database."""
import argparse
from collections import defaultdict
from html import escape
import json
from pathlib import Path
import shutil


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build', type=Path, default=Path('build'))
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    rows = json.loads((args.build / 'export/database.json').read_text())
    edition = json.loads((args.build / 'edition.json').read_text())
    pdf = args.build / 'serra_do_cuo.pdf'
    if not rows or not pdf.is_file() or not pdf.stat().st_size:
        raise SystemExit('A compiled PDF and nonempty route export are required.')
    groups = defaultdict(list)
    for row in rows:
        if not all(isinstance(row.get(k), str) and row[k].strip()
                   for k in ['zone', 'sector', 'name', 'grade']):
            raise SystemExit('Incomplete route data: zone, sector, name and grade required.')
        groups[(row['zone'], row['sector'])].append(row)
    sections = []
    for (zone, sector), routes in sorted(groups.items()):
        body = ''.join(f'<tr><td>{escape(r["name"])}</td><td>{escape(r["grade"])}</td></tr>'
                       for r in sorted(routes, key=lambda r: r['name'].casefold()))
        sections.append(f'<section class="sector"><h3>{escape(sector)}</h3>'
                        f'<p class="zone">{escape(zone)}</p><table><thead><tr>'
                        '<th scope="col">Via</th><th scope="col">Grau</th></tr></thead>'
                        f'<tbody>{body}</tbody></table></section>')
    stats = {'routes': len(rows), 'sectors': len(groups),
             'zones': len({r['zone'] for r in rows}), 'edition': edition}
    template = (root / 'site/index.html').read_text()
    values = {'ROUTES': str(stats['routes']), 'SECTORS': str(stats['sectors']),
              'ZONES': str(stats['zones']), 'VERSION': escape(edition['version']),
              'DATE': escape(edition['source_date']), 'CATALOGUE': ''.join(sections)}
    for key, value in values.items():
        template = template.replace('{{' + key + '}}', value)
    target = args.build / 'site'
    target.mkdir(parents=True, exist_ok=True)
    (target / 'index.html').write_text(template)
    (target / 'stats.json').write_text(json.dumps(stats, ensure_ascii=False, indent=2) + '\n')
    (target / '.nojekyll').touch()
    for source in [pdf, args.build / 'edition.json', root / 'site/style.css']:
        shutil.copy2(source, target / source.name)
    print(f'Static page: {stats["routes"]} routes, {stats["sectors"]} sectors, {stats["zones"]} zones.')


if __name__ == '__main__':
    main()
