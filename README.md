# Guia de Escalada da Serra do Cuó

Guia não oficial, em desenvolvimento, da Serra do Cuó, em Campo Grande/RN.
Abrange Zona Baixa, Paraíso, Catedral e Talhado dos Americanos, com uma seção
sobre as falésias entre Paraíso e Catedral.

**[Baixar o PDF da última edição](https://github.com/lufreitas0000/cg-serra-do-cuo/releases/latest/download/serra_do_cuo.pdf)**

O link estará disponível após a primeira release. Cada PDF informa a versão e a
data da fonte na ficha editorial; os metadados anexos identificam o commit, a
engine e a coleção de imagens. A data da edição não comprova revisão de todas as vias.

Consulte a comunidade no [TheCrag — Serra do Cuó](https://www.thecrag.com/en/climbing/brazil/area/14372948250)
para atualizações das vias e contribua com comentários, correções e ascensões.
PDF e site não são sincronizados automaticamente.
As trilhas estão na [lista do Wikiloc](https://pt.wikiloc.com/wikiloc/user.do?id=20929616&event=favorites&listId=2256269).
Veja [como contribuir](CONTRIBUTING.md) e [como revisar os dados](doc/route-review.md).

## Compilar localmente

Requer LuaLaTeX, pacotes LaTeX extra, Poppler e as fontes Roboto Condensed,
Barlow Condensed (Regular e Bold) e Bebas Neue. No Ubuntu, instale:

```bash
sudo apt-get install texlive-luatex texlive-latex-extra texlive-fonts-recommended fonts-roboto fontconfig poppler-utils
```

O workflow contém os URLs das versões fixadas das fontes Barlow e Bebas Neue.
Instale os arquivos TTF em `~/.local/share/fonts/` e rode `fc-cache -f`.

```bash
git clone --recurse-submodules https://github.com/lufreitas0000/cg-serra-do-cuo.git
cd cg-serra-do-cuo
python3 -m venv env
. env/bin/activate
python -m pip install -r scripts/requirements-build.txt
python -m pip check
dvc pull fig.dvc
make build
make validate
```

O download das imagens exige acesso à pasta Drive e autenticação. Veja a
[configuração do DVC e CI](doc/ci-drive.md). O Git armazena o manifesto `fig.dvc`;
as imagens ficam no Drive. A engine é um submódulo fixado em `infra/engine`.
O resultado é `build/serra_do_cuo.pdf`, com proveniência em `build/edition.json`.

## CI e publicação

[Build guide PDF](https://github.com/lufreitas0000/cg-serra-do-cuo/actions/workflows/build-pdf.yml)
restaura as imagens do Drive, compila e valida o guia. PRs do próprio repositório
produzem artefatos para revisão visual; PRs de forks não recebem a credencial
Drive. O download de artefatos exige login e está sujeito à retenção do GitHub.

Após revisar o PDF, publique uma tag `v*` para produzir uma release com PDF e
metadados. A publicação depende do build validado. Nenhuma tag é criada
automaticamente. Consulte o [plano de implementação](doc/IMPLEMENTATION_PLAN.md)
para os testes e pendências da implantação inicial.
