# Plano de implementação: autenticação com Firebase

## Contexto técnico

- Plataforma: Flutter/Dart.
- Arquitetura: MVVM, com domínio independente da infraestrutura.
- Infraestrutura: Firebase Authentication e persistência de perfil no Firestore.
- Testes: `flutter_test`, fakes para dependências externas e testes de domínio sem Firebase real.
- Feature existente: entidades `AuthSession` e `UserProfile`, contrato `AuthRepository` e `ValidateRegistration`.

## Decisões de implementação

1. Criar um contrato de serviço de autenticação no domínio ou em uma porta de infraestrutura, sem expor tipos do Firebase.
2. Implementar o serviço Firebase em `features/auth/data/services/`.
3. Implementar o repositório concreto em `features/auth/data/repositories/`.
4. Representar falhas externas com erros próprios da aplicação, traduzindo códigos do Firebase na camada de dados.
5. Manter a criação e leitura do perfil separadas da autenticação, mas coordenadas pelo repositório.
6. Implementar a ViewModel com estados explícitos: inicializando, ocioso, carregando, autenticado e erro.
7. Fazer a decisão de rota a partir do estado da sessão, sem acesso direto ao Firebase pela View.
8. Testar o fluxo completo com fakes antes de conectar a aplicação ao Firebase real.

## Fases

### Fase 1 — Contratos e erros

Definir modelos de falha, contrato do serviço e interfaces necessárias para autenticação e perfil.

### Fase 2 — Firebase e Repository

Adicionar dependências/configuração necessária, implementar o serviço Firebase, persistência do perfil e mapeamento de erros.

### Fase 3 — Casos de uso e ViewModel

Implementar registro, login, restauração e logout através de abstrações testáveis.

#### Contratos da fase

- Os casos de uso dependem de `AuthRepository`, nunca de Firebase.
- A `AuthViewModel` depende dos casos de uso ou de uma abstração de aplicação, nunca de `FirebaseAuthService`.
- Cada operação deve expor estados observáveis de carregamento, sucesso e erro.
- Falhas `AuthFailure` devem chegar à apresentação já traduzidas para mensagens apropriadas.
- Operações concorrentes devem ser protegidas contra submissões duplicadas enquanto houver uma operação em andamento.

#### Estados previstos

`AuthViewModel` deverá representar, no mínimo:

- `initializing`: restauração da sessão em andamento;
- `unauthenticated`: nenhuma sessão ativa;
- `authenticated`: sessão válida disponível;
- `submitting`: cadastro ou login em andamento;
- `error`: operação falhou, mantendo a sessão anterior quando aplicável.

#### Critérios específicos de conclusão

- Cadastro chama o Repository somente após validação dos dados.
- Login chama o Repository somente após validação de e-mail e senha.
- Restauração distingue carregamento, sessão ausente e sessão válida.
- Logout limpa o estado autenticado mesmo após a operação bem-sucedida.
- Erros não expõem exceções ou tipos do Firebase à apresentação.
- Testes cobrem sucesso, falha e transições de estado de cada operação.

### Fase 4 — Views e navegação

Substituir a tela de exemplo por telas de autenticação e área protegida, conectadas à ViewModel.

### Fase 5 — Validação e convergência

Executar testes, revisar critérios de aceitação, confirmar isolamento do Firebase e registrar decisões descobertas.

## Riscos e mitigação

- **Configuração divergente entre plataformas:** validar inicialmente Android e documentar o escopo das demais plataformas.
- **Perfil criado parcialmente após falha:** definir comportamento de erro e estratégia de repetição antes da implementação.
- **Vazamento do SDK para camadas superiores:** revisar imports e usar testes/inspeção de dependências.
- **Testes dependentes de serviço externo:** usar fakes e manter o Firebase real fora dos testes unitários.

## Fora do plano desta feature

Login social, verificação de e-mail, recuperação de senha, MFA e edição de perfil.
