# Página de acesso ao guia

## Opções

| Opção | Uso | Limite |
|---|---|---|
| GitHub Release | Um PDF público, versionado, com link direto | Não apresenta um catálogo ou resumo visual |
| GitHub Pages estático | PDF, metadados, contagens e catálogo em uma página simples | Atualiza quando uma nova fonte é compilada e publicada |
| Aplicação com serviço próprio | Integrações e dados em tempo real | Exige operação e uma interface autorizada com a fonte dos dados |

A recomendação é Pages estático, sem backend. `make site` gera tudo a partir de
`build/export/database.json` e `build/edition.json`, e copia o mesmo PDF validado.
Não há catálogo editável em paralelo: mudanças entram na fonte do guia.

## Conteúdo e significado dos números

A página tem um botão de download, data/versão da fonte, número de vias, setores
e zonas, links do TheCrag/Wikiloc e um catálogo recolhido por padrão. Setores são
pares distintos `(zona, setor)` com ao menos uma via; as zonas sem vias não entram
nessa contagem. Os números descrevem a edição, não o estado atual do TheCrag.

As datas de conquista são texto livre e estão ausentes em muitas vias. Um commit
não prova que uma via foi criada naquele mês. Por isso, ainda não exibimos um
gráfico de novas vias por mês. Para adicioná-lo, registrar data, precisão
(dia/mês/ano), fonte e revisão de cada conquista; mostrar a cobertura e as datas
desconhecidas junto ao gráfico. A revisão é descrita em [route-review.md](route-review.md).

## Ativar o deploy

1. Integre o PR depois de revisar a prévia gerada pelo CI.
2. Em Settings → Pages, selecione GitHub Actions como fonte.
3. Em Settings → Secrets and variables → Actions → Variables, configure
   `PUBLISH_PAGES` como `true`.
4. Execute o workflow **Build guide PDF** em `main`.

O job de Pages depende do build validado e publica somente em `main`. O endereço
esperado é `https://lufreitas0000.github.io/cg-serra-do-cuo/`; só adicione esse link
ao README após um deploy bem-sucedido. Para desativar novos deploys, remova a
variável. Versões do PDF também podem ser preservadas em Releases.

Referência: [workflows do GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages).
