# Plano de implementação

| Etapa | Entrega | Critério de aceitação | Estado |
|---|---|---|---|
| 1 | Recuperação das imagens e validação | PDF sem imagens ausentes; falha ao remover uma imagem | Build e validação no sandbox passaram no novo worktree |
| 2 | DVC + Drive + CI | Download com cache vazio usando conta de serviço e build hospedado | Upload e download real de 35 imagens aprovados; CI hospedado pendente |
| 3 | Edição e proveniência | PDF e metadados identificam fonte, engine e imagens | Build e metadados locais verificados |
| 4 | README, contribuições e revisão | Caminhos claros para leitores e contribuidores; nenhuma revisão fictícia | Implementado |
| 5 | Releases por tag v* | Somente build validado publica PDF e metadados; revisão visual antes da tag | Implementado; testar workflow |

O link de download no README passa a funcionar após a primeira release. Publicar
a primeira tag requer revisão do PDF. O PR e seus artefatos permitem essa revisão.

Conta de serviço criada: `cuo-guide-ci@amazing-sunset-508122-m9.iam.gserviceaccount.com`.
Secret GitHub configurado. A conta foi compartilhada como Editor, mas o upload
retornou HTTP 403 por falta de cota da conta de serviço no My Drive. Upload das
novas imagens requer a identidade do usuário com acesso Drive. CI só faz download.

Teste real aprovado: clone com cache DVC vazio restaurou os 32 arquivos publicados
(28.135.831 bytes) usando a conta de serviço. A autenticação de download funciona;
faltam os objetos das três imagens restauradas e o manifesto de 35 arquivos.

Teste posterior aprovado: upload autenticado como proprietário enviou os quatro
objetos faltantes (três imagens e manifesto). Um segundo clone com cache vazio,
usando a conta de serviço, restaurou os 35 arquivos (31.251.333 bytes).
