# Studiositas — Diário de aprendizado

Este documento registra erros, descobertas e aprendizados relevantes surgidos
durante o desenvolvimento do Studiositas. Ele deve ser atualizado quando uma
descoberta alterar ou esclarecer a forma de trabalhar no projeto.

## Como usar

- Registrar a descoberta quando ela for confirmada por código, teste ou
  validação do ambiente.
- Descrever a regra prática que deve ser seguida daqui para frente.
- Evitar registrar apenas detalhes temporários ou decisões já documentadas em
  uma especificação ou decisão técnica.
- Relacionar o aprendizado à fase ou funcionalidade quando possível.

## Entradas

### 001 — Fluxo Spec Kit por funcionalidade

**Contexto:** a autenticação já possuía uma especificação geral, mas não tinha
plano técnico nem lista de tarefas suficientemente detalhada.

**Aprendizado:** funcionalidades relevantes devem seguir o fluxo:

```text
spec.md → plan.md → tasks.md → implementação → validação → code review
```

**Regra para frente:** preparar ou atualizar os artefatos da feature e obter
aprovação antes de iniciar a implementação. Após a implementação, apresentar o
diff e aguardar o code review humano antes do commit.

### 002 — O SDK do Flutter precisa de acesso ao próprio cache

**Contexto:** `flutter analyze` e `flutter test` pareciam travar, enquanto o
Dart funcionava.

**Causa:** o Flutter não conseguia acessar
`C:\flutter\bin\cache\lockfile` por falta de permissão de leitura e escrita.

**Regra para frente:** a instalação do Flutter deve permitir que o usuário de
desenvolvimento modifique o diretório `bin/cache`. Preferir uma instalação em
local controlado pelo usuário ou conceder apenas a permissão `Modify` ao
usuário atual.

### 003 — Separar contrato, serviço de infraestrutura e Repository

**Contexto:** a relação entre `AuthService`, `FirebaseAuthService` e
`FirebaseAuthRepository` gerou dúvida durante a revisão.

**Aprendizado:**

- contratos independentes da infraestrutura ficam no domínio;
- implementações que usam Firebase ficam em `data/services`;
- Repositories coordenam autenticação, perfil e sessão;
- ViewModels dependem de contratos, não do Firebase.

**Regra para frente:** interfaces de serviços devem ficar em
`domain/services/`; implementações concretas devem ficar em `data/services/`;
implementações de Repositories devem ficar em `data/repositories/`.

### 004 — Nomenclatura explícita para casos de uso

**Contexto:** arquivos como `register.dart` e classes como `Register` eram
genéricos e dificultavam identificar sua responsabilidade.

**Aprendizado:** o nome do arquivo e da classe deve deixar explícito que se
trata de um caso de uso.

**Regra para frente:** usar sempre o padrão:

```text
register_use_case.dart → RegisterUseCase
sign_in_use_case.dart → SignInUseCase
restore_session_use_case.dart → RestoreSessionUseCase
sign_out_use_case.dart → SignOutUseCase
```

### 005 — Validação do Flutter faz parte da entrega

**Contexto:** a implementação foi considerada pronta antes de executar
`flutter analyze` e `flutter test` com sucesso.

**Aprendizado:** testes e análise estática devem ser executados depois das
alterações e antes do code review. Um teste simples também pode bloquear toda
a suíte por erro de compilação.

**Regra para frente:** nenhuma fase deve ser apresentada como validada sem
registrar o resultado de `flutter analyze` e `flutter test`.

### 006 — Construtores const em objetos imutáveis

**Contexto:** o teste usava `const ValidateRegistration()`, mas a classe não
possuía construtor `const`.

**Aprendizado:** classes sem estado mutável e usadas como objetos de domínio ou
casos de uso devem permitir construção constante quando isso for compatível
com seu desenho.

**Regra para frente:** considerar construtores `const` em validadores, casos de
uso e objetos imutáveis; confirmar com `flutter analyze` e os testes.

### 007 — Mensagens de commit em português

**Contexto:** os commits anteriores usaram descrições em inglês, embora o
projeto e o processo sejam conduzidos em português.

**Aprendizado:** o padrão semântico pode preservar o tipo e o escopo em formato
convencional e usar uma descrição em português.

**Regra para frente:** usar:

```text
tipo(escopo): descrição em português
```

Exemplo:

```text
feat(auth): adiciona casos de uso de autenticação
```

### 008 — O working tree deve estar limpo antes do próximo ciclo

**Contexto:** alterações da implementação e da organização de arquivos ficaram
temporariamente misturadas antes da revisão e do commit.

**Aprendizado:** manter alterações coerentes agrupadas facilita o code review,
mas arquivos gerados e mudanças de fases diferentes devem ser identificados
antes do commit.

**Regra para frente:** ao terminar uma fase, conferir `git status`, revisar o
diff, validar os testes, obter aprovação e então criar o commit semântico da
fase.
