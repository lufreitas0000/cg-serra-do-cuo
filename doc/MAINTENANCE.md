# Manter o guia

## Compilar em uma máquina nova

No Ubuntu, instale LuaLaTeX, os pacotes adicionais, Poppler e Roboto:

```bash
sudo apt-get install texlive-luatex texlive-latex-extra texlive-fonts-recommended fonts-roboto fontconfig poppler-utils
git clone --recurse-submodules https://github.com/lufreitas0000/cg-serra-do-cuo.git
cd cg-serra-do-cuo
python3 -m venv env
. env/bin/activate
python -m pip install -r scripts/requirements-build.txt
python -m pip check
```

Instale também Barlow Condensed Regular/Bold e Bebas Neue em
`~/.local/share/fonts/`. Os URLs fixados e comandos de instalação estão no
[workflow](../.github/workflows/build-pdf.yml). Rode `fc-cache -f`.

Para recuperar as imagens, solicite acesso à pasta Drive e configure sua
autenticação seguindo [DVC e CI](ci-drive.md). O secret do GitHub usa a conta de
serviço; o upload no My Drive usa a identidade do proprietário.

```bash
dvc pull fig.dvc
make build
make validate
make site
```

Resultados: `build/serra_do_cuo.pdf`, `build/edition.json` e `build/site/index.html`.
A página e o PDF usam a mesma exportação de vias; não edite as contagens à mão.

## Atualizar conteúdo

Edite os arquivos de `src/zones/` e os textos de apresentação. Para fotos e mapas,
atualize `fig/`, rode `dvc add fig` e faça `dvc push fig.dvc` **antes** de enviar o
commit Git. Preserve autoria e créditos. A engine está fixada no submódulo
`infra/engine`; atualizá-la é uma mudança separada que também exige build.

Rode os três comandos de build/validação/site acima. Revise as páginas alteradas,
mapas e links. Abra um PR; o CI gera PDF, metadados e uma prévia da página.
As instruções de [contribuição](../CONTRIBUTING.md) e
[revisão de vias](route-review.md) distinguem atualizações no TheCrag de erros no PDF.

## Publicar uma edição

Após revisar o PDF e integrar o commit, crie e envie uma tag de versão:

```bash
git tag -a v0.1.0 -m 'Serra do Cuó — edição 0.1.0'
git push origin v0.1.0
```

Use uma versão nova a cada edição. O job de release só roda após build validado.
O link estável para edições oficiais é
`https://github.com/lufreitas0000/cg-serra-do-cuo/releases/latest/download/serra_do_cuo.pdf`.
Antes da primeira edição, o README deve apontar para uma prévia existente ou para
o artefato de revisão, nunca para um asset que ainda não existe.

## Página complementar

Veja [opções e ativação do GitHub Pages](PAGES.md). A página é gerada em cada build,
com PDF e catálogo correspondentes à mesma fonte. Para publicar pelo workflow,
configure Pages para GitHub Actions e a variável `PUBLISH_PAGES=true` no repositório.
O deploy só ocorre em `main`; PRs geram uma prévia para revisão.

## Retomar depois de um período sem manutenção

Confira o estado do Git e o commit do submódulo; ative o ambiente Python e rode
`pip check`. Teste `dvc pull` com cache vazio para distinguir problemas de acesso
de arquivos já armazenados. Confira a última execução do CI antes de atualizar
dependências. Consulte [o registro de problemas](../LOG_DISCOVERY_AND_PIVOTS.md),
incluindo o conflito de dependências de OpenSSL e a cota de upload das contas de
serviço. Renove credenciais expiradas sem colocá-las no Git.
