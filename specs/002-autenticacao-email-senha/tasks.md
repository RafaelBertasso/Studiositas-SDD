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

- [ ] T011 Implementar caso de uso de cadastro.
- [ ] T012 Implementar caso de uso de login.
- [ ] T013 Implementar caso de uso de restauração de sessão.
- [ ] T014 Implementar caso de uso de logout.
- [ ] T015 Implementar `AuthViewModel` com estados de carregamento, sucesso e erro.
- [ ] T016 Garantir que ViewModel e domínio não importem o SDK do Firebase.

## Fase 4 — Interface e navegação

- [ ] T017 Criar tela de cadastro com validações e mensagens de erro.
- [ ] T018 Criar tela de login com validações e mensagens de erro.
- [ ] T019 Criar estado de inicialização enquanto a sessão é restaurada.
- [ ] T020 Criar área protegida mínima para confirmar autenticação.
- [ ] T021 Implementar redirecionamento entre área pública e protegida.
- [ ] T022 Implementar ação de logout na área protegida.

## Fase 5 — Testes e convergência

- [ ] T023 Completar testes de `ValidateRegistration`, incluindo telefone opcional.
- [ ] T024 Criar fakes do serviço de autenticação e do perfil.
- [ ] T025 Testar cadastro, login, logout e restauração de sessão na ViewModel/Repository.
- [ ] T026 Testar credenciais inválidas, e-mail duplicado e Firebase indisponível.
- [ ] T027 Executar `flutter analyze` e `flutter test`.
- [ ] T028 Revisar imports para confirmar isolamento do Firebase.
- [ ] T029 Revisar cada critério de aceitação da `spec.md` e marcar evidências.
- [ ] T030 Registrar decisões técnicas descobertas durante a implementação.
