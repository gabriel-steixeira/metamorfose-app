# Modelagem de Dados do Firestore - App Metamorfose

Este documento detalha a estrutura do banco de dados NoSQL (Cloud Firestore) para o aplicativo Metamorfose. Ele serve como um guia de referência para o desenvolvimento e futuras manutenções.

## Estrutura Geral

A base de dados é centrada no usuário, com uma coleção principal `users` onde cada documento representa um único usuário. Informações relacionadas, como o histórico de conversas e dados de planta, são armazenadas em subcoleções dentro do documento do usuário para garantir consultas rápidas e organização lógica dos dados.

---

### Coleção `users`

Coleção principal que armazena o perfil e os dados de estado de cada usuário.

-   **Documento:** O ID de cada documento (`documentId`) nesta coleção **deve ser** o `uid` fornecido pelo Firebase Authentication. Isso cria um vínculo direto e seguro entre o usuário autenticado e seus dados.
-   **Exemplo de Caminho:** `/users/{firebase_auth_uid}`

#### Diagrama de Entidade-Relacionamento

```plaintext
+------------------------------------+
| users (collection)                 |
+------------------------------------+
| [firebase_auth_uid] (document)     |
|   - uid: string (PK)               |
|   - email: string                  |
|   - name: string                   |
|   - phone: string (opcional)       |
|   - photo_url: string (opcional)   |
|   - auth_provider: string          |  // 'email', 'google.com', 'facebook.com'
|   - created_at: timestamp          |
|   - llm_context_summary: string    |
|                                    |
|   +------------------------------+ |
|   | chat_history (sub-collection)| |
|   +------------------------------+ |
|   | [message_id] (document)      | |
|   |   - text: string             | |
|   |   - sender: string           | |
|   |   - timestamp: timestamp     | |
|   +------------------------------+ |
|                                    |
|   +------------------------------+ |
|   | plant_info (sub-collection)  | |
|   +------------------------------+ |
|   | [plant_id] (document)        | |
|   |   - name: string             | |
|   |   - species: string          | |
|   |   - pot_color: string        | |
|   |   - start_date: timestamp    | |
|   |                              | |
|   |   +------------------------+ | |
|   |   | current_photo (sub-coll)| |
|   |   +------------------------+ | |
|   |   | [photo_id] (document)  | |
|   |   |   - url: string        | |
|   |   |   - timestamp: ts      | |
|   |   |   - storage_path: str  | |
|   |   +------------------------+ |
|   |                              | |
|   |   +------------------------+ | |
|   |   | plant_photos (sub-coll)| |
|   |   +------------------------+ | |
|   |   | [photo_id] (document)  | |
|   |   |   - photo_id: string   | |
|   |   |   - storage_path: str  | |
|   |   |   - url: string        | |
|   |   |   - thumbnail_url: str | |
|   |   |   - timestamp: ts      | |
|   |   |   - date_key: string   | |
|   |   |   - is_main_photo: bool| |
|   |   |   - user_notes: string | |
|   |   +------------------------+ |
|   +------------------------------+ |
+------------------------------------+
```

#### Detalhamento dos Campos do Usuário:

| Campo                 | Tipo      | Descrição                                                                                                                              | Obrigatório | Exemplo                                           |
| --------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ------------------------------------------------- |
| `uid`                 | `string`  | O mesmo UID do Firebase Auth. Redundante, mas útil para consultas onde só se tem o corpo do documento.                                   | Sim         | `"aBCd123..."`                                    |
| `email`               | `string`  | E-mail do usuário. Fornecido no cadastro ou pelo provedor social.                                                                      | Sim         | `"usuario@email.com"`                             |
| `name`                | `string`  | Nome de exibição do usuário. No cadastro, vem do campo `username`. No login social, vem do perfil (ex: "Gabriel Teixeira").              | Sim         | `"Gabi"`                                          |
| `phone`               | `string`  | Número de telefone. Preenchido apenas no cadastro via e-mail.                                                                          | Não         | `"+5511999998888"`                                |
| `photo_url`           | `string`  | URL da foto de perfil. Geralmente preenchido apenas por provedores sociais (Google, Facebook).                                           | Não         | `"http://.../photo.jpg"`                          |
| `auth_provider`       | `string`  | Identifica como o usuário foi criado. Essencial para debugging e lógica de negócio. Use os IDs oficiais dos provedores.                 | Sim         | `"password"`, `"google.com"`, `"facebook.com"`    |
| `created_at`          | `timestamp` | Data e hora em que o documento do usuário foi criado. Ideal para tracking e ordenação.                                                   | Sim         | `May 29, 2025 at 10:00:00 PM UTC-3`               |
| `llm_context_summary` | `string`  | Resumo da conversa para ser usado como "memória" pelo agente de IA.                                                                    | Não         | `"O usuário relatou dificuldade no dia de ontem..."` |

---

### Subcoleção `plant_info`

Armazena as informações da planta do usuário, podendo haver múltiplas plantas por usuário.

- **Exemplo de Caminho:** `/users/{firebase_auth_uid}/plant_info/{plant_id}`

#### Detalhamento dos Campos da Planta:

| Campo         | Tipo        | Descrição                                 | Obrigatório | Exemplo                  |
| ------------- | ----------- | ----------------------------------------- | ----------- | ------------------------ |
| `name`        | `string`    | Nome da planta                           | Sim         | "Verdinha"              |
| `species`     | `string`    | Espécie da planta                        | Sim         | "Syngonium mini pixie"  |
| `pot_color`   | `string`    | Cor do vaso escolhida                    | Sim         | "Verde"                 |
| `start_date`  | `timestamp` | Data de início do acompanhamento         | Sim         | `30/06/2025`             |

---

#### Subcoleção `current_photo` (dentro de cada `plant_info`)

Armazena a foto principal atual da planta.

- **Exemplo de Caminho:** `/users/{firebase_auth_uid}/plant_info/{plant_id}/current_photo/{photo_id}`

| Campo         | Tipo        | Descrição                                 | Obrigatório | Exemplo                  |
| ------------- | ----------- | ----------------------------------------- | ----------- | ------------------------ |
| `url`         | `string`    | URL da foto principal atual               | Sim         | `"http://.../foto.jpg"` |
| `timestamp`   | `timestamp` | Data/hora em que a foto foi tirada        | Sim         | `30/06/2025`             |
| `storage_path`| `string`    | Caminho do arquivo no Firebase Storage    | Sim         | `"plantas/verdinha.jpg"`|

---

#### Subcoleção `plant_photos` (dentro de cada `plant_info`)

Armazena o histórico de fotos da planta, para uso em calendário, histórico e comparações.

- **Exemplo de Caminho:** `/users/{firebase_auth_uid}/plant_info/{plant_id}/plant_photos/{photo_id}`

| Campo           | Tipo        | Descrição                                 | Obrigatório | Exemplo                  |
| --------------- | ----------- | ----------------------------------------- | ----------- | ------------------------ |
| `photo_id`      | `string`    | ID da foto (auto-gerado)                  | Sim         | `"abc123"`              |
| `storage_path`  | `string`    | Caminho do arquivo no Storage             | Sim         | `"plantas/verdinha.jpg"`|
| `url`           | `string`    | URL pública da foto                       | Sim         | `"http://.../foto.jpg"` |
| `thumbnail_url` | `string`    | Miniatura para o calendário               | Não         | `"http://.../thumb.jpg"`|
| `timestamp`     | `timestamp` | Data/hora em que a foto foi tirada        | Sim         | `30/06/2025`             |
| `date_key`      | `string`    | Chave de data para indexação (YYYY-MM-DD) | Sim         | `"2025-06-30"`           |
| `is_main_photo` | `boolean`   | Se é a foto principal atual               | Sim         | `true`                   |
| `user_notes`    | `string`    | Observações do usuário sobre a foto       | Não         | `"Primeira foto da planta"`|

---

### Subcoleção `chat_history`

Armazena cada mensagem trocada entre o usuário e o agente de IA.

-   **Exemplo de Caminho:** `/users/{firebase_auth_uid}/chat_history/{message_id}`

#### Detalhamento dos Campos da Mensagem:

| Campo       | Tipo      | Descrição                                         | Obrigatório | Exemplo                                 |
| ----------- | --------- | ------------------------------------------------- | ----------- | --------------------------------------- |
| `text`      | `string`  | O conteúdo da mensagem.                           | Sim         | `"Hoje foi um dia difícil..."`          |
| `sender`    | `string`  | Identifica quem enviou a mensagem (`"user"` ou `"llm"`). | Sim         | `"user"`                                |
| `timestamp` | `timestamp` | Data e hora em que a mensagem foi enviada.        | Sim         | `May 29, 2025 at 10:05:00 PM UTC-3`     | 