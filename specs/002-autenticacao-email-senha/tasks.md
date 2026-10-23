# Tarefas: autenticação com Firebase

## Fase 1 — Contratos e erros

- [x] T001 Definir tipos de erro da aplicação para credencial inválida, e-mail duplicado, indisponibilidade e falhas desconhecidas.
- [x] T002 Definir contrato do serviço de autenticação sem tipos do Firebase.
- [x] T003 Definir contrato de persistência do perfil e comportamento para perfil inexistente.
- [x] T004 Revisar `AuthSession`, `UserProfile` e `AuthRepository` contra a especificação.

## Fase 2 — Integração Firebase

- [x] T005 Adicionar dependências FlutterFire necessárias ao `pubspec.yaml`.
- [x] T006 Implementar `FirebaseAuthService` em `features/auth/data/services/`.
- [x] T007 Implementar serviço/repositório de perfil no Firestore.
- [x] T008 Implementar `FirebaseAuthRepository` coordenando conta, sessão e perfil.
- [x] T009 Mapear erros do Firebase para erros da aplicação.
- [x] T010 Validar que senha e credenciais não são persistidas no perfil.

## Fase 3 — Casos de uso e ViewModel

- [x] T011 Criar casos de uso finos para cadastro, login, restauração de sessão e logout, delegando ao `AuthRepository`.
- [x] T012 Definir o modelo de estado da autenticação e as transições permitidas.
- [x] T013 Implementar `AuthViewModel` com restauração inicial de sessão.
- [x] T014 Implementar fluxo de cadastro na ViewModel, incluindo validação antes do Repository.
- [x] T015 Implementar fluxo de login na ViewModel, incluindo validação antes do Repository.
- [x] T016 Implementar logout e limpeza do estado autenticado.
- [x] T017 Mapear `AuthFailure` para mensagens de apresentação sem expor Firebase.
- [x] T018 Impedir submissões duplicadas durante operações em andamento.
- [x] T019 Garantir que ViewModel, casos de uso e domínio não importem o SDK do Firebase.
- [x] T020 Criar testes de casos de uso para sucesso e propagação de falhas.
- [x] T021 Criar testes de ViewModel para restauração, cadastro, login, logout e transições de estado.

## Fase 4 — Interface e navegação

- [ ] T022 Criar tela de cadastro com validações e mensagens de erro.
- [ ] T023 Criar tela de login com validações e mensagens de erro.
- [ ] T024 Criar estado de inicialização enquanto a sessão é restaurada.
- [ ] T025 Criar área protegida mínima para confirmar autenticação.
- [ ] T026 Implementar redirecionamento entre área pública e protegida.
- [ ] T027 Implementar ação de logout na área protegida.

## Fase 5 — Testes e convergência

- [ ] T028 Completar testes de `ValidateRegistration`, incluindo telefone opcional.
- [ ] T029 Criar fakes do serviço de autenticação e do perfil.
- [ ] T030 Testar cadastro, login, logout e restauração de sessão na ViewModel/Repository.
- [ ] T031 Testar credenciais inválidas, e-mail duplicado e Firebase indisponível.
- [ ] T032 Executar `flutter analyze` e `flutter test`.
- [ ] T033 Revisar imports para confirmar isolamento do Firebase.
- [ ] T034 Revisar cada critério de aceitação da `spec.md` e marcar evidências.
- [ ] T035 Registrar decisões técnicas descobertas durante a implementação.
